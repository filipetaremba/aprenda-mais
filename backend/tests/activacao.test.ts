import crypto from 'node:crypto';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import AdmZip from 'adm-zip';
import Ajv2020 from 'ajv/dist/2020';
import request from 'supertest';
import { createApp } from '../src/app';
import { config, dirImagens } from '../src/config';
import { prisma } from '../src/db';
import { ALFABETO, gerarCodigo, normalizarCodigo } from '../src/activacao/codigos';
import { verificar } from '../src/activacao/licencas';
import { gerarCodigos } from '../src/activacao/servico';
import { exportarApp, publicarProva } from '../src/conteudo/pacotes';
import { catalogoMinimo, entrar } from './ajuda';

const app = createApp();
const CHAVE_PUBLICA = process.env.LICENCA_CHAVE_PUBLICA!;
const RE_CODIGO = /APV-[2-9A-HJKMNP-Z]{4}-[2-9A-HJKMNP-Z]{4}/g;
let admin: Awaited<ReturnType<typeof entrar>>;

// ───── Validador do schema partilhado ─────
const schema = JSON.parse(fs.readFileSync(config.schemaConteudo, 'utf8'));
const ajv = new Ajv2020({ allErrors: true, strict: false });
ajv.addSchema(schema);
const validar = (def: string, dados: unknown) => {
  const v = ajv.getSchema(`${schema.$id}#/$defs/${def}`)!;
  const ok = v(dados);
  return ok ? [] : v.errors!.map((e) => `${e.instancePath} ${e.message}`);
};

const PNG = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==', 'base64');

async function questao(codigo: string, nivel: number, extra: { imagens?: string[]; estado?: string } = {}) {
  await prisma.questao.create({
    data: {
      codigo,
      disciplina: 'MAT',
      tema: 'MAT-FUNCOES',
      tipo: 'escolha_multipla',
      enunciado: `Questão ${codigo}: quanto é $1+1$?`,
      explicacao: 'Porque $1+1=2$.',
      estado: extra.estado ?? 'publicada',
      imagens: JSON.stringify(extra.imagens ?? []),
      ano: 2025,
      alternativas: { create: ['1', '2', '3', '4'].map((t, i) => ({ letra: 'ABCD'[i], texto: t, correcta: t === '2', ordem: i + 1 })) },
      provas: { create: { prova: 'ACT-MAT', nivel } },
    },
  });
}

function activar(corpo: object, agente = request(app), token?: string) {
  const r = agente.post('/api/v1/activacao').send(corpo);
  return token ? r.set('Authorization', `Bearer ${token}`) : r;
}

async function gerarPeloAdmin(produto: string, quantidade = 1, extra: Record<string, string> = {}) {
  const r = await admin.agente
    .post('/admin/codigos/gerar')
    .type('form')
    .send({ _csrf: admin.csrf, produto, quantidade: String(quantidade), validade: '2099-03-31', nota: 'pago por M-Pesa, ref TESTE', ...extra })
    .expect(200);
  return { html: r.text, codigos: [...new Set(r.text.match(RE_CODIGO))] };
}

beforeAll(async () => {
  await catalogoMinimo();
  await prisma.prova.create({ data: { codigo: 'ACT-MAT', grupo_exame: 'TST', disciplina: 'MAT', nome: 'Matemática (activação)' } });
  await prisma.prova.create({ data: { codigo: 'ACT-FIS', grupo_exame: 'TST', disciplina: 'MAT', nome: 'Outra prova' } });
  await prisma.nivel.createMany({ data: Array.from({ length: 10 }, (_, i) => ({ prova: 'ACT-MAT', numero: i + 1, titulo: `Nível ${i + 1}` })) });
  fs.mkdirSync(dirImagens(), { recursive: true });
  fs.writeFileSync(path.join(dirImagens(), 'ACT-MAT-ACT-005.png'), PNG);
  for (let n = 1; n <= 4; n++) for (let k = 1; k <= 2; k++) await questao(`ACT-MAT-ACT-${n}${k}0`, n);
  await questao('ACT-MAT-ACT-005', 5, { imagens: ['ACT-MAT-ACT-005.png'] });
  await questao('ACT-MAT-ACT-006', 6, { estado: 'revista' }); // não publicada: não pode ir no pacote
  await prisma.simulado.create({ data: { codigo: 'ACT-MAT-SIM-1', prova: 'ACT-MAT', titulo: 'Simulado de teste', duracao_min: 60, num_perguntas: 5 } });
  await prisma.produto.create({ data: { codigo: 'ACT-MAT-NIVEIS', nome: 'Matemática (teste)', tipo: 'niveis', preco_mt: 59, provas: { create: { prova: 'ACT-MAT' } } } });
  await prisma.produto.create({ data: { codigo: 'ACT-FIS-NIVEIS', nome: 'Outra (teste)', tipo: 'niveis', preco_mt: 59, provas: { create: { prova: 'ACT-FIS' } } } });
  admin = await entrar(app);
});
afterAll(() => prisma.$disconnect());

