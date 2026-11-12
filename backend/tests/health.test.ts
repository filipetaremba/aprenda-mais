import request from 'supertest';
import { createApp } from '../src/app';
import { prisma } from '../src/db';

afterAll(() => prisma.$disconnect());

test('GET /health responde ok com a base de dados ligada', async () => {
  const r = await request(createApp()).get('/health').expect(200);
  expect(r.body).toEqual({ ok: true, bd: 'ok' });
});
