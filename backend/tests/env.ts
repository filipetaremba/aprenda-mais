// Corre em cada ficheiro de teste, antes de carregar a app.
process.env.NODE_ENV = 'test';
process.env.DATABASE_URL = 'file:./test.db';
process.env.SESSION_SECRET = 'segredo-de-testes-com-tamanho-suficiente';
process.env.STORAGE_DIR = './storage-test';
process.env.ADMIN_EMAIL = 'admin@teste.mz';
process.env.ADMIN_PASSWORD = 'password-de-teste';
