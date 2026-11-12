import fs from 'node:fs';
import path from 'node:path';
import { Router, type Request, type Response } from 'express';
import multer from 'multer';
import type { Prisma } from '@prisma/client';
import { dirImagens } from '../config';
import { prisma } from '../db';
import {
  ESTADOS_QUESTAO,
  LETRAS_EM,
  listaJson,
  NUM_NIVEIS,
  validarRegrasQuestao,
  type AlternativaEntrada,
} from '../dominio';
import { flash, verificarCsrf } from '../seguranca';

const POR_PAGINA = 50;
const TIPOS_IMAGEM: Record<string, string> = { 'image/png': '.png', 'image/jpeg': '.jpg', 'image/webp': '.webp' };

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 2 * 1024 * 1024, files: 1 },
  fileFilter: (_req, f, cb) => cb(null, f.mimetype in TIPOS_IMAGEM),
});

// ───────────── Filtros da lista ─────────────

interface Filtros {
  q: string;
  prova: string;
  nivel: string;
  estado: string;
  tema: string;
  alertas: string;
  pagina: number;
}

function lerFiltros(src: Record<string, any>): Filtros {
  return {
    q: String(src.q ?? '').trim(),
    prova: String(src.prova ?? ''),
    nivel: String(src.nivel ?? ''),
    estado: String(src.estado ?? ''),
    tema: String(src.tema ?? ''),
    alertas: String(src.alertas ?? ''),
    pagina: Math.max(1, Number(src.pagina) || 1),
  };
}

function whereFiltros(f: Filtros): Prisma.QuestaoWhereInput {
  const w: Prisma.QuestaoWhereInput = {};
  if (f.q) w.OR = [{ codigo: { contains: f.q } }, { enunciado: { contains: f.q } }];
  if (f.estado) w.estado = f.estado;
  if (f.tema) w.tema = f.tema;
  if (f.alertas === '1') w.alertas = { not: '[]' };
  if (f.prova || f.nivel) {
    w.provas = {
      some: {
        ...(f.prova && { prova: f.prova }),
        ...(f.nivel && { nivel: f.nivel === 'sem' ? null : Number(f.nivel) }),
      },
    };
  }
  return w;
}

const qsFiltros = (f: Filtros, extra: Partial<Filtros> = {}) =>
  new URLSearchParams(
    Object.entries({ ...f, ...extra })
      .filter(([, v]) => v !== '' && v != null)
      .map(([k, v]) => [k, String(v)]),
  ).toString();

// ───────────── Formulário ─────────────

interface FormQuestao {
  codigo: string;
  prova: string;
  nivel: string;
  tema: string;
  tipo: string;
  estado: string;
  dificuldade: string;
  ano: string;
  enunciado: string;
  dica: string;
  explicacao: string;
  imagens: string[];
  alternativas: { letra: string; texto: string; imagem: string }[];
  correcta: string;
  alertas: string[];
  resposta_origem: string | null;
  resposta_confianca: string | null;
}

const VF_TEXTO: Record<string, string> = { V: 'Verdadeiro', F: 'Falso' };

function formVazio(prova = ''): FormQuestao {
  return {
    codigo: '',
    prova,
    nivel: '',
    tema: '',
    tipo: 'escolha_multipla',
    estado: 'rascunho',
    dificuldade: '',
    ano: '',
    enunciado: '',
    dica: '',
    explicacao: '',
    imagens: [],
    alternativas: LETRAS_EM.map((letra) => ({ letra, texto: '', imagem: '' })),
    correcta: '',
    alertas: [],
    resposta_origem: null,
    resposta_confianca: null,
  };
}

