import { Router } from 'express';
import { config } from '../config';
import { prisma } from '../db';
import { NUM_NIVEIS } from '../dominio';
import { publicarProva } from '../conteudo/pacotes';
import { flash } from '../seguranca';

export function pacotesRouter() {
  const r = Router();

  r.get('/', async (_req, res) => {
    const [provas, publicadas, pacotes] = await Promise.all([
      prisma.prova.findMany({ orderBy: { codigo: 'asc' }, select: { codigo: true, nome: true, questoes_de: true } }),
      prisma.questaoProva.groupBy({ by: ['prova', 'nivel'], where: { q: { estado: 'publicada' } }, _count: { _all: true } }),
      prisma.pacote.findMany({ orderBy: [{ prova: 'asc' }, { versao: 'desc' }] }),
    ]);
    const contagem: Record<string, { gratis: number; pagas: number }> = {};
    for (const c of publicadas) {
      if (!c.nivel) continue;
      const x = (contagem[c.prova] ??= { gratis: 0, pagas: 0 });
      if (c.nivel <= config.niveisGratis) x.gratis += c._count._all;
      else if (c.nivel <= NUM_NIVEIS) x.pagas += c._count._all;
    }
    const historico: Record<string, typeof pacotes> = {};
    for (const p of pacotes) (historico[p.prova] ??= []).push(p);
    res.render('pacotes', {
      linhas: provas.map((p) => {
        // Sem questões próprias: conta as da prova doadora (questoes_de)
        const fonte = contagem[p.codigo] ? p.codigo : (p.questoes_de ?? p.codigo);
        return { ...p, fonte: fonte === p.codigo ? null : fonte, ...(contagem[fonte] ?? { gratis: 0, pagas: 0 }), versoes: historico[p.codigo] ?? [] };
      }),
      niveisGratis: config.niveisGratis,
    });
  });

  r.post('/:prova/publicar', async (req, res) => {
    const prova = String(req.params.prova);
    try {
      const r2 = await publicarProva(prisma, prova, res.locals.admin.id);
      if (r2.estado === 'publicado')
        flash(req, 'ok', `${prova}: versão ${r2.versao} publicada (${r2.num_questoes} questões, ${Math.ceil(r2.tamanho_bytes / 1024)} KB).`);
      else if (r2.estado === 'sem_alteracoes') flash(req, 'info', `${prova}: sem alterações desde a versão ${r2.versao}. Nada publicado.`);
      else flash(req, 'erro', `${prova}: não há questões publicadas nos níveis ${config.niveisGratis + 1}–${NUM_NIVEIS}.`);
    } catch (e) {
      flash(req, 'erro', `${prova}: ${(e as Error).message}`);
    }
    res.redirect('/admin/pacotes');
  });

  return r;
}
