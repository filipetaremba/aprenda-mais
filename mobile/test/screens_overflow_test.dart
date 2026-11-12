import 'package:aprova_mais/app/routes.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ajuda_telas.dart';

/// Todas as telas com dados reais de teste cabem num ecrã pequeno (360×640), no tema claro e escuro.
void main() {
  final rotas = <String>[
    Routes.boasVindas,
    '${Routes.nome}?editar=1',
    '${Routes.objectivos}?editar=1',
    Routes.inicio,
    Routes.inicioTab(1),
    Routes.inicioTab(2),
    Routes.inicioTab(3),
    Routes.prova('TST-MAT'),
    Routes.nivel('TST-MAT', 1),
    Routes.quiz('TST-MAT', 1),
    Routes.lojaDe('TST-MAT'),
    Routes.lojaDe('TST-MAT', tipo: 'simulados'),
    Routes.activar,
    '${Routes.activar}?restaurar=1',
    Routes.sincronizar,
    Routes.concluido,
  ];

  for (final escuro in [false, true]) {
    for (final rota in rotas) {
      testWidgets('$rota cabe em 360×640${escuro ? ' (escuro)' : ''}', (tester) async {
        final a = await prepararAmbiente(tester);
        await abrir(tester, a, rota, escuro: escuro);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
