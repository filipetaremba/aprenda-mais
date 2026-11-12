/**
 * Importador de conteúdo (catálogo + questões) no formato de shared/content.schema.json.
 *
 * Dois passos, para o admin poder ver o relatório antes de gravar:
 *   1. analisar(ficheiros) → { relatorio, plano }   (não escreve nada)
 *   2. gravar(plano)       → grava tudo numa transacção
 */
import fs from 'node:fs';
import path from 'node:path';
import Ajv2020, { type ErrorObject } from 'ajv/dist/2020';
import type { Prisma, PrismaClient } from '@prisma/client';
import { config, dirImagens } from '../config';
import {
  NUM_NIVEIS,
  paraCodigo,
  validarRegrasQuestao,
  type AlternativaEntrada,
  type EstadoQuestao,
} from '../dominio';

// ───────────── Tipos de entrada (formato dos seeds) ─────────────

type Json = Record<string, any>;

export const TIPOS_CATALOGO = ['grupos_exame', 'instituicoes', 'disciplinas', 'temas', 'provas', 'cursos'] as const;
type TipoCatalogo = (typeof TIPOS_CATALOGO)[number];
/** Ficheiros conhecidos dos seeds que não entram na base de dados. */
const IGNORADOS = ['descartados'];

export interface FicheiroEntrada {
  nome: string;
  conteudo: string | Buffer;
}

export interface QuestaoPlano {
  codigo: string;
  prova: string;
  disciplina: string;
  tema: string | null;
  texto_base: string | null;
  tipo: string;
  enunciado: string;
  imagens: string[];
  dica: string | null;
  explicacao: string;
  explicacao_origem: string | null;
  explicacao_revista: boolean;
  resposta_origem: string | null;
  resposta_confianca: string | null;
  dificuldade: number | null;
  nivel: number | null;
  ano: number | null;
  variante: string | null;
  numero_original: number | null;
  fonte_ficheiro: string | null;
  fonte_pagina: number | null;
  estado: EstadoQuestao;
  alertas: string[];
  alternativas: (AlternativaEntrada & { ordem: number })[];
  /** true se já existe na base de dados (só é gravada com `substituir`). */
  existe: boolean;
}

export interface Plano {
  catalogo: Record<TipoCatalogo, Json[]>;
  textos_base: { codigo: string; titulo: string | null; texto: string; fonte: string | null }[];
  questoes: QuestaoPlano[];
  /** nome da imagem → caminho do ficheiro de origem (a copiar para storage/imagens) */
  imagens: Record<string, string>;
  substituir: boolean;
}

export interface Mensagem {
  ficheiro: string;
  onde?: string;
  texto: string;
}

export interface Relatorio {
  ok: boolean;
  erros: Mensagem[];
  avisos: Mensagem[];
  ficheiros: { nome: string; tipo: string; registos: number }[];
  catalogo: Record<string, number>;
  questoes: { novas: number; existentes: number; aGravar: number; ignoradas: number };
  /** prova → nível ("—" sem nível) → nº de questões */
  porProvaNivel: Record<string, Record<string, number>>;
}

export interface OpcoesAnalise {
  /** Imagens enviadas junto com o JSON (nome → caminho). */
  imagens?: Record<string, string>;
  /** Pasta onde procurar imagens em falta (ex.: seeds/imagens). */
  pastaImagens?: string;
  /** Regravar questões que já existem (por omissão ficam como estão). */
  substituir?: boolean;
}

// ───────────── Validação por schema ─────────────

let validadores: { catalogo: (d: unknown) => boolean; questoes: (d: unknown) => boolean } | null = null;
let ultimoErro: () => ErrorObject[] = () => [];

function obterValidadores() {
  if (validadores) return validadores;
  const schema = JSON.parse(fs.readFileSync(config.schemaConteudo, 'utf8'));
  const ajv = new Ajv2020({ allErrors: true, strict: false });
  ajv.addSchema(schema);
  const id = schema.$id as string;
  const cat = ajv.getSchema(`${id}#/$defs/catalogo`)!;
  const qst = ajv.getSchema(`${id}#/$defs/ficheiro_questoes`)!;
  validadores = {
    catalogo: (d) => {
      const r = cat(d) as boolean;
      ultimoErro = () => cat.errors ?? [];
      return r;
    },
    questoes: (d) => {
      const r = qst(d) as boolean;
      ultimoErro = () => qst.errors ?? [];
      return r;
    },
  };
  return validadores;
}

