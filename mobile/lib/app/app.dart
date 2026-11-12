import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

class AprovaApp extends ConsumerWidget {
  const AprovaApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final escuro = ref.watch(temaEscuroProvider);
    AppColors.escuro = escuro;
    return MaterialApp.router(
      title: 'Aprova+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.actual(),
      routerConfig: router,
      // As cores vêm de AppColors (getters): ao mudar de tema, as páginas são recriadas.
      // A navegação mantém-se porque o estado está no GoRouter.
      builder: (context, child) => KeyedSubtree(key: ValueKey(escuro), child: child!),
    );
  }
}
