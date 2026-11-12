import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'content_db.g.dart';

/// content.db: conteúdo de estudo. Vem do APK (níveis grátis) e dos pacotes
/// descarregados (níveis pagos). Pode ser reconstruída; nunca guarda dados do estudante.
/// Chaves de texto = códigos do backend/seeds (ex.: UEM-MAT2, UEM-MAT2-2025-005).

@DataClassName('GrupoExameRow')
class GruposExame extends Table {
  TextColumn get codigo => text()();
  TextColumn get nome => text()();
  BoolColumn get temGabarito => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('InstituicaoRow')
class Instituicoes extends Table {
  TextColumn get codigo => text()();
  TextColumn get sigla => text()();
  TextColumn get nome => text()();
  TextColumn get grupoExame => text()();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('DisciplinaRow')
class Disciplinas extends Table {
  TextColumn get codigo => text()();
  TextColumn get nome => text()();
  TextColumn get icone => text().nullable()();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('TemaRow')
class Temas extends Table {
  TextColumn get codigo => text()();
  TextColumn get disciplina => text()();
  TextColumn get nome => text()();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('ProvaRow')
class Provas extends Table {
  TextColumn get codigo => text()();
  TextColumn get grupoExame => text()();
  TextColumn get disciplina => text()();
  TextColumn get variante => text().nullable()();
  TextColumn get nome => text()();
  IntColumn get duracaoMin => integer().nullable()();
  IntColumn get numQuestoes => integer().nullable()();
  @override
  Set<Column> get primaryKey => {codigo};
}

/// Oferta = curso numa instituição (o "objectivo" do estudante).
@DataClassName('OfertaRow')
class Ofertas extends Table {
  TextColumn get codigo => text()();
  TextColumn get instituicao => text()();
  TextColumn get curso => text()();
  TextColumn get nome => text()();
  TextColumn get icone => text().nullable()();
  TextColumn get nomeOriginal => text()();
  TextColumn get faculdade => text().withDefault(const Constant(''))();
  TextColumn get locais => text().withDefault(const Constant('[]'))();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('OfertaProvaRow')
class OfertaProva extends Table {
  TextColumn get oferta => text()();
  TextColumn get prova => text()();
  IntColumn get peso => integer().nullable()();
  IntColumn get ordem => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {oferta, prova};
}

@DataClassName('NivelRow')
class Niveis extends Table {
  TextColumn get prova => text()();
  IntColumn get numero => integer()();
  TextColumn get titulo => text()();
  TextColumn get descricao => text().nullable()();
  IntColumn get notaMinima => integer().nullable()();
  @override
  Set<Column> get primaryKey => {prova, numero};
}

@DataClassName('TextoBaseRow')
class TextosBase extends Table {
  TextColumn get codigo => text()();
  TextColumn get titulo => text().nullable()();
  TextColumn get texto => text()();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('QuestaoRow')
class Questoes extends Table {
  TextColumn get codigo => text()();
  TextColumn get tema => text().nullable()();
  TextColumn get textoBase => text().nullable()();
  /// escolha_multipla | verdadeiro_falso
  TextColumn get tipo => text()();
  TextColumn get enunciado => text()();
  /// JSON: lista de nomes de imagem
  TextColumn get imagens => text().withDefault(const Constant('[]'))();
  TextColumn get dica => text().nullable()();
  TextColumn get explicacao => text()();
  IntColumn get ano => integer().nullable()();
  IntColumn get dificuldade => integer().nullable()();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('QuestaoProvaRow')
class QuestaoProva extends Table {
  TextColumn get questao => text()();
  TextColumn get prova => text()();
  IntColumn get nivel => integer()();
  @override
  Set<Column> get primaryKey => {questao, prova};
}

@DataClassName('AlternativaRow')
class Alternativas extends Table {
  TextColumn get questao => text()();
  TextColumn get letra => text()();
  TextColumn get texto => text().nullable()();
  TextColumn get imagem => text().nullable()();
  BoolColumn get correcta => boolean().withDefault(const Constant(false))();
  IntColumn get ordem => integer()();
  @override
  Set<Column> get primaryKey => {questao, letra};
}

@DataClassName('SimuladoRow')
class Simulados extends Table {
  TextColumn get codigo => text()();
  TextColumn get prova => text().nullable()();
  TextColumn get oferta => text().nullable()();
  TextColumn get titulo => text()();
  IntColumn get duracaoMin => integer()();
  IntColumn get numPerguntas => integer()();
  BoolColumn get gratuito => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('ProdutoRow')
class Produtos extends Table {
  TextColumn get codigo => text()();
  TextColumn get nome => text()();
  TextColumn get descricao => text().nullable()();
  /// niveis | simulados
  TextColumn get tipo => text()();
  IntColumn get precoMt => integer()();
  TextColumn get epoca => text().nullable()();
  IntColumn get ordem => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('ProdutoProvaRow')
class ProdutoProva extends Table {
  TextColumn get produto => text()();
  TextColumn get prova => text()();
  @override
  Set<Column> get primaryKey => {produto, prova};
}

/// Pacotes pagos já importados (por prova).
@DataClassName('PacoteInstaladoRow')
class PacotesInstalados extends Table {
  TextColumn get prova => text()();
  IntColumn get versao => integer()();
  TextColumn get sha256 => text()();
  DateTimeColumn get instaladoEm => dateTime()();
  @override
  Set<Column> get primaryKey => {prova};
}

/// Chave-valor: versao_app (conteúdo embutido importado), nota_minima_padrao, niveis_gratis.
@DataClassName('MetaRow')
class Meta extends Table {
  TextColumn get chave => text()();
  TextColumn get valor => text()();
  @override
  Set<Column> get primaryKey => {chave};
}

@DriftDatabase(tables: [
  GruposExame,
  Instituicoes,
  Disciplinas,
  Temas,
  Provas,
  Ofertas,
  OfertaProva,
  Niveis,
  TextosBase,
  Questoes,
  QuestaoProva,
  Alternativas,
  Simulados,
  Produtos,
  ProdutoProva,
  PacotesInstalados,
  Meta,
])
class ContentDb extends _$ContentDb {
  ContentDb(super.e);

  /// Base no telemóvel (ficheiro content.sqlite na pasta da app).
  factory ContentDb.abrir() => ContentDb(driftDatabase(name: 'content'));

  @override
  int get schemaVersion => 1;

  Future<String?> lerMeta(String chave) async =>
      (await (select(meta)..where((m) => m.chave.equals(chave))).getSingleOrNull())?.valor;

  Future<void> gravarMeta(String chave, String valor) =>
      into(meta).insertOnConflictUpdate(MetaCompanion.insert(chave: chave, valor: valor));
}
