/**
 * Exportação de conteúdo para a app, no formato de shared/content.schema.json:
 *
 *  - publicarProva(): pacote PAGO de uma prova = questões PUBLICADAS dos níveis > NIVEIS_GRATIS (3–10)
 *    + níveis + simulados, num .zip (pacote.json + imagens/), versão incremental e SHA-256.
 *  - exportarApp():   conteúdo GRÁTIS que vai dentro do APK = catálogo, preços, níveis e as
 *    questões publicadas dos níveis 1–NIVEIS_GRATIS (+ imagens).
 */
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import AdmZip from 'adm-zip';
import type { PrismaClient } from '@prisma/client';
import { config, dirImagens, dirPacotes } from '../config';
import { listaJson, NUM_NIVEIS } from '../dominio';
import { provaFonte } from './provas';

export const FORMATO = 1;

const sha256 = (b: Buffer | string) => crypto.createHash('sha256').update(b).digest('hex');

/** Versão legível a partir da data: AAAAMMDDHHMM (inteiro). */
const versaoData = (d = new Date()) => Number(d.toISOString().slice(0, 16).replace(/\D/g, ''));

// ───────────── Questões no formato dos seeds ─────────────

type Filtro = (nivel: number) => boolean;

/** { prova, textos_base, questoes } (= $defs/ficheiro_questoes) e as imagens usadas. */
async function ficheiroDaProva(db: PrismaClient, prova: string, incluirNivel: Filtro, estados: string[] = ['publicada']) {
  // Prova sem questões próprias usa as da prova doadora (mesma disciplina); o ficheiro sai com o código desta prova
  const fonte = await provaFonte(db, prova);
  const ligacoes = await db.questaoProva.findMany({
    where: { prova: fonte, nivel: { not: null }, q: { estado: { in: estados } } },
    include: { q: { include: { alternativas: { orderBy: { ordem: 'asc' } }, texto: true } } },
    orderBy: [{ nivel: 'asc' }, { questao: 'asc' }],
  });
  const imagens = new Set<string>();
  const textos_base: Record<string, { titulo: string | null; texto: string; fonte: string | null }> = {};
  const questoes = [];
  for (const { q, nivel } of ligacoes) {
    if (!nivel || !incluirNivel(nivel)) continue;
    const imgs = listaJson(q.imagens);
    imgs.forEach((i) => imagens.add(i));
    q.alternativas.forEach((a) => a.imagem && imagens.add(a.imagem));
    if (q.texto) textos_base[q.texto.codigo] = { titulo: q.texto.titulo, texto: q.texto.texto, fonte: q.texto.fonte };
    questoes.push({
      codigo: q.codigo,
      numero_original: q.numero_original,
      tipo: q.tipo,
      tema: q.tema,
      texto_base: q.texto_base,
      enunciado: q.enunciado,
      imagens: imgs,
      dica: q.dica,
      ano: q.ano,
      alternativas: q.alternativas.map((a) => ({ letra: a.letra, texto: a.texto, imagem: a.imagem })),
      resposta: { letra: q.alternativas.find((a) => a.correcta)?.letra ?? null, origem: q.resposta_origem, confianca: q.resposta_confianca },
      explicacao: { texto: q.explicacao, origem: q.explicacao_origem, revisto: q.explicacao_revista },
      dificuldade: q.dificuldade,
      nivel,
      estado: q.estado,
    });
  }
  return { ficheiro: { prova, textos_base, questoes }, imagens };
}

const niveisDaProva = async (db: PrismaClient, prova: string) =>
  (await db.nivel.findMany({ where: { prova }, orderBy: { numero: 'asc' } })).map((n) => ({
    prova: n.prova,
    numero: n.numero,
    titulo: n.titulo,
    descricao: n.descricao,
    nota_minima: n.nota_minima,
  }));

const simuladosDe = async (db: PrismaClient, where: object) =>
  (await db.simulado.findMany({ where, orderBy: { codigo: 'asc' } })).map((s) => ({
    codigo: s.codigo,
    prova: s.prova,
    oferta: s.oferta,
    titulo: s.titulo,
    duracao_min: s.duracao_min,
    num_perguntas: s.num_perguntas,
    gratuito: s.gratuito,
  }));

function verificarImagens(imagens: Set<string>) {
  const faltam = [...imagens].filter((i) => !fs.existsSync(path.join(dirImagens(), i)));
  if (faltam.length) throw new Error(`Imagens em falta no storage: ${faltam.slice(0, 5).join(', ')}${faltam.length > 5 ? '…' : ''}`);
}

