/**
 * Licenças assinadas com Ed25519.
 *
 * A licença é um JSON canónico (texto) e a assinatura é Ed25519 sobre os bytes UTF-8 desse texto.
 * A app verifica OFFLINE com a chave pública embutida (32 bytes, base64) e só depois faz o parse.
 */
import crypto from 'node:crypto';
import { config } from '../config';

export interface ConteudoLicenca {
  v: 1;
  id: string;
  estudante: string;
  produto: string;
  tipo: string;
  provas: string[];
  /** ISO 8601 (UTC) ou null = sem fim */
  valido_ate: string | null;
  emitida_em: string;
}

/** Prefixo DER SPKI de uma chave pública Ed25519 (seguido dos 32 bytes da chave). */
const SPKI_ED25519 = Buffer.from('302a300506032b6570032100', 'hex');

export function gerarParDeChaves() {
  const { privateKey, publicKey } = crypto.generateKeyPairSync('ed25519');
  const privada = privateKey.export({ format: 'der', type: 'pkcs8' }).toString('base64');
  const spki = publicKey.export({ format: 'der', type: 'spki' });
  const publica = spki.subarray(SPKI_ED25519.length).toString('base64');
  return { privada, publica };
}

export function chavePublicaDeRaw(base64: string) {
  const raw = Buffer.from(base64, 'base64');
  if (raw.length !== 32) throw new Error('Chave pública Ed25519 tem de ter 32 bytes');
  return crypto.createPublicKey({ key: Buffer.concat([SPKI_ED25519, raw]), format: 'der', type: 'spki' });
}

let privadaCache: crypto.KeyObject | null = null;
function chavePrivada() {
  privadaCache ??= crypto.createPrivateKey({ key: Buffer.from(config.chavePrivadaLicencas, 'base64'), format: 'der', type: 'pkcs8' });
  return privadaCache;
}

/** Texto canónico: ordem fixa das chaves, provas ordenadas, sem espaços. */
export function serializarLicenca(c: ConteudoLicenca): string {
  return JSON.stringify({
    v: c.v,
    id: c.id,
    estudante: c.estudante,
    produto: c.produto,
    tipo: c.tipo,
    provas: [...c.provas].sort(),
    valido_ate: c.valido_ate,
    emitida_em: c.emitida_em,
  });
}

export function assinar(texto: string): string {
  return crypto.sign(null, Buffer.from(texto, 'utf8'), chavePrivada()).toString('base64');
}

export function verificar(texto: string, assinaturaBase64: string, chavePublicaBase64: string): boolean {
  try {
    return crypto.verify(null, Buffer.from(texto, 'utf8'), chavePublicaDeRaw(chavePublicaBase64), Buffer.from(assinaturaBase64, 'base64'));
  } catch {
    return false;
  }
}

/** Uma licença está válida se não foi revogada e não passou da validade. */
export function licencaValida(l: { revogada: boolean; valido_ate: Date | null }, agora = new Date()) {
  return !l.revogada && (!l.valido_ate || l.valido_ate > agora);
}
