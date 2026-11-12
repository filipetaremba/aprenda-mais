import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import sharp from 'sharp';
import { prisma } from '../src/db';
import { atribuirDoadoras, provaFonte } from '../src/conteudo/provas';
import { exportarApp, publicarProva } from '../src/conteudo/pacotes';
import { optimizarImagem, LARGURA_MAXIMA } from '../src/conteudo/imagens';

afterAll(() => prisma.$disconnect());

async function questao(codigo: string, prova: string, nivel: number) {
  await prisma.questao.create({
    data: {
      codigo,
      disciplina: 'BIO',
      tipo: 'escolha_multipla',
      enunciado: 'A célula é a unidade:',
      explicacao: 'Básica da vida.',
      estado: 'publicada',
      alternativas: { create: ['básica', 'nenhuma', 'mineral', 'química'].map((t, i) => ({ letra: 'ABCD'[i], texto: t, correcta: i === 0, ordem: i + 1 })) },
      provas: { create: { prova, nivel } },
    },
  });
}

beforeAll(async () => {
  await prisma.grupoExame.createMany({ data: [{ codigo: 'PAR', nome: 'Grupo partilha' }, { codigo: 'OUT', nome: 'Outro grupo' }] });
  await prisma.disciplina.createMany({ data: [{ codigo: 'BIO', nome: 'Biologia' }, { codigo: 'ING', nome: 'Inglês' }] });
  await prisma.instituicao.create({ data: { codigo: 'UNIPAR', sigla: 'UniPar', nome: 'Universidade Partilha', grupo_exame: 'PAR' } });
  await prisma.prova.createMany({
    data: [
      { codigo: 'PAR-BIO1', grupo_exame: 'PAR', disciplina: 'BIO', nome: 'Biologia I' },
      { codigo: 'PAR-BIO2', grupo_exame: 'PAR', disciplina: 'BIO', nome: 'Biologia II' },
      { codigo: 'OUT-BIO', grupo_exame: 'OUT', disciplina: 'BIO', nome: 'Biologia (outro grupo)' },
      { codigo: 'PAR-ING', grupo_exame: 'PAR', disciplina: 'ING', nome: 'Inglês' },
    ],
  });
  await questao('PAR-BIO1-2025-001', 'PAR-BIO1', 1);
  await questao('PAR-BIO1-2025-002', 'PAR-BIO1', 3);
  await questao('OUT-BIO-2025-001', 'OUT-BIO', 1);
  await questao('OUT-BIO-2025-002', 'OUT-BIO', 1);
  await prisma.curso.createMany({ data: [{ codigo: 'MEDICINA-PAR', nome: 'Medicina' }, { codigo: 'LINGUAS-PAR', nome: 'Línguas' }] });
  await prisma.oferta.create({
    data: { codigo: 'UNIPAR-MED', slug: 'unipar-med', curso: 'MEDICINA-PAR', instituicao: 'UNIPAR', nome_original: 'Medicina', provas: { create: { prova: 'PAR-BIO2', ordem: 1 } } },
  });
  await prisma.oferta.create({
    data: { codigo: 'UNIPAR-ING', slug: 'unipar-ing', curso: 'LINGUAS-PAR', instituicao: 'UNIPAR', nome_original: 'Línguas', provas: { create: { prova: 'PAR-ING', ordem: 1 } } },
  });
});

test('prova sem questões usa as de outra da mesma disciplina (preferindo o mesmo grupo)', async () => {
  const plano = await atribuirDoadoras(prisma);
  expect(plano.find((x) => x.prova === 'PAR-BIO2')!.doadora).toBe('PAR-BIO1'); // mesmo grupo, mesmo com menos questões
  expect(plano.find((x) => x.prova === 'PAR-ING')!.doadora).toBeNull(); // nenhuma prova de Inglês tem questões
  expect((await prisma.prova.findUnique({ where: { codigo: 'PAR-BIO2' } }))!.questoes_de).toBeNull(); // sem --gravar

  await atribuirDoadoras(prisma, { gravar: true });
  expect(await provaFonte(prisma, 'PAR-BIO2')).toBe('PAR-BIO1');
  expect(await provaFonte(prisma, 'PAR-BIO1')).toBe('PAR-BIO1');
});

test('exportar:app: a prova partilhada tem nível aberto; cursos sem nenhum nível aberto ficam de fora', async () => {
  const saida = fs.mkdtempSync(path.join(os.tmpdir(), 'aprova-partilha-'));
  const r = await exportarApp(prisma, saida);
  const c = JSON.parse(fs.readFileSync(path.join(saida, 'conteudo.json'), 'utf8'));
  const bio2 = c.exames.find((e: any) => e.prova === 'PAR-BIO2');
  expect(bio2.questoes.map((q: any) => q.codigo)).toEqual(['PAR-BIO1-2025-001']);
  expect(c.catalogo.provas.find((p: any) => p.codigo === 'PAR-BIO2').questoes_de).toBe('PAR-BIO1');
  const cursos = c.catalogo.cursos.map((o: any) => o.codigo);
  expect(cursos).toContain('UNIPAR-MED');
  expect(cursos).not.toContain('UNIPAR-ING');
  expect(r.ofertasExcluidas).toContain('UNIPAR-ING');
  fs.rmSync(saida, { recursive: true, force: true });
});

test('o pacote pago de uma prova partilhada leva os níveis pagos da doadora', async () => {
  const r = await publicarProva(prisma, 'PAR-BIO2', null);
  expect(r).toMatchObject({ estado: 'publicado', num_questoes: 1 });
});

test('questões próprias têm prioridade sobre a doadora', async () => {
  await questao('PAR-BIO2-2025-001', 'PAR-BIO2', 1);
  expect(await provaFonte(prisma, 'PAR-BIO2')).toBe('PAR-BIO2');
});

test('imagens: margens cortadas, largura máxima e ficheiro mais pequeno; nunca maior que o original', async () => {
  // 1600×900 com muita margem branca e um rectângulo com gradiente
  const fundo = sharp({ create: { width: 1600, height: 900, channels: 3, background: '#ffffff' } });
  const gradiente = await sharp({ create: { width: 1200, height: 500, channels: 3, background: '#335599' } }).png().toBuffer();
  const original = await fundo.composite([{ input: gradiente, left: 200, top: 200 }]).png({ compressionLevel: 0 }).toBuffer();
  const novo = await optimizarImagem(original);
  const meta = await sharp(novo).metadata();
  expect(meta.width).toBeLessThanOrEqual(LARGURA_MAXIMA);
  expect(meta.height).toBeLessThan(500); // margens cortadas
  expect(novo.length).toBeLessThan(original.length);

  const lixo = Buffer.from('não é uma imagem');
  expect(await optimizarImagem(lixo)).toBe(lixo);
});
