import { Router, type Response } from 'express';
import type { Prisma } from '@prisma/client';
import { validadePadrao } from '../config';
import { prisma } from '../db';
import { mascarar, normalizarTelefone } from '../activacao/codigos';
import { gerarCodigoRecuperacao, gerarCodigos, revogarCodigo } from '../activacao/servico';
import { flash } from '../seguranca';

const POR_PAGINA = 50;
const MAX_LOTE = 200;
export const ESTADOS_CODIGO = ['disponivel', 'usado', 'revogado'] as const;

const dataPt = (d: Date | null | undefined) => (d ? d.toLocaleDateString('pt-PT', { timeZone: 'Africa/Maputo' }) : '—');

function mensagemWhatsApp(codigo: string, produto: string, validade: Date | null, recuperacao = false) {
  const linhas = recuperacao
    ? ['Olá! Aqui está o teu código de recuperação do Aprova+:', `*${codigo}*`, 'Na app, abre «Tenho um código de activação» e escreve o código para recuperar as tuas compras neste telemóvel.']
    : [`Olá! Obrigado por comprares o Aprova+ (${produto}).`, `O teu código de activação é: *${codigo}*`, 'Na app, abre «Desbloquear» → «Tenho um código de activação» e escreve o código.'];
  if (validade) linhas.push(`Válido até ${dataPt(validade)}.`);
  linhas.push('Guarda esta mensagem.');
  return linhas.join('\n');
}

function linkWhatsApp(mensagem: string, telefone: string | null) {
  return `https://wa.me/${telefone ? `258${telefone}` : ''}?text=${encodeURIComponent(mensagem)}`;
}

function filtros(src: Record<string, any>) {
  return {
    estado: String(src.estado ?? ''),
    produto: String(src.produto ?? ''),
    q: String(src.q ?? '').trim(),
    pagina: Math.max(1, Number(src.pagina) || 1),
  };
}

function where(f: ReturnType<typeof filtros>): Prisma.CodigoActivacaoWhereInput {
  const w: Prisma.CodigoActivacaoWhereInput = {};
  if (f.estado) w.estado = f.estado;
  if (f.produto) w.produto = f.produto;
  if (f.q) {
    const final = f.q.toUpperCase().replace(/[^A-Z0-9]/g, '').slice(-4);
    w.OR = [
      { nota: { contains: f.q } },
      ...(final.length === 4 ? [{ codigo_final: final }] : []),
      { estudante: { is: { OR: [{ telefone: { contains: f.q } }, { nome: { contains: f.q } }] } } },
    ];
  }
  return w;
}

function semCache(res: Response) {
  // A página com os códigos em claro não pode ficar em cache
  res.set('Cache-Control', 'no-store');
}

