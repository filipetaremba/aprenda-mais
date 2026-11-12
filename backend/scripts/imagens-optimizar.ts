/**
 * Torna as imagens das questões mais compactas (no lugar): corta margens, largura máx. 720 px,
 * PNG com paleta reduzida. Os nomes não mudam.
 *
 *   npm run imagens:optimizar                 (storage/imagens do backend)
 *   npm run imagens:optimizar -- <pasta>
 */
import { dirImagens } from '../src/config';
import { optimizarPasta } from '../src/conteudo/imagens';

async function main() {
  const pasta = process.argv.slice(2).find((a) => !a.startsWith('--')) ?? dirImagens();
  const r = await optimizarPasta(pasta);
  const kb = (b: number) => `${Math.round(b / 1024)} KB`;
  console.log(`✔ ${r.ficheiros} imagens optimizadas em ${pasta}: ${kb(r.antes)} → ${kb(r.depois)} (${r.antes ? Math.round((1 - r.depois / r.antes) * 100) : 0}% menos)`);
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
