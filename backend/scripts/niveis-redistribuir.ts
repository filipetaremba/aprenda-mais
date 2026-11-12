/**
 * Redistribui os níveis de todas as provas com questões próprias:
 * nível 1 com N questões (por omissão 20, as mais fáceis, temas misturados, só com resposta)
 * e as restantes pelos níveis 2–10 por dificuldade crescente.
 *
 *   npm run niveis:redistribuir                       (só mostra o plano)
 *   npm run niveis:redistribuir -- --gravar
 *   npm run niveis:redistribuir -- --nivel1 25 --prova UEM-MAT2 --gravar
 *
 * As provas que usam questões de outra (questoes_de) seguem a distribuição da doadora.
 * Atenção: reimportar os seeds com --substituir repõe os níveis dos seeds.
 */
import { prisma } from '../src/db';
import { gravarNiveis, planearNiveis } from '../src/conteudo/niveis';

function arg(nome: string) {
  const i = process.argv.indexOf(nome);
  return i > 0 ? process.argv[i + 1] : undefined;
}

async function main() {
  const gravar = process.argv.includes('--gravar');
  const nivel1 = Number(arg('--nivel1') ?? 20);
  const so = arg('--prova');
  const provas = (await prisma.questaoProva.groupBy({ by: ['prova'], orderBy: { prova: 'asc' } }))
    .map((p) => p.prova)
    .filter((p) => !so || p === so);

  for (const prova of provas) {
    const plano = await planearNiveis(prisma, prova, nivel1);
    const linha = Array.from({ length: 10 }, (_, i) => `N${i + 1}:${plano.porNivel[i + 1] ?? 0}`).join(' ');
    const aviso = (plano.porNivel[1] ?? 0) < nivel1 ? `  ⚠ só ${plano.porNivel[1] ?? 0} com resposta para o nível 1` : '';
    console.log(`${prova.padEnd(10)} ${String(plano.total).padStart(3)}  ${linha}${aviso}`);
    if (gravar) await gravarNiveis(prisma, plano);
  }
  console.log(gravar ? '✔ Níveis gravados. Publica de novo os pacotes das provas e corre exportar:app.' : 'Nada gravado. Corre com --gravar para aplicar.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
