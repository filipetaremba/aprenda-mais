import 'package:flutter/material.dart';

import '../features/dev/dev_screens_page.dart';
import '../features/dev/dev_widgets_page.dart';
import '../features/loja/presentation/aguardar_screen.dart';
import '../features/loja/presentation/concluido_screen.dart';
import '../features/loja/presentation/desbloquear_screen.dart';
import '../features/loja/presentation/pagamento_screen.dart';
import '../features/niveis/presentation/nivel_detalhe_screen.dart';
import '../features/niveis/presentation/niveis_screen.dart';
import '../features/objectivos/presentation/objectivos_screen.dart';
import '../features/onboarding/presentation/boas_vindas_screen.dart';
import '../features/onboarding/presentation/nome_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/quiz/presentation/pergunta_screen.dart';
import '../features/quiz/presentation/resultado_screen.dart';
import '../features/quiz/presentation/revisao_screen.dart';
import '../features/simulados/presentation/simulado_curso_screen.dart';
import 'home_shell.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class AprovaApp extends StatelessWidget {
  const AprovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aprova+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (_) => const SplashScreen(),
        Routes.boasVindas: (_) => const BoasVindasScreen(),
        Routes.nome: (_) => const NomeScreen(),
        Routes.objectivos: (_) => const ObjectivosScreen(),
        Routes.inicio: (_) => const HomeShell(),
        Routes.niveis: (_) => const NiveisScreen(),
        Routes.nivelDetalhe: (_) => const NivelDetalheScreen(),
        Routes.quiz: (_) => const PerguntaScreen(),
        Routes.resultado: (_) => const ResultadoScreen(),
        Routes.revisao: (_) => const RevisaoScreen(),
        Routes.simulado: (_) => const SimuladoCursoScreen(),
        Routes.desbloquear: (_) => const DesbloquearScreen(),
        Routes.pagamento: (_) => const PagamentoScreen(),
        Routes.aguardar: (_) => const AguardarScreen(),
        Routes.concluido: (_) => const ConcluidoScreen(),
        Routes.devTelas: (_) => const DevScreensPage(),
        Routes.devWidgets: (_) => const DevWidgetsPage(),
      },
    );
  }
}
