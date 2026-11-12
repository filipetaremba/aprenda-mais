import bcrypt from 'bcryptjs';
import request from 'supertest';
import type { Express } from 'express';
import { prisma } from '../src/db';

export const EMAIL = 'admin@teste.mz';
export const PASSWORD = 'password-de-teste';

export function extrairCsrf(html: string): string {
  const m = html.match(/name="_csrf" value="([^"]+)"/);
  if (!m) throw new Error('Sem token CSRF na página');
  return m[1];
}

export async function criarAdmin() {
  const password_hash = await bcrypt.hash(PASSWORD, 4);
  await prisma.admin.upsert({ where: { email: EMAIL }, create: { email: EMAIL, password_hash }, update: { password_hash, activo: true } });
}

/** Agente com sessão de admin iniciada e o token CSRF da sessão. */
export async function entrar(app: Express) {
  await criarAdmin();
  const agente = request.agent(app);
  const login = await agente.get('/admin/login');
  await agente
    .post('/admin/login')
    .type('form')
    .send({ _csrf: extrairCsrf(login.text), email: EMAIL, password: PASSWORD })
    .expect(302);
  const painel = await agente.get('/admin').expect(200);
  return { agente, csrf: extrairCsrf(painel.text) };
}

/** Catálogo mínimo: grupo TST, disciplina MAT, prova TST-MAT, tema MAT-FUNCOES. */
export async function catalogoMinimo() {
  await prisma.grupoExame.upsert({ where: { codigo: 'TST' }, create: { codigo: 'TST', nome: 'Grupo de teste' }, update: {} });
  await prisma.disciplina.upsert({ where: { codigo: 'MAT' }, create: { codigo: 'MAT', nome: 'Matemática' }, update: {} });
  await prisma.tema.upsert({ where: { codigo: 'MAT-FUNCOES' }, create: { codigo: 'MAT-FUNCOES', disciplina: 'MAT', nome: 'Funções' }, update: {} });
  await prisma.prova.upsert({
    where: { codigo: 'TST-MAT' },
    create: { codigo: 'TST-MAT', grupo_exame: 'TST', disciplina: 'MAT', nome: 'Matemática (teste)' },
    update: {},
  });
}
