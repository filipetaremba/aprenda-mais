import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/formatos.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/repositorios.dart';
import '../../../data/user/user_db.dart';
import '../../inicio/presentation/inicio_screen.dart';

class DadosProgresso {
  const DadosProgresso({
    required this.respostas,
    required this.acertos,
    required this.niveis,
    required this.porDia,
    required this.temas,
    required this.historico,
    required this.nomeProva,
    required this.notaMinima,
  });

  final int respostas;
  final double acertos;
  final int niveis;

  /// Média da nota em cada um dos últimos 7 dias (null = sem tentativas)
  final List<(DateTime, double?)> porDia;
  final List<ResumoTema> temas;
  final List<TentativaRow> historico;
  final Map<String, String> nomeProva;
  final int notaMinima;
}

final progressoProvider = FutureProvider<DadosProgresso>((ref) async {
  ref.watch(progressoVersaoProvider);
  final user = ref.watch(utilizadorRepoProvider);
  final conteudo = ref.watch(conteudoRepoProvider);
  final detalhes = await ref.watch(detalhesObjectivosProvider.future);
  final regras = await ref.watch(regrasProvider.future);

  final hoje = DateTime.now();
  final inicio = DateTime(hoje.year, hoje.month, hoje.day).subtract(const Duration(days: 6));
  final recentes = await user.historico(desde: inicio);
  final porDia = [
    for (var i = 0; i < 7; i++)
      () {
        final d = inicio.add(Duration(days: i));
        final doDia = recentes.where((t) => t.terminadaEm.year == d.year && t.terminadaEm.month == d.month && t.terminadaEm.day == d.day);
        return (d, doDia.isEmpty ? null : doDia.map((t) => t.percentagem).reduce((a, b) => a + b) / doDia.length);
      }(),
  ];

  final todas = await user.historico();
  final respostas = todas.fold(0, (s, t) => s + t.total);
  final certas = todas.fold(0, (s, t) => s + t.certas);
  final respondidas = await user.questoesRespondidas();
  final temas = await user.temasFracos(
    await conteudo.temaDasQuestoes(respondidas),
    await conteudo.temas(),
    await conteudo.disciplinaDoTema(),
  );
  final nomes = <String, String>{};
  for (final t in todas.take(20)) {
    nomes[t.prova] ??= (await conteudo.prova(t.prova))?.disciplinaNome ?? t.prova;
  }
  return DadosProgresso(
    respostas: respostas,
    acertos: respostas == 0 ? 0 : certas * 100 / respostas,
    niveis: detalhes.fold(0, (s, d) => s + d.concluidos),
    porDia: porDia,
    temas: temas.where((t) => t.fraccao < 0.8).take(3).toList(),
    historico: todas.take(10).toList(),
    nomeProva: nomes,
    notaMinima: regras.notaMinimaPadrao,
  );
});

/// Tela 14 — Progresso (tab).
class ProgressoScreen extends ConsumerWidget {
  const ProgressoScreen({super.key});

