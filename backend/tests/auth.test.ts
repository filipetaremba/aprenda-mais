import request from 'supertest';
import { createApp } from '../src/app';
import { prisma } from '../src/db';
import { criarAdmin, EMAIL, entrar, extrairCsrf, PASSWORD } from './ajuda';

const app = createApp();
beforeAll(criarAdmin);
afterAll(() => prisma.$disconnect());

test('sem sessão, o admin redirecciona para o login', async () => {
  const r = await request(app).get('/admin/questoes').expect(302);
  expect(r.headers.location).toMatch(/^\/admin\/login/);
});

test('login com password errada é recusado', async () => {
  const agente = request.agent(app);
  const csrf = extrairCsrf((await agente.get('/admin/login')).text);
  const r = await agente.post('/admin/login').type('form').send({ _csrf: csrf, email: EMAIL, password: 'errada-123' }).expect(401);
  expect(r.text).toContain('Email ou password incorrectos');
  await agente.get('/admin').expect(302);
});

test('login sem token CSRF é recusado', async () => {
  await request(app).post('/admin/login').type('form').send({ email: EMAIL, password: PASSWORD }).expect(403);
});

test('login certo abre o painel; o cookie é httpOnly; logout termina a sessão', async () => {
  const agente = request.agent(app);
  const csrf = extrairCsrf((await agente.get('/admin/login')).text);
  const r = await agente
    .post('/admin/login')
    .type('form')
    .send({ _csrf: csrf, email: EMAIL.toUpperCase(), password: PASSWORD })
    .expect(302);
  expect(r.headers.location).toBe('/admin');
  expect(String(r.headers['set-cookie'])).toMatch(/HttpOnly/i);

  const painel = await agente.get('/admin').expect(200);
  expect(painel.text).toContain('Questões por prova');

  await agente.post('/admin/logout').type('form').send({ _csrf: extrairCsrf(painel.text) }).expect(302);
  await agente.get('/admin').expect(302);
});

test('o helper entrar() devolve sessão e token', async () => {
  const { csrf } = await entrar(app);
  expect(csrf.length).toBeGreaterThan(20);
});
