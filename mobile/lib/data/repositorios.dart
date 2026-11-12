import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/quiz.dart';
import '../domain/regras.dart';
import 'content/content_db.dart';
import 'licencas.dart';
import 'user/user_db.dart';

// ───────────── Modelos de leitura ─────────────

class ProvaInfo {
  const ProvaInfo({required this.row, required this.disciplinaNome, this.disciplinaIcone, required this.instituicoes});
  final ProvaRow row;
  final String disciplinaNome;
  final String? disciplinaIcone;

  /// Siglas das instituições do grupo de exame (ex.: UEM · UniZambeze)
  final List<String> instituicoes;

  String get codigo => row.codigo;
  String get nome => row.nome;
  String get icone => disciplinaIcone ?? iconeDisciplina(row.disciplina);
  String get legenda => 'Exame ${instituicoes.join(' / ')}';
}

class OfertaInfo {
  const OfertaInfo({required this.row, required this.instituicaoSigla, required this.provas});
  final OfertaRow row;
  final String instituicaoSigla;
  final List<ProvaInfo> provas;

  String get codigo => row.codigo;
  String get nome => row.nome;
  String get icone => row.icone ?? '🎓';
  String get disciplinas => provas.map((p) => p.disciplinaNome).toSet().join(' · ');
}

class NivelInfo {
  const NivelInfo({required this.row, required this.numQuestoes, required this.estado, required this.notaMinima, this.melhor, this.tentativas = 0});
  final NivelRow row;
  final int numQuestoes;
  final EstadoNivel estado;
  final int notaMinima;
  final double? melhor;
  final int tentativas;
  int get numero => row.numero;
}

class ProvaDetalhe {
  const ProvaDetalhe({required this.prova, required this.niveis, required this.temLicenca, required this.pacoteVersao, required this.regras});
  final ProvaInfo prova;
  final List<NivelInfo> niveis;
  final bool temLicenca;
  final int? pacoteVersao;
  final Regras regras;

  int get concluidos => niveis.where((n) => n.estado == EstadoNivel.concluido).length;

  /// Nível a destacar: o primeiro disponível (ou o último concluído)
  NivelInfo? get actual =>
      niveis.where((n) => n.estado == EstadoNivel.disponivel).firstOrNull ??
      niveis.where((n) => n.estado == EstadoNivel.porDescarregar || n.estado == EstadoNivel.pago).firstOrNull;
}

class ProdutoInfo {
  const ProdutoInfo({required this.row, required this.provas});
  final ProdutoRow row;
  final List<String> provas;
}

class SimuladoInfo {
  const SimuladoInfo({
    required this.codigo,
    required this.titulo,
    required this.provas,
    required this.duracaoMin,
    required this.numPerguntas,
    required this.gratuito,
    required this.questoesDisponiveis,
  });
  final String codigo;
  final String titulo;
  final List<String> provas;
  final int duracaoMin;
  final int numPerguntas;
  final bool gratuito;
  final int questoesDisponiveis;
}

String iconeDisciplina(String codigo) => switch (codigo) {
      'MAT' => '📐',
      'FIS' => '⚛️',
      'QUI' => '🧪',
      'BIO' => '🧬',
      'POR' => '📖',
      'ING' => '🇬🇧',
      'FRA' => '🇫🇷',
      'HIS' => '🏛️',
      'GEO' => '🌍',
      'FIL' => '💭',
      'DES' => '✏️',
      'EDF' => '🏃',
      _ => '📘',
    };

// ───────────── Conteúdo ─────────────

class ConteudoRepo {
  ConteudoRepo(this.db);
  final ContentDb db;

  Future<Regras> regras() async => Regras(
        notaMinimaPadrao: int.tryParse(await db.lerMeta('nota_minima_padrao') ?? '') ?? notaMinimaPadraoOmissao,
        niveisGratis: int.tryParse(await db.lerMeta('niveis_gratis') ?? '') ?? niveisGratisOmissao,
      );

  Future<bool> temConteudo() async => (await db.lerMeta('versao_app')) != null;

