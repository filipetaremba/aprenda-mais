import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/config.dart';
import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/importador.dart';
import '../../../data/repositorios.dart';

final contactosProvider = FutureProvider((ref) => ref.watch(utilizadorRepoProvider).contactos());

typedef LojaChave = ({String? prova, String tipo});

final produtosLojaProvider = FutureProvider.family<List<ProdutoInfo>, LojaChave>((ref, k) async {
  ref.watch(progressoVersaoProvider);
  final repo = ref.watch(conteudoRepoProvider);
  final provas = k.prova != null ? [k.prova!] : [for (final p in await ref.watch(provasObjectivosProvider.future)) p.codigo];
  final todos = await repo.produtos();
  final relevantes = todos.where((p) => p.provas.any(provas.contains)).toList()
    // primeiro o tipo pedido (níveis ou simulados), depois os pacotes com mais provas
    ..sort((a, b) {
      final t = (a.row.tipo == k.tipo ? 0 : 1) - (b.row.tipo == k.tipo ? 0 : 1);
      return t != 0 ? t : b.provas.length.compareTo(a.provas.length);
    });
  return relevantes;
});

/// Actualiza preços e contactos a partir do /catalogo (silencioso: sem Internet fica o que há).
Future<void> actualizarCatalogo(WidgetRef ref) async {
  try {
    final c = await ref.read(apiProvider).catalogo();
    final produtos = c['produtos'] as List? ?? const [];
    // Um servidor sem produtos (ex.: ainda por configurar) não apaga os preços que vieram com a app
    if (produtos.isNotEmpty) await ImportadorConteudo(ref.read(contentDbProvider)).actualizarProdutos(produtos);
    await ref.read(utilizadorRepoProvider).gravarContactos(c['contactos'] as Map<String, dynamic>);
    ref.invalidate(contactosProvider);
    ref.invalidate(produtosLojaProvider);
  } catch (_) {
    // offline ou servidor indisponível: mantém os preços que vieram com a app
  }
}

/// Tela 16 — Desbloquear (paywall). Nesta fase o pagamento é feito por fora (M-Pesa/e-Mola)
/// e o estudante recebe um código de activação.
class DesbloquearScreen extends ConsumerStatefulWidget {
  const DesbloquearScreen({super.key, this.prova, this.tipo = 'niveis'});

  final String? prova;
  final String tipo;

  @override
  ConsumerState<DesbloquearScreen> createState() => _DesbloquearScreenState();
}

class _DesbloquearScreenState extends ConsumerState<DesbloquearScreen> {
  int _sel = 0;

  @override
  void initState() {
    super.initState();
    actualizarCatalogo(ref);
  }

  /// Soma dos produtos de uma só prova (mesmo tipo) que este produto substitui.
  int? _antes(ProdutoInfo p, List<ProdutoInfo> todos) {
    if (p.provas.length < 2) return null;
    var soma = 0;
    for (final prova in p.provas) {
      final unico = todos.where((x) => x.row.tipo == p.row.tipo && x.provas.length == 1 && x.provas.first == prova).firstOrNull;
      if (unico == null) return null;
      soma += unico.row.precoMt;
    }
    return soma > p.row.precoMt ? soma : null;
  }

