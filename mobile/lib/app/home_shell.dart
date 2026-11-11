import 'package:flutter/material.dart';

import '../core/widgets/widgets.dart';
import '../features/inicio/presentation/inicio_screen.dart';
import '../features/perfil/presentation/perfil_screen.dart';
import '../features/progresso/presentation/progresso_screen.dart';
import '../features/simulados/presentation/simulados_screen.dart';

/// Estrutura com a barra inferior e as 4 tabs.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _index = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: const [
          InicioScreen(),
          SimuladosScreen(),
          ProgressoScreen(),
          PerfilScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