  Future<Map<String, List<String>>> _instituicoesPorGrupo() async {
    final out = <String, List<String>>{};
    for (final i in await (db.select(db.instituicoes)..orderBy([(t) => OrderingTerm(expression: t.sigla)])).get()) {
      (out[i.grupoExame] ??= []).add(i.sigla);
    }
    return out;
  }

  Future<List<ProvaInfo>> _provasInfo(Iterable<ProvaRow> rows) async {
    final disc = {for (final d in await db.select(db.disciplinas).get()) d.codigo: d};
    final grupos = await _instituicoesPorGrupo();
    return [
      for (final r in rows)
        ProvaInfo(
          row: r,
          disciplinaNome: disc[r.disciplina]?.nome ?? r.disciplina,
          disciplinaIcone: disc[r.disciplina]?.icone,
          instituicoes: grupos[r.grupoExame] ?? [r.grupoExame],
        ),
    ];
  }

  Future<ProvaInfo?> prova(String codigo) async {
    final r = await (db.select(db.provas)..where((t) => t.codigo.equals(codigo))).getSingleOrNull();
    return r == null ? null : (await _provasInfo([r])).first;
  }

  Future<List<InstituicaoRow>> instituicoes() => (db.select(db.instituicoes)..orderBy([(t) => OrderingTerm(expression: t.sigla)])).get();

  /// Ofertas (curso numa instituição) com as provas exigidas. Filtros opcionais.
  Future<List<OfertaInfo>> ofertas({String pesquisa = '', String? instituicao, List<String>? codigos}) async {
    final q = db.select(db.ofertas)..orderBy([(t) => OrderingTerm(expression: t.nome), (t) => OrderingTerm(expression: t.instituicao)]);
    if (instituicao != null) q.where((t) => t.instituicao.equals(instituicao));
    if (codigos != null) q.where((t) => t.codigo.isIn(codigos));
    var rows = await q.get();
    if (pesquisa.trim().isNotEmpty) {
      final p = _semAcentos(pesquisa.trim().toLowerCase());
      rows = rows.where((o) => _semAcentos('${o.nome} ${o.nomeOriginal} ${o.instituicao}'.toLowerCase()).contains(p)).toList();
    }
    final ligacoes = await (db.select(db.ofertaProva)..orderBy([(t) => OrderingTerm(expression: t.ordem)])).get();
    final provas = {for (final p in await _provasInfo(await db.select(db.provas).get())) p.codigo: p};
    final siglas = {for (final i in await db.select(db.instituicoes).get()) i.codigo: i.sigla};
    final porOferta = <String, List<ProvaInfo>>{};
    for (final l in ligacoes) {
      final p = provas[l.prova];
      if (p != null) (porOferta[l.oferta] ??= []).add(p);
    }
    return [
      for (final o in rows) OfertaInfo(row: o, instituicaoSigla: siglas[o.instituicao] ?? o.instituicao, provas: porOferta[o.codigo] ?? const []),
    ];
  }

  /// Provas exigidas pelas ofertas (sem repetir), pela ordem dos objectivos.
  Future<List<ProvaInfo>> provasDasOfertas(List<String> ofertas) async {
    if (ofertas.isEmpty) return [];
    final info = await this.ofertas(codigos: ofertas);
    final vistas = <String>{};
    return [
      for (final codigo in ofertas)
        for (final o in info.where((x) => x.codigo == codigo))
          for (final p in o.provas)
            if (vistas.add(p.codigo)) p,
    ];
  }

  Future<Map<int, int>> questoesPorNivel(String prova) async {
    final c = db.questaoProva.questao.count();
    final rows = await (db.selectOnly(db.questaoProva)
          ..addColumns([db.questaoProva.nivel, c])
          ..where(db.questaoProva.prova.equals(prova))
          ..groupBy([db.questaoProva.nivel]))
        .get();
    return {for (final r in rows) r.read(db.questaoProva.nivel)!: r.read(c)!};
  }

  /// Os 10 níveis da prova (com títulos por omissão se faltarem).
  Future<List<NivelRow>> niveis(String prova) async {
    final rows = {for (final n in await (db.select(db.niveis)..where((t) => t.prova.equals(prova))).get()) n.numero: n};
    return [for (var i = 1; i <= numNiveis; i++) rows[i] ?? NivelRow(prova: prova, numero: i, titulo: 'Nível $i')];
  }

