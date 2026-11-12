/**
 * CRUD genérico do catálogo e dos produtos: cada entidade é descrita por uma configuração
 * (campos, colunas da lista) e partilha as mesmas vistas (catalogo/lista, catalogo/form).
 */
import { Router, type Request } from 'express';
import { Prisma } from '@prisma/client';
import { prisma } from '../db';
import { listaJson, NUM_NIVEIS, TIPOS_PRODUTO } from '../dominio';
import { flash } from '../seguranca';

type TipoCampo = 'texto' | 'textarea' | 'numero' | 'bool' | 'lista' | 'ref' | 'opcoes' | 'provas';

interface Campo {
  nome: string;
  label: string;
  tipo: TipoCampo;
  obrigatorio?: boolean;
  /** Chave primária: só se escreve ao criar. */
  chave?: boolean;
  /** Para campos texto NOT NULL opcionais: guardar '' em vez de null. */
  vazio?: string;
  ref?: { modelo: string; texto: string };
  opcoes?: readonly string[];
  /** Tipo 'provas': tabela de ligação e se tem peso. */
  ligacao?: { modelo: 'ofertaProva' | 'produtoProva'; fk: string; comPeso: boolean };
  ajuda?: string;
  padrao?: unknown;
}

interface Entidade {
  chave: string;
  titulo: string;
  singular: string;
  modelo: string;
  campos: Campo[];
  colunas: string[];
  procurar: string[];
  ordem: Record<string, 'asc' | 'desc'>;
}

const CODIGO: Campo = {
  nome: 'codigo',
  label: 'Código',
  tipo: 'texto',
  obrigatorio: true,
  chave: true,
  ajuda: 'Maiúsculas, sem acentos, separado por "-". Não muda depois de criado.',
};

