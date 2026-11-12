import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/formatos.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/user/user_db.dart';
import '../../../domain/regras.dart';
import 'niveis_screen.dart';

typedef NivelChave = ({String prova, int nivel});

final temasDoNivelProvider = FutureProvider.family<List<String>, NivelChave>((ref, k) async {
  final qs = await ref.watch(conteudoRepoProvider).questoes(k.prova, nivel: k.nivel);
  return {for (final q in qs) if (q.temaNome != null) q.temaNome!}.toList();
});

final tentativasDoNivelProvider = FutureProvider.family<List<TentativaRow>, NivelChave>((ref, k) {
  ref.watch(progressoVersaoProvider);
  return ref.watch(utilizadorRepoProvider).tentativasDoNivel(k.prova, k.nivel);
});

/// Tela 7 — Detalhe do nível.
class NivelDetalheScreen extends ConsumerWidget {
  const NivelDetalheScreen({super.key, required this.prova, required this.nivel});

  final String prova;
  final int nivel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(detalheProvaProvider(prova)).value;
    final n = d?.niveis.where((x) => x.numero == nivel).firstOrNull;
    if (d == null || n == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final chave = (prova: prova, nivel: nivel);
    final temas = ref.watch(temasDoNivelProvider(chave)).value ?? const <String>[];
    final tentativas = ref.watch(tentativasDoNivelProvider(chave)).value ?? const <TentativaRow>[];
    final podeJogar = n.estado == EstadoNivel.disponivel || n.estado == EstadoNivel.concluido;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    BlueHeader(
                      padding: const EdgeInsets.fromLTRB(16, 8, 24, 72),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderIconButton(icon: Icons.chevron_left, color: Colors.white, onPressed: () => context.pop()),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                  child: Text('$nivel',
                                      style: const TextStyle(color: AppColors.primary, fontSize: 26, fontWeight: FontWeight.w800)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${d.prova.nome} · Nível $nivel', style: const TextStyle(color: Color(0xDDFFFFFF), fontSize: 12)),
                                      Text(n.row.descricao ?? n.row.titulo,
                                          style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.25, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: -44,
                      child: AppCard(
                        elevated: true,
                        radius: 24,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        child: Row(
                          children: [
                            _Info('${n.numQuestoes}', 'perguntas'),
                            _Info('~${(n.numQuestoes * 1.25).ceil()}′', 'duração'),
                            _Info('${n.notaMinima}%', 'para passar', color: AppColors.primary),
                            _Info('${n.tentativas}', 'tentativas'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (temas.isNotEmpty) ...[
                        const SectionTitle('Temas deste nível'),
                        const SizedBox(height: 10),
                        Wrap(spacing: 8, runSpacing: 8, children: [for (final t in temas) ChipFilter(label: t)]),
                        const SizedBox(height: 22),
                      ],
                      if (tentativas.isNotEmpty) ...[
                        const SectionTitle('As tuas tentativas'),
                        const SizedBox(height: 10),
                        for (final t in tentativas.take(5)) ...[
                          _Tentativa(t, n.notaMinima),
                          const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 6),
                      ],
                      const InfoBanner(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(text: '💡 Podes usar '),
                          TextSpan(text: 'dicas', style: TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(text: ' e '),
                          TextSpan(text: 'ver a resposta', style: TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(text: '. As perguntas em que vires a resposta não contam para a nota.'),
                        ])),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: PrimaryButton(
                label: switch (n.estado) {
                  EstadoNivel.concluido => 'Praticar de novo',
                  EstadoNivel.pago => 'Desbloquear',
                  EstadoNivel.porDescarregar => 'Descarregar conteúdo',
                  _ => tentativas.isEmpty ? 'Começar nível' : 'Tentar de novo',
                },
                onPressed: podeJogar ? () => context.push(Routes.quiz(prova, nivel)) : () => abrirNivel(context, d, n),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.value, this.label, {this.color});

  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color ?? AppColors.ink)),
          FittedBox(child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted))),
        ],
      ),
    );
  }
}

class _Tentativa extends StatelessWidget {
  const _Tentativa(this.t, this.notaMinima);

  final TentativaRow t;
  final int notaMinima;

  @override
  Widget build(BuildContext context) {
    final passou = t.percentagem >= notaMinima;
    final (emoji, bg) = passou
        ? ('🟢', AppColors.successLight)
        : t.percentagem >= notaMinima - 20
            ? ('🟡', AppColors.accentLight)
            : ('🔴', AppColors.errorLight);
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: () => context.push(Routes.revisao(t.id)),
      child: Row(
        children: [
          EmojiBox(emoji, background: bg, size: 40, fontSize: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${percentagem(t.percentagem)} · ${t.certas} de ${t.total}', style: TextStyle(fontSize: 14, color: AppColors.ink)),
                Text('${dataRelativa(t.terminadaEm)} · ${duracao(t.duracaoSeg)}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          Text(passou ? 'Passou' : 'Não passou',
              style: TextStyle(color: passou ? AppColors.success : AppColors.error, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