  /// Provas que têm pelo menos uma questão na content.db.
  Future<Set<String>> provasComQuestoes() async {
    final rows = await (db.selectOnly(db.questaoProva, distinct: true)..addColumns([db.questaoProva.prova])).get();
    return {for (final r in rows) r.read(db.questaoProva.prova)!};
  }

  Future<int?> pacoteInstalado(String prova) async =>
      (await (db.select(db.pacotesInstalados)..where((t) => t.prova.equals(prova))).getSingleOrNull())?.versao;

  Future<List<QuestaoQuiz>> _montar(List<QuestaoRow> qs, Map<String, int> niveis) async {
    if (qs.isEmpty) return [];
    final codigos = [for (final q in qs) q.codigo];
    final alts = await (db.select(db.alternativas)
          ..where((a) => a.questao.isIn(codigos))
          ..orderBy([(a) => OrderingTerm(expression: a.ordem)]))
        .get();
    final porQuestao = <String, List<AlternativaRow>>{};
    for (final a in alts) {
      (porQuestao[a.questao] ??= []).add(a);
    }
    final temas = {for (final t in await db.select(db.temas).get()) t.codigo: t.nome};
    final idsTexto = qs.map((q) => q.textoBase).whereType<String>().toSet();
    final textos = {
      for (final t in await (db.select(db.textosBase)..where((t) => t.codigo.isIn(idsTexto))).get()) t.codigo: t,
    };
    return [
      for (final q in qs)
        QuestaoQuiz(
          codigo: q.codigo,
          tipo: q.tipo,
          enunciado: q.enunciado,
          explicacao: q.explicacao,
          imagens: [for (final i in jsonDecode(q.imagens) as List) i as String],
          dica: q.dica,
          tema: q.tema,
          temaNome: q.tema == null ? null : temas[q.tema],
          textoBase: q.textoBase == null ? null : textos[q.textoBase]?.texto,
          textoBaseTitulo: q.textoBase == null ? null : textos[q.textoBase]?.titulo,
          ano: q.ano,
          nivel: niveis[q.codigo],
          alternativas: [
            for (final a in porQuestao[q.codigo] ?? const <AlternativaRow>[])
              AlternativaQuiz(letra: a.letra, texto: a.texto, imagem: a.imagem, correcta: a.correcta),
          ],
        ),
    ];
  }

  Future<List<QuestaoQuiz>> questoes(String prova, {int? nivel}) async {
    final q = db.select(db.questaoProva)..where((t) => t.prova.equals(prova));
    if (nivel != null) q.where((t) => t.nivel.equals(nivel));
    final ligacoes = await q.get();
    final niveis = {for (final l in ligacoes) l.questao: l.nivel};
    final qs = await (db.select(db.questoes)..where((t) => t.codigo.isIn(niveis.keys))).get();
    // Só questões com resposta (exactamente 1 correcta) entram num quiz
    return (await _montar(qs, niveis)).where((q) => q.alternativas.where((a) => a.correcta).length == 1).toList();
  }

  Future<List<QuestaoQuiz>> questoesPorCodigos(List<String> codigos) async {
    final qs = await (db.select(db.questoes)..where((t) => t.codigo.isIn(codigos))).get();
    final ligacoes = await (db.select(db.questaoProva)..where((t) => t.questao.isIn(codigos))).get();
    final porCodigo = {for (final q in await _montar(qs, {for (final l in ligacoes) l.questao: l.nivel})) q.codigo: q};
    return [for (final c in codigos) if (porCodigo[c] != null) porCodigo[c]!];
  }

  /// Tema de cada questão (para os temas a reforçar).
  Future<Map<String, String?>> temaDasQuestoes(Iterable<String> codigos) async => {
        for (final q in await (db.select(db.questoes)..where((t) => t.codigo.isIn(codigos))).get()) q.codigo: q.tema,
      };

  Future<Map<String, String>> temas() async => {for (final t in await db.select(db.temas).get()) t.codigo: t.nome};

