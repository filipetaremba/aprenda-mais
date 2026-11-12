import crypto from 'node:crypto';
import type { Prisma, PrismaClient } from '@prisma/client';
import { finalCodigo, gerarCodigo, hashCodigo, normalizarCodigo, normalizarTelefone } from './codigos';
import { assinar, licencaValida, serializarLicenca } from './licencas';

/** Erro com código estável para a app: { erro: { codigo, mensagem } }. */
export class ErroApi extends Error {
  constructor(
    public status: number,
    public codigo: string,
    mensagem: string,
  ) {
    super(mensagem);
  }
}

// ───────────── Geração (admin) ─────────────

export async function gerarCodigos(
  db: PrismaClient,
  o: { produto: string; quantidade: number; validade: Date | null; nota: string | null; adminId: number | null },
) {
  const gerados: { id: number; codigo: string }[] = [];
  while (gerados.length < o.quantidade) {
    const codigo = gerarCodigo();
    try {
      const r = await db.codigoActivacao.create({
        data: {
          codigo_hash: hashCodigo(codigo),
          codigo_final: finalCodigo(codigo),
          tipo: 'activacao',
          produto: o.produto,
          validade_ate: o.validade,
          nota: o.nota,
          criado_por: o.adminId,
        },
      });
      gerados.push({ id: r.id, codigo });
    } catch (e) {
      // Colisão de hash (raríssimo): tenta outro código
      if ((e as { code?: string }).code !== 'P2002') throw e;
    }
  }
  return gerados;
}

export async function gerarCodigoRecuperacao(db: PrismaClient, estudanteId: string, adminId: number | null, nota: string | null) {
  const codigo = gerarCodigo();
  const validade = new Date(Date.now() + 7 * 86_400_000); // uma semana
  await db.codigoActivacao.create({
    data: {
      codigo_hash: hashCodigo(codigo),
      codigo_final: finalCodigo(codigo),
      tipo: 'recuperacao',
      para_estudante_id: estudanteId,
      validade_ate: validade,
      nota,
      criado_por: adminId,
    },
  });
  return { codigo, validade };
}

/** Revoga um código; se já foi usado, revoga também as licenças que gerou. */
export async function revogarCodigo(db: PrismaClient, id: number) {
  return db.$transaction(async (tx) => {
    const c = await tx.codigoActivacao.update({ where: { id }, data: { estado: 'revogado' } });
    const { count } = await tx.licenca.updateMany({ where: { codigo_id: id }, data: { revogada: true } });
    return { codigo: c, licencasRevogadas: count };
  });
}

// ───────────── Tokens da app ─────────────

const hashToken = (t: string) => crypto.createHash('sha256').update(t).digest('hex');

async function emitirToken(tx: Prisma.TransactionClient | PrismaClient, estudante: string, dispositivo: string) {
  const token = `apv_${crypto.randomBytes(32).toString('base64url')}`;
  await tx.tokenEstudante.create({ data: { token_hash: hashToken(token), estudante, dispositivo_id: dispositivo } });
  return token;
}

export async function estudanteDoToken(db: PrismaClient, cabecalho: string | undefined) {
  const m = /^Bearer\s+(apv_[A-Za-z0-9_-]{20,})$/.exec(cabecalho ?? '');
  if (!m) return null;
  const t = await db.tokenEstudante.findUnique({ where: { token_hash: hashToken(m[1]) } });
  if (!t || t.revogado) return null;
  db.tokenEstudante.update({ where: { id: t.id }, data: { ultimo_uso: new Date() } }).catch(() => undefined);
  return t.estudante;
}

// ───────────── Licenças e pacotes de um estudante ─────────────

export async function licencasDoEstudante(db: PrismaClient | Prisma.TransactionClient, estudante: string) {
  const todas = await db.licenca.findMany({ where: { estudante }, orderBy: { criada_em: 'asc' } });
  return todas.filter((l) => licencaValida(l));
}

/** Provas cobertas pelas licenças válidas (lidas do conteúdo assinado, que é o que a app também vê). */
export function provasDasLicencas(licencas: { conteudo: string }[]) {
  const provas = new Set<string>();
  for (const l of licencas) for (const p of (JSON.parse(l.conteudo).provas as string[]) ?? []) provas.add(p);
  return provas;
}

export async function pacotesDisponiveis(db: PrismaClient | Prisma.TransactionClient, provas: Iterable<string>, base = '/api/v1') {
  const lista = [];
  for (const prova of [...provas].sort()) {
    const p = await db.pacote.findFirst({ where: { prova }, orderBy: { versao: 'desc' } });
    if (p)
      lista.push({
        prova,
        versao: p.versao,
        sha256: p.sha256,
        tamanho_bytes: p.tamanho_bytes,
        publicado_em: p.publicado_em.toISOString(),
        url: `${base}/pacotes/${encodeURIComponent(prova)}/download`,
      });
  }
  return lista;
}

const formatarLicenca = (l: { conteudo: string; assinatura: string }) => ({ licenca: l.conteudo, assinatura: l.assinatura });

// ───────────── Activação ─────────────

export interface PedidoActivacao {
  codigo: unknown;
  dispositivoId: unknown;
  telefone?: unknown;
  nome?: unknown;
  /** Estudante já autenticado (token enviado pela app), para juntar licenças na mesma conta. */
  estudanteAutenticado?: string | null;
}