async function carregarForm(codigo: string): Promise<FormQuestao | null> {
  const q = await prisma.questao.findUnique({
    where: { codigo },
    include: { alternativas: { orderBy: { ordem: 'asc' } }, provas: true },
  });
  if (!q) return null;
  const ligacao = q.provas[0];
  const alternativas =
    q.tipo === 'verdadeiro_falso'
      ? formVazio().alternativas
      : LETRAS_EM.map((letra) => {
          const a = q.alternativas.find((x) => x.letra === letra);
          return { letra, texto: a?.texto ?? '', imagem: a?.imagem ?? '' };
        });
  return {
    codigo: q.codigo,
    prova: ligacao?.prova ?? '',
    nivel: ligacao?.nivel ? String(ligacao.nivel) : '',
    tema: q.tema ?? '',
    tipo: q.tipo,
    estado: q.estado,
    dificuldade: q.dificuldade ? String(q.dificuldade) : '',
    ano: q.ano ? String(q.ano) : '',
    enunciado: q.enunciado,
    dica: q.dica ?? '',
    explicacao: q.explicacao,
    imagens: listaJson(q.imagens),
    alternativas,
    correcta: q.alternativas.find((a) => a.correcta)?.letra ?? '',
    alertas: listaJson(q.alertas),
    resposta_origem: q.resposta_origem,
    resposta_confianca: q.resposta_confianca,
  };
}

function lerFormBody(body: Record<string, any>, actual: FormQuestao | null): FormQuestao {
  const tipo = body.tipo === 'verdadeiro_falso' ? 'verdadeiro_falso' : 'escolha_multipla';
  const altsBody: any[] = Array.isArray(body.alternativas) ? body.alternativas : Object.values(body.alternativas ?? {});
  const remover = new Set<string>([body.remover_imagens ?? []].flat().map(String));
  return {
    codigo: String(body.codigo ?? '').trim().toUpperCase(),
    prova: String(body.prova ?? ''),
    nivel: String(body.nivel ?? ''),
    tema: String(body.tema ?? ''),
    tipo,
    estado: String(body.estado ?? 'rascunho'),
    dificuldade: String(body.dificuldade ?? ''),
    ano: String(body.ano ?? '').trim(),
    enunciado: String(body.enunciado ?? '').trim(),
    dica: String(body.dica ?? '').trim(),
    explicacao: String(body.explicacao ?? '').trim(),
    imagens: (actual?.imagens ?? []).filter((i) => !remover.has(i)),
    alternativas: LETRAS_EM.map((letra, i) => ({
      letra,
      texto: String(altsBody[i]?.texto ?? '').trim(),
      // imagens das alternativas vêm dos imports; mantêm-se as que já existiam
      imagem: actual?.alternativas.find((a) => a.letra === letra)?.imagem ?? '',
    })),
    correcta: String(tipo === 'verdadeiro_falso' ? (body.correcta_vf ?? '') : (body.correcta ?? '')),
    alertas: actual?.alertas ?? [],
    resposta_origem: actual?.resposta_origem ?? null,
    resposta_confianca: actual?.resposta_confianca ?? null,
  };
}

/** Alternativas finais: V/F fixas; escolha múltipla ignora a 5.ª se estiver vazia. */
function alternativasFinais(f: FormQuestao): (AlternativaEntrada & { ordem: number })[] {
  const base =
    f.tipo === 'verdadeiro_falso'
      ? (['V', 'F'] as const).map((letra) => ({ letra, texto: VF_TEXTO[letra], imagem: null as string | null }))
      : f.alternativas
          .map((a) => ({ letra: a.letra, texto: a.texto || null, imagem: a.imagem || null }))
          .filter((a, i) => i < 4 || a.texto || a.imagem);
  return base.map((a, i) => ({ ...a, correcta: a.letra === f.correcta, ordem: i + 1 }));
}

async function opcoes() {
  const [provas, temas] = await Promise.all([
    prisma.prova.findMany({ select: { codigo: true, nome: true, disciplina: true }, orderBy: { codigo: 'asc' } }),
    prisma.tema.findMany({ select: { codigo: true, nome: true, disciplina: true }, orderBy: { codigo: 'asc' } }),
  ]);
  return { provas, temas, estados: ESTADOS_QUESTAO, niveis: Array.from({ length: NUM_NIVEIS }, (_, i) => i + 1) };
}

async function proximoCodigo(prova: string) {
  const prefixo = `${prova}-ADM-`;
  const ultimos = await prisma.questao.findMany({ where: { codigo: { startsWith: prefixo } }, select: { codigo: true } });
  const max = ultimos.reduce((m, q) => Math.max(m, Number(q.codigo.slice(prefixo.length)) || 0), 0);
  return `${prefixo}${String(max + 1).padStart(3, '0')}`;
}

