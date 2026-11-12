/**
 * Cria produtos por omissão para cada prova com questões (só os que ainda não existem):
 *   <PROVA>-NIVEIS     níveis 3–10 da prova     PRECO_NIVEIS (59 MT)
 *   <PROVA>-SIMULADOS  simulados da prova       PRECO_SIMULADOS (49 MT)
 * Os preços e nomes editam-se depois no admin (Produtos).
 *
 *   npm run produtos:padrao [-- --niveis 59 --simulados 49]
 */
import { prisma } from '../src/db';

function arg(nome: string, padrao: number) {
  const i = process.argv.indexOf(nome);
  return i > 0 ? Number(process.argv[i + 1]) : padrao;
}

async function main() {
  const precoNiveis = arg('--niveis', 59);
  const precoSimulados = arg('--simulados', 49);
  const provas = await prisma.prova.findMany({
    where: { questoes: { some: {} } },
    include: { grupo: true },
    orderBy: { codigo: 'asc' },
  });
  let criados = 0;
  for (const [i, p] of provas.entries()) {
    const nome = `${p.nome} · ${p.grupo.codigo}`;
    for (const [tipo, sufixo, preco, descricao] of [
      ['niveis', 'NIVEIS', precoNiveis, 'Níveis 3 a 10'],
      ['simulados', 'SIMULADOS', precoSimulados, 'Simulados com tempo, como no exame'],
    ] as const) {
      const codigo = `${p.codigo}-${sufixo}`;
      if (await prisma.produto.findUnique({ where: { codigo } })) continue;
      await prisma.produto.create({
        data: {
          codigo,
          nome: tipo === 'niveis' ? nome : `Simulados de ${nome}`,
          descricao,
          tipo,
          preco_mt: preco,
          ordem: i * 2 + (tipo === 'niveis' ? 0 : 1),
          provas: { create: { prova: p.codigo } },
        },
      });
      criados++;
    }
  }
  console.log(`✔ ${criados} produtos criados (${provas.length} provas com questões).`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