export const ENTIDADES: Entidade[] = [
  {
    chave: 'grupos_exame',
    titulo: 'Grupos de exame',
    singular: 'grupo de exame',
    modelo: 'grupoExame',
    campos: [CODIGO, { nome: 'nome', label: 'Nome', tipo: 'texto', obrigatorio: true }, { nome: 'tem_gabarito', label: 'Os exames têm gabarito oficial', tipo: 'bool' }],
    colunas: ['codigo', 'nome', 'tem_gabarito'],
    procurar: ['codigo', 'nome'],
    ordem: { codigo: 'asc' },
  },
  {
    chave: 'instituicoes',
    titulo: 'Instituições',
    singular: 'instituição',
    modelo: 'instituicao',
    campos: [
      CODIGO,
      { nome: 'sigla', label: 'Sigla', tipo: 'texto', obrigatorio: true },
      { nome: 'nome', label: 'Nome', tipo: 'texto', obrigatorio: true },
      { nome: 'grupo_exame', label: 'Grupo de exame', tipo: 'ref', obrigatorio: true, ref: { modelo: 'grupoExame', texto: 'nome' } },
      { nome: 'provincias', label: 'Províncias', tipo: 'lista', ajuda: 'Uma por linha.' },
      { nome: 'edital_ano', label: 'Ano do edital', tipo: 'numero' },
    ],
    colunas: ['codigo', 'sigla', 'nome', 'grupo_exame'],
    procurar: ['codigo', 'sigla', 'nome'],
    ordem: { codigo: 'asc' },
  },
  {
    chave: 'disciplinas',
    titulo: 'Disciplinas',
    singular: 'disciplina',
    modelo: 'disciplina',
    campos: [
      CODIGO,
      { nome: 'nome', label: 'Nome', tipo: 'texto', obrigatorio: true },
      { nome: 'icone', label: 'Ícone (emoji)', tipo: 'texto' },
      { nome: 'aliases', label: 'Outros nomes', tipo: 'lista', ajuda: 'Nomes que aparecem nos editais. Um por linha.' },
    ],
    colunas: ['codigo', 'icone', 'nome'],
    procurar: ['codigo', 'nome'],
    ordem: { codigo: 'asc' },
  },
  {
    chave: 'temas',
    titulo: 'Temas',
    singular: 'tema',
    modelo: 'tema',
    campos: [
      CODIGO,
      { nome: 'disciplina', label: 'Disciplina', tipo: 'ref', obrigatorio: true, ref: { modelo: 'disciplina', texto: 'nome' } },
      { nome: 'nome', label: 'Nome', tipo: 'texto', obrigatorio: true },
    ],
    colunas: ['codigo', 'disciplina', 'nome'],
    procurar: ['codigo', 'nome', 'disciplina'],
    ordem: { codigo: 'asc' },
  },
  {
    chave: 'provas',
    titulo: 'Provas',
    singular: 'prova',
    modelo: 'prova',
    campos: [
      { ...CODIGO, ajuda: 'Grupo + disciplina (+ variante). Ex.: UEM-MAT2.' },
      { nome: 'nome', label: 'Nome', tipo: 'texto', obrigatorio: true },
      { nome: 'grupo_exame', label: 'Grupo de exame', tipo: 'ref', obrigatorio: true, ref: { modelo: 'grupoExame', texto: 'nome' } },
      { nome: 'disciplina', label: 'Disciplina', tipo: 'ref', obrigatorio: true, ref: { modelo: 'disciplina', texto: 'nome' } },
      { nome: 'variante', label: 'Variante', tipo: 'texto', ajuda: 'I, II, III… (vazio se não houver).' },
      { nome: 'tipo', label: 'Tipo', tipo: 'opcoes', opcoes: ['escrita', 'pratica'], obrigatorio: true, padrao: 'escrita' },
      { nome: 'duracao_min', label: 'Duração do simulado (min)', tipo: 'numero' },
      { nome: 'num_questoes', label: 'Nº de questões do exame', tipo: 'numero' },
      { nome: 'num_alternativas', label: 'Nº de alternativas', tipo: 'numero' },
      { nome: 'nota', label: 'Nota interna', tipo: 'textarea' },
    ],
    colunas: ['codigo', 'nome', 'grupo_exame', 'disciplina', 'duracao_min'],
    procurar: ['codigo', 'nome'],
    ordem: { codigo: 'asc' },
  },
  {
    chave: 'cursos',
    titulo: 'Cursos',
    singular: 'curso',
    modelo: 'curso',
    campos: [
      { ...CODIGO, ajuda: 'Curso genérico, sem instituição. Ex.: ENGENHARIA-INFORMATICA.' },
      { nome: 'nome', label: 'Nome', tipo: 'texto', obrigatorio: true },
      { nome: 'icone', label: 'Ícone (emoji)', tipo: 'texto' },
    ],
    colunas: ['codigo', 'icone', 'nome'],
    procurar: ['codigo', 'nome'],
    ordem: { nome: 'asc' },
  },
  {
    chave: 'ofertas',
    titulo: 'Ofertas',
    singular: 'oferta (curso numa instituição)',
    modelo: 'oferta',
    campos: [
      CODIGO,
      { nome: 'slug', label: 'Slug', tipo: 'texto', obrigatorio: true, ajuda: 'minúsculas-com-hifens, único.' },
      { nome: 'curso', label: 'Curso', tipo: 'ref', obrigatorio: true, ref: { modelo: 'curso', texto: 'nome' } },
      { nome: 'instituicao', label: 'Instituição', tipo: 'ref', obrigatorio: true, ref: { modelo: 'instituicao', texto: 'nome' } },
      { nome: 'nome_original', label: 'Nome no edital', tipo: 'texto', obrigatorio: true },
      { nome: 'faculdade', label: 'Faculdade', tipo: 'texto', vazio: '' },
      { nome: 'locais', label: 'Locais', tipo: 'lista', ajuda: 'Um por linha.' },
      { nome: 'regimes', label: 'Regimes', tipo: 'lista', ajuda: 'laboral, pos-laboral… Um por linha.' },
      { nome: 'modelo_exame', label: 'Modelo de exame', tipo: 'texto' },
      {
        nome: 'provas',
        label: 'Provas exigidas',
        tipo: 'provas',
        ligacao: { modelo: 'ofertaProva', fk: 'oferta', comPeso: true },
        ajuda: 'Separadas por vírgula, com peso opcional. Ex.: UEM-MAT3:50, UEM-FIS1:50',
      },
    ],
    colunas: ['codigo', 'nome_original', 'instituicao', 'provas'],
    procurar: ['codigo', 'nome_original', 'instituicao'],
    ordem: { codigo: 'asc' },
  },
  {
    chave: 'simulados',
    titulo: 'Simulados',
    singular: 'simulado',
    modelo: 'simulado',
    campos: [
      CODIGO,
      { nome: 'titulo', label: 'Título', tipo: 'texto', obrigatorio: true },
      { nome: 'prova', label: 'Prova (simulado de uma disciplina)', tipo: 'ref', ref: { modelo: 'prova', texto: 'nome' } },
      { nome: 'oferta', label: 'Oferta (simulado completo do curso)', tipo: 'ref', ref: { modelo: 'oferta', texto: 'nome_original' } },
      { nome: 'duracao_min', label: 'Duração (min)', tipo: 'numero', obrigatorio: true },
      { nome: 'num_perguntas', label: 'Nº de perguntas', tipo: 'numero', obrigatorio: true },
      { nome: 'gratuito', label: 'Gratuito', tipo: 'bool' },
    ],
    colunas: ['codigo', 'titulo', 'prova', 'oferta', 'duracao_min', 'gratuito'],
    procurar: ['codigo', 'titulo'],
    ordem: { codigo: 'asc' },
  },
];

