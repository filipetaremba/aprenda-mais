import { createApp } from '../src/app';
import { prisma } from '../src/db';
import { analisar, gravar } from '../src/conteudo/importador';
import { entrar, extrairCsrf } from './ajuda';

afterAll(() => prisma.$disconnect());

const catalogo = {
  grupos_exame: [{ codigo: 'IMP', nome: 'Grupo importado', instituicoes: ['UNIIMP'], tem_gabarito: true }],
  disciplinas: [{ codigo: 'FIS', nome: 'Física', aliases: ['Fisica'] }],
  instituicoes: [{ codigo: 'UNIIMP', sigla: 'UniImp', nome: 'Universidade Importada', grupo_exame: 'IMP', provincias: ['Sofala'] }],
  temas: [{ codigo: 'FIS-OPTICA', disciplina: 'FIS', nome: 'Óptica' }],
  provas: [{ codigo: 'IMP-FIS', grupo_exame: 'IMP', disciplina: 'FIS', nome: 'Física', duracao_min: 90, num_questoes: 40, num_alternativas: 4 }],
  cursos: [
    {
      codigo: 'UNIIMP-ENG-CIVIL',
      slug: 'uniimp-eng-civil',
      instituicao: 'UNIIMP',
      nome: 'Engenharia Civil',
      faculdade: ['Fac. A', 'Fac. B'],
      local: 'Beira',
      regimes: ['laboral'],
      provas: [{ prova: 'IMP-FIS', peso: 100 }],
    },
  ],
};

function questao(codigo: string, extra: object = {}) {
  return {
    codigo,
    numero_original: 1,
    pagina: 1,
    tipo: 'escolha_multipla',
    tema: 'FIS-OPTICA',
    enunciado: 'A luz propaga-se em linha recta num meio:',
    imagens: [],
    alternativas: ['homogéneo', 'heterogéneo', 'opaco', 'qualquer'].map((t, i) => ({ letra: 'ABCD'[i], texto: t, imagem: null })),
    resposta: { letra: 'A', origem: 'gabarito_oficial', confianca: null },
    explicacao: { texto: 'Num meio homogéneo e transparente a luz propaga-se em linha recta.', origem: 'proposta_ia', revisto: false },
    dificuldade: 1,
    nivel: 2,
    estado: 'extraida',
    alertas: [],
    ...extra,
  };
}

const exame = {
  prova: 'IMP-FIS',
  fonte: { ficheiro: 'x.pdf', ano: 2025, variante: null, epoca: null, gabarito_ficheiro: null },
  questoes: [questao('IMP-FIS-2025-001'), questao('IMP-FIS-2025-002', { nivel: 5 })],
};

test('analisa e grava catálogo + questões (estado "revista", níveis criados)', async () => {
  const { relatorio, plano } = await analisar(prisma, [
    { nome: 'catalogo.json', conteudo: JSON.stringify(catalogo) },
    { nome: 'questoes/IMP/FIS/2025.json', conteudo: JSON.stringify(exame) },
  ]);
  expect(relatorio.erros).toEqual([]);
  expect(relatorio.questoes).toMatchObject({ novas: 2, aGravar: 2 });
  expect(relatorio.porProvaNivel).toEqual({ 'IMP-FIS': { '2': 1, '5': 1 } });

  await gravar(prisma, plano);
  const q = await prisma.questao.findUnique({ where: { codigo: 'IMP-FIS-2025-001' }, include: { alternativas: true, provas: true } });
  expect(q!.estado).toBe('revista');
  expect(q!.resposta_origem).toBe('gabarito_oficial');
  expect(q!.alternativas.find((a) => a.correcta)!.letra).toBe('A');
  expect(q!.provas[0]).toMatchObject({ prova: 'IMP-FIS', nivel: 2 });
  expect(await prisma.nivel.count({ where: { prova: 'IMP-FIS' } })).toBe(10);

  const oferta = await prisma.oferta.findUnique({ where: { codigo: 'UNIIMP-ENG-CIVIL' }, include: { provas: true } });
  expect(oferta!.curso).toBe('ENGENHARIA-CIVIL');
  expect(oferta!.faculdade).toBe('Fac. A | Fac. B');
  expect(oferta!.provas).toEqual([{ oferta: 'UNIIMP-ENG-CIVIL', prova: 'IMP-FIS', peso: 100, ordem: 1 }]);

  // Reimportar não mexe nas que já existem (a não ser com "substituir")
  const segunda = await analisar(prisma, [{ nome: 'q.json', conteudo: JSON.stringify(exame) }]);
  expect(segunda.relatorio.questoes).toMatchObject({ novas: 0, existentes: 2, aGravar: 0 });
});

