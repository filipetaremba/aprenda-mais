/**
 * API pública da app: /api/v1 (JSON, sem cookies, autenticação por Bearer token).
 * Erros sempre no formato { erro: { codigo, mensagem } }.
 */
import fs from 'node:fs';
import express, { Router, type NextFunction, type Request, type Response } from 'express';
import rateLimit from 'express-rate-limit';
import { config } from '../config';
import { prisma } from '../db';
import { listaJson } from '../dominio';
import { activar, ErroApi, estudanteDoToken, licencasDoEstudante, listarLicencas, provasDasLicencas } from '../activacao/servico';
import { caminhoPacote } from '../conteudo/pacotes';

export interface OpcoesApi {
  limiteActivacaoHora?: number;
}

const erro = (res: Response, status: number, codigo: string, mensagem: string) => res.status(status).json({ erro: { codigo, mensagem } });

const assincrono =
  (fn: (req: Request, res: Response) => Promise<unknown>) =>
  (req: Request, res: Response, next: NextFunction) =>
    fn(req, res).catch(next);

export function apiRouter(opcoes: OpcoesApi = {}) {
  const r = Router();
  r.use(express.json({ limit: '20kb' }));
  r.use((_req, res, next) => {
    res.set('Cache-Control', 'no-store');
    next();
  });

  const limite = (windowMs: number, limit: number, keyGenerator?: (req: Request) => string) =>
    rateLimit({
      windowMs,
      limit,
      keyGenerator,
      standardHeaders: 'draft-7',
      legacyHeaders: false,
      handler: (_req, res) => erro(res, 429, 'DEMASIADAS_TENTATIVAS', 'Demasiadas tentativas. Espera um pouco e tenta de novo.'),
    });

  r.use(limite(60_000, 120));

  // 5 tentativas por hora, por IP e por dispositivo (protege contra adivinhar códigos)
  const porHora = opcoes.limiteActivacaoHora ?? config.limiteActivacaoHora;
  const activacaoPorIp = limite(3600_000, porHora);
  const activacaoPorDispositivo = limite(3600_000, porHora, (req) => `disp:${String(req.body?.dispositivoId ?? req.ip).slice(0, 128)}`);

  const exigirToken = (req: Request, res: Response, next: NextFunction) => {
    estudanteDoToken(prisma, req.get('authorization'))
      .then((estudante) => {
        if (!estudante) return erro(res, 401, 'NAO_AUTENTICADO', 'Sessão inválida. Activa ou restaura a compra de novo.');
        res.locals.estudante = estudante;
        next();
      })
      .catch(next);
  };

  r.post(
    '/activacao',
    activacaoPorIp,
    activacaoPorDispositivo,
    assincrono(async (req, res) => {
      const b = req.body ?? {};
      const estudanteAutenticado = await estudanteDoToken(prisma, req.get('authorization'));
      const resultado = await activar(prisma, { codigo: b.codigo, dispositivoId: b.dispositivoId, telefone: b.telefone, nome: b.nome, estudanteAutenticado });
      res.status(resultado.restaurado ? 200 : 201).json(resultado);
    }),
  );

  r.get(
    '/licencas',
    exigirToken,
    assincrono(async (_req, res) => {
      res.json(await listarLicencas(prisma, res.locals.estudante));
    }),
  );

  /** Pacote da prova, se o estudante tiver uma licença válida que a cubra (validado no servidor). */
  async function pacoteAutorizado(estudante: string, prova: string, versao?: number) {
    const provas = provasDasLicencas(await licencasDoEstudante(prisma, estudante));
    if (!provas.has(prova)) throw new ErroApi(403, 'SEM_LICENCA', 'Não tens uma licença válida para esta prova.');
    const p = await prisma.pacote.findFirst({ where: { prova, ...(versao && { versao }) }, orderBy: { versao: 'desc' } });
    if (!p) throw new ErroApi(404, 'PACOTE_INEXISTENTE', 'Ainda não há conteúdo publicado para esta prova.');
    return p;
  }

  r.get(
    '/pacotes/:prova/versao',
    exigirToken,
    assincrono(async (req, res) => {
      const p = await pacoteAutorizado(res.locals.estudante, String(req.params.prova));
      res.json({ prova: p.prova, versao: p.versao, sha256: p.sha256, tamanho_bytes: p.tamanho_bytes, num_questoes: p.num_questoes, publicado_em: p.publicado_em.toISOString() });
    }),
  );

  // ?versao=N fixa a versão (útil para retomar um download a meio com Range sem misturar versões)
  r.get(
    '/pacotes/:prova/download',
    exigirToken,
    assincrono(async (req, res) => {
      const versao = req.query.versao ? Number(req.query.versao) : undefined;
      const p = await pacoteAutorizado(res.locals.estudante, String(req.params.prova), versao);
      const ficheiro = caminhoPacote(p.ficheiro);
      if (!fs.existsSync(ficheiro)) throw new ErroApi(404, 'PACOTE_INEXISTENTE', 'Ficheiro do pacote em falta no servidor.');
      res.set({
        'X-Checksum-SHA256': p.sha256,
        'X-Pacote-Versao': String(p.versao),
        'Content-Type': 'application/zip',
        'Cache-Control': 'private, no-store',
      });
      res.sendFile(ficheiro, { headers: { 'Content-Disposition': `attachment; filename="${p.prova}-v${p.versao}.zip"` }, acceptRanges: true });
    }),
  );

  r.get(
    '/catalogo',
    assincrono(async (_req, res) => {
      const [instituicoes, provas, ofertas, produtos, pacotes] = await Promise.all([
        prisma.instituicao.findMany({ orderBy: { codigo: 'asc' } }),
        prisma.prova.findMany({ orderBy: { codigo: 'asc' } }),
        prisma.oferta.findMany({ orderBy: { codigo: 'asc' }, include: { cur: true, provas: { orderBy: { ordem: 'asc' } } } }),
        prisma.produto.findMany({ where: { activo: true }, orderBy: [{ ordem: 'asc' }, { codigo: 'asc' }], include: { provas: true } }),
        prisma.pacote.groupBy({ by: ['prova'], _max: { versao: true } }),
      ]);
      const versoes = Object.fromEntries(pacotes.map((p) => [p.prova, p._max.versao]));
      res.set('Cache-Control', 'public, max-age=300');
      res.json({
        meta: { nota_minima_padrao: config.notaMinimaPadrao, niveis_gratis: config.niveisGratis },
        contactos: config.contactos,
        instituicoes: instituicoes.map((i) => ({ codigo: i.codigo, sigla: i.sigla, nome: i.nome, grupo_exame: i.grupo_exame })),
        provas: provas.map((p) => ({ codigo: p.codigo, nome: p.nome, grupo_exame: p.grupo_exame, disciplina: p.disciplina, pacote_versao: versoes[p.codigo] ?? null })),
        ofertas: ofertas.map((o) => ({
          codigo: o.codigo,
          curso: o.curso,
          nome: o.cur.nome,
          instituicao: o.instituicao,
          locais: listaJson(o.locais),
          provas: o.provas.map((x) => ({ prova: x.prova, peso: x.peso })),
        })),
        produtos: produtos.map((p) => ({
          codigo: p.codigo,
          nome: p.nome,
          descricao: p.descricao,
          tipo: p.tipo,
          preco_mt: p.preco_mt,
          epoca: p.epoca,
          provas: p.provas.map((x) => x.prova).sort(),
        })),
      });
    }),
  );

  r.use((_req, res) => erro(res, 404, 'NAO_ENCONTRADO', 'Endereço inexistente.'));
  r.use((e: unknown, _req: Request, res: Response, _next: NextFunction) => {
    if (e instanceof ErroApi) return erro(res, e.status, e.codigo, e.message);
    if ((e as { type?: string }).type === 'entity.parse.failed') return erro(res, 400, 'PEDIDO_INVALIDO', 'JSON inválido.');
    console.error(e);
    erro(res, 500, 'ERRO_INTERNO', 'Ocorreu um erro inesperado. Tenta de novo.');
  });
  return r;
}
