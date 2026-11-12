import 'dart:convert';

import 'package:drift/drift.dart';

import 'content/content_db.dart';

/// Conteúdo inválido (formato, prova errada…). A base fica como estava.
class ConteudoInvalido implements Exception {
  ConteudoInvalido(this.mensagem);
  final String mensagem;
  @override
  String toString() => 'ConteudoInvalido: $mensagem';
}

/// Importa para a content.db os formatos de shared/content.schema.json:
/// - `conteudo_app` (assets/content/conteudo.json, níveis grátis + catálogo)
/// - `pacote` (pacote.json dentro do .zip de uma prova, níveis pagos)
///
/// Tudo numa transacção: ou entra tudo, ou nada. Nunca toca na user.db.
class ImportadorConteudo {
  ImportadorConteudo(this.db);

  final ContentDb db;

  static const formato = 1;

  /// Importa o conteúdo embutido se for mais recente do que o já importado.
  /// Devolve true se importou.
  Future<bool> importarConteudoApp(Map<String, dynamic> c, {bool forcar = false}) async {
    if (c['formato'] != formato || c['tipo'] != 'conteudo_app') throw ConteudoInvalido('não é um conteudo_app (formato $formato)');
    final versao = c['versao'] as int;
    final actual = int.tryParse(await db.lerMeta('versao_app') ?? '') ?? 0;
    if (!forcar && actual >= versao) return false;

    final cat = c['catalogo'] as Map<String, dynamic>;
    final meta = c['meta'] as Map<String, dynamic>;
    await db.transaction(() async {
      await db.batch((b) {
        b.insertAllOnConflictUpdate(db.gruposExame, [
          for (final g in _lista(cat['grupos_exame']))
            GruposExameCompanion.insert(codigo: g['codigo'], nome: g['nome'], temGabarito: Value(g['tem_gabarito'] == true)),
        ]);
        b.insertAllOnConflictUpdate(db.instituicoes, [
          for (final i in _lista(cat['instituicoes']))
            InstituicoesCompanion.insert(codigo: i['codigo'], sigla: i['sigla'], nome: i['nome'], grupoExame: i['grupo_exame']),
        ]);
        b.insertAllOnConflictUpdate(db.disciplinas, [
          for (final d in _lista(cat['disciplinas']))
            DisciplinasCompanion.insert(codigo: d['codigo'], nome: d['nome'], icone: Value(d['icone'])),
        ]);
        b.insertAllOnConflictUpdate(db.temas, [
          for (final t in _lista(cat['temas'])) TemasCompanion.insert(codigo: t['codigo'], disciplina: t['disciplina'], nome: t['nome']),
        ]);
        b.insertAllOnConflictUpdate(db.provas, [
          for (final p in _lista(cat['provas']))
            ProvasCompanion.insert(
              codigo: p['codigo'],
              grupoExame: p['grupo_exame'],
              disciplina: p['disciplina'],
              nome: p['nome'],
              variante: Value(p['variante']),
              duracaoMin: Value(p['duracao_min']),
              numQuestoes: Value(p['num_questoes']),
            ),
        ]);
        b.insertAllOnConflictUpdate(db.ofertas, [
          for (final o in _lista(cat['cursos']))
            OfertasCompanion.insert(
              codigo: o['codigo'],
              instituicao: o['instituicao'],
              curso: o['curso'] ?? o['codigo'],
              nome: o['nome'],
              icone: Value(o['icone']),
              nomeOriginal: o['nome_original'] ?? o['nome'],
              faculdade: Value(o['faculdade'] is List ? (o['faculdade'] as List).join(' | ') : (o['faculdade'] ?? '')),
              locais: Value(jsonEncode(o['local'] is List ? o['local'] : [if (o['local'] != null) o['local']])),
            ),
        ]);
        b.deleteAll(db.ofertaProva);
        b.insertAll(db.ofertaProva, [
          for (final o in _lista(cat['cursos']))
            for (final (i, p) in _lista(o['provas']).indexed)
              OfertaProvaCompanion.insert(oferta: o['codigo'], prova: p['prova'], peso: Value(p['peso']), ordem: Value(i + 1)),
        ], mode: InsertMode.insertOrReplace);
        _niveis(b, _lista(c['niveis']));
        _simulados(b, _lista(c['simulados']));
        // Os preços do APK são o ponto de partida; o /catalogo actualiza-os quando houver Internet
        b.deleteAll(db.produtoProva);
        b.deleteAll(db.produtos);
        _produtos(b, _lista(c['produtos']));
      });
      for (final e in _lista(c['exames'])) {
        await _gravarExame(e);
      }
      await db.gravarMeta('versao_app', '$versao');
      await db.gravarMeta('nota_minima_padrao', '${meta['nota_minima_padrao']}');
      await db.gravarMeta('niveis_gratis', '${meta['niveis_gratis']}');
    });
    return true;
  }