describe('códigos', () => {
  test('formato APV-XXXX-XXXX com alfabeto sem 0/O/1/I/L; normalização do que o estudante escreve', () => {
    for (let i = 0; i < 200; i++) expect(gerarCodigo()).toMatch(/^APV-[2-9A-HJKMNP-Z]{4}-[2-9A-HJKMNP-Z]{4}$/);
    expect(ALFABETO).not.toMatch(/[01OIL]/);
    expect(normalizarCodigo(' apv 7k9q-m2xz ')).toBe('APV-7K9Q-M2XZ');
    expect(normalizarCodigo('7K9QM2XZ')).toBe('APV-7K9Q-M2XZ');
    expect(normalizarCodigo('APV-7K9Q-M2X0')).toBeNull(); // 0 não existe no alfabeto
  });

  test('o admin gera N códigos: mostra-os uma vez, guarda só o hash, mensagem de WhatsApp pronta', async () => {
    const { html, codigos } = await gerarPeloAdmin('ACT-MAT-NIVEIS', 3, { telefone: '84 555 6666' });
    expect(codigos).toHaveLength(3);
    expect(html).toContain('Enviar por WhatsApp');
    expect(html).toContain('https://wa.me/258845556666?text=');
    expect(html).toContain('não voltam a aparecer');

    const guardados = await prisma.codigoActivacao.findMany({ where: { produto: 'ACT-MAT-NIVEIS' } });
    const tudo = JSON.stringify(guardados);
    for (const c of codigos) {
      expect(tudo).not.toContain(c);
      expect(guardados.some((g) => g.codigo_final === c.slice(-4))).toBe(true);
    }
    expect(guardados[0].nota).toBe('pago por M-Pesa, ref TESTE · tel. 845556666');

    // A lista e o CSV nunca mostram o código completo
    const lista = await admin.agente.get('/admin/codigos?produto=ACT-MAT-NIVEIS').expect(200);
    const csv = await admin.agente.get('/admin/codigos/exportar.csv?produto=ACT-MAT-NIVEIS').expect(200).expect('content-type', /text\/csv/);
    for (const c of codigos) {
      expect(lista.text).not.toContain(c);
      expect(csv.text).not.toContain(c);
      expect(csv.text).toContain(`APV-••••-${c.slice(-4)}`);
    }
  });
});

