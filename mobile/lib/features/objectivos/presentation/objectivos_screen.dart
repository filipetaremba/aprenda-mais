import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/repositorios.dart';

final _ofertasTodasProvider = FutureProvider((ref) => ref.watch(conteudoRepoProvider).ofertas());
final _instituicoesProvider = FutureProvider((ref) => ref.watch(conteudoRepoProvider).instituicoes());
final _provasComQuestoesProvider = FutureProvider((ref) => ref.watch(conteudoRepoProvider).provasComQuestoes());

/// Tela 4 — Escolher objectivo (curso numa instituição). Também serve para editar os objectivos.
class ObjectivosScreen extends ConsumerStatefulWidget {
  const ObjectivosScreen({super.key, this.editar = false});

  final bool editar;

  @override
  ConsumerState<ObjectivosScreen> createState() => _ObjectivosScreenState();
}

class _ObjectivosScreenState extends ConsumerState<ObjectivosScreen> {
  String? _instituicao;
  String _pesquisa = '';
  Set<String>? _sel;

  static const _fundos = [Color(0xFFDCE8FD), Color(0xFFFDE3E7), Color(0xFFFEF3C7), Color(0xFFDCF8E5), Color(0xFFEDE9FE), Color(0xFFFFEDD5)];

  @override
  void initState() {
    super.initState();
    ref.read(utilizadorRepoProvider).objectivos().then((o) {
      if (mounted) setState(() => _sel ??= o.toSet());
    });
  }

  Future<void> _continuar() async {
    await ref.read(utilizadorRepoProvider).definirObjectivos(_sel!.toList());
    ref.refrescar();
    if (!mounted) return;
    if (widget.editar && context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.inicio);
    }
  }

  bool _corresponde(OfertaInfo o) {
    if (_instituicao != null && o.row.instituicao != _instituicao) return false;
    if (_pesquisa.isEmpty) return true;
    final p = _pesquisa.toLowerCase();
    return o.nome.toLowerCase().contains(p) || o.row.nomeOriginal.toLowerCase().contains(p) || o.instituicaoSigla.toLowerCase().contains(p);
  }

  @override
  Widget build(BuildContext context) {
    final ofertas = ref.watch(_ofertasTodasProvider);
    final instituicoes = ref.watch(_instituicoesProvider).value ?? const [];
    final comQuestoes = ref.watch(_provasComQuestoesProvider).value ?? const <String>{};
    final sel = _sel ?? const <String>{};
    final lista = (ofertas.value ?? const <OfertaInfo>[]).where(_corresponde).toList()
      // seleccionadas primeiro
      ..sort((a, b) => (sel.contains(b.codigo) ? 1 : 0) - (sel.contains(a.codigo) ? 1 : 0));

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.editar)
                      Row(children: [
                        HeaderIconButton(icon: Icons.arrow_back, onPressed: () => context.pop()),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Os meus objectivos',
                              overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                        ),
                      ])
                    else
                      LinearBar(value: 1, color: AppColors.primary, background: AppColors.primaryLight, height: 6),
                    const SizedBox(height: 20),
                    Text('O que queres preparar?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const Text('Podes escolher mais de um.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.muted),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: (v) => setState(() => _pesquisa = v.trim()),
                              style: TextStyle(color: AppColors.ink, fontSize: 14),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Pesquisar curso…',
                                hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final (codigo, sigla) in [(null, 'Todas'), for (final i in instituicoes) (i.codigo, i.sigla)])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChipFilter(
                                label: sigla,
                                selected: codigo == _instituicao,
                                onTap: () => setState(() => _instituicao = codigo),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ofertas.isLoading
                ? const Center(child: CircularProgressIndicator())
                : lista.isEmpty
                    ? Center(child: Text('Nenhum curso encontrado.', style: TextStyle(color: AppColors.muted)))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        itemCount: lista.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, k) {
                          final o = lista[k];
                          final escolhida = sel.contains(o.codigo);
                          final temPerguntas = o.provas.any((p) => comQuestoes.contains(p.codigo));
                          return AppCard(
                            key: ValueKey(o.codigo),
                            onTap: _sel == null
                                ? null
                                : () => setState(() => escolhida ? _sel!.remove(o.codigo) : _sel!.add(o.codigo)),
                            border: Border.all(color: escolhida ? AppColors.primary : Colors.transparent, width: 2),
                            child: Row(
                              children: [
                                EmojiBox(o.icone, background: AppColors.escuro ? AppColors.primaryLight : _fundos[o.codigo.hashCode % _fundos.length]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(o.nome, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                                      Text(
                                        [o.instituicaoSigla, if (o.disciplinas.isNotEmpty) o.disciplinas].join(' · '),
                                        style: const TextStyle(fontSize: 12, color: AppColors.muted),
                                      ),
                                      if (!temPerguntas)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Text('Perguntas em breve', style: TextStyle(fontSize: 11, color: AppColors.accent)),
                                        ),
                                    ],
                                  ),
                                ),
                                SelectCircle(selected: escolhida),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                label: 'Continuar · ${sel.length} seleccionado${sel.length == 1 ? '' : 's'}',
                onPressed: sel.isEmpty ? null : _continuar,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
