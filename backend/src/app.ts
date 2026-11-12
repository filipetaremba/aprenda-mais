import path from 'node:path';
import express, { type NextFunction, type Request, type Response } from 'express';
import session from 'express-session';
import helmet from 'helmet';
import { config } from './config';
import { prisma } from './db';
import { LABEL_ESTADO } from './dominio';
import { garantirCsrf, lerFlash, PrismaSessionStore, verificarCsrfGlobal } from './seguranca';
import { adminRouter } from './admin';
import { apiRouter, type OpcoesApi } from './api';

export function createApp(opcoes: OpcoesApi = {}) {
  const app = express();
  app.disable('x-powered-by');
  app.set('view engine', 'ejs');
  app.set('views', path.join(config.raiz, 'views'));
  if (config.producao) app.set('trust proxy', 1);

  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          scriptSrc: ["'self'"],
          // o KaTeX escreve estilos em linha nas fórmulas
          styleSrc: ["'self'", "'unsafe-inline'"],
          imgSrc: ["'self'", 'data:', 'blob:'],
          fontSrc: ["'self'", 'data:'],
          formAction: ["'self'"],
          frameAncestors: ["'none'"],
        },
      },
    }),
  );

  app.get('/health', async (_req, res) => {
    try {
      await prisma.$queryRaw`SELECT 1`;
      res.json({ ok: true, bd: 'ok' });
    } catch {
      res.status(503).json({ ok: false, bd: 'indisponivel' });
    }
  });

  app.use('/static/katex', express.static(path.join(path.dirname(require.resolve('katex/package.json')), 'dist'), { maxAge: '7d' }));
  app.use('/static', express.static(path.join(config.raiz, 'public'), { maxAge: config.producao ? '1d' : 0 }));

  // API da app: JSON + Bearer token, sem cookies/sessão (por isso antes do CSRF)
  app.use('/api/v1', apiRouter(opcoes));

  app.use(express.urlencoded({ extended: true, limit: '2mb' }));
  app.use(
    session({
      name: 'aprova.sid',
      secret: config.segredoSessao,
      store: new PrismaSessionStore(),
      resave: false,
      saveUninitialized: false,
      rolling: true,
      cookie: { httpOnly: true, sameSite: 'lax', secure: config.producao, maxAge: 8 * 3600_000 },
    }),
  );
  app.use((req, res, next) => {
    res.locals.caminho = req.path;
    res.locals.LABEL_ESTADO = LABEL_ESTADO;
    res.locals.admin = null;
    res.locals.flash = [];
    next();
  });
  app.use(garantirCsrf, verificarCsrfGlobal, lerFlash);

  app.get('/', (_req, res) => res.redirect('/admin'));
  app.use('/admin', adminRouter());

  app.use((_req, res) => {
    res.status(404).render('erro', { titulo: 'Página não encontrada', mensagem: 'O endereço não existe.' });
  });
  app.use((err: unknown, _req: Request, res: Response, _next: NextFunction) => {
    console.error(err);
    const e = err as { status?: number; code?: string; message?: string };
    const status = e.code === 'LIMIT_FILE_SIZE' ? 413 : (e.status ?? 500);
    const mensagem =
      e.code === 'LIMIT_FILE_SIZE'
        ? 'Ficheiro demasiado grande.'
        : status < 500
          ? (e.message ?? 'Pedido inválido.')
          : 'Ocorreu um erro inesperado. Tenta de novo.';
    res.status(status).render('erro', { titulo: 'Erro', mensagem });
  });

  return app;
}