describe('pacotes', () => {
  test('publicar prova: só questões PUBLICADAS dos níveis 3–10, zip válido, versão incremental', async () => {
    await admin.agente.post('/admin/pacotes/ACT-MAT/publicar').type('form').send({ _csrf: admin.csrf }).expect(302);
    const v1 = await prisma.pacote.findFirstOrThrow({ where: { prova: 'ACT-MAT' } });
    expect(v1).toMatchObject({ versao: 1, num_questoes: 5 }); // níveis 3,3,4,4,5 (o 6 não está publicado)

    const zip = new AdmZip(path.join(config.storageDir, 'pacotes', v1.ficheiro));
    const pacote = JSON.parse(zip.readAsText('pacote.json'));
    expect(validar('pacote', pacote)).toEqual([]);
    expect(pacote.niveis_incluidos).toEqual([3, 4, 5, 6, 7, 8, 9, 10]);
    expect(pacote.conteudo.questoes.map((q: any) => q.nivel)).toEqual([3, 3, 4, 4, 5]);
    expect(pacote.conteudo.questoes.every((q: any) => q.resposta.letra === 'B')).toBe(true);
    expect(pacote.simulados.map((s: any) => s.codigo)).toEqual(['ACT-MAT-SIM-1']);
    expect(zip.getEntry('imagens/ACT-MAT-ACT-005.png')).not.toBeNull();
    const bytes = fs.readFileSync(path.join(config.storageDir, 'pacotes', v1.ficheiro));
    expect(crypto.createHash('sha256').update(bytes).digest('hex')).toBe(v1.sha256);

    // Sem alterações → não cria versão nova
    expect(await publicarProva(prisma, 'ACT-MAT', null)).toEqual({ estado: 'sem_alteracoes', versao: 1 });
    // Publicar mais uma questão → versão 2
    await prisma.questao.update({ where: { codigo: 'ACT-MAT-ACT-006' }, data: { estado: 'publicada' } });
    expect(await publicarProva(prisma, 'ACT-MAT', null)).toMatchObject({ estado: 'publicado', versao: 2, num_questoes: 6 });
    // Prova sem questões pagas publicadas
    expect(await publicarProva(prisma, 'ACT-FIS', null)).toEqual({ estado: 'vazio' });
  });

  test('exportar:app: só níveis grátis (1–2) publicados, com catálogo e preços, no formato do schema', async () => {
    const saida = fs.mkdtempSync(path.join(os.tmpdir(), 'aprova-app-'));
    const r = await exportarApp(prisma, saida);
    const conteudo = JSON.parse(fs.readFileSync(path.join(saida, 'conteudo.json'), 'utf8'));
    expect(validar('conteudo_app', conteudo)).toEqual([]);
    const tst = conteudo.exames.find((e: any) => e.prova === 'ACT-MAT');
    expect(tst.questoes.map((q: any) => q.nivel)).toEqual([1, 1, 2, 2]);
    expect(conteudo.meta).toEqual({ nota_minima_padrao: 70, niveis_gratis: 2, inclui_revistas: false });
    expect(conteudo.produtos.find((p: any) => p.codigo === 'ACT-MAT-NIVEIS')).toMatchObject({ preco_mt: 59, provas: ['ACT-MAT'] });
    expect(conteudo.niveis.filter((n: any) => n.prova === 'ACT-MAT')).toHaveLength(10);
    expect(r.porProva['ACT-MAT']).toBe(4);
    fs.rmSync(saida, { recursive: true, force: true });
  });
});

const bearer = (t: string) => ({ Authorization: `Bearer ${t}` });

/** Lê o corpo binário (zip) da resposta. */
function binario(res: any, cb: (e: Error | null, b: Buffer) => void) {
  const partes: Buffer[] = [];
  res.on('data', (c: Buffer) => partes.push(c));
  res.on('end', () => cb(null, Buffer.concat(partes)));
}

