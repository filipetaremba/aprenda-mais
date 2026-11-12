import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/repositorios.dart';
import '../../../domain/regras.dart';

final diasSeguidosProvider = FutureProvider((ref) {
  ref.watch(progressoVersaoProvider);
  return ref.watch(utilizadorRepoProvider).diasSeguidos();
});

final pacotesPendentesProvider = FutureProvider((ref) {
  ref.watch(progressoVersaoProvider);
  return ref.watch(sincronizadorProvider).pendentes();
});

/// Tela 5 — Início (tab).
class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilProvider).value;
    final ofertas = ref.watch(ofertasObjectivosProvider).value ?? const <OfertaInfo>[];
    final detalhes = ref.watch(detalhesObjectivosProvider).value ?? const <ProvaDetalhe>[];
    final dias = ref.watch(diasSeguidosProvider).value ?? 0;
    final pendentes = ref.watch(pacotesPendentesProvider).value ?? const [];

    final concluidos = detalhes.fold(0, (s, d) => s + d.concluidos);
    final totalNiveis = detalhes.length * numNiveis;
    final progresso = totalNiveis == 0 ? 0.0 : concluidos / totalNiveis;
    final continuar = detalhes.where((d) => d.actual?.estado == EstadoNivel.disponivel).firstOrNull;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            BlueHeader(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Olá, ${perfil?.nome ?? ''} 👋', style: const TextStyle(color: Color(0xDDFFFFFF), fontSize: 14)),
                            const Text('Vamos estudar?',
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Color(0xFFFFF1C7), shape: BoxShape.circle),
                        child: Text(perfil?.avatar ?? '🦁', style: const TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: () => context.push('${Routes.objectivos}?editar=1'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(children: [
                                if (ofertas.isEmpty) const TextSpan(text: 'Escolhe um objectivo'),
                                if (ofertas.isNotEmpty) ...[
                                  TextSpan(text: '${ofertas.first.icone} ${ofertas.first.nome} · '),
                                  TextSpan(text: ofertas.first.instituicaoSigla, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  if (ofertas.length > 1) TextSpan(text: '  +${ofertas.length - 1}'),
                                ],
                              ]),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Text('Trocar',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12, decoration: TextDecoration.underline, decorationColor: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: -86,
              child: AppCard(
                elevated: true,
                radius: 24,
                child: Row(
                  children: [
                    RingProgress(
                      value: progresso,
                      size: 72,
                      stroke: 9,
                      center: Text('${(progresso * 100).round()}%',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Progresso geral', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                          Text('$concluidos de $totalNiveis níveis concluídos',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                          const SizedBox(height: 8),
                          if (continuar != null)
                            Material(
                              color: AppColors.primary,
                              shape: const StadiumBorder(),
                              child: InkWell(
                                customBorder: const StadiumBorder(),
                                onTap: () => context.push(Routes.nivel(continuar.prova.codigo, continuar.actual!.numero)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Text(
                                    '▶ Continuar: ${continuar.prova.disciplinaNome} · Nível ${continuar.actual!.numero}',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 108),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              if (pendentes.isNotEmpty) ...[
                InfoBanner(
                  color: AppColors.primaryLight,
                  child: Row(
                    children: [
                      const Text('📦', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Expanded(child: Text('A descarga das tuas compras ficou a meio.')),
                      TextButton(onPressed: () => context.push(Routes.sincronizar), child: const Text('Continuar')),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SectionTitle('As tuas provas', trailing: '${detalhes.length} ${detalhes.length == 1 ? 'disciplina' : 'disciplinas'}'),
              const SizedBox(height: 12),
              if (detalhes.isEmpty)
                AppCard(
                  onTap: () => context.push('${Routes.objectivos}?editar=1'),
                  child: Text('Escolhe um curso para veres as provas que precisas de fazer.', style: TextStyle(color: AppColors.inkSoft)),
                ),
              for (final (i, d) in detalhes.indexed) ...[
                _ProvaCard(
                  detalhe: d,
                  bg: i.isEven ? AppColors.primaryLight : AppColors.accentLight,
                  onTap: () => context.push(Routes.prova(d.prova.codigo)),
                ),
                const SizedBox(height: 12),
              ],
              if (dias > 0)
                InfoBanner(
                  child: Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(text: dias == 1 ? '1 dia seguido! ' : '$dias dias seguidos! ', style: const TextStyle(fontWeight: FontWeight.w700)),
                          const TextSpan(text: 'Faz 1 nível hoje para manter a sequência.'),
                        ])),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProvaCard extends StatelessWidget {
  const _ProvaCard({required this.detalhe, required this.bg, this.onTap});

  final ProvaDetalhe detalhe;
  final Color bg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final d = detalhe;
    final melhor = d.niveis.map((n) => n.melhor ?? 0).fold(0.0, (a, b) => a > b ? a : b);
    final semPerguntas = d.niveis.every((n) => n.numQuestoes == 0) && !d.temLicenca;
    final info = semPerguntas
        ? 'Perguntas em breve · ${d.prova.legenda}'
        : 'Nível ${d.actual?.numero ?? numNiveis} de $numNiveis${melhor > 0 ? ' · Melhor: ${melhor.round()}%' : ''}';
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              EmojiBox(d.prova.icone, background: bg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.prova.nome, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    Text(info, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 14),
          SegmentedProgressBar(total: numNiveis, done: d.concluidos, height: 5),
        ],
      ),
    );
  }
}