test('relatório de erros: formato, JSON partido, prova inexistente', async () => {
  const { relatorio } = await analisar(prisma, [
    { nome: 'mau.json', conteudo: JSON.stringify({ prova: 'IMP-FIS', questoes: [questao('IMP-FIS-2025-013', { campo_inventado: 1 })] }) },
    { nome: 'outra.json', conteudo: JSON.stringify({ ...exame, prova: 'NAO-EXISTE' }) },
    { nome: 'partido.json', conteudo: '{ isto não é json' },
  ]);
  const textos = relatorio.erros.map((e) => e.texto);
  expect(relatorio.ok).toBe(false);
  expect(textos).toContain('campo desconhecido "campo_inventado"');
  expect(textos.some((t) => t.startsWith('JSON inválido'))).toBe(true);
  expect(textos).toContain('Prova inexistente: NAO-EXISTE (importa primeiro o catálogo)');
});

test('relatório de erros: resposta inexistente, imagem em falta, explicação vazia', async () => {
  const mau = {
    prova: 'IMP-FIS',
    questoes: [
      questao('IMP-FIS-2025-010', { resposta: { letra: 'E', origem: null, confianca: null } }),
      questao('IMP-FIS-2025-011', { imagens: ['nao-existe.png'] }),
      questao('IMP-FIS-2025-012', { explicacao: { texto: '', origem: null, revisto: false } }),
    ],
  };
  const { relatorio } = await analisar(prisma, [{ nome: 'mau.json', conteudo: JSON.stringify(mau) }]);
  const textos = relatorio.erros.map((e) => e.texto);
  expect(textos).toContain('A resposta "E" não corresponde a nenhuma alternativa');
  expect(textos).toContain('Imagem em falta: nao-existe.png');
  expect(textos).toContain('A explicação é obrigatória.');
});

test('página Importar JSON: pré-visualização (nada gravado) e confirmação', async () => {
  const app = createApp();
  const { agente, csrf } = await entrar(app);
  const pequeno = { prova: 'IMP-FIS', questoes: [questao('IMP-FIS-2025-020', { resposta: { letra: null, origem: null, confianca: null } })] };

  const prev = await agente
    .post('/admin/importar')
    .field('_csrf', csrf)
    .attach('ficheiros', Buffer.from(JSON.stringify(pequeno)), { filename: '2025.json', contentType: 'application/json' })
    .expect(200);
  expect(prev.text).toContain('Confirmar e gravar');
  expect(prev.text).toContain('Sem resposta: importada como rascunho');
  expect(await prisma.questao.findUnique({ where: { codigo: 'IMP-FIS-2025-020' } })).toBeNull();

  const id = prev.text.match(/name="id" value="([a-f0-9]+)"/)![1];
  await agente.post('/admin/importar/confirmar').type('form').send({ _csrf: extrairCsrf(prev.text), id }).expect(200);
  const q = await prisma.questao.findUnique({ where: { codigo: 'IMP-FIS-2025-020' } });
  expect(q!.estado).toBe('rascunho');
});

test('página Importar JSON: ficheiro com erros mostra o relatório e não grava', async () => {
  const app = createApp();
  const { agente, csrf } = await entrar(app);
  const r = await agente
    .post('/admin/importar')
    .field('_csrf', csrf)
    .attach('ficheiros', Buffer.from('[1,2]'), { filename: 'coisas.json', contentType: 'application/json' })
    .expect(422);
  expect(r.text).toContain('Lista sem tipo conhecido');
  expect(r.text).not.toContain('Confirmar e gravar');
});
