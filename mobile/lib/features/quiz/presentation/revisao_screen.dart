import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/user/user_db.dart';
import '../../../domain/quiz.dart';
import 'pergunta_screen.dart';

enum _Res { certa, errada, ajuda }

class _Item {
  _Item(this.resposta, this.questao);
  final RespostaRow resposta;
  final QuestaoQuiz questao;

  _Res get res => resposta.viuResposta ? _Res.ajuda : (resposta.correcta ? _Res.certa : _Res.errada);

  /// Alternativas pela ordem em que foram mostradas.
  List<AlternativaQuiz> get ordem {
    final letras = [for (final l in jsonDecode(resposta.ordemAlternativas) as List) l as String];
    final porLetra = {for (final a in questao.alternativas) a.letra: a};
    return [for (final l in letras) if (porLetra[l] != null) porLetra[l]!];
  }
}

final _revisaoProvider = FutureProvider.family<({TentativaRow? t, List<_Item> itens, String titulo}), String>((ref, id) async {
  final user = ref.watch(utilizadorRepoProvider);
  final conteudo = ref.watch(conteudoRepoProvider);
  final t = await user.tentativa(id);
  if (t == null) return (t: null, itens: <_Item>[], titulo: '');
  final respostas = await user.respostas(id);
  final qs = {for (final q in await conteudo.questoesPorCodigos([for (final r in respostas) r.questao])) q.codigo: q};
  final prova = await conteudo.prova(t.prova);
  final titulo = t.simulado != null ? 'Revisão · Simulado' : 'Revisão · ${prova?.disciplinaNome ?? ''} N${t.nivel}';
  return (t: t, itens: [for (final r in respostas) if (qs[r.questao] != null) _Item(r, qs[r.questao]!)], titulo: titulo);
});

/// Tela 11 — Revisão (grelha + detalhe).
class RevisaoScreen extends ConsumerStatefulWidget {
  const RevisaoScreen({super.key, required this.tentativa});

  final String tentativa;

  @override
  ConsumerState<RevisaoScreen> createState() => _RevisaoScreenState();
}

class _RevisaoScreenState extends ConsumerState<RevisaoScreen> {
  int _filtro = 0; // 0 todas, 1 erradas, 2 com ajuda
  int _actual = 0; // índice em itens

  List<int> _visiveis(List<_Item> itens) => [
        for (var i = 0; i < itens.length; i++)
          if (_filtro == 0 || (_filtro == 1 && itens[i].res == _Res.errada) || (_filtro == 2 && itens[i].res == _Res.ajuda)) i,
      ];

  void _filtrar(int f, List<_Item> itens) => setState(() {
        _filtro = f;
        final v = _visiveis(itens);
        if (v.isNotEmpty && !v.contains(_actual)) _actual = v.first;
      });

  void _mover(int d, List<_Item> itens) {
    final v = _visiveis(itens);
    if (v.isEmpty) return;
    final i = v.indexOf(_actual);
    setState(() => _actual = v[(i + d).clamp(0, v.length - 1)]);
  }

  @override
  Widget build(BuildContext context) {
    final dados = ref.watch(_revisaoProvider(widget.tentativa)).value;
    if (dados == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final itens = dados.itens;
    final erradas = itens.where((x) => x.res == _Res.errada).length;
    final ajuda = itens.where((x) => x.res == _Res.ajuda).length;
    final visiveis = _visiveis(itens);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 48, 0),
              child: Row(
                children: [
                  HeaderIconButton(icon: Icons.close, onPressed: () => context.pop()),
                  Expanded(
                    child: Text(dados.titulo,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ChipFilter(label: 'Todas (${itens.length})', selected: _filtro == 0, onTap: () => _filtrar(0, itens)),
                  const SizedBox(width: 8),
                  ChipFilter(
                    label: 'Erradas ($erradas)',
                    selected: _filtro == 1,
                    color: AppColors.error,
                    background: AppColors.errorLight,
                    onTap: () => _filtrar(1, itens),
                  ),
                  const SizedBox(width: 8),
                  ChipFilter(
                    label: 'Com ajuda ($ajuda)',
                    selected: _filtro == 2,
                    color: const Color(0xFFD97706),
                    background: AppColors.accentLight,
                    onTap: () => _filtrar(2, itens),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                children: [
                  GridView.count(
                    crossAxisCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.15,
                    children: [for (final i in visiveis) _celula(i, itens[i])],
                  ),
                  const SizedBox(height: 16),
                  if (visiveis.isEmpty)
                    const Center(child: Text('Nenhuma questão neste filtro.', style: TextStyle(color: AppColors.muted)))
                  else if (itens.isNotEmpty)
                    _detalhe(_actual, itens[_actual]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: '‹ Anterior',
                      background: AppColors.escuro ? AppColors.border : const Color(0xFFF1F5F9),
                      foreground: AppColors.ink,
                      onPressed: () => _mover(-1, itens),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SecondaryButton(
                      label: 'Seguinte ›',
                      background: AppColors.primary,
                      foreground: Colors.white,
                      onPressed: () => _mover(1, itens),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _celula(int i, _Item item) {
    final (fg, bg, borda) = switch (item.res) {
      _Res.certa => (AppColors.success, AppColors.successLight, Colors.transparent),
      _Res.errada => (AppColors.error, AppColors.errorLight, AppColors.error),
      _Res.ajuda => (const Color(0xFFD97706), AppColors.accentLight, AppColors.accent),
    };
    final sel = i == _actual;
    return GestureDetector(
      onTap: () => setState(() => _actual = i),
      child: Container(
        padding: EdgeInsets.all(sel ? 2 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: sel ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: borda, width: 2)),
          child: Text('${i + 1}', style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _detalhe(int i, _Item item) {
    final q = item.questao;
    final escolhida = item.resposta.letra;
    final vf = q.verdadeiroFalso;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Questão ${i + 1} · ${vf ? 'Verdadeiro ou falso' : (q.temaNome ?? 'Escolha múltipla')}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              if (q.ano != null) Text('Exame ${q.ano}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          MathText(q.enunciado, style: TextStyle(fontSize: 15, color: AppColors.ink, height: 1.45)),
          if (q.imagens.isNotEmpty) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(color: Colors.white, child: Padding(padding: const EdgeInsets.all(8), child: ImagensConteudo(q.imagens))),
            ),
          ],
          const SizedBox(height: 12),
          for (final (k, a) in item.ordem.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OptionTile(
                compact: true,
                letter: vf ? a.letra : letrasPosicao[k],
                text: [
                  a.texto ?? '',
                  if (a.letra == escolhida && !item.resposta.viuResposta) '· tua',
                  if (a.correcta && item.resposta.viuResposta) '· 👁',
                ].where((x) => x.isNotEmpty).join(' '),
                imagem: a.imagem,
                state: a.correcta ? OptionState.correct : (a.letra == escolhida ? OptionState.wrong : OptionState.normal),
              ),
            ),
          if (escolhida == null) const Text('Ficou em branco.', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 6),
          MathText('**Explicação:** ${q.explicacao}', style: TextStyle(fontSize: 13, color: AppColors.inkSoft, height: 1.55)),
        ],
      ),
    );
  }
}
