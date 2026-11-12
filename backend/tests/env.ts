// Corre em cada ficheiro de teste, antes de carregar a app.
process.env.NODE_ENV = 'test';
process.env.DATABASE_URL = 'file:./test.db';
process.env.SESSION_SECRET = 'segredo-de-testes-com-tamanho-suficiente';
process.env.STORAGE_DIR = './storage-test';
process.env.ADMIN_EMAIL = 'admin@teste.mz';
process.env.ADMIN_PASSWORD = 'password-de-teste';

// Chaves Ed25519 e pepper só para os testes (geradas em cada execução)
import crypto from 'node:crypto';
const { privateKey, publicKey } = crypto.generateKeyPairSync('ed25519');
process.env.LICENCA_CHAVE_PRIVADA = privateKey.export({ format: 'der', type: 'pkcs8' }).toString('base64');
process.env.LICENCA_CHAVE_PUBLICA = publicKey.export({ format: 'der', type: 'spki' }).subarray(12).toString('base64');
process.env.CODIGO_PEPPER = crypto.randomBytes(16).toString('hex');
process.env.CODIGOS_VALIDADE_PADRAO = '2099-03-31';
// Limite alto por omissão; o teste de rate limit cria uma app com o limite real (5)
process.env.ACTIVACAO_LIMITE_HORA = '1000';
process.env.CONTACTO_MPESA = '84 111 2222';
process.env.CONTACTO_WHATSAPP = '84 333 4444';
