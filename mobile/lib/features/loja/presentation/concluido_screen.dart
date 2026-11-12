import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/licencas.dart';
import '../../../data/repositorios.dart';

final _resumoActivacaoProvider = FutureProvider((ref) async {
  final licencas = [...await ref.watch(licencasProvider.future)]..sort((a, b) => b.emitidaEm.compareTo(a.emitidaEm));
  final repo = ref.watch(conteudoRepoProvider);
  final produtos = {for (final p in await repo.produtos()) p.row.codigo: p};
  final provas = <String, ProvaInfo>{};
  for (final l in licencas) {
    for (final c in l.provas) {
      provas[c] ??= (await repo.prova(c))!;
    }
  }
  return (licencas: licencas, produtos: produtos, provas: provas);
});

/// Tela 19 — Activação concluída (antes "Compra concluída").
class ConcluidoScreen extends ConsumerWidget {
  const ConcluidoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(_resumoActivacaoProvider).value;
    final nome = ref.watch(perfilProvider).value?.nome ?? '';
    final nova = r?.licencas.firstOrNull;
    final produto = nova == null ? null : r!.produtos[nova.produto];
    final primeiraProva = nova == null || nova.provas.isEmpty ? null : nova.provas.first;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 170,
                      child: Stack(
                        children: [
                          const Positioned.fill(child: Confetti()),
                          Center(
                            child: Container(
                              width: 112,
                              height: 112,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                              child: Container(
                                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                                child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Activação concluída!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    Text(
                      'O conteúdo já está no teu telemóvel e funciona sem Internet. Bons estudos${nome.isEmpty ? '' : ', $nome'}!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: AppColors.muted),
                    ),
                    const SizedBox(height: 22),
                    if (nova != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          children: [
                            for (final (i, c) in nova.provas.indexed) ...[
                              if (i > 0) const SizedBox(height: 12),
                              _Item(r!.provas[c]?.icone ?? '📘', r.provas[c]?.nome ?? c, nova.tipo == 'simulados' ? '🎯 Simulados' : '🔓 Níveis 3–10'),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (nova != null)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.escuro ? AppColors.border : const Color(0xFFEFF2F7), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            _Recibo('Produto', produto?.row.nome ?? nova.produto),
                            if (produto != null) _Recibo('Valor', '${produto.row.precoMt} MT'),
                            _Recibo('Válido até', _validade(nova)),
                          ],
                        ),
                      ),
                    if (r != null && r.licencas.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text('Tens ${r.licencas.length} compras activas neste telemóvel.',
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      ),
                  ],
                ),
              ),
              PrimaryButton(
                label: primeiraProva == null ? 'Começar a estudar' : (nova!.tipo == 'simulados' ? 'Ver simulados' : 'Ir para os níveis'),
                onPressed: () {
                  context.go(Routes.inicioTab(nova?.tipo == 'simulados' ? 1 : 0));
                  if (primeiraProva != null && nova!.tipo != 'simulados') context.push(Routes.prova(primeiraProva));
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  static String _validade(Licenca l) {
    final d = l.validoAte;
    if (d == null) return 'Sem fim';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _Item extends StatelessWidget {
  const _Item(this.emoji, this.nome, this.estado);

  final String emoji;
  final String nome;
  final String estado;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          EmojiBox(emoji, background: AppColors.surface, size: 40, fontSize: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(nome, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink))),
          Text(estado, style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
        ],
      );
}

class _Recibo extends StatelessWidget {
  const _Recibo(this.k, this.v);

  final String k;
  final String v;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(k, style: const TextStyle(fontSize: 13, color: AppColors.muted))),
            Flexible(child: Text(v, textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink))),
          ],
        ),
      );
}
