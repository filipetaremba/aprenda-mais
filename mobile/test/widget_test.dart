import 'package:aprova_mais/app/routes.dart';
import 'package:aprova_mais/data/repositorios.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ajuda_telas.dart';

void main() {
  testWidgets('primeira abertura: o splash importa o conteúdo embutido e vai para as boas-vindas', (tester) async {
    final a = await prepararAmbiente(tester, semPerfil: true);
    await abrir(tester, a, Routes.splash);
    await esperarPor(tester, find.text('Estuda sem Internet'));
    expect(find.text('Estuda sem Internet'), findsOneWidget);
    // o conteúdo real do APK ficou na base
    final ofertas = await tester.runAsync(() => ConteudoRepo(a.content).ofertas());
    expect(ofertas!.length, greaterThan(100));
  });

  testWidgets('com perfil e objectivo, o splash vai directo para o início', (tester) async {
    final a = await prepararAmbiente(tester);
    await abrir(tester, a, Routes.splash);
    await esperarPor(tester, find.textContaining('Olá, Ana'));
    expect(find.textContaining('Olá, Ana'), findsOneWidget);
    expect(find.text('As tuas provas'), findsOneWidget);
  });
}
