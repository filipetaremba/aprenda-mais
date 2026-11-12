import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'app/router.dart';
import 'app/theme/app_colors.dart';
import 'core/widgets/conteudo.dart';
import 'data/content/content_db.dart';
import 'data/repositorios.dart';
import 'data/user/user_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final content = ContentDb.abrir();
  final user = UserDb.abrir();
  final suporte = await getApplicationSupportDirectory();
  final pasta = Directory(p.join(suporte.path, 'conteudo'));
  ImagemConteudo.pastaDescarregada = p.join(pasta.path, 'imagens');
  AppColors.escuro = await UtilizadorRepo(user).temaEscuro();

  runApp(ProviderScope(
    overrides: [
      contentDbProvider.overrideWithValue(content),
      userDbProvider.overrideWithValue(user),
      pastaConteudoProvider.overrideWithValue(pasta),
    ],
    child: AprovaApp(router: criarRouter()),
  ));
}
