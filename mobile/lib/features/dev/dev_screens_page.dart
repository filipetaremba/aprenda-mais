import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

/// Página interna (só em debug) com atalhos para as telas que não precisam de parâmetros.
/// As restantes (níveis, quiz, resultado…) abrem-se a partir do Início com dados reais.
class DevScreensPage extends StatelessWidget {
  const DevScreensPage({super.key});

  static final _telas = <(String, String)>[
    ('Splash', Routes.splash),
    ('Boas-vindas', Routes.boasVindas),
    ('O teu nome', Routes.nome),
    ('Escolher objectivo', '${Routes.objectivos}?editar=1'),
    ('Início', Routes.inicio),
    ('Simulados', Routes.inicioTab(1)),
    ('Progresso', Routes.inicioTab(2)),
    ('Perfil', Routes.inicioTab(3)),
    ('Desbloquear', Routes.loja),
    ('Activar código', Routes.activar),
    ('Sincronizar', Routes.sincronizar),
    ('Activação concluída', Routes.concluido),
    ('Pagamento (flag)', Routes.pagamento),
    ('A aguardar confirmação (flag)', Routes.aguardar),
    ('Componentes', Routes.devWidgets),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Telas (dev)', style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _telas.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (nome, rota) = _telas[i];
          return AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            onTap: () => context.push(rota),
            child: Row(
              children: [
                EmojiBox('${i + 1}', size: 34, fontSize: 13),
                const SizedBox(width: 12),
                Expanded(child: Text(nome, style: TextStyle(fontSize: 14, color: AppColors.ink))),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          );
        },
      ),
    );
  }
}