export async function activar(db: PrismaClient, p: PedidoActivacao) {
  const dispositivo = typeof p.dispositivoId === 'string' ? p.dispositivoId.trim() : '';
  if (!dispositivo || dispositivo.length > 128) throw new ErroApi(400, 'PEDIDO_INVALIDO', 'Falta o identificador do dispositivo.');
  const telefoneBruto = typeof p.telefone === 'string' ? p.telefone.trim() : '';
  const telefone = normalizarTelefone(telefoneBruto);
  if (telefoneBruto && !telefone) throw new ErroApi(400, 'TELEFONE_INVALIDO', 'Número de telefone inválido. Usa 9 dígitos, ex.: 84 123 4567.');
  const nome = typeof p.nome === 'string' && p.nome.trim() ? p.nome.trim().slice(0, 80) : null;

  const codigo = normalizarCodigo(String(p.codigo ?? ''));
  if (!codigo) throw new ErroApi(404, 'CODIGO_INVALIDO', 'Código inválido. Confirma as letras e os números (formato APV-XXXX-XXXX).');
  const registo = await db.codigoActivacao.findUnique({ where: { codigo_hash: hashCodigo(codigo) }, include: { estudante: true } });
  if (!registo) throw new ErroApi(404, 'CODIGO_INVALIDO', 'Código inválido. Confirma as letras e os números (formato APV-XXXX-XXXX).');
  if (registo.estado === 'revogado') throw new ErroApi(410, 'CODIGO_REVOGADO', 'Este código foi cancelado. Fala connosco pelo WhatsApp.');

  // Código já usado: só se devolve a compra ao mesmo telemóvel ou a quem indicar o mesmo telefone (restaurar)
  if (registo.estado === 'usado') {
    const mesmoDispositivo = registo.dispositivo_id === dispositivo;
    const mesmoTelefone = !!telefone && registo.estudante?.telefone === telefone;
    if (!registo.usado_por_estudante_id || !(mesmoDispositivo || mesmoTelefone))
      throw new ErroApi(409, 'CODIGO_USADO', 'Este código já foi usado. Se és tu noutro telemóvel, indica o mesmo número de telefone usado na activação.');
    return resposta(db, registo.usado_por_estudante_id, await emitirToken(db, registo.usado_por_estudante_id, dispositivo), null, true);
  }

  if (registo.validade_ate && registo.validade_ate < new Date())
    throw new ErroApi(410, 'CODIGO_EXPIRADO', 'Este código já passou da validade. Fala connosco pelo WhatsApp.');

  const { estudante, token, licencaId } = await db.$transaction(async (tx) => {
    // Marcar como usado de forma atómica (dois pedidos ao mesmo tempo: só um ganha)
    const agora = new Date();
    const { count } = await tx.codigoActivacao.updateMany({
      where: { id: registo.id, estado: 'disponivel' },
      data: { estado: 'usado', usado_em: agora, dispositivo_id: dispositivo },
    });
    if (count !== 1) throw new ErroApi(409, 'CODIGO_USADO', 'Este código já foi usado.');

    let estudante: string;
    if (registo.tipo === 'recuperacao') {
      estudante = registo.para_estudante_id!;
    } else {
      const existente =
        (p.estudanteAutenticado && (await tx.estudante.findUnique({ where: { id: p.estudanteAutenticado } }))) ||
        (telefone && (await tx.estudante.findFirst({ where: { telefone }, orderBy: { criado_em: 'asc' } }))) ||
        null;
      if (existente) {
        estudante = existente.id;
        if ((!existente.nome && nome) || (!existente.telefone && telefone))
          await tx.estudante.update({ where: { id: existente.id }, data: { nome: existente.nome ?? nome, telefone: existente.telefone ?? telefone } });
      } else {
        estudante = (await tx.estudante.create({ data: { nome, telefone } })).id;
      }
    }
    await tx.codigoActivacao.update({ where: { id: registo.id }, data: { usado_por_estudante_id: estudante } });

    let licencaId: string | null = null;
    if (registo.tipo === 'activacao') {
      const produto = await tx.produto.findUniqueOrThrow({ where: { codigo: registo.produto! }, include: { provas: true } });
      licencaId = crypto.randomUUID();
      const conteudo = serializarLicenca({
        v: 1,
        id: licencaId,
        estudante,
        produto: produto.codigo,
        tipo: produto.tipo,
        provas: produto.provas.map((x) => x.prova),
        valido_ate: registo.validade_ate ? registo.validade_ate.toISOString() : null,
        emitida_em: agora.toISOString(),
      });
      await tx.licenca.create({
        data: { id: licencaId, estudante, produto: produto.codigo, codigo_id: registo.id, valido_ate: registo.validade_ate, conteudo, assinatura: assinar(conteudo) },
      });
    }
    return { estudante, licencaId, token: await emitirToken(tx, estudante, dispositivo) };
  });

  return resposta(db, estudante, token, licencaId, registo.tipo === 'recuperacao');
}

async function resposta(db: PrismaClient, estudanteId: string, token: string, licencaNova: string | null, restaurado: boolean) {
  const [estudante, licencas] = await Promise.all([
    db.estudante.findUniqueOrThrow({ where: { id: estudanteId }, select: { id: true, nome: true, telefone: true } }),
    licencasDoEstudante(db, estudanteId),
  ]);
  const nova = licencaNova ? licencas.find((l) => l.id === licencaNova) : null;
  return {
    token,
    restaurado,
    estudante,
    ...(nova && formatarLicenca(nova)),
    licencas: licencas.map(formatarLicenca),
    pacotes: await pacotesDisponiveis(db, provasDasLicencas(licencas)),
  };
}

export async function listarLicencas(db: PrismaClient, estudante: string) {
  const licencas = await licencasDoEstudante(db, estudante);
  return { licencas: licencas.map(formatarLicenca), pacotes: await pacotesDisponiveis(db, provasDasLicencas(licencas)) };
}
