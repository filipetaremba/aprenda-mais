import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 19 — Compra concluída (recibo).
class ConcluidoScreen extends StatelessWidget {
  const ConcluidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 170,
                      child: Stack(
                        children: [
                          const Positioned.fill(child: Confetti()),
                          Center(
                            child: Container(
                              width: 112,
                              height: 112,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFDCFCE7),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 52),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Pagamento confirmado!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const Text('Todos os níveis estão desbloqueados. Bons estudos, Filipe!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: AppColors.muted)),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        children: [
                          _Item('📐', 'Matemática', '🔓 Níveis 3–10'),
                          SizedBox(height: 12),
                          _Item('⚛️', 'Física', '🔓 Níveis 3–10'),
                          SizedBox(height: 12),
                          _Item('🎯', 'Simulado completo', '🔓 Incluído'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFEFF2F7), width: 1.5),
                      ),
                      child: const Column(
                        children: [
                          _Recibo('Valor', '99 MT · M-Pesa'),
                          _Recibo('Referência', 'APV-27-8F3K2Q'),
                          _Recibo('Válido até', 'Fim da Admissão 2027'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                label: 'Começar Nível 3',
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.quiz,
                  (r) => r.settings.name == Routes.inicio || r.isFirst,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.emoji, this.nome, this.estado);

  final String emoji;
  final String nome;
  final String estado;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox.shrink(),
        EmojiBox(emoji, background: Colors.white, size: 40, fontSize: 18),
        const SizedBox(width: 12),
        Expanded(
            child: Text(nome, style: const TextStyle(fontSize: 15, color: AppColors.ink))),
        Text(estado,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
      ],
    );
  }
}

class _Recibo extends StatelessWidget {
  const _Recibo(this.k, this.v);

  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(k, style: const TextStyle(fontSize: 12, color: AppColors.muted))),
          Text(v,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
        ],
      ),
    );
  }
}