  Future<void> _whatsapp(ProdutoInfo p, String numero) async {
    final digitos = numero.replaceAll(RegExp(r'\D'), '');
    final internacional = digitos.length == 9 ? '258$digitos' : digitos;
    final texto = Uri.encodeComponent('Olá! Quero comprar "${p.row.nome}" (${p.row.precoMt} MT) do Aprova+. Envio o comprovativo do pagamento.');
    final ok = await launchUrl(Uri.parse('https://wa.me/$internacional?text=$texto'), mode: LaunchMode.externalApplication);
    if (!ok && mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')));
  }

  @override
  Widget build(BuildContext context) {
    final produtos = ref.watch(produtosLojaProvider((prova: widget.prova, tipo: widget.tipo))).value ?? const <ProdutoInfo>[];
    final contactos = ref.watch(contactosProvider).value ?? const <String, dynamic>{};
    final sel = produtos.isEmpty ? null : produtos[_sel.clamp(0, produtos.length - 1)];
    final simulados = widget.tipo == 'simulados';
    final mpesa = contactos['mpesa'] as String? ?? '';
    final emola = contactos['emola'] as String? ?? '';
    final whatsapp = (contactos['whatsapp'] as String?) ?? AppConfig.contactoWhatsapp;
    final conta = contactos['nome_conta'] as String? ?? 'Aprova+';

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    BlueHeader(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: HeaderIconButton(icon: Icons.close, color: Colors.white, onPressed: () => context.pop()),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(18)),
                            child: const Icon(Icons.lock_open_rounded, color: Colors.white, size: 30),
                          ),
                          const SizedBox(height: 14),
                          Text(simulados ? 'Desbloqueia os simulados' : 'Desbloqueia todos os níveis',
                              textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            simulados ? 'Treina com tempo e sem ajudas, como no dia do exame.' : 'Os níveis 1 e 2 são grátis. Continua até à simulação final!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: -70,
                      child: AppCard(
                        elevated: true,
                        radius: 24,
                        child: Column(
                          children: [
                            for (final b in [
                              if (!simulados) 'Níveis 3 a 10 de cada prova' else 'Simulados com tempo, como no exame',
                              'Explicações e revisão de todas as respostas',
                              'Funciona sem Internet depois de descarregar',
                              if (sel?.row.epoca != null) 'Válido para a época ${sel!.row.epoca}' else 'Válido até ao fim da época de exames',
                            ])
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check, color: AppColors.success, size: 16),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(b, style: TextStyle(fontSize: 13, color: AppColors.ink))),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 96),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (produtos.isEmpty)
                        AppCard(child: Text('Ainda não há preços para esta prova. Fala connosco pelo WhatsApp.', style: TextStyle(color: AppColors.inkSoft))),
                      for (var i = 0; i < produtos.length; i++) ...[
                        _opcao(i, produtos[i], _antes(produtos[i], produtos)),
                        const SizedBox(height: 14),
                      ],
                      if (sel != null) _comoPagar(sel, mpesa: mpesa, emola: emola, whatsapp: whatsapp, conta: conta),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
              child: Column(
                children: [
                  PrimaryButton(label: '🔑 Tenho um código de activação', onPressed: () => context.push(Routes.activarPara(widget.prova))),
                  if (AppConfig.pagamentoAutomatico && sel != null) ...[
                    const SizedBox(height: 8),
                    SecondaryButton(label: 'Pagar agora · ${sel.row.precoMt} MT', onPressed: () => context.push(Routes.pagamento)),
                  ],
                  TextButton(
                    onPressed: () => context.push('${Routes.activar}?restaurar=1'),
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Já compraste noutro telemóvel? '),
                        TextSpan(text: 'Restaurar compra', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ]),
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _comoPagar(ProdutoInfo p, {required String mpesa, required String emola, required String whatsapp, required String conta}) {
    Widget passo(String n, Widget texto) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmojiBox(n, size: 26, fontSize: 12),
              const SizedBox(width: 10),
              Expanded(child: DefaultTextStyle.merge(style: TextStyle(fontSize: 13, color: AppColors.ink, height: 1.45), child: texto)),
            ],
          ),
        );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Como pagar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 12),
          passo(
            '1',
            Text.rich(TextSpan(children: [
              TextSpan(text: 'Envia ${p.row.precoMt} MT', style: const TextStyle(fontWeight: FontWeight.w700)),
              if (mpesa.isNotEmpty) ...[
                const TextSpan(text: ' por '),
                const TextSpan(text: 'M-Pesa', style: TextStyle(color: AppColors.mpesa, fontWeight: FontWeight.w700)),
                TextSpan(text: ' para $mpesa'),
              ],
              if (emola.isNotEmpty) ...[
                TextSpan(text: mpesa.isNotEmpty ? ' ou ' : ' por '),
                const TextSpan(text: 'e-Mola', style: TextStyle(color: AppColors.emola, fontWeight: FontWeight.w700)),
                TextSpan(text: ' para $emola'),
              ],
              TextSpan(text: ' ($conta).'),
            ])),
          ),
          passo('2', Text('Envia o comprovativo pelo WhatsApp${whatsapp.isEmpty ? '' : ' ($whatsapp)'}, a dizer que compraste "${p.row.nome}".')),
          passo('3', const Text('Recebes um código APV-XXXX-XXXX. Carrega em "Tenho um código de activação" e escreve-o.')),
          if (whatsapp.isNotEmpty)
            SecondaryButton(
              label: '💬 Abrir o WhatsApp',
              height: 44,
              background: const Color(0xFFDCF8E5),
              foreground: const Color(0xFF15803D),
              onPressed: () => _whatsapp(p, whatsapp),
            ),
        ],
      ),
    );
  }

  Widget _opcao(int i, ProdutoInfo p, int? antes) {
    final sel = i == _sel;
    final recomendado = antes != null;
    final card = AppCard(
      onTap: () => setState(() => _sel = i),
      border: Border.all(color: sel ? AppColors.primary : (AppColors.escuro ? AppColors.border : const Color(0xFFEFF2F7)), width: 2),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          SelectCircle(selected: sel, radio: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.row.nome, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                Text(p.row.descricao ?? (p.row.tipo == 'simulados' ? 'Simulados' : 'Níveis 3–10'),
                    style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (antes != null)
                Text('$antes MT', style: const TextStyle(fontSize: 11, color: AppColors.muted, decoration: TextDecoration.lineThrough)),
              Text('${p.row.precoMt} MT',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: recomendado ? AppColors.primary : AppColors.ink)),
            ],
          ),
        ],
      ),
    );
    if (!recomendado) return card;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          left: 16,
          top: -11,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
            child: Text('⭐ RECOMENDADO · POUPAS ${antes - p.row.precoMt} MT',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
          ),
        ),
      ],
    );
  }
}
