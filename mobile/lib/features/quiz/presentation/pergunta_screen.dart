import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Pergunta fictícia (estática) até existir a base de conteúdo.
class _Q {
  const _Q(this.numero, this.tema, this.texto, this.figura, this.alts, this.certa,
      this.dica, this.explicacao);

  final int numero;
  final String tema;
  final String texto;
  final Widget? figura;
  final List<String> alts;
  final int certa;
  final String? dica;
  final String explicacao;
}

const _perguntas = [
  _Q(
    7,
    'Geometria',
    r'No triângulo rectângulo da figura, qual é o comprimento da hipotenusa $x$?',
    TriangleFigure(),
    ['10', '12', '14', '9,6'],
    0,
    r'Lembra-te do Teorema de Pitágoras: $a^2 + b^2 = c^2$.',
    r'Pelo Teorema de Pitágoras, $x^2 = 6^2 + 8^2 = 100$, logo $x = 10$.',
  ),
  _Q(
    8,
    'Funções',
    r'O gráfico representa a função $f$. Quais são os seus zeros?',
    ParabolaFigure(),
    ['x = −1 e x = 3', 'x = 1 e x = 3', 'x = 0 e x = 3', 'x = −3 e x = 1'],
    0,
    'Os zeros são os pontos onde o gráfico corta o eixo dos x.',
    'Os zeros são os pontos onde o gráfico corta o eixo dos x (f(x) = 0). '
        'A parábola corta o eixo em −1 e 3. O valor 1 é o vértice, não um zero.',
  ),
  _Q(
    9,
    'Funções',
    r'A função $f(x) = -2x + 5$ é crescente em todo o seu domínio.',
    null,
    ['Verdadeiro', 'Falso'],
    1,
    null,
    'Numa função afim f(x) = ax + b, o sinal de a define o comportamento. '
        'Como a = −2 < 0, a função é decrescente.',
  ),
];

/// Tela 8 — Pergunta (com a tela 9, feedback, como folha inferior).
class PerguntaScreen extends StatefulWidget {
  const PerguntaScreen({super.key});

  @override
  State<PerguntaScreen> createState() => _PerguntaScreenState();
}

class _PerguntaScreenState extends State<PerguntaScreen> {
  int _i = 0;
  int? _sel;
  bool _confirmada = false;
  bool _viuResposta = false;

  _Q get _q => _perguntas[_i];

  void _confirmar() {
    if (_sel == null) return;
    setState(() => _confirmada = true);
  }

  void _verResposta() {
    setState(() {
      _viuResposta = true;
      _sel = _q.certa;
      _confirmada = true;
    });
  }

  void _dica() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡 Dica',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 10),
            MathText(_q.dica!, style: const TextStyle(fontSize: 15, color: AppColors.inkSoft, height: 1.5)),
          ],
        ),
      ),
    );
  }

  void _seguinte() {
    if (_i == _perguntas.length - 1) {
      Navigator.of(context).pushReplacementNamed(Routes.resultado);
      return;
    }
    setState(() {
      _i++;
      _sel = null;
      _confirmada = false;
      _viuResposta = false;
    });
  }

  OptionState _estado(int k) {
    if (!_confirmada) return k == _sel ? OptionState.selected : OptionState.normal;
    if (k == _q.certa) return OptionState.correct;
    if (k == _sel) return OptionState.wrong;
    return OptionState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final vf = _q.alts.length == 2;
    final letras = ['A', 'B', 'C', 'D'];
    final certa = _sel == _q.certa && !_viuResposta;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  const HeaderIconButton(icon: Icons.close),
                  const Expanded(
                    child: Text('Matemática · Nível 4',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                  Text('⏱ 12:3${5 + _i}',
                      style: const TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SegmentedProgressBar(total: 10, done: 6 + _i, height: 5),
                  const SizedBox(height: 4),
                  Text('${_q.numero} / 20',
                      style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: [
                  QuestionCard(
                    label: 'Questão ${_q.numero} · ${vf ? 'Verdadeiro ou falso' : _q.tema}',
                    text: _q.texto,
                    figure: _q.figura,
                  ),
                  const SizedBox(height: 16),
                  if (vf)
                    Row(
                      children: [
                        for (var k = 0; k < 2; k++) ...[
                          if (k == 1) const SizedBox(width: 12),
                          Expanded(
                            child: OptionTile(
                              letter: k == 0 ? 'V' : 'F',
                              text: _q.alts[k],
                              state: _estado(k),
                              onTap: _confirmada ? null : () => setState(() => _sel = k),
                            ),
                          ),
                        ],
                      ],
                    )
                  else
                    for (var k = 0; k < _q.alts.length; k++)
                      // Depois de confirmar, só mostra a certa e a escolhida.
                      if (!_confirmada || k == _q.certa || k == _sel)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: OptionTile(
                            letter: letras[k],
                            text: _q.alts[k],
                            state: _estado(k),
                            onTap: _confirmada ? null : () => setState(() => _sel = k),
                          ),
                        ),
                ],
              ),
            ),
            if (_confirmada)
              BottomSheetFeedback(
                correct: certa,
                correctAnswer: _q.alts[_q.certa],
                explanation: _viuResposta
                    ? '${_q.explicacao}\n\n👁 Viste a resposta: esta pergunta não conta para a nota.'
                    : _q.explicacao,
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
                          opacity: _q.dica == null ? 0.4 : 1,
                          child: SecondaryButton(
                            label: '💡 Dica',
                            height: 48,
                            background: AppColors.accentLight,
                            foreground: AppColors.ink,
                            onPressed: _q.dica == null ? null : _dica,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SecondaryButton(
                          label: '👁 Ver resposta',
                          height: 48,
                          onPressed: _verResposta,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Opacity(
                          opacity: _sel == null ? 0.5 : 1,
                          child: SecondaryButton(
                            label: 'Confirmar',
                            height: 48,
                            background: AppColors.primary,
                            foreground: Colors.white,
                            onPressed: _confirmar,
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
    );
  }
}