  Future<Map<String, String>> disciplinaDoTema() async => {for (final t in await db.select(db.temas).get()) t.codigo: t.disciplina};

  Future<List<ProdutoInfo>> produtos({String? prova, String? tipo}) async {
    final ligacoes = await db.select(db.produtoProva).get();
    final provasDe = <String, List<String>>{};
    for (final l in ligacoes) {
      (provasDe[l.produto] ??= []).add(l.prova);
    }
    final q = db.select(db.produtos)..orderBy([(t) => OrderingTerm(expression: t.ordem), (t) => OrderingTerm(expression: t.precoMt)]);
    if (tipo != null) q.where((t) => t.tipo.equals(tipo));
    return [
      for (final p in await q.get())
        if (prova == null || (provasDe[p.codigo] ?? const []).contains(prova)) ProdutoInfo(row: p, provas: provasDe[p.codigo] ?? const []),
    ];
  }

  /// Simulados das provas: os definidos no conteúdo e, para cada prova sem nenhum, um automático
  /// com a duração e o nº de questões do exame (ou 90 min / 40 questões).
  Future<List<SimuladoInfo>> simulados(List<ProvaInfo> provas) async {
    final definidos = await db.select(db.simulados).get();
    final out = <SimuladoInfo>[];
    for (final p in provas) {
      final porNivel = await questoesPorNivel(p.codigo);
      final disponiveis = porNivel.values.fold(0, (a, b) => a + b);
      final daProva = definidos.where((s) => s.prova == p.codigo).toList();
      if (daProva.isEmpty) {
        out.add(SimuladoInfo(
          codigo: 'AUTO-${p.codigo}',
          titulo: 'Simulado de ${p.disciplinaNome}',
          provas: [p.codigo],
          duracaoMin: p.row.duracaoMin ?? 90,
          numPerguntas: p.row.numQuestoes ?? 40,
          gratuito: false,
          questoesDisponiveis: disponiveis,
        ));
      }
      for (final s in daProva) {
        out.add(SimuladoInfo(
          codigo: s.codigo,
          titulo: s.titulo,
          provas: [p.codigo],
          duracaoMin: s.duracaoMin,
          numPerguntas: s.numPerguntas,
          gratuito: s.gratuito,
          questoesDisponiveis: disponiveis,
        ));
      }
    }
    return out;
  }

  /// Simulado pelo código (`AUTO-PROVA` ou um definido no conteúdo).
  Future<SimuladoInfo?> simulado(String codigo) async {
    String? prova;
    if (codigo.startsWith('AUTO-')) {
      prova = codigo.substring(5);
    } else {
      prova = (await (db.select(db.simulados)..where((t) => t.codigo.equals(codigo))).getSingleOrNull())?.prova;
    }
    if (prova == null) return null;
    final info = await this.prova(prova);
    if (info == null) return null;
    return (await simulados([info])).where((s) => s.codigo == codigo).firstOrNull;
  }

  static String _semAcentos(String s) {
    const de = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const para = 'aaaaaeeeeiiiiooooouuuucn';
    final b = StringBuffer();
    for (final c in s.split('')) {
      final i = de.indexOf(c);
      b.write(i >= 0 ? para[i] : c);
    }
    return b.toString();
  }
}

// ───────────── Utilizador ─────────────

class ResumoTema {
  const ResumoTema({required this.tema, required this.nome, required this.disciplina, required this.total, required this.certas});
  final String tema;
  final String nome;
  final String disciplina;
  final int total;
  final int certas;
  double get fraccao => total == 0 ? 0 : certas / total;
}

class UtilizadorRepo {
  UtilizadorRepo(this.db);
  final UserDb db;

  Future<PerfilRow?> perfil() => db.select(db.perfil).getSingleOrNull();

  Future<void> gravarPerfil({required String nome, required String avatar}) async {
    final actual = await perfil();
    await db.into(db.perfil).insertOnConflictUpdate(
          PerfilCompanion.insert(id: const Value(1), nome: nome, avatar: avatar, criadoEm: actual?.criadoEm ?? DateTime.now()),
        );
  }

