import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/formatos.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/quiz.dart';

const letrasPosicao = ['A', 'B', 'C', 'D', 'E'];

/// Enunciado completo de uma questão (texto de leitura, enunciado, imagens).
class EnunciadoQuestao extends StatelessWidget {
  const EnunciadoQuestao({super.key, required this.questao, required this.rotulo, this.trailing});

  final QuestaoQuiz questao;
  final String rotulo;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final q = questao;
    return Column(
      children: [
        if (q.textoBase != null) ...[
          AppCard(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('📄 ${q.textoBaseTitulo ?? 'Lê o texto'}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                childrenPadding: const EdgeInsets.only(right: 8, bottom: 12),
                children: [MathText(q.textoBase!, style: TextStyle(fontSize: 14, height: 1.55, color: AppColors.inkSoft))],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        QuestionCard(
          label: rotulo,
          text: q.enunciado,
          trailing: trailing,
          figure: q.imagens.isEmpty ? null : ImagensConteudo(q.imagens),
        ),
      ],
    );
  }
}

/// Telas 8 e 9 — Pergunta (modo praticar) com feedback depois de confirmar.
class PerguntaScreen extends ConsumerStatefulWidget {
  const PerguntaScreen({super.key, required this.prova, required this.nivel});

  final String prova;
  final int nivel;

  @override
  ConsumerState<PerguntaScreen> createState() => _PerguntaScreenState();
}

class _PerguntaScreenState extends ConsumerState<PerguntaScreen> {
  SessaoQuiz? _s;
  String _titulo = '';
  int _notaMinima = 70;
  Timer? _relogio;
  int _segundos = 0;
  int _inicioQuestao = 0;
  bool _aGravar = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final conteudo = ref.read(conteudoRepoProvider);
    final questoes = await conteudo.questoes(widget.prova, nivel: widget.nivel);
    final prova = await conteudo.prova(widget.prova);
    final detalhe = await ref.read(detalheProvaProvider(widget.prova).future);
    if (!mounted) return;
    setState(() {
      _s = SessaoQuiz(questoes: questoes, modo: ModoQuiz.praticar);
      _titulo = '${prova?.disciplinaNome ?? widget.prova} · Nível ${widget.nivel}';
      _notaMinima = detalhe?.niveis.where((n) => n.numero == widget.nivel).firstOrNull?.notaMinima ?? 70;
    });
    _relogio = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _segundos++));
  }

  @override
  void dispose() {
    _relogio?.cancel();
    super.dispose();
  }

  void _dica() {
    final s = _s!;
    s.usarDica();
    setState(() {});
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('💡 Dica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 10),
            MathText(s.questaoActual.questao.dica!, style: TextStyle(fontSize: 15, color: AppColors.inkSoft, height: 1.5)),
            const SizedBox(height: 8),
            const Text('Usar a dica não tira pontos.', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }

  void _marcarTempo() {
    final r = _s!.questaoActual;
    r.tempoSeg += _segundos - _inicioQuestao;
    _inicioQuestao = _segundos;
  }

  void _confirmar() => setState(() {
        _marcarTempo();
        _s!.confirmar();
      });

  void _verResposta() => setState(() {
        _marcarTempo();
        _s!.verResposta();
      });

  Future<void> _seguinte() async {
    final s = _s!;
    if (s.seguinte()) {
      setState(() {});
      return;
    }
    if (_aGravar) return;
    _aGravar = true;
    _relogio?.cancel();
    final id = await ref
        .read(utilizadorRepoProvider)
        .gravarTentativa(s, prova: widget.prova, nivel: widget.nivel, notaMinima: _notaMinima);
    ref.refrescar();
    if (mounted) context.pushReplacement(Routes.resultado(id));
  }

  Future<void> _sair() async {
    final sair = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair do nível?', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('O progresso desta tentativa perde-se.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Continuar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sair', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (sair == true && mounted) context.pop();
  }

  OptionState _estado(RespostaQuiz r, int k) {
    if (!r.confirmada) return k == r.escolhida ? OptionState.selected : OptionState.normal;
    if (k == r.indiceCorrecto) return OptionState.correct;
    if (k == r.escolhida) return OptionState.wrong;
    return OptionState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    if (s == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (s.total == 0) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Ainda não há perguntas neste nível.'))),
      );
    }
    final r = s.questaoActual;
    final q = r.questao;
    final vf = q.verdadeiroFalso;
    final correcta = r.ordem[r.indiceCorrecto];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _sair();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
                child: Row(
                  children: [
                    HeaderIconButton(icon: Icons.close, onPressed: _sair),
                    Expanded(
                      child: Text(_titulo,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    ),
                    Text('⏱ ${relogio(_segundos)}',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SegmentedProgressBar(total: s.total, done: s.actual + (r.confirmada ? 1 : 0), height: 5),
                    const SizedBox(height: 4),
                    Text('${s.actual + 1} / ${s.total}', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  key: ValueKey(q.codigo),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  children: [
                    EnunciadoQuestao(
                      questao: q,
                      rotulo: 'Questão ${s.actual + 1} · ${vf ? 'Verdadeiro ou falso' : (q.temaNome ?? 'Escolha múltipla')}',
                      trailing: q.ano == null ? null : Text('Exame ${q.ano}', style: const TextStyle(color: Color(0xBBFFFFFF), fontSize: 11)),
                    ),
                    const SizedBox(height: 16),
                    if (vf)
                      Row(
                        children: [
                          for (var k = 0; k < r.ordem.length; k++) ...[
                            if (k == 1) const SizedBox(width: 12),
                            Expanded(
                              child: OptionTile(
                                letter: r.ordem[k].letra,
                                text: r.ordem[k].texto ?? '',
                                state: _estado(r, k),
                                onTap: r.confirmada ? null : () => setState(() => s.escolher(k)),
                              ),
                            ),
                          ],
                        ],
                      )
                    else
                      for (var k = 0; k < r.ordem.length; k++)
                        // Depois de confirmar, só mostra a certa e a escolhida.
                        if (!r.confirmada || k == r.indiceCorrecto || k == r.escolhida)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: OptionTile(
                              letter: letrasPosicao[k],
                              text: r.ordem[k].texto ?? '',
                              imagem: r.ordem[k].imagem,
                              state: _estado(r, k),
                              onTap: r.confirmada ? null : () => setState(() => s.escolher(k)),
                            ),
                          ),
                  ],
                ),
              ),
              if (r.confirmada)
                BottomSheetFeedback(
                  correct: r.contaComoCerta,
                  correctAnswer: correcta.texto ?? (correcta.imagem != null ? 'a figura assinalada' : ''),
                  explanation: r.viuResposta ? '${q.explicacao}\n\n👁 Viste a resposta: esta pergunta não conta para a nota.' : q.explicacao,
                  onNext: _seguinte,
                )
              else
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          child: Opacity(
                            opacity: q.dica == null ? 0.4 : 1,
                            child: SecondaryButton(
                              label: '💡 Dica',
                              height: 48,
                              background: AppColors.accentLight,
                              foreground: AppColors.ink,
                              onPressed: q.dica == null ? null : _dica,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: SecondaryButton(label: '👁 Ver resposta', height: 48, onPressed: _verResposta)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Opacity(
                            opacity: r.escolhida == null ? 0.5 : 1,
                            child: SecondaryButton(
                              label: 'Confirmar',
                              height: 48,
                              background: AppColors.primary,
                              foreground: Colors.white,
                              onPressed: r.escolhida == null ? null : _confirmar,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
