import 'dart:io';

import 'package:aprova_mais/app/app.dart';
import 'package:aprova_mais/app/providers.dart';
import 'package:aprova_mais/app/router.dart';
import 'package:aprova_mais/app/theme/app_colors.dart';
import 'package:aprova_mais/data/api.dart';
import 'package:aprova_mais/data/content/content_db.dart';
import 'package:aprova_mais/data/importador.dart';
import 'package:aprova_mais/data/licencas.dart';
import 'package:aprova_mais/data/repositorios.dart';
import 'package:aprova_mais/data/user/user_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ajuda.dart';

class Ambiente {
  Ambiente(this.content, this.user, this.servidor, this.pasta);
  final ContentDb content;
  final UserDb user;
  final ServidorFalso servidor;
  final Directory pasta;
}

/// Bases em memória com o conteúdo de teste, perfil e um objectivo (salvo [semPerfil]).
Future<Ambiente> prepararAmbiente(WidgetTester tester, {bool semPerfil = false}) async {
  late Ambiente a;
  await tester.runAsync(() async {
    final content = contentEmMemoria();
    final user = userEmMemoria();
    await ImportadorConteudo(content).importarConteudoApp(conteudoApp());
    if (!semPerfil) {
      final u = UtilizadorRepo(user);
      await u.gravarPerfil(nome: 'Ana', avatar: '🦁');
      await u.definirObjectivos(['UNITST-ENG-INF']);
    }
    a = Ambiente(content, user, ServidorFalso(await ChavesTeste.gerar()), Directory.systemTemp.createTempSync('aprova-ui-'));
  });
  addTearDown(() => a.pasta.deleteSync(recursive: true));
  return a;
}

/// Monta a app na [rota], em ecrã pequeno (360×640), e espera que os dados carreguem.
Future<void> abrir(WidgetTester tester, Ambiente a, String rota, {bool escuro = false, Size tamanho = const Size(360, 640)}) async {
  tester.view.physicalSize = tamanho;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  AppColors.escuro = escuro;
  addTearDown(() => AppColors.escuro = false);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      contentDbProvider.overrideWithValue(a.content),
      userDbProvider.overrideWithValue(a.user),
      pastaConteudoProvider.overrideWithValue(a.pasta),
      apiProvider.overrideWithValue(ApiCliente(baseUrl: 'http://servidor', cliente: a.servidor.cliente)),
      verificadorProvider.overrideWithValue(VerificadorLicencas(a.servidor.chaves.publicaBase64)),
    ],
    child: AprovaApp(router: criarRouter(inicial: rota)),
  ));
  await assentar(tester);
}

/// Deixa correr o trabalho assíncrono real (SQLite) e reconstrói, várias vezes.
Future<void> assentar(WidgetTester tester, {int voltas = 15}) async {
  for (var i = 0; i < voltas; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 15)));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> tocar(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await assentar(tester);
}

/// Espera (com tempo real) até [f] aparecer, no máximo [limite].
Future<void> esperarPor(WidgetTester tester, Finder f, {Duration limite = const Duration(seconds: 30)}) async {
  final fim = DateTime.now().add(limite);
  while (f.evaluate().isEmpty && DateTime.now().isBefore(fim)) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump(const Duration(milliseconds: 100));
  }
}
