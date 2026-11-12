import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/formatos.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/licencas.dart';
import '../../../data/repositorios.dart';

final _versaoConteudoProvider = FutureProvider((ref) => ref.watch(contentDbProvider).lerMeta('versao_app'));
final _produtosProvider = FutureProvider((ref) async => {for (final p in await ref.watch(conteudoRepoProvider).produtos()) p.row.codigo: p});

/// Tela 15 — Perfil e definições (tab).
class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilProvider).value;
    final ofertas = ref.watch(ofertasObjectivosProvider).value ?? const <OfertaInfo>[];
    final licencas = ref.watch(licencasProvider).value ?? const <Licenca>[];
    final produtos = ref.watch(_produtosProvider).value ?? const <String, ProdutoInfo>{};
    final escuro = ref.watch(temaEscuroProvider);
    final dias = perfil == null ? 0 : DateTime.now().difference(perfil.criadoEm).inDays + 1;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        BlueHeader(
          padding: const EdgeInsets.fromLTRB(20, 20, 24, 24),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xFFFFF1C7), shape: BoxShape.circle),
                  child: Text(perfil?.avatar ?? '🦁', style: const TextStyle(fontSize: 34)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(perfil?.nome ?? '', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    Text(dias <= 1 ? 'Começaste hoje' : 'A estudar há $dias dias', style: const TextStyle(color: Color(0xDDFFFFFF), fontSize: 13)),
                  ],
                ),
              ),
              PillButton(label: 'Editar', background: Colors.white.withValues(alpha: 0.2), onPressed: () => context.push('${Routes.nome}?editar=1')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Rotulo('OS MEUS OBJECTIVOS'),
              for (final o in ofertas) ...[
                AppCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      EmojiBox(o.icone, size: 40, fontSize: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.nome, style: TextStyle(fontSize: 15, color: AppColors.ink)),
                            Text('${o.instituicaoSigla} · ${o.disciplinas}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      const CircleAvatar(radius: 5, backgroundColor: AppColors.success),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.push('${Routes.objectivos}?editar=1'),
                child: CustomPaint(
                  painter: _DashedBorder(),
                  child: const SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Center(
                      child: Text('+ Adicionar ou trocar objectivo',
                          style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const _Rotulo('AS MINHAS COMPRAS'),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    if (licencas.isEmpty)
                      _Linha('🛒', 'Ainda não tens compras', const SizedBox.shrink()),
                    for (final l in licencas) ...[
                      _Linha(
                        l.tipo == 'simulados' ? '🎯' : '🔓',
                        produtos[l.produto]?.row.nome ?? l.produto,
                        Text(l.validoAte == null ? 'sem fim' : 'até ${dataRelativa(l.validoAte!)} ${l.validoAte!.year}',
                            style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                      ),
                      _divisor(),
                    ],
                    _Linha('🔑', 'Tenho um código de activação', const Icon(Icons.chevron_right, color: AppColors.muted),
                        onTap: () => context.push(Routes.activar)),
                    _divisor(),
                    _Linha('♻️', 'Restaurar compra (telemóvel novo)', const Icon(Icons.chevron_right, color: AppColors.muted),
                        onTap: () => context.push('${Routes.activar}?restaurar=1')),
                    _divisor(),
                    _Linha('⬇️', 'Verificar actualizações', const Icon(Icons.chevron_right, color: AppColors.muted),
                        onTap: () => context.push(Routes.sincronizar)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _Rotulo('PREFERÊNCIAS'),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _Linha('🌙', 'Modo escuro', AppSwitch(value: escuro, onChanged: (v) => ref.read(temaEscuroProvider.notifier).definir(v))),
                    _divisor(),
                    _Linha(
                      '⏰',
                      'Lembrete de estudo',
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                        child: const Text('EM BREVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                    ),
                    _divisor(),
                    _Linha('ℹ️', 'Sobre o Aprova+', const Icon(Icons.chevron_right, color: AppColors.muted), onTap: () => _sobre(context, ref)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _divisor() => Divider(height: 1, color: AppColors.escuro ? AppColors.border : const Color(0xFFF1F5F9));

  void _sobre(BuildContext context, WidgetRef ref) {
    final versao = ref.read(_versaoConteudoProvider).value ?? '—';
    showAboutDialog(
      context: context,
      applicationName: 'Aprova+',
      applicationVersion: '1.0 · conteúdo v$versao',
      children: const [
        Text('Preparação para os exames de admissão. Funciona sem Internet; só precisas de Internet para activar compras e descarregar conteúdo.'),
      ],
    );
  }
}

class _Rotulo extends StatelessWidget {
  const _Rotulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(texto, style: const TextStyle(fontSize: 12, letterSpacing: 0.5, fontWeight: FontWeight.w700, color: AppColors.muted)),
      );
}

class _Linha extends StatelessWidget {
  const _Linha(this.emoji, this.texto, this.trailing, {this.onTap});

  final String emoji;
  final String texto;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 14),
              Expanded(child: Text(texto, style: TextStyle(fontSize: 14, color: AppColors.ink))),
              trailing,
            ],
          ),
        ),
      );
}

class _DashedBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(20));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.border;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 10) {
        canvas.drawPath(m.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
