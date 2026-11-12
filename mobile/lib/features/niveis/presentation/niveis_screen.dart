import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/repositorios.dart';
import '../../../domain/regras.dart';

/// O que fazer quando se toca num nível (partilhado com o detalhe).
void abrirNivel(BuildContext context, ProvaDetalhe d, NivelInfo n) {
  void aviso(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  switch (n.estado) {
    case EstadoNivel.bloqueado:
      final anterior = d.niveis.where((x) => x.numero == n.numero - 1).firstOrNull;
      aviso('Passa o nível ${n.numero - 1} com pelo menos ${anterior?.notaMinima ?? d.regras.notaMinimaPadrao}% para abrir este.');
    case EstadoNivel.pago:
      context.push(Routes.lojaDe(d.prova.codigo));
    case EstadoNivel.porDescarregar:
      context.push(Routes.sincronizar);
    case EstadoNivel.semQuestoes:
      aviso('Ainda não há perguntas neste nível. Estamos a preparar mais!');
    case EstadoNivel.concluido:
    case EstadoNivel.disponivel:
      context.push(Routes.nivel(d.prova.codigo, n.numero));
  }
}

/// Tela 6 — Níveis da prova (caminho em zig-zag).
class NiveisScreen extends ConsumerWidget {
  const NiveisScreen({super.key, required this.prova});

  final String prova;

  // posição horizontal (0 = esquerda, 1 = direita) de cada nó
  static const _x = [0.0, 0.55, 0.15, 0.5, 0.65, 0.1, 0.5, 0.75, 0.25, 0.5];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalhe = ref.watch(detalheProvaProvider(prova));
    final d = detalhe.value;
    if (d == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: detalhe.isLoading ? const CircularProgressIndicator() : const Text('Prova não encontrada.')),
      );
    }
    final actual = d.niveis.where((n) => n.estado == EstadoNivel.disponivel).firstOrNull;
    return Scaffold(
      body: Column(
        children: [
          BlueHeader(
            padding: const EdgeInsets.fromLTRB(16, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    HeaderIconButton(icon: Icons.chevron_left, color: Colors.white, onPressed: () => context.pop()),
                    Expanded(
                      child: Text('${d.prova.icone} ${d.prova.nome}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text('${d.concluidos}/$numNiveis', style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(padding: const EdgeInsets.only(left: 8), child: LinearBar(value: d.concluidos / numNiveis)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '${d.prova.legenda} · ${d.concluidos} ${d.concluidos == 1 ? 'nível concluído' : 'níveis concluídos'}',
                    style: const TextStyle(color: Color(0xDDFFFFFF), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth - 48;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  children: [
                    if (!d.temLicenca)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InfoBanner(
                          color: AppColors.primaryLight,
                          child: Row(
                            children: [
                              const Text('🔓', style: TextStyle(fontSize: 18)),
                              const SizedBox(width: 10),
                              Expanded(child: Text('Níveis 1–${d.regras.niveisGratis} grátis. Desbloqueia os restantes.')),
                              TextButton(onPressed: () => context.push(Routes.lojaDe(d.prova.codigo)), child: const Text('Ver')),
                            ],
                          ),
                        ),
                      ),
                    Stack(
                      children: [
                        Positioned.fill(
                          child: Center(child: CustomPaint(size: const Size(2, double.infinity), painter: _DashPainter())),
                        ),
                        Column(
                          children: [
                            for (var i = 0; i < d.niveis.length; i++) _linha(context, d, d.niveis[i], i, w, d.niveis[i] == actual),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String? _rotulo(NivelInfo n) => switch (n.estado) {
        EstadoNivel.pago => '🔒 Desbloquear',
        EstadoNivel.porDescarregar => '⬇ Descarregar',
        EstadoNivel.semQuestoes => 'Em breve',
        _ => null,
      };

  Widget _linha(BuildContext context, ProvaDetalhe d, NivelInfo n, int i, double w, bool actual) {
    void tap() => abrirNivel(context, d, n);
    final titulo = n.row.titulo;

    if (actual) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(8)),
              child: Text(n.tentativas == 0 ? 'COMEÇAR' : 'CONTINUAR',
                  style: TextStyle(color: AppColors.background, fontWeight: FontWeight.w700, fontSize: 11)),
            ),
            const SizedBox(height: 2),
            LevelNode(number: n.numero, state: LevelState.current, onTap: tap),
            const SizedBox(height: 4),
            Text(titulo, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink)),
          ],
        ),
      );
    }
    final feito = n.estado == EstadoNivel.concluido;
    final left = _x[i] * (w - 200);
    final rotulo = _rotulo(n);
    return Padding(
      padding: EdgeInsets.only(left: left.clamp(0, w), top: 8, bottom: 8),
      child: GestureDetector(
        onTap: tap,
        child: Row(
          children: [
            LevelNode(number: n.numero, state: feito ? LevelState.done : LevelState.locked),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${n.numero} · $titulo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: feito ? FontWeight.w700 : FontWeight.w400,
                      color: feito ? AppColors.ink : AppColors.muted,
                    ),
                  ),
                  if (feito)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Melhor ${n.melhor!.round()}% ', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                        StarRow(n.melhor!.round()),
                      ],
                    ),
                  if (rotulo != null)
                    Text(rotulo, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.primarySoft
      ..strokeWidth = 2;
    for (double y = 0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(0, y + 5), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
