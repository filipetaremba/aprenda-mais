/**
 * Importa conteúdo pela linha de comandos (mesmo motor da página "Importar JSON" do admin).
 *
 *   npm run importar -- <ficheiro.json | pasta-de-seeds> [--gravar] [--substituir]
 *
 * Sem --gravar só mostra o relatório (não altera nada).
 */
import { prisma } from '../src/db';
import { analisar, gravar, lerCaminho, type Relatorio } from '../src/conteudo/importador';

function imprimir(r: Relatorio) {
  console.log('\nFicheiros:');
  for (const f of r.ficheiros) console.log(`  ${f.nome.padEnd(40)} ${f.tipo.padEnd(24)} ${f.registos}`);
  console.log('\nCatálogo:', Object.entries(r.catalogo).map(([k, v]) => `${k}=${v}`).join(' '));
  const q = r.questoes;
  console.log(`Questões: ${q.novas} novas, ${q.existentes} já existem, ${q.aGravar} a gravar, ${q.ignoradas} removidas (ignoradas)`);
  for (const [prova, niveis] of Object.entries(r.porProvaNivel))
    console.log(`  ${prova.padEnd(10)} ${Object.entries(niveis).map(([n, c]) => `N${n}:${c}`).join(' ')}`);
  if (r.avisos.length) {
    console.log(`\nAvisos (${r.avisos.length}):`);
    for (const a of r.avisos.slice(0, 30)) console.log(`  ⚠ ${a.ficheiro}${a.onde ? ` [${a.onde}]` : ''}: ${a.texto}`);
    if (r.avisos.length > 30) console.log(`  … e mais ${r.avisos.length - 30}`);
  }
  if (r.erros.length) {
    console.log(`\nErros (${r.erros.length}):`);
    for (const e of r.erros.slice(0, 50)) console.log(`  ✖ ${e.ficheiro}${e.onde ? ` [${e.onde}]` : ''}: ${e.texto}`);
    if (r.erros.length > 50) console.log(`  … e mais ${r.erros.length - 50}`);
  }
}

async function main() {
  const args = process.argv.slice(2);
  const caminho = args.find((a) => !a.startsWith('--'));
  if (!caminho) {
    console.error('Uso: npm run importar -- <ficheiro.json | pasta> [--gravar] [--substituir]');
    process.exit(2);
  }
  const { ficheiros, pastaImagens } = lerCaminho(caminho);
  const { relatorio, plano } = await analisar(prisma, ficheiros, {
    pastaImagens,
    substituir: args.includes('--substituir'),
  });
  imprimir(relatorio);

  if (!relatorio.ok) {
    console.log('\n✖ Há erros: nada foi gravado.');
    process.exitCode = 1;
  } else if (args.includes('--gravar')) {
    const r = await gravar(prisma, plano);
    console.log(`\n✔ Gravado: ${r.questoes} questões, ${r.textos_base} textos base, ${r.imagens} imagens copiadas.`);
  } else {
    console.log('\nSem erros. Corre de novo com --gravar para importar.');
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
