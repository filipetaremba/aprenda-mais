/**
 * Gera o par de chaves Ed25519 das licenças e um pepper para os códigos.
 *
 *   npm run chaves:gerar
 *
 * Copia as linhas para o .env do servidor. A CHAVE PRIVADA nunca sai do servidor;
 * a CHAVE PÚBLICA vai para a app (--dart-define=LICENCA_CHAVE_PUBLICA=... ou constante).
 * Trocar as chaves invalida todas as licenças já emitidas.
 */
import crypto from 'node:crypto';
import { gerarParDeChaves } from '../src/activacao/licencas';

const { privada, publica } = gerarParDeChaves();
console.log('# --- colar no backend/.env ---');
console.log(`LICENCA_CHAVE_PRIVADA=${privada}`);
console.log(`LICENCA_CHAVE_PUBLICA=${publica}`);
if (process.argv.includes('--pepper')) console.log(`CODIGO_PEPPER=${crypto.randomBytes(32).toString('base64url')}`);
console.log('\n# Chave pública para a app (32 bytes, base64):');
console.log(publica);