// ───────────── Pacote pago de uma prova ─────────────

export type ResultadoPublicacao =
  | { estado: 'publicado'; versao: number; sha256: string; tamanho_bytes: number; num_questoes: number }
  | { estado: 'sem_alteracoes'; versao: number }
  | { estado: 'vazio' };

export async function publicarProva(db: PrismaClient, prova: string, adminId: number | null): Promise<ResultadoPublicacao> {
  await db.prova.findUniqueOrThrow({ where: { codigo: prova } });
  const pagos: Filtro = (n) => n > config.niveisGratis && n <= NUM_NIVEIS;
  const { ficheiro, imagens } = await ficheiroDaProva(db, prova, pagos);
  if (!ficheiro.questoes.length) return { estado: 'vazio' };
  verificarImagens(imagens);

  const corpo = {
    niveis_incluidos: Array.from({ length: NUM_NIVEIS - config.niveisGratis }, (_, i) => config.niveisGratis + i + 1),
    niveis: await niveisDaProva(db, prova),
    simulados: await simuladosDe(db, { prova }),
    conteudo: ficheiro,
  };
  const conteudoSha = sha256(JSON.stringify(corpo) + [...imagens].sort().map((i) => sha256(fs.readFileSync(path.join(dirImagens(), i)))).join());

  const ultimo = await db.pacote.findFirst({ where: { prova }, orderBy: { versao: 'desc' } });
  if (ultimo && ultimo.conteudo_sha256 === conteudoSha) return { estado: 'sem_alteracoes', versao: ultimo.versao };

  const versao = (ultimo?.versao ?? 0) + 1;
  const pacote = { formato: FORMATO, tipo: 'pacote', prova, versao, gerado_em: new Date().toISOString(), ...corpo };

  const zip = new AdmZip();
  zip.addFile('pacote.json', Buffer.from(JSON.stringify(pacote), 'utf8'));
  for (const i of [...imagens].sort()) zip.addLocalFile(path.join(dirImagens(), i), 'imagens/');
  const buffer = zip.toBuffer();

  const relativo = `${prova}/${prova}-v${versao}.zip`;
  const destino = path.join(dirPacotes(), relativo);
  fs.mkdirSync(path.dirname(destino), { recursive: true });
  fs.writeFileSync(`${destino}.tmp`, buffer);
  fs.renameSync(`${destino}.tmp`, destino);

  const r = await db.pacote.create({
    data: {
      prova,
      versao,
      ficheiro: relativo,
      sha256: sha256(buffer),
      conteudo_sha256: conteudoSha,
      tamanho_bytes: buffer.length,
      num_questoes: ficheiro.questoes.length,
      publicado_por: adminId,
    },
  });
  return { estado: 'publicado', versao, sha256: r.sha256, tamanho_bytes: r.tamanho_bytes, num_questoes: r.num_questoes };
}

export const caminhoPacote = (relativo: string) => path.join(dirPacotes(), relativo);

// ───────────── Conteúdo grátis para o APK ─────────────