describe('API /api/v1', () => {
  let codigo: string;
  let token: string;

  test('activar → licença assinada (verificável com a chave pública) → pacote descarregável e íntegro', async () => {
    [codigo] = (await gerarPeloAdmin('ACT-MAT-NIVEIS')).codigos;
    // escrito como o estudante escreveria: minúsculas, sem hífenes
    const r = await activar({ codigo: codigo.toLowerCase().replace(/-/g, ''), dispositivoId: 'telemovel-1', telefone: '+258 84 123 4567', nome: 'Ana' }).expect(201);
    token = r.body.token;
    expect(token).toMatch(/^apv_/);
    expect(r.body.restaurado).toBe(false);

    // Assinatura Ed25519 válida; qualquer alteração invalida-a
    expect(verificar(r.body.licenca, r.body.assinatura, CHAVE_PUBLICA)).toBe(true);
    expect(verificar(r.body.licenca.replace('ACT-MAT', 'ACT-FIS'), r.body.assinatura, CHAVE_PUBLICA)).toBe(false);
    const lic = JSON.parse(r.body.licenca);
    expect(lic).toMatchObject({ v: 1, produto: 'ACT-MAT-NIVEIS', tipo: 'niveis', provas: ['ACT-MAT'], valido_ate: '2099-03-31T23:59:59.000Z' });
    expect(r.body.estudante).toMatchObject({ nome: 'Ana', telefone: '841234567' });

    const pacote = r.body.pacotes.find((p: any) => p.prova === 'ACT-MAT');
    expect(pacote).toMatchObject({ versao: 2, url: '/api/v1/pacotes/ACT-MAT/download' });

    const versao = await request(app).get('/api/v1/pacotes/ACT-MAT/versao').set(bearer(token)).expect(200);
    expect(versao.body).toMatchObject({ prova: 'ACT-MAT', versao: 2, sha256: pacote.sha256 });

    const d = await request(app).get(pacote.url).set(bearer(token)).buffer(true).parse(binario).expect(200).expect('content-type', /application\/zip/);
    expect(d.headers['x-checksum-sha256']).toBe(pacote.sha256);
    expect(crypto.createHash('sha256').update(d.body).digest('hex')).toBe(pacote.sha256);
    expect(JSON.parse(new AdmZip(d.body).readAsText('pacote.json')).prova).toBe('ACT-MAT');

    // Retomar a meio (Range) com a versão fixa
    const parte = await request(app).get(pacote.url + '?versao=2').set(bearer(token)).set('Range', 'bytes=0-9').buffer(true).parse(binario).expect(206);
    expect(parte.headers['content-range']).toMatch(/^bytes 0-9\//);

    // O código ficou usado e ligado ao estudante
    const reg = await prisma.codigoActivacao.findFirstOrThrow({ where: { codigo_final: codigo.slice(-4), produto: 'ACT-MAT-NIVEIS', estado: 'usado' } });
    expect(reg).toMatchObject({ dispositivo_id: 'telemovel-1', usado_por_estudante_id: r.body.estudante.id });
  });

  test('código já usado: recusado noutro telemóvel; restaurado no mesmo telemóvel ou com o mesmo telefone', async () => {
    const outro = await activar({ codigo, dispositivoId: 'telemovel-2' }).expect(409);
    expect(outro.body).toEqual({ erro: { codigo: 'CODIGO_USADO', mensagem: expect.any(String) } });
    await activar({ codigo, dispositivoId: 'telemovel-2', telefone: '84 999 9999' }).expect(409);

    const mesmo = await activar({ codigo, dispositivoId: 'telemovel-1' }).expect(200);
    expect(mesmo.body.restaurado).toBe(true);
    const novo = await activar({ codigo, dispositivoId: 'telemovel-2', telefone: '841234567' }).expect(200);
    expect(novo.body.licencas).toHaveLength(1);
    expect(verificar(novo.body.licencas[0].licenca, novo.body.licencas[0].assinatura, CHAVE_PUBLICA)).toBe(true);

    const l = await request(app).get('/api/v1/licencas').set(bearer(novo.body.token)).expect(200);
    expect(l.body.licencas).toHaveLength(1);
    expect(l.body.pacotes.map((p: any) => p.prova)).toEqual(['ACT-MAT']);
  });

  test('código inválido, mal escrito, revogado e expirado', async () => {
    expect((await activar({ codigo: 'APV-2222-2222', dispositivoId: 'x' }).expect(404)).body.erro.codigo).toBe('CODIGO_INVALIDO');
    expect((await activar({ codigo: 'isto-nao', dispositivoId: 'x' }).expect(404)).body.erro.codigo).toBe('CODIGO_INVALIDO');
    expect((await activar({ codigo: 'APV-2222-2222' }).expect(400)).body.erro.codigo).toBe('PEDIDO_INVALIDO');
    expect((await activar({ codigo: 'APV-2222-2222', dispositivoId: 'x', telefone: '123' }).expect(400)).body.erro.codigo).toBe('TELEFONE_INVALIDO');

    const [revogar] = (await gerarPeloAdmin('ACT-MAT-NIVEIS')).codigos;
    const reg = await prisma.codigoActivacao.findFirstOrThrow({ where: { codigo_final: revogar.slice(-4), estado: 'disponivel' }, orderBy: { id: 'desc' } });
    await admin.agente.post('/admin/codigos/' + reg.id + '/revogar').type('form').send({ _csrf: admin.csrf }).expect(302);
    expect((await activar({ codigo: revogar, dispositivoId: 'x' }).expect(410)).body.erro.codigo).toBe('CODIGO_REVOGADO');

    const [expirado] = await gerarCodigos(prisma, { produto: 'ACT-MAT-NIVEIS', quantidade: 1, validade: new Date(Date.now() - 86_400_000), nota: null, adminId: null });
    expect((await activar({ codigo: expirado.codigo, dispositivoId: 'x' }).expect(410)).body.erro.codigo).toBe('CODIGO_EXPIRADO');
  });

  test('download recusado sem token, com token inválido, sem licença para a prova e com licença revogada', async () => {
    expect((await request(app).get('/api/v1/pacotes/ACT-MAT/download').expect(401)).body.erro.codigo).toBe('NAO_AUTENTICADO');
    await request(app).get('/api/v1/pacotes/ACT-MAT/download').set(bearer('apv_inventado_inventado_inventado')).expect(401);

    // Estudante com licença só da outra prova
    const [outro] = (await gerarPeloAdmin('ACT-FIS-NIVEIS')).codigos;
    const r = await activar({ codigo: outro, dispositivoId: 'telemovel-3' }).expect(201);
    const sem = await request(app).get('/api/v1/pacotes/ACT-MAT/download').set(bearer(r.body.token)).expect(403);
    expect(sem.body.erro.codigo).toBe('SEM_LICENCA');
    expect((await request(app).get('/api/v1/pacotes/ACT-FIS/versao').set(bearer(r.body.token)).expect(404)).body.erro.codigo).toBe('PACOTE_INEXISTENTE');

    // Revogar um código já usado cancela a licença → deixa de poder descarregar
    const reg = await prisma.codigoActivacao.findFirstOrThrow({ where: { codigo_final: codigo.slice(-4), estado: 'usado' } });
    await admin.agente.post('/admin/codigos/' + reg.id + '/revogar').type('form').send({ _csrf: admin.csrf }).expect(302);
    expect((await request(app).get('/api/v1/pacotes/ACT-MAT/download').set(bearer(token)).expect(403)).body.erro.codigo).toBe('SEM_LICENCA');
  });

  test('código de recuperação emitido pelo admin devolve as licenças num telemóvel novo', async () => {
    const [c] = (await gerarPeloAdmin('ACT-MAT-NIVEIS')).codigos;
    const primeira = await activar({ codigo: c, dispositivoId: 'tel-antigo', nome: 'Bento' }).expect(201);
    const pagina = await admin.agente
      .post('/admin/estudantes/' + primeira.body.estudante.id + '/recuperacao')
      .type('form')
      .send({ _csrf: admin.csrf })
      .expect(200)
      .expect('cache-control', /no-store/);
    const [recuperacao] = pagina.text.match(RE_CODIGO)!;
    const r = await activar({ codigo: recuperacao, dispositivoId: 'tel-novo' }).expect(200);
    expect(r.body).toMatchObject({ restaurado: true, estudante: { id: primeira.body.estudante.id } });
    expect(r.body.licencas).toHaveLength(1);
    expect(r.body.licenca).toBeUndefined(); // não cria licença nova
    await activar({ codigo: recuperacao, dispositivoId: 'outro-ainda' }).expect(409); // uso único
  });

  test('um segundo código com o mesmo token junta as licenças na mesma conta', async () => {
    const [a, b] = (await gerarPeloAdmin('ACT-MAT-NIVEIS', 2)).codigos;
    const r1 = await activar({ codigo: a, dispositivoId: 'tel-junta' }).expect(201);
    const r2 = await activar({ codigo: b, dispositivoId: 'tel-junta' }, request(app), r1.body.token).expect(201);
    expect(r2.body.estudante.id).toBe(r1.body.estudante.id);
    expect(r2.body.licencas).toHaveLength(2);
  });

  test('rate limit: 5 tentativas por hora; a 6.ª recebe 429', async () => {
    const limitada = createApp({ limiteActivacaoHora: 5 });
    for (let i = 0; i < 5; i++) await request(limitada).post('/api/v1/activacao').send({ codigo: 'APV-2222-2222', dispositivoId: 'brute' }).expect(404);
    const r = await request(limitada).post('/api/v1/activacao').send({ codigo: 'APV-2222-2223', dispositivoId: 'brute' }).expect(429);
    expect(r.body.erro.codigo).toBe('DEMASIADAS_TENTATIVAS');
  });

  test('GET /catalogo: preços, provas e contactos de pagamento, sem autenticação', async () => {
    const r = await request(app).get('/api/v1/catalogo').expect(200);
    expect(r.body.contactos).toMatchObject({ mpesa: '84 111 2222', whatsapp: '84 333 4444' });
    expect(r.body.produtos.find((p: any) => p.codigo === 'ACT-MAT-NIVEIS')).toMatchObject({ preco_mt: 59, provas: ['ACT-MAT'] });
    expect(r.body.provas.find((p: any) => p.codigo === 'ACT-MAT').pacote_versao).toBe(2);
    expect(r.body.meta).toEqual({ nota_minima_padrao: 70, niveis_gratis: 2 });
  });

  test('erros em JSON: endereço inexistente e JSON partido', async () => {
    expect((await request(app).get('/api/v1/nada').expect(404)).body.erro.codigo).toBe('NAO_ENCONTRADO');
    const r = await request(app).post('/api/v1/activacao').set('Content-Type', 'application/json').send('{partido').expect(400);
    expect(r.body.erro.codigo).toBe('PEDIDO_INVALIDO');
  });
});

