import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/dev/dev_screens_page.dart';
import '../features/dev/dev_widgets_page.dart';
import '../features/loja/presentation/activar_screen.dart';
import '../features/loja/presentation/aguardar_screen.dart';
import '../features/loja/presentation/concluido_screen.dart';
import '../features/loja/presentation/desbloquear_screen.dart';
import '../features/loja/presentation/pagamento_screen.dart';
import '../features/loja/presentation/sincronizar_screen.dart';
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
import 'config.dart';
import 'home_shell.dart';
import 'routes.dart';

GoRouter criarRouter({String inicial = Routes.splash}) => GoRouter(
      initialLocation: inicial,
      redirect: (_, estado) {
        // Telas 17–18 (pagamento automático) escondidas nesta fase
        final pagamento = estado.matchedLocation == Routes.pagamento || estado.matchedLocation == Routes.aguardar;
        if (pagamento && !AppConfig.pagamentoAutomatico) return Routes.loja;
        if (estado.matchedLocation.startsWith('/dev') && !kDebugMode) return Routes.inicio;
        return null;
      },
      routes: [
        GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
        GoRoute(path: Routes.boasVindas, builder: (_, _) => const BoasVindasScreen()),
        GoRoute(path: Routes.nome, builder: (_, s) => NomeScreen(editar: s.uri.queryParameters['editar'] == '1')),
        GoRoute(path: Routes.objectivos, builder: (_, s) => ObjectivosScreen(editar: s.uri.queryParameters['editar'] == '1')),
        GoRoute(path: Routes.inicio, builder: (_, s) => HomeShell(initialTab: int.tryParse(s.uri.queryParameters['tab'] ?? '') ?? 0)),
        GoRoute(path: '/prova/:prova', builder: (_, s) => NiveisScreen(prova: s.pathParameters['prova']!)),
        GoRoute(
          path: '/prova/:prova/nivel/:n',
          builder: (_, s) => NivelDetalheScreen(prova: s.pathParameters['prova']!, nivel: int.parse(s.pathParameters['n']!)),
        ),
        GoRoute(
          path: '/quiz/:prova/:n',
          builder: (_, s) => PerguntaScreen(prova: s.pathParameters['prova']!, nivel: int.parse(s.pathParameters['n']!)),
        ),
        GoRoute(path: '/simulado/:codigo', builder: (_, s) => SimuladoCursoScreen(codigo: s.pathParameters['codigo']!)),
        GoRoute(path: '/resultado/:id', builder: (_, s) => ResultadoScreen(tentativa: s.pathParameters['id']!)),
        GoRoute(path: '/revisao/:id', builder: (_, s) => RevisaoScreen(tentativa: s.pathParameters['id']!)),
        GoRoute(
          path: Routes.loja,
          builder: (_, s) => DesbloquearScreen(prova: s.uri.queryParameters['prova'], tipo: s.uri.queryParameters['tipo'] ?? 'niveis'),
        ),
        GoRoute(path: Routes.concluido, builder: (_, _) => const ConcluidoScreen()),
        GoRoute(path: Routes.pagamento, builder: (_, _) => const PagamentoScreen()),
        GoRoute(path: Routes.aguardar, builder: (_, _) => const AguardarScreen()),
        GoRoute(
          path: Routes.activar,
          builder: (_, s) => ActivarScreen(prova: s.uri.queryParameters['prova'], restaurar: s.uri.queryParameters['restaurar'] == '1'),
        ),
        GoRoute(path: Routes.sincronizar, builder: (_, s) => SincronizarScreen(depoisDeActivar: s.uri.queryParameters['activacao'] == '1')),
        GoRoute(path: Routes.devTelas, builder: (_, _) => const DevScreensPage()),
        GoRoute(path: Routes.devWidgets, builder: (_, _) => const DevWidgetsPage()),
      ],
    );
