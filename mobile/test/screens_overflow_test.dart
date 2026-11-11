import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aprova_mais/app/app.dart';
import 'package:aprova_mais/app/routes.dart';

/// Abre cada tela num ecrã pequeno (360×640) e falha se algo transbordar.
void main() {
  const rotas = [
    Routes.splash,
    Routes.boasVindas,
    Routes.nome,
    Routes.objectivos,
    Routes.inicio,
    Routes.niveis,
    Routes.nivelDetalhe,
    Routes.quiz,
    Routes.resultado,
    Routes.revisao,
    Routes.simulado,
    Routes.desbloquear,
    Routes.pagamento,
    Routes.aguardar,
    Routes.concluido,
    Routes.devTelas,
    Routes.devWidgets,
  ];

  for (final rota in rotas) {
    testWidgets('Tela $rota cabe em 360×640', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(const AprovaApp());
      final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
      nav.pushNamed(rota);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      // Limpa timers (splash/aguardar) antes de terminar.
      await tester.pumpWidget(MaterialApp(navigatorKey: key, home: const SizedBox()));
      await tester.pump(const Duration(seconds: 10));
    });
  }
}