function errosAjv(ficheiro: string, max = 15): Mensagem[] {
  const lista = ultimoErro()
    // oneOf/anyOf repetem erros dos ramos; mostrar só os úteis
    .filter((e) => !['oneOf', 'anyOf', 'if'].includes(e.keyword));
  const msgs = lista.slice(0, max).map((e) => ({
    ficheiro,
    onde: e.instancePath || '/',
    texto: traduzirAjv(e),
  }));
  if (lista.length > max) msgs.push({ ficheiro, onde: '', texto: `… e mais ${lista.length - max} erros de formato` });
  return msgs;
}

function traduzirAjv(e: ErrorObject): string {
  const p = e.params as Record<string, unknown>;
  switch (e.keyword) {
    case 'required':
      return `falta o campo "${p.missingProperty}"`;
    case 'additionalProperties':
      return `campo desconhecido "${p.additionalProperty}"`;
    case 'type':
      return `tipo errado (esperado ${p.type})`;
    case 'enum':
      return `valor não permitido (permitidos: ${(p.allowedValues as unknown[]).join(', ')})`;
    case 'pattern':
      return `formato inválido (padrão ${p.pattern})`;
    case 'minItems':
      return `tem de ter pelo menos ${p.limit} elementos`;
    case 'maxItems':
      return `pode ter no máximo ${p.limit} elementos`;
    case 'minimum':
    case 'maximum':
      return `valor fora do intervalo (${e.keyword === 'minimum' ? '≥' : '≤'} ${p.limit})`;
    default:
      return e.message ?? 'inválido';
  }
}

// ───────────── Análise ─────────────

const ESTADO_SEED: Record<string, EstadoQuestao | null> = {
  extraida: 'revista',
  revista: 'revista',
  aprovada: 'publicada',
  rascunho: 'rascunho',
  publicada: 'publicada',
  removida: null,
};

function texto(v: unknown): string | null {
  return typeof v === 'string' && v.trim() ? v : null;
}