export const PRODUTOS: Entidade = {
  chave: 'produtos',
  titulo: 'Produtos e preços',
  singular: 'produto',
  modelo: 'produto',
  campos: [
    { ...CODIGO, ajuda: 'Ex.: UEM-MAT2-NIVEIS ou UEM-ENG-PACOTE.' },
    { nome: 'nome', label: 'Nome', tipo: 'texto', obrigatorio: true, ajuda: 'Como aparece na app. Ex.: "Matemática + Física".' },
    { nome: 'descricao', label: 'Descrição', tipo: 'textarea' },
    { nome: 'tipo', label: 'Tipo', tipo: 'opcoes', opcoes: TIPOS_PRODUTO, obrigatorio: true, padrao: 'niveis' },
    { nome: 'preco_mt', label: 'Preço (MT)', tipo: 'numero', obrigatorio: true },
    { nome: 'epoca', label: 'Época', tipo: 'texto', ajuda: 'Ex.: 2026.' },
    { nome: 'ordem', label: 'Ordem na loja', tipo: 'numero', padrao: 0 },
    { nome: 'activo', label: 'Activo (visível na app)', tipo: 'bool', padrao: true },
    {
      nome: 'provas',
      label: 'Provas que abre',
      tipo: 'provas',
      ligacao: { modelo: 'produtoProva', fk: 'produto', comPeso: false },
      ajuda: 'Códigos separados por vírgula. Ex.: UEM-MAT2, UEM-FIS1',
    },
  ],
  colunas: ['codigo', 'nome', 'tipo', 'preco_mt', 'activo', 'provas'],
  procurar: ['codigo', 'nome'],
  ordem: { ordem: 'asc' },
};

// ───────────── Utilitários ─────────────

const delegado = (modelo: string) => (prisma as any)[modelo];

function textoLigacao(linhas: { prova: string; peso?: number | null }[]) {
  return linhas.map((l) => (l.peso != null ? `${l.prova}:${l.peso}` : l.prova)).join(', ');
}

/** "UEM-MAT3:50, UEM-FIS1" → [{prova, peso}] */
function lerLigacao(v: string) {
  return v
    .split(/[,;\n]/)
    .map((s) => s.trim())
    .filter(Boolean)
    .map((s) => {
      const [prova, peso] = s.split(':').map((x) => x.trim());
      return { prova: prova.toUpperCase(), peso: peso ? Number(peso) : null };
    });
}

