import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 18 — A aguardar confirmação (simula o PIN com um atraso).
class AguardarScreen extends StatefulWidget {
  const AguardarScreen({super.key});

  @override
  State<AguardarScreen> createState() => _AguardarScreenState();
}

class _AguardarScreenState extends State<AguardarScreen> {
  static const _expiracao = 120;
  int _restante = _expiracao;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  void _iniciar() {
    _timer?.cancel();
    _restante = _expiracao;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _restante--);
      // Mock: o "PIN" é confirmado ao fim de 6 segundos.
      if (_expiracao - _restante >= 6) {
        t.cancel();
        context.pushReplacement(Routes.concluido);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mm = (_restante ~/ 60).toString().padLeft(2, '0');
    final ss = (_restante % 60).toString().padLeft(2, '0');
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
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 160,
                        height: 160,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0xFFFBD5D5), Color(0xFFFEF1F1)],
                          ),
                        ),
                        child: Container(
                          width: 80,
                          height: 124,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.mpesa,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('M-Pesa',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(height: 4),
                                const Text('Pagar 99 MT\na Aprova+?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 7, color: AppColors.muted)),
                                const SizedBox(height: 6),
                                Text('● ● ● ○',
                                    style: TextStyle(fontSize: 8, color: AppColors.ink)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Confirma no teu telemóvel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Enviámos um pedido de pagamento M-Pesa para '),
                        TextSpan(
                            text: '84 123 4567',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, color: AppColors.ink)),
                        TextSpan(text: '. Introduz o teu PIN para concluir.'),
                      ]),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.muted, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          _Passo(_Estado.feito, 'Pedido enviado'),
                          SizedBox(height: 12),
                          _Passo(_Estado.actual, 'A aguardar o teu PIN…'),
                          SizedBox(height: 12),
                          _Passo(_Estado.pendente, 'Activar níveis'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(children: [
                        const TextSpan(text: 'O pedido expira em '),
                        TextSpan(
                            text: '$mm:$ss',
                            style: const TextStyle(
                                color: AppColors.error, fontWeight: FontWeight.w700)),
                      ]),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              SecondaryButton(
                label: 'Não recebi o pedido · Reenviar',
                onPressed: () => setState(_iniciar),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar pagamento',
                    style: TextStyle(color: AppColors.muted, fontSize: 13)),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Estado { feito, actual, pendente }

class _Passo extends StatelessWidget {
  const _Passo(this.estado, this.texto);

  final _Estado estado;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final icone = switch (estado) {
      _Estado.feito => Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        ),
      _Estado.actual => const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
        ),
      _Estado.pendente => Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 2),
          ),
        ),
    };
    return Row(
      children: [
        icone,
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 14,
              fontWeight: estado == _Estado.actual ? FontWeight.w700 : FontWeight.w400,
              color: estado == _Estado.pendente ? AppColors.muted : AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
