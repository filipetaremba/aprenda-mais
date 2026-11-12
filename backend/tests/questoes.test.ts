import { createApp } from '../src/app';
import { prisma } from '../src/db';
import { validarRegrasQuestao } from '../src/dominio';
import { catalogoMinimo, entrar } from './ajuda';

const app = createApp();
let agente: Awaited<ReturnType<typeof entrar>>['agente'];
let csrf: string;

beforeAll(async () => {
  await catalogoMinimo();
  ({ agente, csrf } = await entrar(app));
});
afterAll(() => prisma.$disconnect());

function base(extra: Record<string, string> = {}) {
  return {
    _csrf: csrf,
    prova: 'TST-MAT',
    nivel: '3',
    tema: 'MAT-FUNCOES',
    tipo: 'escolha_multipla',
    estado: 'revista',
    enunciado: 'Seja $f(x) = -2x + 3$. A função é:',
    explicacao: 'Como $a = -2 < 0$, a função é decrescente.',
    'alternativas[0][texto]': 'crescente',
    'alternativas[1][texto]': 'decrescente',
    'alternativas[2][texto]': 'constante',
    'alternativas[3][texto]': 'nula',
    'alternativas[4][texto]': '',
    correcta: 'B',
    ...extra,
  };
}

function enviar(url: string, campos: Record<string, string>) {
  let r = agente.post(url);
  for (const [k, v] of Object.entries(campos)) r = r.field(k, v);
  return r;
}

const PNG_1PX = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
  'base64',
);

test('cria uma questão de escolha múltipla válida (com imagem)', async () => {
  const r = await enviar('/admin/questoes/nova', base({ codigo: 'TST-MAT-ADM-001' }))
    .attach('imagem', PNG_1PX, { filename: 'fig.png', contentType: 'image/png' })
    .expect(302);
  expect(r.headers.location).toBe('/admin/questoes/TST-MAT-ADM-001');

  const q = await prisma.questao.findUnique({ where: { codigo: 'TST-MAT-ADM-001' }, include: { alternativas: true, provas: true } });
  expect(q).not.toBeNull();
  expect(q!.disciplina).toBe('MAT');
  expect(q!.alternativas).toHaveLength(4); // a 5.ª vazia é ignorada
  expect(q!.alternativas.filter((a) => a.correcta).map((a) => a.letra)).toEqual(['B']);
  expect(q!.provas).toEqual([{ questao: 'TST-MAT-ADM-001', prova: 'TST-MAT', nivel: 3 }]);
  expect(JSON.parse(q!.imagens)).toEqual(['TST-MAT-ADM-001.png']);

  const pagina = await agente.get('/admin/questoes/TST-MAT-ADM-001').expect(200);
  expect(pagina.text).toContain('decrescente');
  await agente.get('/admin/media/TST-MAT-ADM-001.png').expect(200).expect('content-type', /image\/png/);
});

test('edita a questão (muda o nível e a resposta)', async () => {
  await enviar('/admin/questoes/TST-MAT-ADM-001', base({ nivel: '4', correcta: 'C' })).expect(302);
  const q = await prisma.questao.findUnique({ where: { codigo: 'TST-MAT-ADM-001' }, include: { alternativas: true, provas: true } });
  expect(q!.provas[0].nivel).toBe(4);
  expect(q!.alternativas.find((a) => a.correcta)!.letra).toBe('C');
  expect(JSON.parse(q!.imagens)).toEqual(['TST-MAT-ADM-001.png']); // a imagem mantém-se
});

test('gera o código automaticamente e aceita Verdadeiro/Falso com 2 alternativas', async () => {
  await enviar('/admin/questoes/nova', base({ tipo: 'verdadeiro_falso', correcta: '', correcta_vf: 'F', enunciado: '$2 + 2 = 5$' })).expect(302);
  const q = await prisma.questao.findFirst({ where: { tipo: 'verdadeiro_falso' }, include: { alternativas: { orderBy: { ordem: 'asc' } } } });
  expect(q!.codigo).toMatch(/^TST-MAT-ADM-\d{3}$/);
  expect(q!.alternativas.map((a) => [a.letra, a.correcta])).toEqual([
    ['V', false],
    ['F', true],
  ]);
});

