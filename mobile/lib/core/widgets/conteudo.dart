import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:path/path.dart' as p;

import '../../app/theme/app_colors.dart';

/// Texto do conteúdo: Markdown simples (**negrito**, quebras de linha) + LaTeX
/// em linha `$...$` ou em bloco `$$...$$` (flutter_math_fork).
class MathText extends StatelessWidget {
  const MathText(this.text, {super.key, this.style, this.textAlign});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  static final _re = RegExp(r'\$\$(.+?)\$\$|\$(.+?)\$|\*\*(.+?)\*\*', dotAll: true);

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.merge(style);
    final spans = <InlineSpan>[];
    var i = 0;
    for (final m in _re.allMatches(text)) {
      if (m.start > i) spans.add(TextSpan(text: text.substring(i, m.start)));
      final bloco = m.group(1), linha = m.group(2), negrito = m.group(3);
      if (negrito != null) {
        spans.add(TextSpan(text: negrito, style: const TextStyle(fontWeight: FontWeight.w700)));
      } else {
        final tex = (bloco ?? linha)!;
        final formula = Math.tex(
          tex,
          mathStyle: bloco != null ? MathStyle.display : MathStyle.text,
          textStyle: base.copyWith(fontSize: (base.fontSize ?? 15) * 1.05),
          onErrorFallback: (_) => Text(tex, style: base.copyWith(fontStyle: FontStyle.italic)),
        );
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: bloco != null
              ? Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: formula))
              : formula,
        ));
      }
      i = m.end;
    }
    if (i < text.length) spans.add(TextSpan(text: text.substring(i)));
    return Text.rich(TextSpan(style: style, children: spans), textAlign: textAlign);
  }
}

/// Imagem de uma questão/alternativa: primeiro a pasta dos pacotes descarregados,
/// depois os assets da app (conteúdo grátis).
class ImagemConteudo extends StatelessWidget {
  const ImagemConteudo(this.nome, {super.key, this.altura});

  /// Pasta das imagens dos pacotes (definida no arranque, em main.dart).
  static String? pastaDescarregada;

  final String nome;
  final double? altura;

  @override
  Widget build(BuildContext context) {
    final pasta = pastaDescarregada;
    final ficheiro = pasta == null ? null : File(p.join(pasta, nome));
    final erro = Container(
      height: 60,
      alignment: Alignment.center,
      child: const Text('Imagem indisponível', style: TextStyle(color: AppColors.muted, fontSize: 12)),
    );
    if (ficheiro != null && ficheiro.existsSync()) {
      return Image.file(ficheiro, height: altura, fit: BoxFit.contain, errorBuilder: (_, _, _) => erro);
    }
    return Image.asset('assets/content/imagens/$nome', height: altura, fit: BoxFit.contain, errorBuilder: (_, _, _) => erro);
  }
}

/// Várias imagens em coluna (enunciado com mais de uma figura).
class ImagensConteudo extends StatelessWidget {
  const ImagensConteudo(this.nomes, {super.key});

  final List<String> nomes;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, n) in nomes.indexed) ...[
            if (i > 0) const SizedBox(height: 8),
            Flexible(child: ImagemConteudo(n)),
          ],
        ],
      );
}