export async function analisar(
  db: PrismaClient,
  ficheiros: FicheiroEntrada[],
  opcoes: OpcoesAnalise = {},
): Promise<{ relatorio: Relatorio; plano: Plano }> {
  const v = obterValidadores();
  const erros: Mensagem[] = [];
  const avisos: Mensagem[] = [];
  const relFicheiros: Relatorio['ficheiros'] = [];
  const catalogo = Object.fromEntries(TIPOS_CATALOGO.map((t) => [t, [] as Json[]])) as Record<TipoCatalogo, Json[]>;
  const ficheirosQuestoes: { nome: string; dados: Json }[] = [];

  // 1. Ler, classificar e validar o formato
  for (const f of ficheiros) {
    let dados: unknown;
    try {
      dados = JSON.parse(f.conteudo.toString().replace(/^﻿/, ''));
    } catch (e) {
      erros.push({ ficheiro: f.nome, texto: `JSON inválido: ${(e as Error).message}` });
      continue;
    }
    const base = path.basename(f.nome, path.extname(f.nome)).toLowerCase();

    if (Array.isArray(dados)) {
      if (IGNORADOS.includes(base)) {
        relFicheiros.push({ nome: f.nome, tipo: 'ignorado', registos: dados.length });
        continue;
      }
      if (!(TIPOS_CATALOGO as readonly string[]).includes(base)) {
        erros.push({
          ficheiro: f.nome,
          texto: `Lista sem tipo conhecido. O nome do ficheiro tem de ser um de: ${TIPOS_CATALOGO.join(', ')}.json`,
        });
        continue;
      }
      dados = { [base]: dados };
    }

    const obj = dados as Json;
    if (obj && typeof obj === 'object' && 'questoes' in obj) {
      if (!v.questoes(obj)) {
        erros.push(...errosAjv(f.nome));
        continue;
      }
      ficheirosQuestoes.push({ nome: f.nome, dados: obj });
      relFicheiros.push({ nome: f.nome, tipo: `questões (${obj.prova})`, registos: obj.questoes.length });
    } else {
      if (!v.catalogo(obj)) {
        erros.push(...errosAjv(f.nome));
        continue;
      }
      for (const t of TIPOS_CATALOGO) {
        if (!obj[t]) continue;
        catalogo[t].push(...obj[t]);
        relFicheiros.push({ nome: f.nome, tipo: t, registos: obj[t].length });
      }
    }
  }

  // 2. Referências do catálogo (o que já existe na BD + o que vem na importação)
  const [gruposBD, discBD, instBD, temasBD, provasBD] = await Promise.all([
    db.grupoExame.findMany({ select: { codigo: true } }),
    db.disciplina.findMany({ select: { codigo: true } }),
    db.instituicao.findMany({ select: { codigo: true } }),
    db.tema.findMany({ select: { codigo: true, disciplina: true } }),
    db.prova.findMany({ select: { codigo: true, disciplina: true } }),
  ]);
  const grupos = new Set([...gruposBD.map((x) => x.codigo), ...catalogo.grupos_exame.map((x) => x.codigo)]);
  const disciplinas = new Set([...discBD.map((x) => x.codigo), ...catalogo.disciplinas.map((x) => x.codigo)]);
  const instituicoes = new Set([...instBD.map((x) => x.codigo), ...catalogo.instituicoes.map((x) => x.codigo)]);
  const temas = new Map<string, string>([
    ...temasBD.map((x): [string, string] => [x.codigo, x.disciplina]),
    ...catalogo.temas.map((x): [string, string] => [x.codigo, x.disciplina]),
  ]);
  const provas = new Map<string, string>([
    ...provasBD.map((x): [string, string] => [x.codigo, x.disciplina]),
    ...catalogo.provas.map((x): [string, string] => [x.codigo, x.disciplina]),
  ]);

  const duplicados = (t: TipoCatalogo, campo = 'codigo') => {
    const vistos = new Set<string>();
    for (const r of catalogo[t]) {
      if (vistos.has(r[campo])) erros.push({ ficheiro: t, texto: `Código repetido: ${r[campo]}` });
      vistos.add(r[campo]);
    }
  };
  TIPOS_CATALOGO.forEach((t) => duplicados(t));
  duplicados('cursos', 'slug');

  for (const i of catalogo.instituicoes)
    if (!grupos.has(i.grupo_exame))
      erros.push({ ficheiro: 'instituicoes', onde: i.codigo, texto: `Grupo de exame inexistente: ${i.grupo_exame}` });
  for (const t of catalogo.temas)
    if (!disciplinas.has(t.disciplina))
      erros.push({ ficheiro: 'temas', onde: t.codigo, texto: `Disciplina inexistente: ${t.disciplina}` });
  for (const p of catalogo.provas) {
    if (!grupos.has(p.grupo_exame))
      erros.push({ ficheiro: 'provas', onde: p.codigo, texto: `Grupo de exame inexistente: ${p.grupo_exame}` });
    if (!disciplinas.has(p.disciplina))
      erros.push({ ficheiro: 'provas', onde: p.codigo, texto: `Disciplina inexistente: ${p.disciplina}` });
  }
  for (const c of catalogo.cursos) {
    if (!instituicoes.has(c.instituicao))
      erros.push({ ficheiro: 'cursos', onde: c.codigo, texto: `Instituição inexistente: ${c.instituicao}` });
    for (const p of c.provas ?? []) {
      const cod = typeof p === 'string' ? p : p.prova;
      if (!provas.has(cod)) erros.push({ ficheiro: 'cursos', onde: c.codigo, texto: `Prova inexistente: ${cod}` });
    }
  }

  // 3. Questões
  const existentes = new Set(
    (
      await db.questao.findMany({
        where: { codigo: { in: ficheirosQuestoes.flatMap((f) => f.dados.questoes.map((q: Json) => q.codigo)) } },
        select: { codigo: true },
      })
    ).map((q) => q.codigo),
  );
  const imagensDisponiveis = new Map<string, string>(Object.entries(opcoes.imagens ?? {}));
  const imagemExiste = (nome: string) => {
    if (imagensDisponiveis.has(nome)) return true;
    if (fs.existsSync(path.join(dirImagens(), nome))) return true;
    if (opcoes.pastaImagens) {
      const p = path.join(opcoes.pastaImagens, nome);
      if (fs.existsSync(p)) {
        imagensDisponiveis.set(nome, p);
        return true;
      }
    }
    return false;
  };

  const questoes: QuestaoPlano[] = [];
  const textosBase: Plano['textos_base'] = [];
  const codigosVistos = new Set<string>();
  let ignoradas = 0;
  let semDica = 0;
  let comAlertas = 0;

  for (const { nome, dados } of ficheirosQuestoes) {
    const prova: string = dados.prova;
    const disciplina = provas.get(prova);
    if (!disciplina) {
      erros.push({ ficheiro: nome, texto: `Prova inexistente: ${prova} (importa primeiro o catálogo)` });
      continue;
    }
    const fonte = dados.fonte ?? {};
    const ano: number | null = fonte.ano ?? null;
    const variante: string | null = fonte.variante ?? null;
    const prefixoTexto = `${prova}-${ano ?? 'X'}${variante ?? ''}`;
    const idsTexto = new Set(Object.keys(dados.textos_base ?? {}));
    for (const [id, t] of Object.entries<Json>(dados.textos_base ?? {}))
      textosBase.push({ codigo: `${prefixoTexto}-${id}`, titulo: t.titulo ?? null, texto: t.texto, fonte: t.fonte ?? null });

    for (const q of dados.questoes as Json[]) {
      const onde = q.codigo;
      if (codigosVistos.has(q.codigo)) {
        erros.push({ ficheiro: nome, onde, texto: 'Código de questão repetido na importação' });
        continue;
      }
      codigosVistos.add(q.codigo);

      const estadoSeed: string = q.estado ?? 'rascunho';
      let estado = ESTADO_SEED[estadoSeed];
      if (estado === null) {
        ignoradas++;
        continue;
      }
      const letraCerta: string | null = q.resposta?.letra ?? null;
      if (!letraCerta) {
        estado = 'rascunho';
        avisos.push({ ficheiro: nome, onde, texto: 'Sem resposta: importada como rascunho (não pode ser publicada).' });
      } else if (!q.alternativas.some((a: Json) => a.letra === letraCerta)) {
        erros.push({ ficheiro: nome, onde, texto: `A resposta "${letraCerta}" não corresponde a nenhuma alternativa` });
      }

      if (q.tema && !temas.has(q.tema)) erros.push({ ficheiro: nome, onde, texto: `Tema inexistente: ${q.tema}` });
      else if (q.tema && temas.get(q.tema) !== disciplina)
        avisos.push({ ficheiro: nome, onde, texto: `O tema ${q.tema} é de outra disciplina` });
      if (q.texto_base && !idsTexto.has(q.texto_base))
        erros.push({ ficheiro: nome, onde, texto: `Texto base inexistente no ficheiro: ${q.texto_base}` });

      const alternativas = (q.alternativas as Json[]).map((a, i) => ({
        letra: a.letra,
        texto: texto(a.texto),
        imagem: texto(a.imagem),
        correcta: a.letra === letraCerta,
        ordem: i + 1,
      }));
      const imagens: string[] = q.imagens ?? [];
      for (const img of [...imagens, ...alternativas.map((a) => a.imagem).filter((x): x is string => !!x)])
        if (!imagemExiste(img)) erros.push({ ficheiro: nome, onde, texto: `Imagem em falta: ${img}` });

      const plano: QuestaoPlano = {
        codigo: q.codigo,
        prova,
        disciplina,
        tema: q.tema ?? null,
        texto_base: q.texto_base ? `${prefixoTexto}-${q.texto_base}` : null,
        tipo: q.tipo,
        enunciado: q.enunciado,
        imagens,
        dica: texto(q.dica),
        explicacao: q.explicacao?.texto ?? '',
        explicacao_origem: q.explicacao?.origem ?? null,
        explicacao_revista: !!q.explicacao?.revisto,
        resposta_origem: q.resposta?.origem ?? null,
        resposta_confianca: q.resposta?.confianca ?? null,
        dificuldade: q.dificuldade ?? null,
        nivel: q.nivel ?? null,
        ano: q.ano ?? ano,
        variante,
        numero_original: q.numero_original ?? null,
        fonte_ficheiro: fonte.ficheiro ?? null,
        fonte_pagina: q.pagina ?? null,
        estado,
        alertas: q.alertas ?? [],
        alternativas,
        existe: existentes.has(q.codigo),
      };
      for (const e of validarRegrasQuestao(plano)) erros.push({ ficheiro: nome, onde, texto: e });
      if (!plano.dica) semDica++;
      if (plano.alertas.length) comAlertas++;
      questoes.push(plano);
    }
  }

  if (semDica) avisos.push({ ficheiro: '—', texto: `${semDica} questões sem dica (o botão de dica fica desactivado na app).` });
  if (comAlertas)
    avisos.push({ ficheiro: '—', texto: `${comAlertas} questões com alertas da extracção (ver filtro "Com alertas").` });

  const substituir = !!opcoes.substituir;
  const aGravar = questoes.filter((q) => !q.existe || substituir);
  const porProvaNivel: Relatorio['porProvaNivel'] = {};
  for (const q of aGravar) {
    const n = q.nivel ? String(q.nivel) : '—';
    porProvaNivel[q.prova] ??= {};
    porProvaNivel[q.prova][n] = (porProvaNivel[q.prova][n] ?? 0) + 1;
  }

  const relatorio: Relatorio = {
    ok: erros.length === 0,
    erros,
    avisos,
    ficheiros: relFicheiros,
    catalogo: Object.fromEntries(TIPOS_CATALOGO.map((t) => [t, catalogo[t].length])),
    questoes: {
      novas: questoes.filter((q) => !q.existe).length,
      existentes: questoes.filter((q) => q.existe).length,
      aGravar: aGravar.length,
      ignoradas,
    },
    porProvaNivel,
  };
  const imagens: Record<string, string> = {};
  for (const q of aGravar)
    for (const img of [...q.imagens, ...q.alternativas.map((a) => a.imagem)])
      if (img && imagensDisponiveis.has(img)) imagens[img] = imagensDisponiveis.get(img)!;

  return { relatorio, plano: { catalogo, textos_base: textosBase, questoes: aGravar, imagens, substituir } };
}

