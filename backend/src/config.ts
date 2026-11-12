import fs from 'node:fs';
import path from 'node:path';
import dotenv from 'dotenv';

/** Pasta do backend (a que tem o package.json): funciona em src/ (dev) e em dist/src/ (produção). */
function pastaRaiz(): string {
  let d = __dirname;
  while (!fs.existsSync(path.join(d, 'package.json')) && path.dirname(d) !== d) d = path.dirname(d);
  return d;
}

const RAIZ = pastaRaiz();
dotenv.config({ path: path.join(RAIZ, '.env') });

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

  /** Segredo extra para o hash dos códigos de activação (sem ele, os hashes não servem a ninguém). */
  get pepperCodigos() {
    return obrigatorio('CODIGO_PEPPER');
  },
  /** Ed25519 em base64: privada PKCS#8 DER; pública = 32 bytes "raw" (a mesma que vai na app). */
  get chavePrivadaLicencas() {
    return obrigatorio('LICENCA_CHAVE_PRIVADA');
  },
  get chavePublicaLicencas() {
    return obrigatorio('LICENCA_CHAVE_PUBLICA');
  },
  /** Validade por omissão dos códigos (fim da época de exames), AAAA-MM-DD. */
  validadePadrao: process.env.CODIGOS_VALIDADE_PADRAO ?? '',
  /** Tentativas de activação por hora, por IP e por dispositivo. */
  limiteActivacaoHora: Number(process.env.ACTIVACAO_LIMITE_HORA ?? 5),
  contactos: {
    mpesa: process.env.CONTACTO_MPESA ?? '',
    emola: process.env.CONTACTO_EMOLA ?? '',
    whatsapp: process.env.CONTACTO_WHATSAPP ?? '',
    nome_conta: process.env.CONTACTO_NOME_CONTA ?? 'Aprova+',
  },
};

export const dirImagens = () => path.join(config.storageDir, 'imagens');
export const dirImportacoes = () => path.join(config.storageDir, 'importacoes');
export const dirPacotes = () => path.join(config.storageDir, 'pacotes');

/** Fim do dia da validade padrão; se não houver, 31 de Março seguinte (fim da época de admissões). */
export function validadePadrao(): Date {
  if (/^\d{4}-\d{2}-\d{2}$/.test(config.validadePadrao)) return new Date(`${config.validadePadrao}T23:59:59.000Z`);
  const agora = new Date();
  const ano = agora.getUTCMonth() >= 3 ? agora.getUTCFullYear() + 1 : agora.getUTCFullYear();
  return new Date(`${ano}-03-31T23:59:59.000Z`);
}
