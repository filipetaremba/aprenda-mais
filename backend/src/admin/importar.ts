/**
 * Importar JSON: envio → relatório (pré-visualização, nada gravado) → confirmar → gravar.
 * O plano fica em storage/importacoes/<id>/ entre os dois passos.
 */
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { Router, type NextFunction, type Request, type Response } from 'express';
import multer from 'multer';
import { dirImportacoes } from '../config';
import { prisma } from '../db';
import { analisar, gravar, type FicheiroEntrada, type Plano } from '../conteudo/importador';
import { flash, verificarCsrf } from '../seguranca';

const EXT_IMAGEM = /\.(png|jpe?g|webp)$/i;

function dirDe(id: string) {
  return path.join(dirImportacoes(), id);
}

function criarDir(req: Request, _res: Response, next: NextFunction) {
  const id = crypto.randomBytes(12).toString('hex');
  fs.mkdirSync(dirDe(id), { recursive: true });
  (req as any).importId = id;
  next();
}

const upload = multer({
  storage: multer.diskStorage({
    destination: (req, _f, cb) => cb(null, dirDe((req as any).importId)),
    // nome original (sem pastas) para as imagens manterem o nome referido no JSON
    filename: (_req, f, cb) => cb(null, path.basename(Buffer.from(f.originalname, 'latin1').toString('utf8'))),
  }),
  limits: { fileSize: 10 * 1024 * 1024, files: 500 },
  fileFilter: (_req, f, cb) => cb(null, /\.json$/i.test(f.originalname) || EXT_IMAGEM.test(f.originalname)),
});

function limparAntigas() {
  // Pré-visualizações com mais de 1 dia
  if (!fs.existsSync(dirImportacoes())) return;
  for (const d of fs.readdirSync(dirImportacoes())) {
    const p = path.join(dirImportacoes(), d);
    if (Date.now() - fs.statSync(p).mtimeMs > 86_400_000) fs.rmSync(p, { recursive: true, force: true });
  }
}

export function importarRouter() {
  const r = Router();

  r.get('/', (_req, res) => res.render('importar/form', { erro: null }));

  r.post('/', criarDir, upload.array('ficheiros'), verificarCsrf, async (req, res) => {
    const id = (req as any).importId as string;
    const enviados = (req.files as Express.Multer.File[]) ?? [];
    const jsons = enviados.filter((f) => /\.json$/i.test(f.originalname));
    if (!jsons.length) {
      fs.rmSync(dirDe(id), { recursive: true, force: true });
      return res.status(400).render('importar/form', { erro: 'Escolhe pelo menos um ficheiro .json.' });
    }
    const ficheiros: FicheiroEntrada[] = jsons.map((f) => ({ nome: f.filename, conteudo: fs.readFileSync(f.path) }));
    const imagens = Object.fromEntries(enviados.filter((f) => EXT_IMAGEM.test(f.originalname)).map((f) => [f.filename, f.path]));

    const { relatorio, plano } = await analisar(prisma, ficheiros, { imagens, substituir: req.body.substituir === 'on' });
    if (relatorio.ok) {
      fs.writeFileSync(path.join(dirDe(id), 'plano.json'), JSON.stringify(plano));
      req.session.importacao = id;
    } else {
      fs.rmSync(dirDe(id), { recursive: true, force: true });
    }
    limparAntigas();
    res.status(relatorio.ok ? 200 : 422).render('importar/relatorio', { relatorio, id: relatorio.ok ? id : null });
  });

  r.post('/confirmar', async (req, res) => {
    const id = String(req.body.id ?? '');
    const ficheiro = path.join(dirDe(id), 'plano.json');
    if (!/^[a-f0-9]{24}$/.test(id) || req.session.importacao !== id || !fs.existsSync(ficheiro)) {
      flash(req, 'erro', 'A pré-visualização expirou. Envia os ficheiros de novo.');
      return res.redirect('/admin/importar');
    }
    const plano = JSON.parse(fs.readFileSync(ficheiro, 'utf8')) as Plano;
    const resultado = await gravar(prisma, plano);
    fs.rmSync(dirDe(id), { recursive: true, force: true });
    req.session.importacao = undefined;
    res.render('importar/feito', { resultado });
  });

  return r;
}
