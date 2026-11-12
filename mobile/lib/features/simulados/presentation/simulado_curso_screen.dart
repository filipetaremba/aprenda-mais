import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/formatos.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/repositorios.dart';
import '../../../domain/quiz.dart';
import '../../quiz/presentation/pergunta_screen.dart';
import 'simulados_screen.dart';

/// Tela 13 — Simulado em curso: cronómetro decrescente, marcar, navegação livre, sem ajudas.
/// Termina sozinho quando o tempo acaba. A correcção só aparece no fim (Resultado + Revisão).
class SimuladoCursoScreen extends ConsumerStatefulWidget {
  const SimuladoCursoScreen({super.key, required this.codigo});

  final String codigo;

  @override
  ConsumerState<SimuladoCursoScreen> createState() => _SimuladoCursoScreenState();
}

class _SimuladoCursoScreenState extends ConsumerState<SimuladoCursoScreen> {
  SimuladoInfo? _info;
  SessaoQuiz? _s;
  String? _erro;
  Timer? _relogio;
  int _restante = 0;
  bool _aTerminar = false;
  final _lista = ScrollController();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final conteudo = ref.read(conteudoRepoProvider);
    final info = await conteudo.simulado(widget.codigo);
    final licencas = await ref.read(licencasProvider.future);
    if (info == null || !simuladoAcessivel(info, licencas)) {
      if (mounted) setState(() => _erro = 'Este simulado precisa de uma licença de simulados.');
      return;
    }
    final todas = [for (final p in info.provas) ...await conteudo.questoes(p)]..shuffle(Random());
    final escolhidas = todas.take(info.numPerguntas).toList();
    if (!mounted) return;
    setState(() {
      _info = info;
      _s = SessaoQuiz(questoes: escolhidas, modo: ModoQuiz.simulado, baralharQuestoes: false);
      _restante = info.duracaoMin * 60;
    });
    _relogio = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _restante--);
      if (_restante <= 0) _terminar(confirmar: false);
    });
  }

  @override
  void dispose() {
    _relogio?.cancel();
    _lista.dispose();
    super.dispose();
  }

  Future<void> _terminar({bool confirmar = true}) async {
    final s = _s!;
    if (_aTerminar) return;
    if (confirmar) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Terminar o simulado?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          content: Text('Respondeste a ${s.respondidas} de ${s.total} perguntas. As que ficaram em branco contam como erradas.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Continuar')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Terminar', style: TextStyle(color: AppColors.error))),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }
    _aTerminar = true;
    _relogio?.cancel();
    final regras = await ref.read(regrasProvider.future);
    final id = await ref
        .read(utilizadorRepoProvider)
        .gravarTentativa(s, prova: _info!.provas.first, simulado: _info!.codigo, notaMinima: regras.notaMinimaPadrao);
    ref.refrescar();
    if (!mounted) return;
    if (!confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⏱ O tempo acabou. O simulado foi entregue.')));
    }
    context.pushReplacement(Routes.resultado(id));
  }

  void _ir(int i) => setState(() => _s!.irPara(i));

  @override
  Widget build(BuildContext context) {
    if (_erro != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Ver como desbloquear', onPressed: () => context.pushReplacement(Routes.loja)),
            ]),
          ),
        ),
      );
    }
    final s = _s;
    if (s == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final r = s.questaoActual;
    final q = r.questao;
    final poucoTempo = _restante < 5 * 60;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _terminar();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_info!.titulo,
                          overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: poucoTempo ? AppColors.errorLight : AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
                      child: Text('⏱ ${relogio(_restante)}',
                          style: TextStyle(color: poucoTempo ? AppColors.error : AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  controller: _lista,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: s.total,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (_, i) => _numero(s, i),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Text.rich(
                  TextSpan(children: [
                    const WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.square, size: 10, color: AppColors.primary)),
                    const TextSpan(text: ' respondida · '),
                    const WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.square, size: 10, color: AppColors.accent)),
                    TextSpan(text: ' marcada · ${s.respondidas} de ${s.total} respondidas'),
                  ]),
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ),
              Expanded(
                child: ListView(
                  key: ValueKey(q.codigo),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  children: [
                    EnunciadoQuestao(
                      questao: q,
                      rotulo: 'Questão ${s.actual + 1}${q.temaNome == null ? '' : ' · ${q.temaNome}'}',
                      trailing: GestureDetector(
                        onTap: () => setState(s.alternarMarca),
                        child: Text(r.marcada ? '🚩 Marcada' : '🚩 Marcar', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    for (var k = 0; k < r.ordem.length; k++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: OptionTile(
                          compact: true,
                          letter: q.verdadeiroFalso ? r.ordem[k].letra : letrasPosicao[k],
                          text: r.ordem[k].texto ?? '',
                          imagem: r.ordem[k].imagem,
                          state: r.escolhida == k ? OptionState.selected : OptionState.normal,
                          onTap: () => setState(() => s.escolher(k)),
                        ),
                      ),
                    const SizedBox(height: 4),
                    const Text('Sem dicas nem respostas durante o simulado.',
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: SecondaryButton(
                        label: '‹',
                        background: AppColors.escuro ? AppColors.border : const Color(0xFFF1F5F9),
                        foreground: AppColors.ink,
                        onPressed: s.actual == 0 ? null : () => _ir(s.actual - 1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SecondaryButton(
                        label: s.ultima ? 'Rever marcadas' : 'Seguinte',
                        background: AppColors.primary,
                        foreground: Colors.white,
                        onPressed: () {
                          if (!s.ultima) return _ir(s.actual + 1);
                          final marcada = s.respostas.indexWhere((x) => x.marcada || x.escolhida == null);
                          if (marcada >= 0) _ir(marcada);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 104,
                      child: SecondaryButton(label: 'Terminar', background: AppColors.errorLight, foreground: AppColors.error, onPressed: _terminar),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numero(SessaoQuiz s, int i) {
    final r = s.respostas[i];
    final actual = i == s.actual;
    final (bg, fg) = r.marcada
        ? (AppColors.accent, AppColors.ink)
        : r.escolhida != null
            ? (AppColors.primary, Colors.white)
            : actual
                ? (AppColors.surface, AppColors.primary)
                : (AppColors.escuro ? AppColors.border : const Color(0xFFF1F5F9), AppColors.muted);
    return GestureDetector(
      onTap: () => _ir(i),
      child: Container(
        width: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: actual ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        child: Text('${i + 1}', style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }
}
