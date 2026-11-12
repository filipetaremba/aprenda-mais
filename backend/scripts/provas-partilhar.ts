/**
 * Para cada prova SEM questões próprias, escolhe uma prova da mesma disciplina cujas questões
 * passa a usar (campo `questoes_de`), de preferência do mesmo grupo de exame. Assim todos os
 * cursos com alguma disciplina com questões têm pelo menos um nível aberto.
 *
 *   npm run provas:partilhar               (só mostra o plano)
 *   npm run provas:partilhar -- --gravar
 *   npm run provas:partilhar -- --gravar --refazer   (recalcula também as já atribuídas)
 *
 * Pode-se mudar à mão no admin (Catálogo → Provas → "Usar questões de").
 */
import { prisma } from '../src/db';
import { atribuirDoadoras } from '../src/conteudo/provas';

async function main() {
  const gravar = process.argv.includes('--gravar');
  const r = await atribuirDoadoras(prisma, { gravar, refazer: process.argv.includes('--refazer') });
  const com = r.filter((x) => x.doadora);
  const sem = r.filter((x) => !x.doadora);
  console.log(`Provas sem questões próprias: ${r.length}`);
  for (const x of com) console.log(`  ${x.prova.padEnd(14)} ← ${x.doadora} (${x.questoes} questões)`);
  if (sem.length) console.log(`Sem nenhuma prova da mesma disciplina: ${sem.map((x) => `${x.prova} [${x.disciplina}]`).join(', ')}`);

  const ofertas = await prisma.oferta.findMany({ include: { provas: { include: { pr: { include: { questoes: { take: 1 } } } } } } });
  const abertas = ofertas.filter((o) => o.provas.some((x) => x.pr.questoes.length > 0 || com.some((c) => c.prova === x.prova)));
  console.log(`Cursos com pelo menos um nível aberto: ${abertas.length} de ${ofertas.length}`);
  console.log(gravar ? '✔ Gravado.' : 'Nada gravado. Corre com --gravar para aplicar.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
