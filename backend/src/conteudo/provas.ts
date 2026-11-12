/**
 * Provas partilhadas: uma prova sem questões próprias pode usar as de outra prova da MESMA
 * disciplina (campo `questoes_de`). Assim todos os cursos têm pelo menos um nível aberto.
 * As questões próprias têm sempre prioridade: quando a prova recebe questões, deixa de emprestar.
 */
import type { PrismaClient } from '@prisma/client';

/** Prova cujas questões devem ser usadas para [prova]. */
export async function provaFonte(db: PrismaClient, prova: string): Promise<string> {
  const proprias = await db.questaoProva.count({ where: { prova } });
  if (proprias > 0) return prova;
  const p = await db.prova.findUnique({ where: { codigo: prova }, select: { questoes_de: true } });
  return p?.questoes_de ?? prova;
}

export interface Atribuicao {
  prova: string;
  disciplina: string;
  doadora: string | null;
  questoes: number;
}

/**
 * Escolhe a doadora de cada prova sem questões próprias: mesma disciplina, de preferência do mesmo
 * grupo de exame e, entre essas, a que tem mais questões. Com [gravar] grava em `questoes_de`
 * (só preenche as que ainda não têm doadora, a não ser com [refazer]).
 */
export async function atribuirDoadoras(db: PrismaClient, { gravar = false, refazer = false } = {}): Promise<Atribuicao[]> {
  const provas = await db.prova.findMany({ orderBy: { codigo: 'asc' } });
  const contagem = new Map(
    (await db.questaoProva.groupBy({ by: ['prova'], _count: { _all: true } })).map((c) => [c.prova, c._count._all]),
  );
  const out: Atribuicao[] = [];
  for (const p of provas) {
    if ((contagem.get(p.codigo) ?? 0) > 0) continue;
    if (p.questoes_de && !refazer) {
      out.push({ prova: p.codigo, disciplina: p.disciplina, doadora: p.questoes_de, questoes: contagem.get(p.questoes_de) ?? 0 });
      continue;
    }
    const candidatas = provas
      .filter((x) => x.disciplina === p.disciplina && (contagem.get(x.codigo) ?? 0) > 0)
      .sort(
        (a, b) =>
          Number(b.grupo_exame === p.grupo_exame) - Number(a.grupo_exame === p.grupo_exame) ||
          (contagem.get(b.codigo) ?? 0) - (contagem.get(a.codigo) ?? 0),
      );
    const doadora = candidatas[0]?.codigo ?? null;
    out.push({ prova: p.codigo, disciplina: p.disciplina, doadora, questoes: doadora ? (contagem.get(doadora) ?? 0) : 0 });
    if (gravar && doadora !== p.questoes_de) await db.prova.update({ where: { codigo: p.codigo }, data: { questoes_de: doadora } });
  }
  return out;
}