  Future<List<String>> objectivos() async =>
      [for (final o in await (db.select(db.objectivos)..orderBy([(t) => OrderingTerm(expression: t.criadoEm)])).get()) o.oferta];

  Future<void> definirObjectivos(List<String> ofertas) => db.transaction(() async {
        final actuais = await objectivos();
        await (db.delete(db.objectivos)..where((t) => t.oferta.isNotIn(ofertas))).go();
        var i = 0;
        for (final o in ofertas.where((o) => !actuais.contains(o))) {
          await db.into(db.objectivos).insert(ObjectivosCompanion.insert(oferta: o, criadoEm: DateTime.now().add(Duration(milliseconds: i++))));
        }
      });

  /// Melhor percentagem e nº de tentativas por nível (modo praticar).
  Future<Map<int, ({double melhor, int tentativas})>> resumoNiveis(String prova) async {
    final ts = await (db.select(db.tentativas)..where((t) => t.prova.equals(prova) & t.nivel.isNotNull())).get();
    final out = <int, ({double melhor, int tentativas})>{};
    for (final t in ts) {
      final a = out[t.nivel!];
      out[t.nivel!] = (melhor: max(a?.melhor ?? 0, t.percentagem), tentativas: (a?.tentativas ?? 0) + 1);
    }
    return out;
  }

  Future<List<TentativaRow>> tentativasDoNivel(String prova, int nivel) => (db.select(db.tentativas)
        ..where((t) => t.prova.equals(prova) & t.nivel.equals(nivel))
        ..orderBy([(t) => OrderingTerm(expression: t.terminadaEm, mode: OrderingMode.desc)]))
      .get();

  Future<List<TentativaRow>> historico({int? limite, DateTime? desde, bool? simulados}) {
    final q = db.select(db.tentativas)..orderBy([(t) => OrderingTerm(expression: t.terminadaEm, mode: OrderingMode.desc)]);
    if (desde != null) q.where((t) => t.terminadaEm.isBiggerOrEqualValue(desde));
    if (simulados == true) q.where((t) => t.simulado.isNotNull());
    if (simulados == false) q.where((t) => t.simulado.isNull());
    if (limite != null) q.limit(limite);
    return q.get();
  }

