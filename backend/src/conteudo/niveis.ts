/**
 * Redistribuição dos níveis de uma prova:
 *  - nível 1: as N questões mais fáceis (por omissão 20), misturando temas, só com resposta;
 *  - níveis 2–10: as restantes por dificuldade crescente, em blocos de tamanho quase igual.
 * Só muda o nível (questao_prova.nivel); o texto das questões não é tocado.
 */
import type { PrismaClient } from '@prisma/client';
import { NUM_NIVEIS } from '../dominio';

export interface PlanoNiveis {
  prova: string;
  total: number;
  porNivel: Record<number, number>;
  /** questão → nível novo */
  atribuicao: Map<string, number>;
  /** questões sem resposta (não podem estar no nível 1) */
  semResposta: number;
}

/** Ordem estável "aleatória" a partir do código (para não depender da ordem do exame). */
function hash(s: string) {
  let h = 2166136261;
  for (const c of s) h = Math.imul(h ^ c.charCodeAt(0), 16777619);
  return h >>> 0;
}

/** Por dificuldade crescente e, dentro da mesma dificuldade, alternando os temas. */
function ordenar<T extends { codigo: string; dificuldade: number | null; tema: string | null }>(qs: T[]): T[] {
  const porDificuldade = new Map<number, T[]>();
  for (const q of qs) {
    const d = q.dificuldade ?? 3;
    porDificuldade.set(d, [...(porDificuldade.get(d) ?? []), q]);
  }
  const out: T[] = [];
  for (const d of [...porDificuldade.keys()].sort((a, b) => a - b)) {
    const porTema = new Map<string, T[]>();
    for (const q of porDificuldade.get(d)!.sort((a, b) => hash(a.codigo) - hash(b.codigo))) {
      const t = q.tema ?? '';
      porTema.set(t, [...(porTema.get(t) ?? []), q]);
    }
    const filas = [...porTema.values()];
    while (filas.some((f) => f.length)) for (const f of filas) if (f.length) out.push(f.shift()!);
  }
  return out;
}

export async function planearNiveis(db: PrismaClient, prova: string, nivel1 = 20): Promise<PlanoNiveis> {
  const ligacoes = await db.questaoProva.findMany({
    where: { prova },
    include: { q: { select: { codigo: true, dificuldade: true, tema: true, estado: true, alternativas: { select: { correcta: true } } } } },
  });
  const questoes = ligacoes.map((l) => ({
    codigo: l.q.codigo,
    dificuldade: l.q.dificuldade,
    tema: l.q.tema,
    temResposta: l.q.alternativas.filter((a) => a.correcta).length === 1,
  }));
  const ordenadas = ordenar(questoes);
  const comResposta = ordenadas.filter((q) => q.temResposta);
  const primeiro = new Set(comResposta.slice(0, nivel1).map((q) => q.codigo));
  const resto = ordenadas.filter((q) => !primeiro.has(q.codigo));

  const atribuicao = new Map<string, number>();
  for (const c of primeiro) atribuicao.set(c, 1);
  const niveisRestantes = NUM_NIVEIS - 1;
  resto.forEach((q, i) => atribuicao.set(q.codigo, 2 + Math.floor((i * niveisRestantes) / Math.max(resto.length, 1))));

  const porNivel: Record<number, number> = {};
  for (const n of atribuicao.values()) porNivel[n] = (porNivel[n] ?? 0) + 1;
  return { prova, total: questoes.length, porNivel, atribuicao, semResposta: questoes.length - comResposta.length };
}

export async function gravarNiveis(db: PrismaClient, plano: PlanoNiveis) {
  await db.$transaction(
    [...plano.atribuicao].map(([questao, nivel]) =>
      db.questaoProva.update({ where: { questao_prova: { questao, prova: plano.prova } }, data: { nivel } }),
    ),
  );
}