  /// Importa um pacote pago já verificado (checksum). Substitui os níveis incluídos dessa prova.
  Future<int> importarPacote(Map<String, dynamic> p, {required String provaEsperada, required String sha256}) async {
    if (p['formato'] != formato || p['tipo'] != 'pacote') throw ConteudoInvalido('não é um pacote (formato $formato)');
    final prova = p['prova'];
    final conteudo = p['conteudo'] as Map<String, dynamic>?;
    if (prova != provaEsperada || conteudo?['prova'] != prova) throw ConteudoInvalido('o pacote não é da prova $provaEsperada');
    final niveisIncluidos = [for (final n in (p['niveis_incluidos'] as List? ?? const [])) n as int];
    final questoes = _lista(conteudo!['questoes']);
    for (final q in questoes) {
      if (!niveisIncluidos.contains(q['nivel'])) throw ConteudoInvalido('questão ${q['codigo']} fora dos níveis do pacote');
    }

    await db.transaction(() async {
      await db.batch((b) {
        b.deleteWhere(db.questaoProva, (t) => t.prova.equals(prova) & t.nivel.isIn(niveisIncluidos));
        _niveis(b, _lista(p['niveis']));
        _simulados(b, _lista(p['simulados']));
      });
      await _gravarExame(conteudo);
      await db.into(db.pacotesInstalados).insertOnConflictUpdate(
            PacotesInstaladosCompanion.insert(prova: prova, versao: p['versao'], sha256: sha256, instaladoEm: DateTime.now()),
          );
    });
    return questoes.length;
  }

  /// Produtos e preços vindos do /catalogo (online).
  Future<void> actualizarProdutos(List<dynamic> produtos) => db.transaction(() async {
        await db.batch((b) {
          b.deleteAll(db.produtoProva);
          b.deleteAll(db.produtos);
          _produtos(b, _lista(produtos));
        });
      });

  // ───── auxiliares ─────

  static List<Map<String, dynamic>> _lista(dynamic v) => [for (final x in (v as List? ?? const [])) x as Map<String, dynamic>];

  void _niveis(Batch b, List<Map<String, dynamic>> niveis) {
    b.insertAllOnConflictUpdate(db.niveis, [
      for (final n in niveis)
        NiveisCompanion.insert(
          prova: n['prova'],
          numero: n['numero'],
          titulo: n['titulo'],
          descricao: Value(n['descricao']),
          notaMinima: Value(n['nota_minima']),
        ),
    ]);
  }

  void _simulados(Batch b, List<Map<String, dynamic>> simulados) {
    b.insertAllOnConflictUpdate(db.simulados, [
      for (final s in simulados)
        SimuladosCompanion.insert(
          codigo: s['codigo'],
          prova: Value(s['prova']),
          oferta: Value(s['oferta']),
          titulo: s['titulo'],
          duracaoMin: s['duracao_min'],
          numPerguntas: s['num_perguntas'],
          gratuito: Value(s['gratuito'] == true),
        ),
    ]);
  }

  void _produtos(Batch b, List<Map<String, dynamic>> produtos) {
    b.insertAll(db.produtos, [
      for (final p in produtos)
        ProdutosCompanion.insert(
          codigo: p['codigo'],
          nome: p['nome'],
          descricao: Value(p['descricao']),
          tipo: p['tipo'],
          precoMt: p['preco_mt'],
          epoca: Value(p['epoca']),
          ordem: Value(p['ordem'] ?? 0),
        ),
    ], mode: InsertMode.insertOrReplace);
    b.insertAll(db.produtoProva, [
      for (final p in produtos)
        for (final prova in (p['provas'] as List? ?? const [])) ProdutoProvaCompanion.insert(produto: p['codigo'], prova: prova as String),
    ], mode: InsertMode.insertOrReplace);
  }

  /// `$defs/ficheiro_questoes`: { prova, textos_base, questoes }
  Future<void> _gravarExame(Map<String, dynamic> e) async {
    final prova = e['prova'] as String;
    final questoes = _lista(e['questoes']);
    final textos = (e['textos_base'] as Map<String, dynamic>? ?? const {});
    final codigos = [for (final q in questoes) q['codigo'] as String];
    await db.batch((b) {
      b.insertAllOnConflictUpdate(db.textosBase, [
        for (final MapEntry(:key, :value) in textos.entries)
          TextosBaseCompanion.insert(codigo: key, titulo: Value(value['titulo']), texto: value['texto']),
      ]);
      b.insertAllOnConflictUpdate(db.questoes, [
        for (final q in questoes)
          QuestoesCompanion.insert(
            codigo: q['codigo'],
            tipo: q['tipo'],
            enunciado: q['enunciado'],
            explicacao: (q['explicacao'] as Map?)?['texto'] ?? '',
            tema: Value(q['tema']),
            textoBase: Value(q['texto_base']),
            imagens: Value(jsonEncode(q['imagens'] ?? const [])),
            dica: Value(q['dica']),
            ano: Value(q['ano']),
            dificuldade: Value(q['dificuldade']),
          ),
      ]);
      b.deleteWhere(db.alternativas, (a) => a.questao.isIn(codigos));
      b.insertAll(db.alternativas, [
        for (final q in questoes)
          for (final (i, a) in _lista(q['alternativas']).indexed)
            AlternativasCompanion.insert(
              questao: q['codigo'],
              letra: a['letra'],
              texto: Value(a['texto']),
              imagem: Value(a['imagem']),
              correcta: Value(a['letra'] == (q['resposta'] as Map?)?['letra']),
              ordem: i + 1,
            ),
      ]);
      b.insertAllOnConflictUpdate(db.questaoProva, [
        for (final q in questoes)
          if (q['nivel'] != null) QuestaoProvaCompanion.insert(questao: q['codigo'], prova: prova, nivel: q['nivel']),
      ]);
    });
  }
}
