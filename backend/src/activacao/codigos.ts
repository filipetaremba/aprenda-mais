/**
 * Códigos de activação: APV-XXXX-XXXX, gerados com crypto.randomInt (nunca Math.random).
 * Alfabeto sem caracteres ambíguos (sem 0/O e 1/I/L): 31 símbolos, 8 posições ≈ 8,5×10^11 combinações.
 * Guarda-se só HMAC-SHA256(pepper, código); o código em claro aparece apenas no momento da geração.
 */
import crypto from 'node:crypto';
import { config } from '../config';

export const ALFABETO = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';
const PREFIXO = 'APV';

export function gerarCodigo(): string {
  const parte = () => Array.from({ length: 4 }, () => ALFABETO[crypto.randomInt(ALFABETO.length)]).join('');
  return `${PREFIXO}-${parte()}-${parte()}`;
}

/**
 * Aceita o que o estudante escreve: minúsculas, espaços, sem hífenes, com ou sem "APV".
 * Devolve APV-XXXX-XXXX ou null se não tiver o formato.
 */
export function normalizarCodigo(entrada: string): string | null {
  let s = String(entrada ?? '').toUpperCase().replace(/[\s\-_.]/g, '');
  if (s.startsWith(PREFIXO)) s = s.slice(PREFIXO.length);
  if (s.length !== 8) return null;
  for (const c of s) if (!ALFABETO.includes(c)) return null;
  return `${PREFIXO}-${s.slice(0, 4)}-${s.slice(4)}`;
}

export function hashCodigo(codigoNormalizado: string): string {
  return crypto.createHmac('sha256', config.pepperCodigos).update(codigoNormalizado).digest('hex');
}

/** Parte visível no admin: APV-••••-K7QX */
export function finalCodigo(codigoNormalizado: string): string {
  return codigoNormalizado.slice(-4);
}

export const mascarar = (final: string) => `${PREFIXO}-••••-${final}`;

/** Telefone moçambicano: 9 dígitos a começar por 8 (aceita +258 / 258 / espaços). */
export function normalizarTelefone(entrada: string | undefined | null): string | null {
  if (!entrada) return null;
  let d = String(entrada).replace(/\D/g, '');
  if (d.length === 12 && d.startsWith('258')) d = d.slice(3);
  return /^8\d{8}$/.test(d) ? d : null;
}
