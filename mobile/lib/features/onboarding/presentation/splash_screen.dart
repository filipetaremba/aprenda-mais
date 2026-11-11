import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';

/// Tela 1 — Splash. Na fase de dados vai importar o seed se preciso.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.of(context).pushReplacementNamed(Routes.boasVindas);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 5),
              const AppLogo(),
              const SizedBox(height: 24),
              Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(text: 'Aprova'),
                    TextSpan(text: '+', style: TextStyle(color: AppColors.accent)),
                  ],
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Prepara-te para a admissão',
                style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 15),
              ),
              const Spacer(flex: 3),
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  color: Colors.white,
                  backgroundColor: Color(0x44FFFFFF),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'A preparar as perguntas…',
                style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
              ),
              const Spacer(flex: 4),
              GestureDetector(
                // Atalho interno para ver todas as telas.
                onLongPress: () => Navigator.of(context).pushNamed(Routes.devTelas),
                child: const Text(
                  'Funciona sem Internet · v1.0',
                  style: TextStyle(color: Color(0x99FFFFFF), fontSize: 11),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logótipo: capelo azul num quadrado branco com "+" amarelo.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 112});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1E50).withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.school_rounded, size: size * 0.55, color: AppColors.primary),
          Positioned(
            right: size * 0.22,
            top: size * 0.26,
            child: Container(
              width: size * 0.17,
              height: size * 0.17,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: size * 0.14),
            ),
          ),
        ],
      ),
    );
  }
}