test('recusa questão sem alternativa correcta, sem explicação e com LaTeX aberto', async () => {
  const antes = await prisma.questao.count();
  const r = await enviar(
    '/admin/questoes/nova',
    base({ codigo: 'TST-MAT-ADM-900', correcta: '', explicacao: '', enunciado: 'Quanto é $x^2?' }),
  ).expect(400);
  expect(r.text).toContain('Indica a alternativa correcta.');
  expect(r.text).toContain('A explicação é obrigatória.');
  expect(r.text).toContain('LaTeX com $ desequilibrados');
  expect(await prisma.questao.count()).toBe(antes);
});

test('recusa escolha múltipla com uma das 4 alternativas vazia', async () => {
  const r = await enviar('/admin/questoes/nova', base({ codigo: 'TST-MAT-ADM-901', 'alternativas[3][texto]': '' })).expect(400);
  expect(r.text).toContain('A alternativa D está vazia');
});

test('regras: escolha múltipla com 3 alternativas é inválida; com 5 é aceite', () => {
  const alts = (letras: string[]) => letras.map((letra) => ({ letra, texto: letra, imagem: null, correcta: letra === 'A' }));
  const q = { tipo: 'escolha_multipla', enunciado: 'x', explicacao: 'y', estado: 'revista' };
  expect(validarRegrasQuestao({ ...q, alternativas: alts(['A', 'B', 'C']) })).toContain('Escolha múltipla tem de ter 4 ou 5 alternativas (tem 3).');
  expect(validarRegrasQuestao({ ...q, alternativas: alts(['A', 'B', 'C', 'D', 'E']) })).toEqual([]);
});

test('formulário multipart com CSRF errado é recusado', async () => {
  await enviar('/admin/questoes/nova', { ...base({ codigo: 'TST-MAT-ADM-902' }), _csrf: 'falso' }).expect(403);
  expect(await prisma.questao.findUnique({ where: { codigo: 'TST-MAT-ADM-902' } })).toBeNull();
});

test('publicar em lote só publica questões com resposta', async () => {
  await prisma.questao.create({
    data: {
      codigo: 'TST-MAT-ADM-950',
      disciplina: 'MAT',
      tipo: 'escolha_multipla',
      enunciado: 'Sem resposta',
      explicacao: 'x',
      estado: 'rascunho',
      alternativas: { create: ['A', 'B', 'C', 'D'].map((letra, i) => ({ letra, texto: letra, ordem: i + 1 })) },
      provas: { create: { prova: 'TST-MAT', nivel: 1 } },
    },
  });
  await agente
    .post('/admin/questoes/estado')
    .type('form')
    .send({ _csrf: csrf, novo_estado: 'publicada', codigos: ['TST-MAT-ADM-001', 'TST-MAT-ADM-950'] })
    .expect(302);
  expect((await prisma.questao.findUnique({ where: { codigo: 'TST-MAT-ADM-001' } }))!.estado).toBe('publicada');
  expect((await prisma.questao.findUnique({ where: { codigo: 'TST-MAT-ADM-950' } }))!.estado).toBe('rascunho');

  const lista = await agente.get('/admin/questoes?prova=TST-MAT&estado=publicada').expect(200);
  expect(lista.text).toContain('TST-MAT-ADM-001');
  expect(lista.text).not.toContain('TST-MAT-ADM-950');
});

test('regras: 2 alternativas correctas é inválido', () => {
  const erros = validarRegrasQuestao({
    tipo: 'escolha_multipla',
    enunciado: 'x',
    explicacao: 'y',
    estado: 'revista',
    alternativas: ['A', 'B', 'C', 'D'].map((letra) => ({ letra, texto: letra, imagem: null, correcta: letra === 'A' || letra === 'B' })),
  });
  expect(erros).toContain('Só pode haver 1 alternativa correcta (há 2).');
});