  Future<TentativaRow?> tentativa(String id) => (db.select(db.tentativas)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<RespostaRow>> respostas(String tentativa) =>
      (db.select(db.respostas)..where((r) => r.tentativa.equals(tentativa))..orderBy([(r) => OrderingTerm(expression: r.posicao)])).get();

  /// Grava a tentativa e as respostas. Devolve o id.
  Future<String> gravarTentativa(SessaoQuiz s, {required String prova, int? nivel, String? simulado, required int notaMinima}) async {
    final id = const Uuid().v4();
    final agora = DateTime.now();
    await db.transaction(() async {
      await db.into(db.tentativas).insert(TentativasCompanion.insert(
            id: id,
            prova: prova,
            nivel: Value(nivel),
            simulado: Value(simulado),
            iniciadaEm: s.iniciadaEm,
            terminadaEm: agora,
            duracaoSeg: agora.difference(s.iniciadaEm).inSeconds,
            total: s.total,
            certas: s.certas,
            erradas: s.erradas,
            comAjuda: s.comAjuda,
            percentagem: s.percentagem,
            aprovado: s.percentagem >= notaMinima,
          ));
      await db.batch((b) => b.insertAll(db.respostas, [
            for (final (i, r) in s.respostas.indexed)
              RespostasCompanion.insert(
                tentativa: id,
                questao: r.questao.codigo,
                posicao: i,
                letra: Value(r.alternativaEscolhida?.letra),
                correcta: r.contaComoCerta,
                usouDica: Value(r.usouDica),
                viuResposta: Value(r.viuResposta),
                marcada: Value(r.marcada),
                ordemAlternativas: jsonEncode([for (final a in r.ordem) a.letra]),
                tempoSeg: Value(r.tempoSeg),
              ),
          ]));
    });
    return id;
  }

  /// Taxa de acerto por tema (só temas com pelo menos [minimo] respostas), do pior para o melhor.
  Future<List<ResumoTema>> temasFracos(Map<String, String?> temaDaQuestao, Map<String, String> nomeTema, Map<String, String> discDoTema,
      {int minimo = 3}) async {
    final contagem = <String, (int, int)>{};
    for (final r in await db.select(db.respostas).get()) {
      final tema = temaDaQuestao[r.questao];
      if (tema == null) continue;
      final (t, c) = contagem[tema] ?? (0, 0);
      contagem[tema] = (t + 1, c + (r.correcta ? 1 : 0));
    }
    final lista = [
      for (final MapEntry(:key, :value) in contagem.entries)
        if (value.$1 >= minimo)
          ResumoTema(tema: key, nome: nomeTema[key] ?? key, disciplina: discDoTema[key] ?? '', total: value.$1, certas: value.$2),
    ]..sort((a, b) => a.fraccao.compareTo(b.fraccao));
    return lista;
  }

  Future<Set<String>> questoesRespondidas() async => {for (final r in await db.select(db.respostas).get()) r.questao};

  /// Dias seguidos com pelo menos uma tentativa (até hoje ou ontem).
  Future<int> diasSeguidos([DateTime? hoje]) async {
    final dias = {for (final t in await db.select(db.tentativas).get()) _dia(t.terminadaEm)};
    var d = _dia(hoje ?? DateTime.now());
    if (!dias.contains(d)) d = d.subtract(const Duration(days: 1));
    var n = 0;
    while (dias.contains(d)) {
      n++;
      d = d.subtract(const Duration(days: 1));
    }
    return n;
  }

  static DateTime _dia(DateTime t) => DateTime(t.year, t.month, t.day);

  // ───── preferências ─────

  Future<String> dispositivoId() async {
    final id = await db.pref('dispositivo_id');
    if (id != null) return id;
    final novo = const Uuid().v4();
    await db.definirPref('dispositivo_id', novo);
    return novo;
  }

  Future<String?> token() => db.pref('token');
  Future<void> gravarToken(String t) => db.definirPref('token', t);

  Future<bool> temaEscuro() async => (await db.pref('tema_escuro')) == '1';
  Future<void> gravarTemaEscuro(bool v) => db.definirPref('tema_escuro', v ? '1' : '0');

  Future<Map<String, dynamic>> contactos() async {
    final j = await db.pref('contactos');
    return j == null ? <String, dynamic>{} : jsonDecode(j) as Map<String, dynamic>;
  }

  Future<void> gravarContactos(Map<String, dynamic> c) => db.definirPref('contactos', jsonEncode(c));
}

/// Junta conteúdo + progresso + licenças para o ecrã de níveis.
Future<ProvaDetalhe?> detalheDaProva(ConteudoRepo conteudo, UtilizadorRepo user, List<Licenca> licencas, String prova) async {
  final info = await conteudo.prova(prova);
  if (info == null) return null;
  final regras = await conteudo.regras();
  final niveis = await conteudo.niveis(prova);
  final contagem = await conteudo.questoesPorNivel(prova);
  final resumo = await user.resumoNiveis(prova);
  final pacote = await conteudo.pacoteInstalado(prova);
  final temLicenca = licencas.any((l) => l.cobre(prova, 'niveis'));
  final dados = [
    for (final n in niveis)
      DadosNivel(numero: n.numero, numQuestoes: contagem[n.numero] ?? 0, notaMinima: n.notaMinima, melhorPercentagem: resumo[n.numero]?.melhor),
  ];
  final estados = regras.estados(dados, temLicenca: temLicenca, pacoteInstalado: pacote != null);
  return ProvaDetalhe(
    prova: info,
    temLicenca: temLicenca,
    pacoteVersao: pacote,
    regras: regras,
    niveis: [
      for (final (i, n) in niveis.indexed)
        NivelInfo(
          row: n,
          numQuestoes: dados[i].numQuestoes,
          estado: estados[i],
          notaMinima: regras.notaMinima(dados[i]),
          melhor: dados[i].melhorPercentagem,
          tentativas: resumo[n.numero]?.tentativas ?? 0,
        ),
    ],
  );
}
