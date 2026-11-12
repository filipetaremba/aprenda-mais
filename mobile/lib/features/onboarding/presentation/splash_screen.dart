import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/importador.dart';

/// Caminho do conteúdo embutido no APK (gerado por `npm run exportar:app` no backend).
const conteudoEmbutido = 'assets/content/conteudo.json';

/// Importa o conteúdo embutido se a app trouxer uma versão mais recente do que a instalada.
Future<void> prepararConteudo(WidgetRef ref) async {
  // sem cache: só se lê uma vez e são ~600 KB
  final texto = await rootBundle.loadString(conteudoEmbutido, cache: false);
  await ImportadorConteudo(ref.read(contentDbProvider)).importarConteudoApp(jsonDecode(texto) as Map<String, dynamic>);
}

/// Tela 1 — Splash: prepara o conteúdo (offline) e decide para onde ir.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _erro;

  @override
  void initState() {
    super.initState();
    _arrancar();
  }

  Future<void> _arrancar() async {
    try {
      final minimo = Future<void>.delayed(const Duration(milliseconds: 1200));
      await prepararConteudo(ref);
      final user = ref.read(utilizadorRepoProvider);
      final perfil = await user.perfil();
      final objectivos = await user.objectivos();
      await minimo;
      if (!mounted) return;
      ref.refrescar();
      context.go(perfil == null ? Routes.boasVindas : objectivos.isEmpty ? Routes.objectivos : Routes.inicio);
    } catch (e) {
      if (mounted) {
        setState(() => _erro = 'Não foi possível preparar as perguntas.\n$e');
      }
    }
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _erro ?? 'A preparar as perguntas…',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
                ),
              ),
              const Spacer(flex: 4),
              const Text(
                'Funciona sem Internet · v1.0',
                style: TextStyle(color: Color(0x99FFFFFF), fontSize: 11),
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