// ───────────── Gravação ─────────────

export interface ResultadoGravacao {
  catalogo: Record<string, number>;
  questoes: number;
  textos_base: number;
  imagens: number;
}

const json = (v: unknown) => JSON.stringify(v ?? []);

export async function gravar(db: PrismaClient, plano: Plano): Promise<ResultadoGravacao> {
  const c = plano.catalogo;
  await db.$transaction(
    async (tx: Prisma.TransactionClient) => {
      for (const g of c.grupos_exame) {
        const d = { nome: g.nome, tem_gabarito: !!g.tem_gabarito };
        await tx.grupoExame.upsert({ where: { codigo: g.codigo }, create: { codigo: g.codigo, ...d }, update: d });
      }
      for (const x of c.disciplinas) {
        const d = { nome: x.nome, aliases: json(x.aliases), ...(x.icone !== undefined && { icone: x.icone }) };
        await tx.disciplina.upsert({ where: { codigo: x.codigo }, create: { codigo: x.codigo, ...d }, update: d });
      }
      for (const i of c.instituicoes) {
        const d = {
          sigla: i.sigla,
          nome: i.nome,
          grupo_exame: i.grupo_exame,
          provincias: json(i.provincias),
          edital_ano: i.edital?.ano ?? null,
        };
        await tx.instituicao.upsert({ where: { codigo: i.codigo }, create: { codigo: i.codigo, ...d }, update: d });
      }
      for (const t of c.temas) {
        const d = { disciplina: t.disciplina, nome: t.nome };
        await tx.tema.upsert({ where: { codigo: t.codigo }, create: { codigo: t.codigo, ...d }, update: d });
      }
      for (const p of c.provas) {
        const d = {
          grupo_exame: p.grupo_exame,
          disciplina: p.disciplina,
          variante: p.variante ?? null,
          tipo: p.tipo ?? 'escrita',
          nome: p.nome,
          duracao_min: p.duracao_min ?? null,
          num_questoes: p.num_questoes ?? null,
          num_alternativas: p.num_alternativas ?? null,
          nota: p.nota ?? null,
        };
        await tx.prova.upsert({ where: { codigo: p.codigo }, create: { codigo: p.codigo, ...d }, update: d });
        // 10 níveis por prova; títulos editáveis no admin (não se sobrepõem)
        for (let n = 1; n <= NUM_NIVEIS; n++)
          await tx.nivel.upsert({
            where: { prova_numero: { prova: p.codigo, numero: n } },
            create: { prova: p.codigo, numero: n, titulo: `Nível ${n}` },
            update: {},
          });
      }
      for (const o of c.cursos) {
        const curso = o.curso ?? paraCodigo(o.nome);
        await tx.curso.upsert({
          where: { codigo: curso },
          create: { codigo: curso, nome: o.nome, icone: o.icone ?? null },
          update: o.icone ? { icone: o.icone } : {},
        });
        const d = {
          slug: o.slug,
          curso,
          instituicao: o.instituicao,
          nome_original: o.nome_original ?? o.nome,
          faculdade: Array.isArray(o.faculdade) ? o.faculdade.join(' | ') : (o.faculdade ?? ''),
          locais: json(Array.isArray(o.local) ? o.local : o.local ? [o.local] : []),
          regimes: json(o.regimes),
          modelo_exame: o.modelo_exame ?? null,
          vagas: json(o.vagas),
          fonte_ficheiro: o.fonte?.ficheiro ?? null,
          fonte_pagina: o.fonte?.pagina ?? null,
        };
        await tx.oferta.upsert({ where: { codigo: o.codigo }, create: { codigo: o.codigo, ...d }, update: d });
        await tx.ofertaProva.deleteMany({ where: { oferta: o.codigo } });
        await tx.ofertaProva.createMany({
          data: (o.provas as (string | Json)[]).map((p, i) => ({
            oferta: o.codigo,
            prova: typeof p === 'string' ? p : p.prova,
            peso: typeof p === 'string' ? null : (p.peso ?? null),
            ordem: i + 1,
          })),
        });
      }

      for (const t of plano.textos_base) {
        const d = { titulo: t.titulo, texto: t.texto, fonte: t.fonte };
        await tx.textoBase.upsert({ where: { codigo: t.codigo }, create: { codigo: t.codigo, ...d }, update: d });
      }

      for (const q of plano.questoes) {
        const { alternativas, prova, nivel, existe: _e, imagens, alertas, ...resto } = q;
        const d = { ...resto, imagens: json(imagens), alertas: json(alertas) };
        await tx.questao.upsert({ where: { codigo: q.codigo }, create: d, update: d });
        await tx.alternativa.deleteMany({ where: { questao: q.codigo } });
        await tx.alternativa.createMany({ data: alternativas.map((a) => ({ ...a, questao: q.codigo })) });
        await tx.questaoProva.upsert({
          where: { questao_prova: { questao: q.codigo, prova } },
          create: { questao: q.codigo, prova, nivel },
          update: { nivel },
        });
      }
    },
    { timeout: 300_000, maxWait: 30_000 },
  );

  // Imagens fora da transacção (ficheiros); copiar só depois de a BD gravar bem.
  fs.mkdirSync(dirImagens(), { recursive: true });
  let imagens = 0;
  for (const [nome, origem] of Object.entries(plano.imagens)) {
    const destino = path.join(dirImagens(), path.basename(nome));
    if (path.resolve(origem) !== path.resolve(destino)) {
      fs.copyFileSync(origem, destino);
      imagens++;
    }
  }

  return {
    catalogo: Object.fromEntries(TIPOS_CATALOGO.map((t) => [t, c[t].length])),
    questoes: plano.questoes.length,
    textos_base: plano.textos_base.length,
    imagens,
  };
}

