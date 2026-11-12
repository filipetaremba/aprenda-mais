import 'package:aprova_mais/app/routes.dart';
import 'package:aprova_mais/app/theme/app_colors.dart';
import 'package:aprova_mais/core/widgets/widgets.dart';
import 'package:aprova_mais/data/repositorios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ajuda_telas.dart';

void main() {
  testWidgets('quiz do nível 1: responder certo → resultado 100% e nível 2 desbloqueado', (tester) async {
    final a = await prepararAmbiente(tester);
    await abrir(tester, a, Routes.quiz('TST-MAT', 1));
    for (var i = 0; i < 2; i++) {
      final vf = find.text('Verdadeiro');
      await tocar(tester, vf.evaluate().isNotEmpty ? vf : find.widgetWithText(OptionTile, '2'));
      await tocar(tester, find.text('Confirmar'));
      expect(find.text('Resposta certa!'), findsOneWidget);
      await tocar(tester, find.text('Seguinte'));
    }
    await esperarPor(tester, find.text('100%'));
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('🎉 Nível 2 desbloqueado!'), findsOneWidget);
    final hist = await tester.runAsync(() => UtilizadorRepo(a.user).historico());
    expect(hist!.single.percentagem, 100);
  });

  testWidgets('ver resposta: mostra a correcta e a questão não conta', (tester) async {
    final a = await prepararAmbiente(tester);
    await abrir(tester, a, Routes.quiz('TST-MAT', 1));
    await tocar(tester, find.text('👁 Ver resposta'));
    expect(find.text('Resposta errada'), findsOneWidget);
    expect(find.textContaining('não conta para a nota'), findsOneWidget);
  });

  testWidgets('nível 3 sem licença: cadeado e paywall com preços e instruções de pagamento', (tester) async {
    final a = await prepararAmbiente(tester);
    await abrir(tester, a, Routes.prova('TST-MAT'));
    // níveis 1–2 ainda não passados: o 3 está bloqueado pelo progresso; o aviso mostra que é pago
    expect(find.textContaining('Níveis 1–2 grátis'), findsOneWidget);

    await abrir(tester, a, Routes.lojaDe('TST-MAT'));
    expect(find.text('59 MT'), findsOneWidget);
    expect(find.text('Como pagar'), findsOneWidget);
    expect(find.text('🔑 Tenho um código de activação'), findsOneWidget);
    // contactos vindos do /catalogo (servidor falso)
    expect(find.textContaining('84 111 2222'), findsOneWidget);
  });

  testWidgets('activar código: máscara, activação, sincronização e "Activação concluída"', (tester) async {
    final a = await prepararAmbiente(tester);
    await abrir(tester, a, Routes.activar);
    await tester.enterText(find.byKey(const Key('campo-codigo')), 'apv7k9qm2xz');
    await tester.pump();
    expect(find.text('APV-7K9Q-M2XZ'), findsOneWidget);

    await tocar(tester, find.text('Activar'));
    await esperarPor(tester, find.text('Activação concluída!'));
    expect(find.text('Activação concluída!'), findsOneWidget);
    await esperarPor(tester, find.text('🔓 Níveis 3–10'));
    expect(find.text('🔓 Níveis 3–10'), findsOneWidget);

    final n = await tester.runAsync(() => ConteudoRepo(a.content).questoesPorNivel('TST-MAT'));
    expect(n![3], 2, reason: 'o pacote foi importado');
  });

  testWidgets('activar código: erros claros (inválido e sem Internet)', (tester) async {
    final a = await prepararAmbiente(tester);
    await abrir(tester, a, Routes.activar);
    await tester.enterText(find.byKey(const Key('campo-codigo')), 'APV-2222-2222');
    await tocar(tester, find.text('Activar'));
    await esperarPor(tester, find.textContaining('Código inválido'));
    expect(find.textContaining('Código inválido'), findsOneWidget);

    a.servidor.semInternet = true;
    await tester.enterText(find.byKey(const Key('campo-codigo')), 'APV-7K9Q-M2XZ');
    await tocar(tester, find.text('Activar'));
    await esperarPor(tester, find.textContaining('Sem Internet'));
    expect(find.textContaining('Sem Internet'), findsOneWidget);
  });

  testWidgets('perfil: o modo escuro aplica-se e fica guardado', (tester) async {
    final a = await prepararAmbiente(tester);
    await abrir(tester, a, Routes.inicioTab(3));
    await tocar(tester, find.byType(AppSwitch).first);
    expect(AppColors.escuro, isTrue);
    final guardado = await tester.runAsync(() => UtilizadorRepo(a.user).temaEscuro());
    expect(guardado, isTrue);
  });
}