async function opcoesRef(ent: Entidade) {
  const out: Record<string, { valor: string; texto: string }[]> = {};
  for (const c of ent.campos.filter((c) => c.tipo === 'ref')) {
    const linhas = await delegado(c.ref!.modelo).findMany({ select: { codigo: true, [c.ref!.texto]: true }, orderBy: { codigo: 'asc' } });
    out[c.nome] = linhas.map((l: any) => ({ valor: l.codigo, texto: `${l.codigo} — ${l[c.ref!.texto]}` }));
  }
  return out;
}

/** Converte um registo da BD nos valores do formulário. */
async function valoresForm(ent: Entidade, reg: any) {
  const v: Record<string, unknown> = {};
  for (const c of ent.campos) {
    if (c.tipo === 'lista') v[c.nome] = listaJson(reg?.[c.nome]).join('\n');
    else if (c.tipo === 'provas')
      v[c.nome] = reg
        ? textoLigacao(await delegado(c.ligacao!.modelo).findMany({ where: { [c.ligacao!.fk]: reg.codigo }, orderBy: c.ligacao!.comPeso ? { ordem: 'asc' } : undefined }))
        : '';
    else v[c.nome] = reg?.[c.nome] ?? c.padrao ?? '';
  }
  return v;
}

/** Lê e valida o formulário. Devolve dados para o Prisma, ligações e erros. */
async function lerForm(ent: Entidade, body: Record<string, any>, criar: boolean) {
  const dados: Record<string, unknown> = {};
  const erros: string[] = [];
  let ligacao: { campo: Campo; linhas: { prova: string; peso: number | null }[] } | null = null;

  for (const c of ent.campos) {
    if (c.chave && !criar) continue;
    const bruto = body[c.nome];
    const s = typeof bruto === 'string' ? bruto.trim() : '';
    switch (c.tipo) {
      case 'bool':
        dados[c.nome] = bruto === 'on' || bruto === '1' || bruto === 'true';
        break;
      case 'numero': {
        if (!s) {
          if (c.obrigatorio) erros.push(`${c.label} é obrigatório.`);
          dados[c.nome] = c.padrao ?? null;
        } else if (!/^-?\d+$/.test(s)) erros.push(`${c.label} tem de ser um número inteiro.`);
        else dados[c.nome] = Number(s);
        break;
      }
      case 'lista':
        dados[c.nome] = JSON.stringify(s.split(/\r?\n/).map((x) => x.trim()).filter(Boolean));
        break;
      case 'provas': {
        const linhas = lerLigacao(s);
        const existentes = new Set(
          (await prisma.prova.findMany({ where: { codigo: { in: linhas.map((l) => l.prova) } }, select: { codigo: true } })).map((p) => p.codigo),
        );
        for (const l of linhas) {
          if (!existentes.has(l.prova)) erros.push(`Prova inexistente: ${l.prova}`);
          if (l.peso != null && (Number.isNaN(l.peso) || l.peso < 0 || l.peso > 100)) erros.push(`Peso inválido em ${l.prova}`);
        }
        ligacao = { campo: c, linhas };
        break;
      }
      default: {
        if (!s) {
          if (c.obrigatorio) erros.push(`${c.label} é obrigatório.`);
          dados[c.nome] = c.vazio ?? null;
        } else {
          dados[c.nome] = c.chave ? s.toUpperCase() : s;
          if (c.opcoes && !c.opcoes.includes(s)) erros.push(`${c.label}: valor inválido.`);
        }
      }
    }
  }
  if (criar && dados.codigo && !/^[A-Z0-9]+(-[A-Z0-9]+)*$/.test(String(dados.codigo)))
    erros.push('Código inválido: só maiúsculas, números e "-".');
  return { dados, erros, ligacao: ligacao as typeof ligacao };
}

