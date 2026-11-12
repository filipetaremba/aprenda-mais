import { prisma } from '../src/db';
import { gravarNiveis, planearNiveis } from '../src/conteudo/niveis';

afterAll(() => prisma.$disconnect());

beforeAll(async () => {
  await prisma.grupoExame.create({ data: { codigo: 'NIV', nome: 'Grupo níveis' } });
  await prisma.disciplina.upsert({ where: { codigo: 'QUI' }, create: { codigo: 'QUI', nome: 'Química' }, update: {} });
  await prisma.tema.createMany({
    data: [
      { codigo: 'QUI-A', disciplina: 'QUI', nome: 'A' },
      { codigo: 'QUI-B', disciplina: 'QUI', nome: 'B' },
    ],
  });
  await prisma.prova.create({ data: { codigo: 'NIV-QUI', grupo_exame: 'NIV', disciplina: 'QUI', nome: 'Química' } });
  // 40 questões: dificuldades 1–4, dois temas, 3 sem resposta (as primeiras, todas fáceis)
  for (let i = 1; i <= 40; i++) {
    const semResposta = i <= 3;
    await prisma.questao.create({
      data: {
        codigo: `NIV-QUI-2025-${String(i).padStart(3, '0')}`,
        disciplina: 'QUI',
        tema: i % 2 ? 'QUI-A' : 'QUI-B',
        tipo: 'escolha_multipla',
        enunciado: `Questão ${i}`,
        explicacao: 'x',
        dificuldade: 1 + ((i * 7) % 4),
        estado: semResposta ? 'rascunho' : 'revista',
        alternativas: { create: ['A', 'B', 'C', 'D'].map((l, k) => ({ letra: l, texto: l, correcta: !semResposta && k === 0, ordem: k + 1 })) },
        provas: { create: { prova: 'NIV-QUI', nivel: 1 + (i % 10) } },
      },
    });
  }
});

test('nível 1 com 20 questões (as mais fáceis, só com resposta, temas misturados); resto por 2–10', async () => {
  const plano = await planearNiveis(prisma, 'NIV-QUI', 20);
  expect(plano.total).toBe(40);
  expect(plano.porNivel[1]).toBe(20);
  expect(Object.values(plano.porNivel).reduce((a, b) => a + b, 0)).toBe(40);
  for (let n = 2; n <= 10; n++) expect(plano.porNivel[n]).toBeGreaterThanOrEqual(2);
  expect(plano.semResposta).toBe(3);

  await gravarNiveis(prisma, plano);
  const nivel1 = await prisma.questaoProva.findMany({ where: { prova: 'NIV-QUI', nivel: 1 }, include: { q: { include: { alternativas: true } } } });
  expect(nivel1).toHaveLength(20);
  expect(nivel1.every((l) => l.q.alternativas.some((a) => a.correcta))).toBe(true);
  expect(new Set(nivel1.map((l) => l.q.tema)).size).toBe(2);
  // as do nível 1 não são mais difíceis do que as do nível 10
  const nivel10 = await prisma.questaoProva.findMany({ where: { prova: 'NIV-QUI', nivel: 10 }, include: { q: true } });
  const max1 = Math.max(...nivel1.map((l) => l.q.dificuldade ?? 0));
  const min10 = Math.min(...nivel10.map((l) => l.q.dificuldade ?? 0));
  expect(max1).toBeLessThanOrEqual(min10);
});
