import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

/** Cria uma base SQLite limpa para os testes (prisma/test.db) e limpa o storage de testes. */
export default function () {
  const raiz = path.resolve(__dirname, '..');
  for (const f of ['test.db', 'test.db-journal']) fs.rmSync(path.join(raiz, 'prisma', f), { force: true });
  fs.rmSync(path.join(raiz, 'storage-test'), { recursive: true, force: true });
  execFileSync(process.execPath, [path.join(raiz, 'node_modules', 'prisma', 'build', 'index.js'), 'migrate', 'deploy'], {
    cwd: raiz,
    env: { ...process.env, DATABASE_URL: 'file:./test.db' },
    stdio: 'pipe',
  });
}
