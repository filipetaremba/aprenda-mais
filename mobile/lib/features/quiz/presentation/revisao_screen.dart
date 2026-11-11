import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

enum _Res { certa, errada, ajuda }

/// Tela 11 — Revisão (grelha + detalhe).
class RevisaoScreen extends StatefulWidget {
  const RevisaoScreen({super.key});

  @override
  State<RevisaoScreen> createState() => _RevisaoScreenState();
}

class _RevisaoScreenState extends State<RevisaoScreen> {
  int _filtro = 0; // 0 todas, 1 erradas, 2 com ajuda
  int _actual = 12;

  static _Res _res(int n) => switch (n) {
        5 || 12 || 17 => _Res.errada,
        9 => _Res.ajuda,
        _ => _Res.certa,
      };

  List<int> get _visiveis => [
        for (var n = 1; n <= 20; n++)
          if (_filtro == 0 ||
              (_filtro == 1 && _res(n) == _Res.errada) ||
              (_filtro == 2 && _res(n) == _Res.ajuda))
            n,
      ];

  void _mover(int d) {
    final v = _visiveis;
    final i = v.indexOf(_actual);
    final j = (i + d).clamp(0, v.length - 1);
    setState(() => _actual = v[j]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 48, 0),
              child: Row(
                children: const [
                  HeaderIconButton(icon: Icons.close),
                  Expanded(
                    child: Text('Revisão · Nível 4',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ChipFilter(
                    label: 'Todas (20)',
                    selected: _filtro == 0,
                    onTap: () => setState(() => _filtro = 0),
                  ),
                  const SizedBox(width: 8),
                  ChipFilter(
                    label: 'Erradas (3)',
                    selected: _filtro == 1,
                    color: AppColors.error,
                    background: AppColors.errorLight,
                    onTap: () => setState(() {
                      _filtro = 1;
                      _actual = 5;
                    }),
                  ),
                  const SizedBox(width: 8),
                  ChipFilter(
                    label: 'Com ajuda (1)',
                    selected: _filtro == 2,
                    color: const Color(0xFFD97706),
                    background: const Color(0xFFFFFBEB),
                    onTap: () => setState(() {
                      _filtro = 2;
                      _actual = 9;
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                children: [
                  GridView.count(
                    crossAxisCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.15,
                    children: [for (final n in _visiveis) _cell(n)],
                  ),
                  const SizedBox(height: 16),
                  _detalhe(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: '‹ Anterior',
                      background: const Color(0xFFF1F5F9),
                      foreground: AppColors.ink,
                      onPressed: () => _mover(-1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SecondaryButton(
                      label: 'Seguinte ›',
                      background: AppColors.primary,
                      foreground: Colors.white,
                      onPressed: () => _mover(1),
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

  Widget _cell(int n) {
    final r = _res(n);
    final (fg, bg, borda) = switch (r) {
      _Res.certa => (AppColors.success, AppColors.successLight, Colors.transparent),
      _Res.errada => (AppColors.error, AppColors.errorLight, AppColors.error),
      _Res.ajuda => (const Color(0xFFD97706), const Color(0xFFFFFBEB), AppColors.accent),
    };
    final sel = n == _actual;
    return GestureDetector(
      onTap: () => setState(() => _actual = n),
      child: Container(
        padding: EdgeInsets.all(sel ? 2 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: sel ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borda, width: 2),
          ),
          child: Text('$n',
              style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _detalhe() {
    final r = _res(_actual);
    final errada = r == _Res.errada;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Questão $_actual · Verdadeiro ou falso',
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              const Text('Exame UEM 2021',
                  style: TextStyle(color: AppColors.muted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          const MathText(r'A função $f(x) = -2x + 5$ é crescente em todo o seu domínio.',
              style: TextStyle(fontSize: 15, color: AppColors.ink, height: 1.45)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _VfBox(
                  label: errada ? 'Verdadeiro · tua' : 'Verdadeiro',
                  state: errada ? OptionState.wrong : OptionState.normal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VfBox(
                  label: errada ? 'Falso ✓' : (r == _Res.ajuda ? 'Falso ✓ · 👁' : 'Falso ✓ · tua'),
                  state: OptionState.correct,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Explicação: ', style: TextStyle(fontWeight: FontWeight.w700)),
              TextSpan(text: 'numa função afim f(x) = ax + b, o sinal de '),
              TextSpan(text: 'a', style: TextStyle(fontStyle: FontStyle.italic)),
              TextSpan(text: ' define o comportamento. Como a = −2 < 0, a função é '),
              TextSpan(text: 'decrescente', style: TextStyle(fontWeight: FontWeight.w700)),
              TextSpan(text: '.'),
            ]),
            style: TextStyle(fontSize: 13, color: AppColors.inkSoft, height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _VfBox extends StatelessWidget {
  const _VfBox({required this.label, required this.state});

  final String label;
  final OptionState state;

  @override
  Widget build(BuildContext context) {
    final (fg, bg, borda) = switch (state) {
      OptionState.correct => (AppColors.success, AppColors.successLight, AppColors.success),
      OptionState.wrong => (AppColors.error, AppColors.errorLight, AppColors.error),
      _ => (AppColors.inkSoft, Colors.white, AppColors.border),
    };
    return Container(
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borda, width: 2),
      ),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(label,
              style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 14)),
        ),
      ),
    );
  }
}
