import fs from 'node:fs';
import path from 'node:path';
import { Router } from 'express';
import bcrypt from 'bcryptjs';
import rateLimit from 'express-rate-limit';
import { dirImagens } from '../config';
import { prisma } from '../db';
import { exigirAdmin } from '../seguranca';
import { catalogoRouter, produtosRouter } from './catalogo';
import { questoesRouter } from './questoes';
import { importarRouter } from './importar';
import { codigosRouter, recuperacaoRouter } from './codigos';
import { pacotesRouter } from './pacotes';

// Hash fixo para comparar quando o email não existe (o tempo de resposta não revela contas)
const HASH_FALSO = bcrypt.hashSync('nao-existe-esta-conta', 12);

export function adminRouter() {
  const r = Router();

  const limiteLogin = rateLimit({
    windowMs: 15 * 60_000,
    limit: 10,
    skipSuccessfulRequests: true,
    standardHeaders: 'draft-7',
    legacyHeaders: false,
    handler: (_req, res) =>
      res.status(429).render('login', { erro: 'Demasiadas tentativas. Espera 15 minutos.', email: '', voltar: '' }),
  });

  r.get('/login', (req, res) => {
    if (req.session.adminId) return res.redirect('/admin');
    res.render('login', { erro: null, email: '', voltar: String(req.query.voltar ?? '') });
  });

  r.post('/login', limiteLogin, async (req, res, next) => {
    try {
      const email = String(req.body.email ?? '').trim().toLowerCase();
      const password = String(req.body.password ?? '');
      const voltar = String(req.body.voltar ?? '');
      const admin = await prisma.admin.findUnique({ where: { email } });
      const certo = await bcrypt.compare(password, admin?.password_hash ?? HASH_FALSO);
      if (!admin || !certo || !admin.activo) {
        return res.status(401).render('login', { erro: 'Email ou password incorrectos.', email, voltar });
      }
      // Nova sessão no login (evita fixação de sessão)
      req.session.regenerate((err) => {
        if (err) return next(err);
        req.session.adminId = admin.id;
        prisma.admin.update({ where: { id: admin.id }, data: { ultimo_login: new Date() } }).catch(() => undefined);
        req.session.save(() => res.redirect(voltar.startsWith('/admin') ? voltar : '/admin'));
      });
    } catch (e) {
      next(e);
    }
  });

  r.post('/logout', (req, res) => {
    req.session.destroy(() => {
      res.clearCookie('aprova.sid');
      res.redirect('/admin/login');
    });
  });

  // ───── A partir daqui é preciso sessão de admin ─────
  r.use(exigirAdmin);

  r.get('/', async (_req, res) => {
    const [porEstado, provas, instituicoes, ofertas, estudantes, produtos, licencas, porProva] = await Promise.all([
      prisma.questao.groupBy({ by: ['estado'], _count: { _all: true } }),
      prisma.prova.count(),
      prisma.instituicao.count(),
      prisma.oferta.count(),
      prisma.estudante.count(),
      prisma.produto.count(),
      prisma.licenca.count({ where: { revogada: false } }),
      prisma.questaoProva.groupBy({ by: ['prova'], _count: { _all: true }, orderBy: { prova: 'asc' } }),
    ]);
    const estados = Object.fromEntries(porEstado.map((e) => [e.estado, e._count._all]));
    const publicadasPorProva = Object.fromEntries(
      (
        await prisma.questaoProva.groupBy({ by: ['prova'], where: { q: { estado: 'publicada' } }, _count: { _all: true } })
      ).map((p) => [p.prova, p._count._all]),
    );
    res.render('painel', {
      estados,
      totalQuestoes: porEstado.reduce((s, e) => s + e._count._all, 0),
      provas,
      instituicoes,
      ofertas,
      estudantes,
      produtos,
      licencas,
      porProva: porProva.map((p) => ({ prova: p.prova, total: p._count._all, publicadas: publicadasPorProva[p.prova] ?? 0 })),
    });
  });

  r.use('/catalogo', catalogoRouter());
  r.use('/produtos', produtosRouter());
  r.use('/questoes', questoesRouter());
  r.use('/importar', importarRouter());
  r.use('/codigos', codigosRouter());
  r.use('/pacotes', pacotesRouter());
  r.use('/estudantes', recuperacaoRouter());

  r.get('/estudantes', async (req, res) => {
    const q = String(req.query.q ?? '').trim();
    const where = q ? { OR: [{ nome: { contains: q } }, { telefone: { contains: q } }] } : {};
    const estudantes = await prisma.estudante.findMany({
      where,
      orderBy: { criado_em: 'desc' },
      take: 200,
      include: {
        licencas: { select: { produto: true, revogada: true, valido_ate: true } },
        _count: { select: { tokens: { where: { revogado: false } } } },
      },
    });
    res.render('estudantes', { estudantes, q });
  });

  // Imagens das questões (só para o admin; a app recebe-as nos pacotes)
  r.get('/media/:nome', (req, res) => {
    const nome = path.basename(req.params.nome);
    const ficheiro = path.join(dirImagens(), nome);
    if (!fs.existsSync(ficheiro)) return res.status(404).end();
    res.sendFile(ficheiro);
  });

  return r;
}
