import 'package:flutter/material.dart';

import '../../app/home_shell.dart';
import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

/// Página interna com atalhos para as 19 telas do design.
class DevScreensPage extends StatelessWidget {
  const DevScreensPage({super.key});

  static const _telas = <(int, String, String?)>[
    (1, 'Splash', Routes.splash),
    (2, 'Boas-vindas', Routes.boasVindas),
    (3, 'O teu nome', Routes.nome),
    (4, 'Escolher objectivo', Routes.objectivos),
    (5, 'Início', Routes.inicio),
    (6, 'Níveis da disciplina', Routes.niveis),
    (7, 'Detalhe do nível', Routes.nivelDetalhe),
    (8, 'Pergunta (+ 9 Feedback)', Routes.quiz),
    (10, 'Resultado', Routes.resultado),
    (11, 'Revisão', Routes.revisao),
    (12, 'Simulados', null),
    (13, 'Simulado em curso', Routes.simulado),
    (14, 'Progresso', null),
    (15, 'Perfil', null),
    (16, 'Desbloquear', Routes.desbloquear),
    (17, 'Pagamento', Routes.pagamento),
    (18, 'A aguardar confirmação', Routes.aguardar),
    (19, 'Compra concluída', Routes.concluido),
  ];

  static const _tabDe = {12: 1, 14: 2, 15: 3};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telas (dev)', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(Routes.devWidgets),
            child: const Text('Componentes'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _telas.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (n, nome, rota) = _telas[i];
          return AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            onTap: () {
              if (rota != null) {
                Navigator.of(context).pushNamed(rota);
              } else {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => HomeShell(initialTab: _tabDe[n]!),
                ));
              }
            },
            child: Row(
              children: [
                EmojiBox('$n', size: 34, fontSize: 13),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(nome,
                      style: const TextStyle(fontSize: 14, color: AppColors.ink)),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          );
        },
      ),
    );
  }
}
