import crypto from 'node:crypto';
import session from 'express-session';
import type { NextFunction, Request, Response } from 'express';
import { prisma } from './db';

declare module 'express-session' {
  interface SessionData {
    adminId?: number;
    csrf?: string;
    flash?: { tipo: 'ok' | 'erro' | 'info'; texto: string }[];
    importacao?: string;
  }
}

// ───────────── Sessões guardadas na base de dados ─────────────

export class PrismaSessionStore extends session.Store {
  get(sid: string, cb: (err: unknown, s?: session.SessionData | null) => void) {
    prisma.sessao
      .findUnique({ where: { sid } })
      .then((s) => {
        if (!s || s.expira < new Date()) return cb(null, null);
        cb(null, JSON.parse(s.dados));
      })
      .catch(cb);
  }

  set(sid: string, s: session.SessionData, cb?: (err?: unknown) => void) {
    const expira = s.cookie?.expires ? new Date(s.cookie.expires) : new Date(Date.now() + 8 * 3600_000);
    const dados = JSON.stringify(s);
    prisma.sessao
      .upsert({ where: { sid }, create: { sid, dados, expira }, update: { dados, expira } })
      .then(() => cb?.())
      .catch((e) => cb?.(e));
  }

  destroy(sid: string, cb?: (err?: unknown) => void) {
    prisma.sessao
      .deleteMany({ where: { sid } })
      .then(() => cb?.())
      .catch((e) => cb?.(e));
  }

  touch(sid: string, s: session.SessionData, cb?: () => void) {
    const expira = s.cookie?.expires ? new Date(s.cookie.expires) : new Date(Date.now() + 8 * 3600_000);
    prisma.sessao
      .updateMany({ where: { sid }, data: { expira } })
      .then(() => cb?.())
      .catch(() => cb?.());
  }

  /** Apaga sessões expiradas (chamado periodicamente pelo servidor). */
  static limpar() {
    return prisma.sessao.deleteMany({ where: { expira: { lt: new Date() } } });
  }
}

// ───────────── CSRF (token sincronizado na sessão) ─────────────

export function garantirCsrf(req: Request, res: Response, next: NextFunction) {
  if (!req.session.csrf) req.session.csrf = crypto.randomBytes(32).toString('base64url');
  res.locals.csrf = req.session.csrf;
  next();
}

function tokenValido(req: Request): boolean {
  const esperado = req.session.csrf;
  const recebido = (req.body?._csrf as string | undefined) ?? req.get('x-csrf-token');
  if (!esperado || !recebido) return false;
  const a = Buffer.from(esperado);
  const b = Buffer.from(String(recebido));
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

/** Verifica o token em todos os POST. Formulários multipart verificam depois do multer (ver verificarCsrf). */
export function verificarCsrfGlobal(req: Request, res: Response, next: NextFunction) {
  if (req.method !== 'POST' || req.is('multipart/form-data')) return next();
  return verificarCsrf(req, res, next);
}

export function verificarCsrf(req: Request, res: Response, next: NextFunction) {
  if (tokenValido(req)) return next();
  res.status(403).render('erro', { titulo: 'Pedido recusado', mensagem: 'O formulário expirou. Volta atrás, actualiza a página e tenta de novo.' });
}

// ───────────── Autenticação do admin ─────────────

export async function exigirAdmin(req: Request, res: Response, next: NextFunction) {
  const id = req.session.adminId;
  if (!id) return res.redirect(`/admin/login?voltar=${encodeURIComponent(req.originalUrl)}`);
  const admin = await prisma.admin.findUnique({ where: { id }, select: { id: true, email: true, nome: true, activo: true } });
  if (!admin?.activo) {
    req.session.adminId = undefined;
    return res.redirect('/admin/login');
  }
  res.locals.admin = admin;
  next();
}

export function flash(req: Request, tipo: 'ok' | 'erro' | 'info', texto: string) {
  (req.session.flash ??= []).push({ tipo, texto });
}

/** Passa as mensagens flash para a vista e limpa-as. */
export function lerFlash(req: Request, res: Response, next: NextFunction) {
  res.locals.flash = req.session.flash ?? [];
  if (req.session.flash?.length) req.session.flash = [];
  next();
}
