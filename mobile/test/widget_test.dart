import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aprova_mais/app/app.dart';
import 'package:aprova_mais/app/home_shell.dart';
import 'package:aprova_mais/features/loja/presentation/pagamento_screen.dart';

void main() {
  testWidgets('Splash mostra a marca e avança para as boas-vindas', (tester) async {
    await tester.pumpWidget(const AprovaApp());
    expect(find.text('Prepara-te para a admissão'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Saltar'), findsOneWidget);
  });

  testWidgets('Tabs do início em ecrã pequeno (360×640) sem transbordo', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HomeShell()));
    expect(find.text('Vamos estudar?'), findsOneWidget);
    for (final tab in ['Simulados', 'Progresso', 'Perfil']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
    }
    expect(find.text('Modo escuro'), findsOneWidget);
  });

  test('Detecção da carteira pelo prefixo', () {
    expect(carteiraDoNumero('84 123 4567'), Carteira.mpesa);
    expect(carteiraDoNumero('85'), Carteira.mpesa);
    expect(carteiraDoNumero('86 000 0000'), Carteira.emola);
    expect(carteiraDoNumero('87'), Carteira.emola);
    expect(carteiraDoNumero('82 123 4567'), isNull);
    expect(carteiraDoNumero('8'), isNull);
  });
}
