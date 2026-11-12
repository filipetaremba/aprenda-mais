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
import '../../../data/user/user_db.dart';

final historicoSimuladosProvider = FutureProvider((ref) {
  ref.watch(progressoVersaoProvider);
  return ref.watch(utilizadorRepoProvider).historico(simulados: true, limite: 10);
});

/// Um simulado abre se for gratuito ou se houver licença de simulados para TODAS as suas provas.
bool simuladoAcessivel(SimuladoInfo s, List<Licenca> licencas) =>
    s.gratuito || s.provas.every((p) => licencas.any((l) => l.cobre(p, 'simulados')));

/// Tela 12 — Simulados (tab).
class SimuladosScreen extends ConsumerWidget {
  const SimuladosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulados = ref.watch(simuladosProvider).value ?? const <SimuladoInfo>[];
    final licencas = ref.watch(licencasProvider).value ?? const <Licenca>[];
    final provas = {for (final p in ref.watch(provasObjectivosProvider).value ?? const <ProvaInfo>[]) p.codigo: p};
    final historico = ref.watch(historicoSimuladosProvider).value ?? const <TentativaRow>[];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const BlueHeader(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Simulados', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('Como no dia do exame: tempo limitado e sem ajudas.', style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 14)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (simulados.isEmpty)
                AppCard(child: Text('Escolhe um curso no Início para veres os simulados das tuas provas.', style: TextStyle(color: AppColors.inkSoft))),
              for (final (i, s) in simulados.indexed) ...[
                Builder(builder: (context) {
                  final prova = provas[s.provas.first];
                  final acesso = simuladoAcessivel(s, licencas);
                  final ultima = historico.where((t) => t.simulado == s.codigo).firstOrNull;
                  final perguntas = s.questoesDisponiveis < s.numPerguntas ? s.questoesDisponiveis : s.numPerguntas;
                  return _SimuladoCard(
                    emoji: prova?.icone ?? '🎯',
                    emojiBg: i.isEven ? AppColors.primaryLight : AppColors.accentLight,
                    titulo: s.titulo,
                    sub: '${prova?.instituicoes.join(' / ') ?? ''} · ${acesso ? perguntas : s.numPerguntas} perguntas · ${s.duracaoMin} min',
                    rodape: !acesso
                        ? const Text('🔒 Simulados são pagos')
                        : ultima == null
                            ? const Text('Ainda não feito')
                            : Text.rich(TextSpan(children: [
                                const TextSpan(text: 'Última: '),
                                TextSpan(text: percentagem(ultima.percentagem), style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                              ])),
                    rotulo: acesso ? 'Iniciar' : 'Desbloquear',
                    onIniciar: () {
                      if (!acesso) {
                        context.push(Routes.lojaDe(s.provas.first, tipo: 'simulados'));
                      } else if (s.questoesDisponiveis == 0) {
                        context.push(Routes.sincronizar);
                      } else {
                        context.push(Routes.simulado(s.codigo));
                      }
                    },
                  );
                }),
                const SizedBox(height: 12),
              ],
              if (historico.isNotEmpty) ...[
                const SizedBox(height: 10),
                const SectionTitle('Últimos resultados'),
                const SizedBox(height: 10),
                for (final t in historico.take(5)) ...[
                  AppCard(
                    padding: const EdgeInsets.all(12),
                    onTap: () => context.push(Routes.revisao(t.id)),
                    child: Row(
                      children: [
                        EmojiBox(percentagem(t.percentagem),
                            background: t.aprovado ? AppColors.successLight : AppColors.errorLight, size: 40, fontSize: 12),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provas[t.prova]?.disciplinaNome ?? t.prova, style: TextStyle(fontSize: 15, color: AppColors.ink)),
                              Text('${dataRelativa(t.terminadaEm)} · ${duracao(t.duracaoSeg)}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.primary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SimuladoCard extends StatelessWidget {
  const _SimuladoCard({
    required this.emoji,
    required this.emojiBg,
    required this.titulo,
    required this.sub,
    required this.rodape,
    required this.onIniciar,
    this.rotulo = 'Iniciar',
  });

  final String emoji;
  final Color emojiBg;
  final String titulo;
  final String sub;
  final Widget rodape;
  final VoidCallback onIniciar;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmojiBox(emoji, background: emojiBg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: DefaultTextStyle.merge(style: const TextStyle(fontSize: 12, color: AppColors.muted), child: rodape)),
              PillButton(label: rotulo, onPressed: onIniciar),
            ],
          ),
        ],
      ),
    );
  }
}
