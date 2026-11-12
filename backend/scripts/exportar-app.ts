/**
 * Exporta o conteúdo GRÁTIS (catálogo, preços, níveis e questões publicadas dos níveis 1–NIVEIS_GRATIS)
 * para dentro da app: mobile/assets/content/conteudo.json + imagens/.
 *
 *   npm run exportar:app                       (por omissão ../mobile/assets/content)
 *   npm run exportar:app -- --saida <pasta>
 */
import path from 'node:path';
import { config } from '../src/config';
import { prisma } from '../src/db';
import { exportarApp } from '../src/conteudo/pacotes';

async function main() {
  const i = process.argv.indexOf('--saida');
  const saida = path.resolve(i > 0 ? process.argv[i + 1] : path.join(config.raiz, '..', 'mobile', 'assets', 'content'));
  const r = await exportarApp(prisma, saida);
  console.log(`✔ Conteúdo da app v${r.versao} em ${saida}`);
  console.log(`  ${r.provas} provas, ${r.ofertas} ofertas, ${r.produtos} produtos, ${r.questoes} questões grátis, ${r.imagens} imagens`);
  for (const [prova, n] of Object.entries(r.porProva)) console.log(`  ${prova.padEnd(10)} ${n}`);
  if (!r.questoes) console.log('  ⚠ Nenhuma questão publicada nos níveis grátis: publica-as primeiro no admin.');
}

main()
  .catch((e) => {
    console.error(e.message ?? e);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