const csv = (v: unknown) => {
  const s = v == null ? '' : v instanceof Date ? v.toISOString() : String(v);
  return /[";\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
};

export function codigosRouter() {
  const r = Router();

  r.get('/', async (req, res) => {
    const f = filtros(req.query);
    const w = where(f);
    const [codigos, total, produtos, contagens] = await Promise.all([
      prisma.codigoActivacao.findMany({
        where: w,
        orderBy: { id: 'desc' },
        skip: (f.pagina - 1) * POR_PAGINA,
        take: POR_PAGINA,
        include: { prod: { select: { nome: true } }, estudante: { select: { nome: true, telefone: true } } },
      }),
      prisma.codigoActivacao.count({ where: w }),
      prisma.produto.findMany({ orderBy: { ordem: 'asc' }, select: { codigo: true, nome: true, preco_mt: true } }),
      prisma.codigoActivacao.groupBy({ by: ['estado'], _count: { _all: true } }),
    ]);
    res.render('codigos/lista', {
      codigos: codigos.map((c) => ({ ...c, mascara: mascarar(c.codigo_final) })),
      total,
      f,
      produtos,
      contagens: Object.fromEntries(contagens.map((c) => [c.estado, c._count._all])),
      paginas: Math.max(1, Math.ceil(total / POR_PAGINA)),
      qs: (extra: object) => new URLSearchParams(Object.entries({ ...f, ...extra }).filter(([, v]) => v !== '').map(([k, v]) => [k, String(v)])).toString(),
      dataPt,
    });
  });

  r.get('/exportar.csv', async (req, res) => {
    const codigos = await prisma.codigoActivacao.findMany({
      where: where(filtros(req.query)),
      orderBy: { id: 'asc' },
      include: { estudante: true, admin: { select: { email: true } } },
    });
    const cab = ['id', 'codigo', 'tipo', 'produto', 'estado', 'validade_ate', 'nota', 'criado_em', 'criado_por', 'usado_em', 'estudante_nome', 'estudante_telefone', 'dispositivo_id'];
    const linhas = codigos.map((c) =>
      [c.id, mascarar(c.codigo_final), c.tipo, c.produto, c.estado, c.validade_ate, c.nota, c.criado_em, c.admin?.email, c.usado_em, c.estudante?.nome, c.estudante?.telefone, c.dispositivo_id]
        .map(csv)
        .join(';'),
    );
    res.set({ 'Content-Type': 'text/csv; charset=utf-8', 'Content-Disposition': `attachment; filename="codigos-${new Date().toISOString().slice(0, 10)}.csv"` });
    // BOM para o Excel abrir os acentos correctamente
    res.send(`﻿${[cab.join(';'), ...linhas].join('\r\n')}\r\n`);
  });

  r.get('/gerar', async (req, res) => {
    const produtos = await prisma.produto.findMany({ where: { activo: true }, orderBy: { ordem: 'asc' } });
    res.render('codigos/gerar', {
      produtos,
      v: { produto: String(req.query.produto ?? ''), quantidade: '1', validade: validadePadrao().toISOString().slice(0, 10), nota: '', telefone: '' },
      erros: [],
    });
  });

  r.post('/gerar', async (req, res) => {
    const v = {
      produto: String(req.body.produto ?? ''),
      quantidade: String(req.body.quantidade ?? '1').trim(),
      validade: String(req.body.validade ?? '').trim(),
      nota: String(req.body.nota ?? '').trim(),
      telefone: String(req.body.telefone ?? '').trim(),
    };
    const erros: string[] = [];
    const produto = await prisma.produto.findUnique({ where: { codigo: v.produto } });
    if (!produto) erros.push('Escolhe o produto.');
    const quantidade = Number(v.quantidade);
    if (!Number.isInteger(quantidade) || quantidade < 1 || quantidade > MAX_LOTE) erros.push(`A quantidade vai de 1 a ${MAX_LOTE}.`);
    let validade: Date | null = null;
    if (v.validade) {
      if (!/^\d{4}-\d{2}-\d{2}$/.test(v.validade)) erros.push('Data de validade inválida.');
      else {
        validade = new Date(`${v.validade}T23:59:59.000Z`);
        if (validade < new Date()) erros.push('A validade já passou.');
      }
    }
    const telefone = normalizarTelefone(v.telefone);
    if (v.telefone && !telefone) erros.push('Telefone inválido (9 dígitos, ex.: 841234567).');
    if (erros.length) {
      const produtos = await prisma.produto.findMany({ where: { activo: true }, orderBy: { ordem: 'asc' } });
      return res.status(400).render('codigos/gerar', { produtos, v, erros });
    }

    const nota = [v.nota, telefone && `tel. ${telefone}`].filter(Boolean).join(' · ') || null;
    const gerados = await gerarCodigos(prisma, { produto: produto!.codigo, quantidade, validade, nota, adminId: res.locals.admin.id });
    semCache(res);
    res.render('codigos/gerados', {
      titulo: `${gerados.length} código(s) gerado(s)`,
      produto,
      validade: dataPt(validade),
      nota,
      codigos: gerados.map((g) => {
        const msg = mensagemWhatsApp(g.codigo, produto!.nome, validade);
        return { codigo: g.codigo, mensagem: msg, whatsapp: linkWhatsApp(msg, telefone) };
      }),
      csv: ['codigo;produto;preco_mt;validade;nota', ...gerados.map((g) => [g.codigo, produto!.codigo, produto!.preco_mt, v.validade, nota].map(csv).join(';'))].join('\r\n'),
    });
  });

  r.post('/:id/revogar', async (req, res) => {
    const id = Number(req.params.id);
    const c = await prisma.codigoActivacao.findUnique({ where: { id } });
    if (!c || c.estado === 'revogado') {
      flash(req, 'erro', 'Código inexistente ou já revogado.');
    } else {
      const { licencasRevogadas } = await revogarCodigo(prisma, id);
      flash(req, 'ok', `Código ${mascarar(c.codigo_final)} revogado${licencasRevogadas ? ` (e ${licencasRevogadas} licença(s) cancelada(s))` : ''}.`);
    }
    res.redirect(`/admin/codigos?${new URLSearchParams(filtros(req.body) as any).toString()}`);
  });

  return r;
}

/** Código de recuperação para um estudante (mudou de telemóvel e não se lembra do código/telefone). */
export function recuperacaoRouter() {
  const r = Router();
  r.post('/:id/recuperacao', async (req, res) => {
    const estudante = await prisma.estudante.findUnique({ where: { id: String(req.params.id) } });
    if (!estudante) return res.status(404).render('erro', { titulo: 'Não encontrado', mensagem: 'Estudante inexistente.' });
    const { codigo, validade } = await gerarCodigoRecuperacao(prisma, estudante.id, res.locals.admin.id, `recuperação de ${estudante.nome ?? estudante.telefone ?? estudante.id}`);
    const msg = mensagemWhatsApp(codigo, '', validade, true);
    semCache(res);
    res.render('codigos/gerados', {
      titulo: 'Código de recuperação',
      produto: null,
      validade: dataPt(validade),
      nota: `Para ${estudante.nome ?? '—'} (${estudante.telefone ?? 'sem telefone'}). Devolve todas as licenças deste estudante num telemóvel novo.`,
      codigos: [{ codigo, mensagem: msg, whatsapp: linkWhatsApp(msg, estudante.telefone) }],
      csv: null,
    });
  });
  return r;
}
