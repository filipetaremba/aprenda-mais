/**
 * Imagens compactas para a app: corta margens brancas, limita a largura, fundo branco e PNG com
 * paleta reduzida (figuras de exame são traço/texto: poucas cores chegam). Mantém o nome .png,
 * por isso nenhuma referência muda. Se o resultado não for mais pequeno, fica o original.
 */
import fs from 'node:fs';
import path from 'node:path';
import sharp from 'sharp';

export const LARGURA_MAXIMA = 720;
const MARGEM = 6;

export async function optimizarImagem(entrada: Buffer): Promise<Buffer> {
  try {
    const base = sharp(entrada)
      .flatten({ background: '#ffffff' })
      .trim({ background: '#ffffff', threshold: 12 })
      // o sharp redimensiona sempre antes de acrescentar a margem: descontá-la na largura
      .resize({ width: LARGURA_MAXIMA - 2 * MARGEM, withoutEnlargement: true })
      .extend({ top: MARGEM, bottom: MARGEM, left: MARGEM, right: MARGEM, background: '#ffffff' });
    const buf = await base.png({ palette: true, colours: 32, dither: 0.4, compressionLevel: 9, effort: 10 }).toBuffer();
    return buf.length < entrada.length ? buf : entrada;
  } catch {
    // Imagem que o sharp não percebe (ou toda branca): fica como está
    return entrada;
  }
}

/** Optimiza todas as imagens de uma pasta (no lugar). */
export async function optimizarPasta(pasta: string) {
  let antes = 0;
  let depois = 0;
  let n = 0;
  for (const nome of fs.readdirSync(pasta)) {
    if (!/\.(png|jpe?g|webp)$/i.test(nome)) continue;
    const ficheiro = path.join(pasta, nome);
    const original = fs.readFileSync(ficheiro);
    const novo = /\.png$/i.test(nome) ? await optimizarImagem(original) : original;
    antes += original.length;
    depois += novo.length;
    if (novo !== original) {
      fs.writeFileSync(ficheiro, novo);
      n++;
    }
  }
  return { ficheiros: n, antes, depois };
}
