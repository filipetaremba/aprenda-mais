import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 13 — Simulado em curso.
class SimuladoCursoScreen extends StatefulWidget {
  const SimuladoCursoScreen({super.key});

  @override
  State<SimuladoCursoScreen> createState() => _SimuladoCursoScreenState();
}

class _SimuladoCursoScreenState extends State<SimuladoCursoScreen> {
  int _actual = 18;
  int? _sel = 0;
  final Set<int> _marcadas = {16};
  final Set<int> _respondidas = {for (var i = 1; i <= 17; i++) if (i != 16) i, 16};

  Future<void> _terminar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Terminar o simulado?',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        content: Text(
          'Respondeste a ${_respondidas.length} de 40 perguntas. '
          'As que ficaram em branco contam como erradas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Continuar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Terminar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    const alts = ['2 A', '3 A', '6 A', '1,5 A'];
    const letras = ['A', 'B', 'C', 'D'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Prova de Física',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('⏱ 01:12:45',
                        style: TextStyle(
                            color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 40,
                controller: ScrollController(initialScrollOffset: 13 * 40.0),
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (_, i) => _numero(i + 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Text.rich(
                TextSpan(children: [
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.square, size: 10, color: AppColors.primary),
                  ),
                  const TextSpan(text: ' respondida · '),
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.square, size: 10, color: AppColors.accent),
                  ),
                  TextSpan(text: ' marcada · ${_respondidas.length} de 40 respondidas'),
                ]),
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                children: [
                  QuestionCard(
                    label: 'Questão $_actual · Electricidade',
                    text: 'No circuito da figura, qual é a intensidade da corrente eléctrica?',
                    figure: const CircuitFigure(),
                    trailing: GestureDetector(
                      onTap: () => setState(() => _marcadas.contains(_actual)
                          ? _marcadas.remove(_actual)
                          : _marcadas.add(_actual)),
                      child: Text(
                        _marcadas.contains(_actual) ? '🚩 Marcada' : '🚩 Marcar',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.9,
                    children: [
                      for (var k = 0; k < 4; k++)
                        OptionTile(
                          compact: true,
                          letter: letras[k],
                          text: alts[k],
                          state: _sel == k ? OptionState.selected : OptionState.normal,
                          onTap: () => setState(() {
                            _sel = k;
                            _respondidas.add(_actual);
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Sem dicas nem respostas durante o simulado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.muted)),
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
                      background: const Color(0xFFF1F5F9),
                      foreground: AppColors.ink,
                      onPressed: () => setState(() {
                        if (_actual > 1) _actual--;
                        _sel = null;
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SecondaryButton(
                      label: 'Seguinte',
                      background: AppColors.primary,
                      foreground: Colors.white,
                      onPressed: () => setState(() {
                        if (_actual < 40) _actual++;
                        _sel = null;
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 104,
                    child: SecondaryButton(
                      label: 'Terminar',
                      background: AppColors.errorLight,
                      foreground: AppColors.error,
                      onPressed: _terminar,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numero(int n) {
    final actual = n == _actual;
    final marcada = _marcadas.contains(n);
    final resp = _respondidas.contains(n);
    final (bg, fg) = marcada
        ? (AppColors.accent, AppColors.ink)
        : resp
            ? (AppColors.primary, Colors.white)
            : actual
                ? (Colors.white, AppColors.primary)
                : (const Color(0xFFF1F5F9), AppColors.muted);
    return GestureDetector(
      onTap: () => setState(() {
        _actual = n;
        _sel = null;
      }),
      child: Container(
        width: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: actual ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        child: Text('$n',
            style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }
}