function mensagemPrisma(e: unknown): string | null {
  if (e instanceof Prisma.PrismaClientKnownRequestError) {
    if (e.code === 'P2002') return 'Já existe um registo com esse código (ou slug).';
    if (e.code === 'P2003') return 'Não é possível: este registo está ligado a outros (ex.: questões, ofertas, códigos).';
    if (e.code === 'P2025') return 'Registo não encontrado.';
  }
  return null;
}

function valorColuna(ent: Entidade, reg: any, col: string, ligacoes: Map<string, string>) {
  const campo = ent.campos.find((c) => c.nome === col);
  if (campo?.tipo === 'provas') return ligacoes.get(reg.codigo) ?? '';
  if (campo?.tipo === 'bool') return reg[col] ? 'Sim' : 'Não';
  if (col === 'preco_mt') return `${reg[col]} MT`;
  return reg[col] ?? '';
}

// ───────────── Router genérico ─────────────

function crud(ent: Entidade, base: string, tabs: boolean) {
  const r = Router();
  const comuns = (extra: object) => ({ ent, base, tabs: tabs ? ENTIDADES : null, ...extra });

  r.get('/', async (req, res) => {
    const q = String(req.query.q ?? '').trim();
    const where = q ? { OR: ent.procurar.map((c) => ({ [c]: { contains: q } })) } : {};
    const [registos, total] = await Promise.all([
      delegado(ent.modelo).findMany({ where, orderBy: ent.ordem, take: 300 }),
      delegado(ent.modelo).count({ where }),
    ]);
    const ligacoes = new Map<string, string>();
    const campoLig = ent.campos.find((c) => c.tipo === 'provas');
    if (campoLig && ent.colunas.includes(campoLig.nome)) {
      const linhas = await delegado(campoLig.ligacao!.modelo).findMany({ where: { [campoLig.ligacao!.fk]: { in: registos.map((x: any) => x.codigo) } } });
      const agrupadas = new Map<string, any[]>();
      for (const l of linhas) agrupadas.set(l[campoLig.ligacao!.fk], [...(agrupadas.get(l[campoLig.ligacao!.fk]) ?? []), l]);
      for (const [k, v] of agrupadas) ligacoes.set(k, textoLigacao(v));
    }
    const linhas = registos.map((reg: any) => ({ codigo: reg.codigo, valores: ent.colunas.map((c) => valorColuna(ent, reg, c, ligacoes)) }));
    res.render('catalogo/lista', comuns({ linhas, total, q }));
  });

  r.get('/novo', async (_req, res) => {
    res.render('catalogo/form', comuns({ criar: true, valores: await valoresForm(ent, null), opcoes: await opcoesRef(ent), erros: [] }));
  });

  r.get('/:codigo', async (req, res) => {
    const reg = await delegado(ent.modelo).findUnique({ where: { codigo: req.params.codigo } });
    if (!reg) return res.status(404).render('erro', { titulo: 'Não encontrado', mensagem: `${ent.singular} inexistente.` });
    res.render('catalogo/form', comuns({ criar: false, codigo: reg.codigo, valores: await valoresForm(ent, reg), opcoes: await opcoesRef(ent), erros: [] }));
  });

  const gravar = (criar: boolean) => async (req: Request, res: any) => {
    const codigo = criar ? undefined : req.params.codigo;
    const { dados, erros, ligacao } = await lerForm(ent, req.body, criar);
    const reRender = async (errosFinal: string[]) =>
      res.status(400).render('catalogo/form', comuns({ criar, codigo, valores: { ...req.body }, opcoes: await opcoesRef(ent), erros: errosFinal }));
    if (erros.length) return reRender(erros);
    try {
      const pk = (criar ? dados.codigo : codigo) as string;
      await prisma.$transaction(async (tx) => {
        const d = (tx as any)[ent.modelo];
        if (criar) await d.create({ data: dados });
        else await d.update({ where: { codigo }, data: dados });
        if (ligacao) {
          const { modelo, fk, comPeso } = ligacao.campo.ligacao!;
          await (tx as any)[modelo].deleteMany({ where: { [fk]: pk } });
          if (ligacao.linhas.length)
            await (tx as any)[modelo].createMany({
              data: ligacao.linhas.map((l, i) => (comPeso ? { [fk]: pk, prova: l.prova, peso: l.peso, ordem: i + 1 } : { [fk]: pk, prova: l.prova })),
            });
        }
        // Cada prova nova tem logo os 10 níveis
        if (criar && ent.modelo === 'prova')
          await tx.nivel.createMany({ data: Array.from({ length: NUM_NIVEIS }, (_, i) => ({ prova: pk, numero: i + 1, titulo: `Nível ${i + 1}` })) });
      });
      flash(req, 'ok', `${ent.singular[0].toUpperCase()}${ent.singular.slice(1)} gravado(a): ${pk}`);
      res.redirect(base);
    } catch (e) {
      const m = mensagemPrisma(e);
      if (m) return reRender([m]);
      throw e;
    }
  };

  r.post('/novo', gravar(true));
  r.post('/:codigo', gravar(false));

  r.post('/:codigo/apagar', async (req, res) => {
    try {
      await prisma.$transaction(async (tx) => {
        if (ent.modelo === 'prova') await tx.nivel.deleteMany({ where: { prova: req.params.codigo } });
        await (tx as any)[ent.modelo].delete({ where: { codigo: req.params.codigo } });
      });
      flash(req, 'ok', `Apagado: ${req.params.codigo}`);
    } catch (e) {
      flash(req, 'erro', mensagemPrisma(e) ?? 'Não foi possível apagar.');
    }
    res.redirect(base);
  });

  return r;
}

