import path from 'node:path';
import dotenv from 'dotenv';

dotenv.config({ path: path.resolve(__dirname, '..', '.env') });

const RAIZ = path.resolve(__dirname, '..');

function obrigatorio(nome: string): string {
  const v = process.env[nome];
  if (!v) throw new Error(`Falta a variável ${nome} no .env (ver .env.example)`);
  return v;
}

export const config = {
  raiz: RAIZ,
  porta: Number(process.env.PORT ?? 3000),
  producao: process.env.NODE_ENV === 'production',
  segredoSessao: obrigatorio('SESSION_SECRET'),
  storageDir: path.resolve(RAIZ, process.env.STORAGE_DIR ?? './storage'),
  notaMinimaPadrao: Number(process.env.NOTA_MINIMA_PADRAO ?? 70),
  niveisGratis: Number(process.env.NIVEIS_GRATIS ?? 2),
  /** Esquema JSON do conteúdo (fonte da verdade, partilhado com a app). */
  schemaConteudo: path.resolve(RAIZ, '..', 'shared', 'content.schema.json'),
};

export const dirImagens = () => path.join(config.storageDir, 'imagens');
export const dirImportacoes = () => path.join(config.storageDir, 'importacoes');