/** Lê uma pasta de seeds (catalogo/*.json, questoes/**\/*.json, imagens/) ou um único ficheiro. */
export function lerCaminho(caminho: string): { ficheiros: FicheiroEntrada[]; pastaImagens?: string } {
  const st = fs.statSync(caminho);
  if (st.isFile()) return { ficheiros: [{ nome: path.basename(caminho), conteudo: fs.readFileSync(caminho) }] };
  const ficheiros: FicheiroEntrada[] = [];
  const percorrer = (dir: string) => {
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) {
        if (!['schema', 'relatorios', 'imagens'].includes(e.name)) percorrer(p);
      } else if (e.name.endsWith('.json')) {
        ficheiros.push({ nome: path.relative(caminho, p).replace(/\\/g, '/'), conteudo: fs.readFileSync(p) });
      }
    }
  };
  percorrer(caminho);
  // Catálogo primeiro, por ordem de dependência (só para o relatório ficar arrumado)
  ficheiros.sort((a, b) => Number(a.nome.includes('questoes/')) - Number(b.nome.includes('questoes/')) || a.nome.localeCompare(b.nome));
  const pastaImagens = path.join(caminho, 'imagens');
  return { ficheiros, pastaImagens: fs.existsSync(pastaImagens) ? pastaImagens : undefined };
}