// ───────────── Níveis (por prova) ─────────────

function niveisRouter() {
  const r = Router();
  r.get('/', async (req, res) => {
    const provas = await prisma.prova.findMany({ select: { codigo: true, nome: true }, orderBy: { codigo: 'asc' } });
    const prova = String(req.query.prova ?? provas[0]?.codigo ?? '');
    const niveis = await prisma.nivel.findMany({ where: { prova }, orderBy: { numero: 'asc' } });
    const contagens = Object.fromEntries(
      (await prisma.questaoProva.groupBy({ by: ['nivel'], where: { prova }, _count: { _all: true } })).map((c) => [c.nivel ?? 0, c._count._all]),
    );
    res.render('catalogo/niveis', { tabs: ENTIDADES, provas, prova, niveis, contagens, base: '/admin/catalogo/niveis' });
  });

  r.post('/', async (req, res) => {
    const prova = String(req.body.prova ?? '');
    const linhas: any[] = Object.values(req.body.niveis ?? {});
    for (const l of linhas) {
      const numero = Number(l.numero);
      const nota = String(l.nota_minima ?? '').trim();
      if (!numero || numero < 1 || numero > NUM_NIVEIS) continue;
      const dados = {
        titulo: String(l.titulo ?? '').trim() || `Nível ${numero}`,
        descricao: String(l.descricao ?? '').trim() || null,
        nota_minima: nota ? Math.max(0, Math.min(100, Number(nota) || 0)) : null,
      };
      await prisma.nivel.upsert({ where: { prova_numero: { prova, numero } }, create: { prova, numero, ...dados }, update: dados });
    }
    flash(req, 'ok', `Níveis de ${prova} gravados.`);
    res.redirect(`/admin/catalogo/niveis?prova=${encodeURIComponent(prova)}`);
  });
  return r;
}

export function catalogoRouter() {
  const r = Router();
  r.get('/', (_req, res) => res.redirect('/admin/catalogo/instituicoes'));
  r.use('/niveis', niveisRouter());
  for (const ent of ENTIDADES) r.use(`/${ent.chave}`, crud(ent, `/admin/catalogo/${ent.chave}`, true));
  return r;
}

export function produtosRouter() {
  return crud(PRODUTOS, '/admin/produtos', false);
}