/** `incluirRevistas`: só para desenvolvimento, inclui também as questões em estado "revista". */
export async function exportarApp(db: PrismaClient, saida: string, opcoes: { incluirRevistas?: boolean } = {}) {
  const estados = opcoes.incluirRevistas ? ['publicada', 'revista'] : ['publicada'];
  const gratis: Filtro = (n) => n >= 1 && n <= config.niveisGratis;
  const [grupos, instituicoes, disciplinas, temas, provas, cursos, ofertas, produtos] = await Promise.all([
    db.grupoExame.findMany({ orderBy: { codigo: 'asc' }, include: { instituicoes: { select: { codigo: true } } } }),
    db.instituicao.findMany({ orderBy: { codigo: 'asc' } }),
    db.disciplina.findMany({ orderBy: { codigo: 'asc' } }),
    db.tema.findMany({ orderBy: { codigo: 'asc' } }),
    db.prova.findMany({ orderBy: { codigo: 'asc' } }),
    db.curso.findMany(),
    db.oferta.findMany({ orderBy: { codigo: 'asc' }, include: { provas: { orderBy: { ordem: 'asc' } } } }),
    db.produto.findMany({ where: { activo: true }, orderBy: [{ ordem: 'asc' }, { codigo: 'asc' }], include: { provas: true } }),
  ]);
  const cursoPorCodigo = new Map(cursos.map((c) => [c.codigo, c]));

  const exames = [];
  const imagens = new Set<string>();
  const niveis = [];
  const comNivelAberto = new Set<string>();
  const fontes = new Map<string, string>();
  for (const p of provas) {
    niveis.push(...(await niveisDaProva(db, p.codigo)));
    const { ficheiro, imagens: imgs } = await ficheiroDaProva(db, p.codigo, gratis, estados);
    if (ficheiro.questoes.length) {
      exames.push(ficheiro);
      comNivelAberto.add(p.codigo);
    }
    imgs.forEach((i) => imagens.add(i));
    const fonte = await provaFonte(db, p.codigo);
    if (fonte !== p.codigo) fontes.set(p.codigo, fonte);
  }
  verificarImagens(imagens);
  // Na app só entram cursos com pelo menos um nível aberto (alguma prova com questões grátis)
  const ofertasApp = ofertas.filter((o) => o.provas.some((x) => comNivelAberto.has(x.prova)));
  const excluidas = ofertas.filter((o) => !ofertasApp.includes(o)).map((o) => o.codigo);

  const conteudo = {
    formato: FORMATO,
    tipo: 'conteudo_app',
    versao: versaoData(),
    gerado_em: new Date().toISOString(),
    meta: { nota_minima_padrao: config.notaMinimaPadrao, niveis_gratis: config.niveisGratis, inclui_revistas: !!opcoes.incluirRevistas },
    catalogo: {
      grupos_exame: grupos.map((g) => ({ codigo: g.codigo, nome: g.nome, instituicoes: g.instituicoes.map((i) => i.codigo), tem_gabarito: g.tem_gabarito })),
      instituicoes: instituicoes.map((i) => ({ codigo: i.codigo, sigla: i.sigla, nome: i.nome, grupo_exame: i.grupo_exame, provincias: listaJson(i.provincias) })),
      disciplinas: disciplinas.map((d) => ({ codigo: d.codigo, nome: d.nome, icone: d.icone })),
      temas: temas.map((t) => ({ codigo: t.codigo, disciplina: t.disciplina, nome: t.nome })),
      provas: provas.map((p) => ({
        codigo: p.codigo,
        grupo_exame: p.grupo_exame,
        disciplina: p.disciplina,
        variante: p.variante,
        tipo: p.tipo,
        nome: p.nome,
        duracao_min: p.duracao_min,
        num_questoes: p.num_questoes,
        num_alternativas: p.num_alternativas,
        ...(fontes.has(p.codigo) && { questoes_de: fontes.get(p.codigo) }),
      })),
      cursos: ofertasApp.map((o) => ({
        codigo: o.codigo,
        slug: o.slug,
        instituicao: o.instituicao,
        curso: o.curso,
        nome: cursoPorCodigo.get(o.curso)?.nome ?? o.nome_original,
        icone: cursoPorCodigo.get(o.curso)?.icone ?? null,
        nome_original: o.nome_original,
        faculdade: o.faculdade,
        local: listaJson(o.locais),
        regimes: listaJson(o.regimes),
        modelo_exame: o.modelo_exame,
        provas: o.provas.map((x) => ({ prova: x.prova, peso: x.peso })),
      })),
    },
    niveis,
    produtos: produtos.map((p) => ({
      codigo: p.codigo,
      nome: p.nome,
      descricao: p.descricao,
      tipo: p.tipo,
      preco_mt: p.preco_mt,
      epoca: p.epoca,
      ordem: p.ordem,
      provas: p.provas.map((x) => x.prova).sort(),
    })),
    simulados: await simuladosDe(db, {}),
    exames,
  };

  // A pasta de saída pertence a este script: substitui o conteúdo.json e a pasta imagens/
  fs.mkdirSync(saida, { recursive: true });
  const dirImg = path.join(saida, 'imagens');
  fs.rmSync(dirImg, { recursive: true, force: true });
  fs.mkdirSync(dirImg, { recursive: true });
  for (const i of imagens) fs.copyFileSync(path.join(dirImagens(), i), path.join(dirImg, i));
  fs.writeFileSync(path.join(saida, 'conteudo.json'), JSON.stringify(conteudo));

  return {
    versao: conteudo.versao,
    provas: provas.length,
    ofertas: ofertasApp.length,
    ofertasExcluidas: excluidas,
    provasPartilhadas: Object.fromEntries(fontes),
    produtos: produtos.length,
    questoes: exames.reduce((s, e) => s + e.questoes.length, 0),
    imagens: imagens.size,
    porProva: Object.fromEntries(exames.map((e) => [e.prova, e.questoes.length])),
  };
}
