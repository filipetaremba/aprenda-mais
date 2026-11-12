import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'user_db.g.dart';

/// user.db: tudo o que é do estudante (perfil, objectivos, tentativas, licenças).
/// NUNCA é apagada nem tocada pela importação de conteúdo.

@DataClassName('PerfilRow')
class Perfil extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get nome => text()();
  TextColumn get avatar => text()();
  DateTimeColumn get criadoEm => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ObjectivoRow')
class Objectivos extends Table {
  TextColumn get oferta => text()();
  DateTimeColumn get criadoEm => dateTime()();
  @override
  Set<Column> get primaryKey => {oferta};
}

@DataClassName('TentativaRow')
class Tentativas extends Table {
  TextColumn get id => text()();
  TextColumn get prova => text()();
  /// Nível praticado (null num simulado)
  IntColumn get nivel => integer().nullable()();
  TextColumn get simulado => text().nullable()();
  DateTimeColumn get iniciadaEm => dateTime()();
  DateTimeColumn get terminadaEm => dateTime()();
  IntColumn get duracaoSeg => integer()();
  IntColumn get total => integer()();
  IntColumn get certas => integer()();
  IntColumn get erradas => integer()();
  /// Nº de questões em que viu a resposta
  IntColumn get comAjuda => integer()();
  RealColumn get percentagem => real()();
  BoolColumn get aprovado => boolean()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RespostaRow')
class Respostas extends Table {
  TextColumn get tentativa => text()();
  TextColumn get questao => text()();
  IntColumn get posicao => integer()();
  /// Letra ORIGINAL escolhida (as alternativas são baralhadas na apresentação)
  TextColumn get letra => text().nullable()();
  BoolColumn get correcta => boolean()();
  BoolColumn get usouDica => boolean().withDefault(const Constant(false))();
  BoolColumn get viuResposta => boolean().withDefault(const Constant(false))();
  BoolColumn get marcada => boolean().withDefault(const Constant(false))();
  /// JSON: letras pela ordem em que foram mostradas
  TextColumn get ordemAlternativas => text()();
  IntColumn get tempoSeg => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {tentativa, questao};
}

/// Licenças recebidas do servidor. Só se guardam depois de verificar a assinatura Ed25519.
@DataClassName('LicencaRow')
class Licencas extends Table {
  TextColumn get id => text()();
  TextColumn get produto => text()();
  TextColumn get tipo => text()();
  /// JSON: provas cobertas
  TextColumn get provas => text()();
  DateTimeColumn get validoAte => dateTime().nullable()();
  /// Texto assinado tal como veio do servidor
  TextColumn get conteudo => text()();
  TextColumn get assinatura => text()();
  DateTimeColumn get recebidaEm => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

/// Chave-valor: dispositivo_id, token, tema_escuro, contactos (JSON), onboarding…
@DataClassName('PreferenciaRow')
class Preferencias extends Table {
  TextColumn get chave => text()();
  TextColumn get valor => text()();
  @override
  Set<Column> get primaryKey => {chave};
}

@DriftDatabase(tables: [Perfil, Objectivos, Tentativas, Respostas, Licencas, Preferencias])
class UserDb extends _$UserDb {
  UserDb(super.e);

  factory UserDb.abrir() => UserDb(driftDatabase(name: 'user'));

  @override
  int get schemaVersion => 1;

  Future<String?> pref(String chave) async =>
      (await (select(preferencias)..where((p) => p.chave.equals(chave))).getSingleOrNull())?.valor;

  Future<void> definirPref(String chave, String valor) =>
      into(preferencias).insertOnConflictUpdate(PreferenciasCompanion.insert(chave: chave, valor: valor));

  Future<void> apagarPref(String chave) => (delete(preferencias)..where((p) => p.chave.equals(chave))).go();
}