function guardarImagem(codigo: string, ficheiro: Express.Multer.File): string {
  fs.mkdirSync(dirImagens(), { recursive: true });
  const ext = TIPOS_IMAGEM[ficheiro.mimetype];
  let nome = `${codigo}${ext}`;
  for (let i = 0; fs.existsSync(path.join(dirImagens(), nome)); i++) nome = `${codigo}_${String.fromCharCode(97 + i)}${ext}`;
  fs.writeFileSync(path.join(dirImagens(), nome), ficheiro.buffer);
  return nome;
}

// ───────────── Router ─────────────

export function questoesRouter() {
  const r = Router();

  r.get('/', async (req, res) => {
    const f = lerFiltros(req.query);
    const where = whereFiltros(f);
    const [questoes, total, op] = await Promise.all([
      prisma.questao.findMany({
        where,
        orderBy: { codigo: 'asc' },
        skip: (f.pagina - 1) * POR_PAGINA,
        take: POR_PAGINA,
        include: { provas: true, alternativas: { select: { correcta: true } } },
      }),
      prisma.questao.count({ where }),
      opcoes(),
    ]);
    res.render('questoes/lista', {
      questoes: questoes.map((q) => ({
        ...q,
        ligacoes: q.provas.map((p) => `${p.prova}${p.nivel ? ` · N${p.nivel}` : ''}`).join(', '),
        semResposta: !q.alternativas.some((a) => a.correcta),
        numAlertas: listaJson(q.alertas).length,
      })),
      total,
      f,
      paginas: Math.max(1, Math.ceil(total / POR_PAGINA)),
      qs: (extra: Partial<Filtros>) => qsFiltros(f, extra),
      ...op,
    });
  });

  r.get('/nova', async (req, res) => {
    res.render('questoes/form', { criar: true, q: formVazio(String(req.query.prova ?? '')), erros: [], ...(await opcoes()) });
  });

  r.get('/:codigo', async (req, res) => {
    const q = await carregarForm(req.params.codigo);
    if (!q) return res.status(404).render('erro', { titulo: 'Não encontrada', mensagem: 'Questão inexistente.' });
    const outras = await prisma.questaoProva.findMany({ where: { questao: q.codigo }, skip: 1 });
    res.render('questoes/form', { criar: false, q, outras, erros: [], ...(await opcoes()) });
  });

  const gravar = (criar: boolean) => async (req: Request, res: Response) => {
    const actual = criar ? null : await carregarForm(String(req.params.codigo));
    if (!criar && !actual) return res.status(404).render('erro', { titulo: 'Não encontrada', mensagem: 'Questão inexistente.' });
    const f = lerFormBody(req.body, actual);
    if (!criar) f.codigo = actual!.codigo;
    const erros: string[] = [];

    const prova = await prisma.prova.findUnique({ where: { codigo: f.prova } });
    if (!prova) erros.push('Escolhe a prova.');
    if (f.tema) {
      const tema = await prisma.tema.findUnique({ where: { codigo: f.tema } });
      if (!tema) erros.push('Tema inexistente.');
      else if (prova && tema.disciplina !== prova.disciplina) erros.push('O tema não é da disciplina da prova.');
    }
    if (criar && prova && !f.codigo) f.codigo = await proximoCodigo(prova.codigo);
    if (criar && f.codigo) {
      if (!/^[A-Z0-9]+(-[A-Z0-9]+)*-\d{3,4}$/.test(f.codigo)) erros.push('Código inválido. Formato: UEM-MAT2-ADM-001 (termina em 3 ou 4 dígitos).');
      else if (await prisma.questao.findUnique({ where: { codigo: f.codigo } })) erros.push('Já existe uma questão com esse código.');
    }
    if (f.ano && !/^\d{4}$/.test(f.ano)) erros.push('Ano inválido.');

    const alternativas = alternativasFinais(f);
    const nivel = f.nivel ? Number(f.nivel) : null;
    const dificuldade = f.dificuldade ? Number(f.dificuldade) : null;
    // No admin a resposta é sempre obrigatória, mesmo em rascunho
    if (!alternativas.some((a) => a.correcta)) erros.push('Indica a alternativa correcta.');
    erros.push(
      ...validarRegrasQuestao({ tipo: f.tipo, enunciado: f.enunciado, explicacao: f.explicacao, dica: f.dica, estado: f.estado, alternativas, nivel, dificuldade }).filter(
        (e) => e !== 'Indica a alternativa correcta.',
      ),
    );

    if (erros.length) {
      return res.status(400).render('questoes/form', { criar, q: f, outras: [], erros, ...(await opcoes()) });
    }

    if (req.file) f.imagens.push(guardarImagem(f.codigo, req.file));
    const dados = {
      disciplina: prova!.disciplina,
      tema: f.tema || null,
      tipo: f.tipo,
      enunciado: f.enunciado,
      imagens: JSON.stringify(f.imagens),
      dica: f.dica || null,
      explicacao: f.explicacao,
      dificuldade,
      ano: f.ano ? Number(f.ano) : null,
      estado: f.estado,
      // Questões criadas no admin: resposta e explicação escritas por uma pessoa
      ...(criar && { resposta_origem: null, explicacao_origem: 'humana', explicacao_revista: true }),
    };

    await prisma.$transaction(async (tx) => {
      if (criar) await tx.questao.create({ data: { codigo: f.codigo, ...dados } });
      else await tx.questao.update({ where: { codigo: f.codigo }, data: dados });
      await tx.alternativa.deleteMany({ where: { questao: f.codigo } });
      await tx.alternativa.createMany({ data: alternativas.map((a) => ({ ...a, questao: f.codigo })) });
      // Ligação principal (prova + nível). Se mudou de prova, troca a ligação antiga.
      if (actual?.prova && actual.prova !== f.prova)
        await tx.questaoProva.deleteMany({ where: { questao: f.codigo, prova: actual.prova } });
      await tx.questaoProva.upsert({
        where: { questao_prova: { questao: f.codigo, prova: f.prova } },
        create: { questao: f.codigo, prova: f.prova, nivel },
        update: { nivel },
      });
    });

    flash(req, 'ok', `Questão gravada: ${f.codigo}`);
    res.redirect(req.body.depois === 'nova' ? `/admin/questoes/nova?prova=${encodeURIComponent(f.prova)}` : `/admin/questoes/${f.codigo}`);
  };

  r.post('/nova', upload.single('imagem'), verificarCsrf, gravar(true));

  // Mudança de estado em lote (antes de /:codigo para não colidir)
  r.post('/estado', async (req, res) => {
    const estado = String(req.body.novo_estado ?? '');
    if (!ESTADOS_QUESTAO.includes(estado as any)) {
      flash(req, 'erro', 'Estado inválido.');
      return res.redirect('/admin/questoes');
    }
    const f = lerFiltros(req.body);
    const where: Prisma.QuestaoWhereInput =
      req.body.todas === '1' ? whereFiltros(f) : { codigo: { in: [req.body.codigos ?? []].flat().map(String) } };
    const alvo = await prisma.questao.findMany({ where, select: { codigo: true, alternativas: { select: { correcta: true } } } });
    // Só se publica (ou marca revista) com exactamente 1 alternativa correcta
    const validas = alvo.filter((q) => estado === 'rascunho' || q.alternativas.filter((a) => a.correcta).length === 1);
    const { count } = await prisma.questao.updateMany({ where: { codigo: { in: validas.map((q) => q.codigo) } }, data: { estado } });
    flash(req, 'ok', `${count} questões passaram a "${estado}".`);
    if (validas.length < alvo.length) flash(req, 'erro', `${alvo.length - validas.length} ficaram como estavam por não terem resposta correcta.`);
    res.redirect(`/admin/questoes?${qsFiltros(f, { pagina: 1 })}`);
  });

  r.post('/:codigo', upload.single('imagem'), verificarCsrf, gravar(false));

  r.post('/:codigo/apagar', async (req, res) => {
    // Os códigos nunca se reutilizam: o progresso dos alunos está ligado a eles.
    const q = await prisma.questao.findUnique({ where: { codigo: req.params.codigo } });
    if (q?.estado === 'publicada') {
      flash(req, 'erro', 'Uma questão publicada não se apaga: passa-a a rascunho para a retirar dos próximos pacotes.');
      return res.redirect(`/admin/questoes/${req.params.codigo}`);
    }
    await prisma.questao.delete({ where: { codigo: req.params.codigo } }).catch(() => undefined);
    flash(req, 'ok', `Questão apagada: ${req.params.codigo}`);
    res.redirect('/admin/questoes');
  });

  return r;
}