  static const _dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressoProvider).value;
    final dias = ref.watch(diasSeguidosProvider).value ?? 0;
    if (p == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28))),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('O teu progresso', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16)),
                        child: const Text('Últimos 7 dias', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: StatTile(value: '${p.respostas}', label: 'respostas', color: AppColors.primary, background: AppColors.primaryLight)),
                      const SizedBox(width: 8),
                      Expanded(child: StatTile(value: percentagem(p.acertos), label: 'acertos', color: AppColors.success, background: AppColors.successLight)),
                      const SizedBox(width: 8),
                      Expanded(child: StatTile(value: '${p.niveis}', label: 'níveis', color: const Color(0xFFF59E0B), background: AppColors.accentLight)),
                      const SizedBox(width: 8),
                      Expanded(child: StatTile(value: '🔥$dias', label: 'dias', color: AppColors.error, background: AppColors.errorLight)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Evolução das notas'),
                    const SizedBox(height: 12),
                    SizedBox(height: 150, width: double.infinity, child: _Grafico(p.porDia, p.notaMinima)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final (d, _) in p.porDia) Text(_dias[d.weekday - 1], style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Temas a reforçar'),
                    const SizedBox(height: 12),
                    if (p.temas.isEmpty)
                      Text('Responde a mais perguntas para vermos os temas em que precisas de reforço.',
                          style: TextStyle(fontSize: 13, color: AppColors.inkSoft)),
                    for (final t in p.temas)
                      _Tema(
                        '${t.nome}${t.disciplina.isEmpty ? '' : ' · ${t.disciplina}'}',
                        t.fraccao,
                        t.fraccao < 0.5 ? AppColors.error : AppColors.accent,
                        t.fraccao < 0.5 ? AppColors.errorLight : AppColors.accentLight,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const SectionTitle('Histórico'),
              const SizedBox(height: 10),
              if (p.historico.isEmpty) Text('Ainda não fizeste nenhum nível.', style: TextStyle(color: AppColors.inkSoft)),
              for (final t in p.historico)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(12),
                    onTap: () => context.push(Routes.revisao(t.id)),
                    child: Row(
                      children: [
                        EmojiBox(percentagem(t.percentagem),
                            background: t.aprovado ? AppColors.successLight : AppColors.accentLight, size: 40, fontSize: 12),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.simulado != null ? 'Simulado de ${p.nomeProva[t.prova] ?? t.prova}' : '${p.nomeProva[t.prova] ?? t.prova} · Nível ${t.nivel}',
                                style: TextStyle(fontSize: 14, color: AppColors.ink),
                              ),
                              Text('${dataRelativa(t.terminadaEm)} · ${duracao(t.duracaoSeg)}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        Text(t.aprovado ? 'Passou' : 'Não passou', style: TextStyle(fontSize: 12, color: t.aprovado ? AppColors.success : AppColors.error)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tema extends StatelessWidget {
  const _Tema(this.nome, this.valor, this.cor, this.fundo);

  final String nome;
  final double valor;
  final Color cor;
  final Color fundo;

  @override
  Widget build(BuildContext context) {
    final pctColor = cor == AppColors.accent ? const Color(0xFFF59E0B) : cor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(nome, style: TextStyle(fontSize: 13, color: AppColors.ink))),
              Text('${(valor * 100).round()}%', style: TextStyle(fontWeight: FontWeight.w700, color: pctColor, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          LinearBar(value: valor, color: cor, background: fundo, height: 8),
        ],
      ),
    );
  }
}

/// Média diária (fl_chart), com a linha da nota mínima tracejada.
class _Grafico extends StatelessWidget {
  const _Grafico(this.porDia, this.notaMinima);

  final List<(DateTime, double?)> porDia;
  final int notaMinima;

  @override
  Widget build(BuildContext context) {
    final pontos = [
      for (final (i, (_, v)) in porDia.indexed)
        if (v != null) FlSpot(i.toDouble(), v),
    ];
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 100,
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 1),
        ),
        extraLinesData: ExtraLinesData(horizontalLines: [
          HorizontalLine(
            y: notaMinima.toDouble(),
            color: AppColors.success,
            strokeWidth: 1.2,
            dashArray: [4, 4],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topLeft,
              style: const TextStyle(fontSize: 9, color: AppColors.muted),
              labelResolver: (_) => '$notaMinima%',
            ),
          ),
        ]),
        lineBarsData: [
          LineChartBarData(
            spots: pontos,
            isCurved: true,
            preventCurveOverShooting: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: FlDotData(
              getDotPainter: (_, _, _, _) => FlDotCirclePainter(radius: 4, color: AppColors.surface, strokeWidth: 2.5, strokeColor: AppColors.primary),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary.withValues(alpha: 0.25), AppColors.primary.withValues(alpha: 0)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
