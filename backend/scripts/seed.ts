/**
 * Dados iniciais: cria (ou actualiza a password do) primeiro admin a partir de ADMIN_EMAIL/ADMIN_PASSWORD.
 * Opcional: SEED_CATALOGO=<pasta> importa também o catálogo dos seeds (sem questões).
 *
 *   npm run db:seed
 */
import fs from 'node:fs';
import path from 'node:path';
import bcrypt from 'bcryptjs';
import { prisma } from '../src/db';
import { analisar, gravar, lerCaminho } from '../src/conteudo/importador';

async function main() {
  const email = process.env.ADMIN_EMAIL?.trim().toLowerCase();
  const password = process.env.ADMIN_PASSWORD;
  if (!email || !password) throw new Error('Define ADMIN_EMAIL e ADMIN_PASSWORD no .env');
  if (password.length < 10) throw new Error('ADMIN_PASSWORD tem de ter pelo menos 10 caracteres');

  const password_hash = await bcrypt.hash(password, 12);
  await prisma.admin.upsert({ where: { email }, create: { email, password_hash, nome: 'Administrador' }, update: { password_hash } });
  console.log(`✔ Admin pronto: ${email}`);

  const pasta = process.env.SEED_CATALOGO;
  if (pasta) {
    const dir = path.resolve(pasta);
    if (!fs.existsSync(dir)) throw new Error(`SEED_CATALOGO não existe: ${dir}`);
    const { ficheiros } = lerCaminho(dir);
    const { relatorio, plano } = await analisar(prisma, ficheiros);
    if (!relatorio.ok) {
      relatorio.erros.slice(0, 20).forEach((e) => console.error(`  ✖ ${e.ficheiro} [${e.onde ?? ''}] ${e.texto}`));
      throw new Error('O catálogo tem erros; nada foi importado.');
    }
    const r = await gravar(prisma, plano);
    console.log('✔ Catálogo importado:', r.catalogo);
  }
}

main()
  .catch((e) => {
    console.error(e.message ?? e);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
