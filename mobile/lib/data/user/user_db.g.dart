// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_db.dart';

// ignore_for_file: type=lint
class $PerfilTable extends Perfil with TableInfo<$PerfilTable, PerfilRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerfilTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, avatar, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'perfil';
  @override
  VerificationContext validateIntegrity(
    Insertable<PerfilRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PerfilRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PerfilRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $PerfilTable createAlias(String alias) {
    return $PerfilTable(attachedDatabase, alias);
  }
}

class PerfilRow extends DataClass implements Insertable<PerfilRow> {
  final int id;
  final String nome;
  final String avatar;
  final DateTime criadoEm;
  const PerfilRow({
    required this.id,
    required this.nome,
    required this.avatar,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['avatar'] = Variable<String>(avatar);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  PerfilCompanion toCompanion(bool nullToAbsent) {
    return PerfilCompanion(
      id: Value(id),
      nome: Value(nome),
      avatar: Value(avatar),
      criadoEm: Value(criadoEm),
    );
  }

  factory PerfilRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PerfilRow(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      avatar: serializer.fromJson<String>(json['avatar']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'avatar': serializer.toJson<String>(avatar),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  PerfilRow copyWith({
    int? id,
    String? nome,
    String? avatar,
    DateTime? criadoEm,
  }) => PerfilRow(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    avatar: avatar ?? this.avatar,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  PerfilRow copyWithCompanion(PerfilCompanion data) {
    return PerfilRow(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PerfilRow(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('avatar: $avatar, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, avatar, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PerfilRow &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.avatar == this.avatar &&
          other.criadoEm == this.criadoEm);
}

class PerfilCompanion extends UpdateCompanion<PerfilRow> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> avatar;
  final Value<DateTime> criadoEm;
  const PerfilCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.avatar = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  PerfilCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String avatar,
    required DateTime criadoEm,
  }) : nome = Value(nome),
       avatar = Value(avatar),
       criadoEm = Value(criadoEm);
  static Insertable<PerfilRow> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? avatar,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (avatar != null) 'avatar': avatar,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  PerfilCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? avatar,
    Value<DateTime>? criadoEm,
  }) {
    return PerfilCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      avatar: avatar ?? this.avatar,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerfilCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('avatar: $avatar, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

class $ObjectivosTable extends Objectivos
    with TableInfo<$ObjectivosTable, ObjectivoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObjectivosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ofertaMeta = const VerificationMeta('oferta');
  @override
  late final GeneratedColumn<String> oferta = GeneratedColumn<String>(
    'oferta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [oferta, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'objectivos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObjectivoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('oferta')) {
      context.handle(
        _ofertaMeta,
        oferta.isAcceptableOrUnknown(data['oferta']!, _ofertaMeta),
      );
    } else if (isInserting) {
      context.missing(_ofertaMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {oferta};
  @override
  ObjectivoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObjectivoRow(
      oferta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oferta'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $ObjectivosTable createAlias(String alias) {
    return $ObjectivosTable(attachedDatabase, alias);
  }
}

class ObjectivoRow extends DataClass implements Insertable<ObjectivoRow> {
  final String oferta;
  final DateTime criadoEm;
  const ObjectivoRow({required this.oferta, required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['oferta'] = Variable<String>(oferta);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  ObjectivosCompanion toCompanion(bool nullToAbsent) {
    return ObjectivosCompanion(
      oferta: Value(oferta),
      criadoEm: Value(criadoEm),
    );
  }

  factory ObjectivoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObjectivoRow(
      oferta: serializer.fromJson<String>(json['oferta']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'oferta': serializer.toJson<String>(oferta),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  ObjectivoRow copyWith({String? oferta, DateTime? criadoEm}) => ObjectivoRow(
    oferta: oferta ?? this.oferta,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  ObjectivoRow copyWithCompanion(ObjectivosCompanion data) {
    return ObjectivoRow(
      oferta: data.oferta.present ? data.oferta.value : this.oferta,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObjectivoRow(')
          ..write('oferta: $oferta, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(oferta, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObjectivoRow &&
          other.oferta == this.oferta &&
          other.criadoEm == this.criadoEm);
}

class ObjectivosCompanion extends UpdateCompanion<ObjectivoRow> {
  final Value<String> oferta;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const ObjectivosCompanion({
    this.oferta = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObjectivosCompanion.insert({
    required String oferta,
    required DateTime criadoEm,
    this.rowid = const Value.absent(),
  }) : oferta = Value(oferta),
       criadoEm = Value(criadoEm);
  static Insertable<ObjectivoRow> custom({
    Expression<String>? oferta,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (oferta != null) 'oferta': oferta,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObjectivosCompanion copyWith({
    Value<String>? oferta,
    Value<DateTime>? criadoEm,
    Value<int>? rowid,
  }) {
    return ObjectivosCompanion(
      oferta: oferta ?? this.oferta,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (oferta.present) {
      map['oferta'] = Variable<String>(oferta.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObjectivosCompanion(')
          ..write('oferta: $oferta, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TentativasTable extends Tentativas
    with TableInfo<$TentativasTable, TentativaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TentativasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provaMeta = const VerificationMeta('prova');
  @override
  late final GeneratedColumn<String> prova = GeneratedColumn<String>(
    'prova',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nivelMeta = const VerificationMeta('nivel');
  @override
  late final GeneratedColumn<int> nivel = GeneratedColumn<int>(
    'nivel',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _simuladoMeta = const VerificationMeta(
    'simulado',
  );
  @override
  late final GeneratedColumn<String> simulado = GeneratedColumn<String>(
    'simulado',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iniciadaEmMeta = const VerificationMeta(
    'iniciadaEm',
  );
  @override
  late final GeneratedColumn<DateTime> iniciadaEm = GeneratedColumn<DateTime>(
    'iniciada_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _terminadaEmMeta = const VerificationMeta(
    'terminadaEm',
  );
  @override
  late final GeneratedColumn<DateTime> terminadaEm = GeneratedColumn<DateTime>(
    'terminada_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duracaoSegMeta = const VerificationMeta(
    'duracaoSeg',
  );
  @override
  late final GeneratedColumn<int> duracaoSeg = GeneratedColumn<int>(
    'duracao_seg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _certasMeta = const VerificationMeta('certas');
  @override
  late final GeneratedColumn<int> certas = GeneratedColumn<int>(
    'certas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _erradasMeta = const VerificationMeta(
    'erradas',
  );
  @override
  late final GeneratedColumn<int> erradas = GeneratedColumn<int>(
    'erradas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _comAjudaMeta = const VerificationMeta(
    'comAjuda',
  );
  @override
  late final GeneratedColumn<int> comAjuda = GeneratedColumn<int>(
    'com_ajuda',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentagemMeta = const VerificationMeta(
    'percentagem',
  );
  @override
  late final GeneratedColumn<double> percentagem = GeneratedColumn<double>(
    'percentagem',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aprovadoMeta = const VerificationMeta(
    'aprovado',
  );
  @override
  late final GeneratedColumn<bool> aprovado = GeneratedColumn<bool>(
    'aprovado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aprovado" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prova,
    nivel,
    simulado,
    iniciadaEm,
    terminadaEm,
    duracaoSeg,
    total,
    certas,
    erradas,
    comAjuda,
    percentagem,
    aprovado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tentativas';
  @override
  VerificationContext validateIntegrity(
    Insertable<TentativaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('prova')) {
      context.handle(
        _provaMeta,
        prova.isAcceptableOrUnknown(data['prova']!, _provaMeta),
      );
    } else if (isInserting) {
      context.missing(_provaMeta);
    }
    if (data.containsKey('nivel')) {
      context.handle(
        _nivelMeta,
        nivel.isAcceptableOrUnknown(data['nivel']!, _nivelMeta),
      );
    }
    if (data.containsKey('simulado')) {
      context.handle(
        _simuladoMeta,
        simulado.isAcceptableOrUnknown(data['simulado']!, _simuladoMeta),
      );
    }
    if (data.containsKey('iniciada_em')) {
      context.handle(
        _iniciadaEmMeta,
        iniciadaEm.isAcceptableOrUnknown(data['iniciada_em']!, _iniciadaEmMeta),
      );
    } else if (isInserting) {
      context.missing(_iniciadaEmMeta);
    }
    if (data.containsKey('terminada_em')) {
      context.handle(
        _terminadaEmMeta,
        terminadaEm.isAcceptableOrUnknown(
          data['terminada_em']!,
          _terminadaEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_terminadaEmMeta);
    }
    if (data.containsKey('duracao_seg')) {
      context.handle(
        _duracaoSegMeta,
        duracaoSeg.isAcceptableOrUnknown(data['duracao_seg']!, _duracaoSegMeta),
      );
    } else if (isInserting) {
      context.missing(_duracaoSegMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('certas')) {
      context.handle(
        _certasMeta,
        certas.isAcceptableOrUnknown(data['certas']!, _certasMeta),
      );
    } else if (isInserting) {
      context.missing(_certasMeta);
    }
    if (data.containsKey('erradas')) {
      context.handle(
        _erradasMeta,
        erradas.isAcceptableOrUnknown(data['erradas']!, _erradasMeta),
      );
    } else if (isInserting) {
      context.missing(_erradasMeta);
    }
    if (data.containsKey('com_ajuda')) {
      context.handle(
        _comAjudaMeta,
        comAjuda.isAcceptableOrUnknown(data['com_ajuda']!, _comAjudaMeta),
      );
    } else if (isInserting) {
      context.missing(_comAjudaMeta);
    }
    if (data.containsKey('percentagem')) {
      context.handle(
        _percentagemMeta,
        percentagem.isAcceptableOrUnknown(
          data['percentagem']!,
          _percentagemMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_percentagemMeta);
    }
    if (data.containsKey('aprovado')) {
      context.handle(
        _aprovadoMeta,
        aprovado.isAcceptableOrUnknown(data['aprovado']!, _aprovadoMeta),
      );
    } else if (isInserting) {
      context.missing(_aprovadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TentativaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TentativaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      prova: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prova'],
      )!,
      nivel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nivel'],
      ),
      simulado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simulado'],
      ),
      iniciadaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}iniciada_em'],
      )!,
      terminadaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}terminada_em'],
      )!,
      duracaoSeg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duracao_seg'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      certas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}certas'],
      )!,
      erradas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}erradas'],
      )!,
      comAjuda: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}com_ajuda'],
      )!,
      percentagem: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percentagem'],
      )!,
      aprovado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aprovado'],
      )!,
    );
  }

  @override
  $TentativasTable createAlias(String alias) {
    return $TentativasTable(attachedDatabase, alias);
  }
}

class TentativaRow extends DataClass implements Insertable<TentativaRow> {
  final String id;
  final String prova;

  /// Nível praticado (null num simulado)
  final int? nivel;
  final String? simulado;
  final DateTime iniciadaEm;
  final DateTime terminadaEm;
  final int duracaoSeg;
  final int total;
  final int certas;
  final int erradas;

  /// Nº de questões em que viu a resposta
  final int comAjuda;
  final double percentagem;
  final bool aprovado;
  const TentativaRow({
    required this.id,
    required this.prova,
    this.nivel,
    this.simulado,
    required this.iniciadaEm,
    required this.terminadaEm,
    required this.duracaoSeg,
    required this.total,
    required this.certas,
    required this.erradas,
    required this.comAjuda,
    required this.percentagem,
    required this.aprovado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['prova'] = Variable<String>(prova);
    if (!nullToAbsent || nivel != null) {
      map['nivel'] = Variable<int>(nivel);
    }
    if (!nullToAbsent || simulado != null) {
      map['simulado'] = Variable<String>(simulado);
    }
    map['iniciada_em'] = Variable<DateTime>(iniciadaEm);
    map['terminada_em'] = Variable<DateTime>(terminadaEm);
    map['duracao_seg'] = Variable<int>(duracaoSeg);
    map['total'] = Variable<int>(total);
    map['certas'] = Variable<int>(certas);
    map['erradas'] = Variable<int>(erradas);
    map['com_ajuda'] = Variable<int>(comAjuda);
    map['percentagem'] = Variable<double>(percentagem);
    map['aprovado'] = Variable<bool>(aprovado);
    return map;
  }

  TentativasCompanion toCompanion(bool nullToAbsent) {
    return TentativasCompanion(
      id: Value(id),
      prova: Value(prova),
      nivel: nivel == null && nullToAbsent
          ? const Value.absent()
          : Value(nivel),
      simulado: simulado == null && nullToAbsent
          ? const Value.absent()
          : Value(simulado),
      iniciadaEm: Value(iniciadaEm),
      terminadaEm: Value(terminadaEm),
      duracaoSeg: Value(duracaoSeg),
      total: Value(total),
      certas: Value(certas),
      erradas: Value(erradas),
      comAjuda: Value(comAjuda),
      percentagem: Value(percentagem),
      aprovado: Value(aprovado),
    );
  }

  factory TentativaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TentativaRow(
      id: serializer.fromJson<String>(json['id']),
      prova: serializer.fromJson<String>(json['prova']),
      nivel: serializer.fromJson<int?>(json['nivel']),
      simulado: serializer.fromJson<String?>(json['simulado']),
      iniciadaEm: serializer.fromJson<DateTime>(json['iniciadaEm']),
      terminadaEm: serializer.fromJson<DateTime>(json['terminadaEm']),
      duracaoSeg: serializer.fromJson<int>(json['duracaoSeg']),
      total: serializer.fromJson<int>(json['total']),
      certas: serializer.fromJson<int>(json['certas']),
      erradas: serializer.fromJson<int>(json['erradas']),
      comAjuda: serializer.fromJson<int>(json['comAjuda']),
      percentagem: serializer.fromJson<double>(json['percentagem']),
      aprovado: serializer.fromJson<bool>(json['aprovado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'prova': serializer.toJson<String>(prova),
      'nivel': serializer.toJson<int?>(nivel),
      'simulado': serializer.toJson<String?>(simulado),
      'iniciadaEm': serializer.toJson<DateTime>(iniciadaEm),
      'terminadaEm': serializer.toJson<DateTime>(terminadaEm),
      'duracaoSeg': serializer.toJson<int>(duracaoSeg),
      'total': serializer.toJson<int>(total),
      'certas': serializer.toJson<int>(certas),
      'erradas': serializer.toJson<int>(erradas),
      'comAjuda': serializer.toJson<int>(comAjuda),
      'percentagem': serializer.toJson<double>(percentagem),
      'aprovado': serializer.toJson<bool>(aprovado),
    };
  }

  TentativaRow copyWith({
    String? id,
    String? prova,
    Value<int?> nivel = const Value.absent(),
    Value<String?> simulado = const Value.absent(),
    DateTime? iniciadaEm,
    DateTime? terminadaEm,
    int? duracaoSeg,
    int? total,
    int? certas,
    int? erradas,
    int? comAjuda,
    double? percentagem,
    bool? aprovado,
  }) => TentativaRow(
    id: id ?? this.id,
    prova: prova ?? this.prova,
    nivel: nivel.present ? nivel.value : this.nivel,
    simulado: simulado.present ? simulado.value : this.simulado,
    iniciadaEm: iniciadaEm ?? this.iniciadaEm,
    terminadaEm: terminadaEm ?? this.terminadaEm,
    duracaoSeg: duracaoSeg ?? this.duracaoSeg,
    total: total ?? this.total,
    certas: certas ?? this.certas,
    erradas: erradas ?? this.erradas,
    comAjuda: comAjuda ?? this.comAjuda,
    percentagem: percentagem ?? this.percentagem,
    aprovado: aprovado ?? this.aprovado,
  );
  TentativaRow copyWithCompanion(TentativasCompanion data) {
    return TentativaRow(
      id: data.id.present ? data.id.value : this.id,
      prova: data.prova.present ? data.prova.value : this.prova,
      nivel: data.nivel.present ? data.nivel.value : this.nivel,
      simulado: data.simulado.present ? data.simulado.value : this.simulado,
      iniciadaEm: data.iniciadaEm.present
          ? data.iniciadaEm.value
          : this.iniciadaEm,
      terminadaEm: data.terminadaEm.present
          ? data.terminadaEm.value
          : this.terminadaEm,
      duracaoSeg: data.duracaoSeg.present
          ? data.duracaoSeg.value
          : this.duracaoSeg,
      total: data.total.present ? data.total.value : this.total,
      certas: data.certas.present ? data.certas.value : this.certas,
      erradas: data.erradas.present ? data.erradas.value : this.erradas,
      comAjuda: data.comAjuda.present ? data.comAjuda.value : this.comAjuda,
      percentagem: data.percentagem.present
          ? data.percentagem.value
          : this.percentagem,
      aprovado: data.aprovado.present ? data.aprovado.value : this.aprovado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TentativaRow(')
          ..write('id: $id, ')
          ..write('prova: $prova, ')
          ..write('nivel: $nivel, ')
          ..write('simulado: $simulado, ')
          ..write('iniciadaEm: $iniciadaEm, ')
          ..write('terminadaEm: $terminadaEm, ')
          ..write('duracaoSeg: $duracaoSeg, ')
          ..write('total: $total, ')
          ..write('certas: $certas, ')
          ..write('erradas: $erradas, ')
          ..write('comAjuda: $comAjuda, ')
          ..write('percentagem: $percentagem, ')
          ..write('aprovado: $aprovado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    prova,
    nivel,
    simulado,
    iniciadaEm,
    terminadaEm,
    duracaoSeg,
    total,
    certas,
    erradas,
    comAjuda,
    percentagem,
    aprovado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TentativaRow &&
          other.id == this.id &&
          other.prova == this.prova &&
          other.nivel == this.nivel &&
          other.simulado == this.simulado &&
          other.iniciadaEm == this.iniciadaEm &&
          other.terminadaEm == this.terminadaEm &&
          other.duracaoSeg == this.duracaoSeg &&
          other.total == this.total &&
          other.certas == this.certas &&
          other.erradas == this.erradas &&
          other.comAjuda == this.comAjuda &&
          other.percentagem == this.percentagem &&
          other.aprovado == this.aprovado);
}

class TentativasCompanion extends UpdateCompanion<TentativaRow> {
  final Value<String> id;
  final Value<String> prova;
  final Value<int?> nivel;
  final Value<String?> simulado;
  final Value<DateTime> iniciadaEm;
  final Value<DateTime> terminadaEm;
  final Value<int> duracaoSeg;
  final Value<int> total;
  final Value<int> certas;
  final Value<int> erradas;
  final Value<int> comAjuda;
  final Value<double> percentagem;
  final Value<bool> aprovado;
  final Value<int> rowid;
  const TentativasCompanion({
    this.id = const Value.absent(),
    this.prova = const Value.absent(),
    this.nivel = const Value.absent(),
    this.simulado = const Value.absent(),
    this.iniciadaEm = const Value.absent(),
    this.terminadaEm = const Value.absent(),
    this.duracaoSeg = const Value.absent(),
    this.total = const Value.absent(),
    this.certas = const Value.absent(),
    this.erradas = const Value.absent(),
    this.comAjuda = const Value.absent(),
    this.percentagem = const Value.absent(),
    this.aprovado = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TentativasCompanion.insert({
    required String id,
    required String prova,
    this.nivel = const Value.absent(),
    this.simulado = const Value.absent(),
    required DateTime iniciadaEm,
    required DateTime terminadaEm,
    required int duracaoSeg,
    required int total,
    required int certas,
    required int erradas,
    required int comAjuda,
    required double percentagem,
    required bool aprovado,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       prova = Value(prova),
       iniciadaEm = Value(iniciadaEm),
       terminadaEm = Value(terminadaEm),
       duracaoSeg = Value(duracaoSeg),
       total = Value(total),
       certas = Value(certas),
       erradas = Value(erradas),
       comAjuda = Value(comAjuda),
       percentagem = Value(percentagem),
       aprovado = Value(aprovado);
  static Insertable<TentativaRow> custom({
    Expression<String>? id,
    Expression<String>? prova,
    Expression<int>? nivel,
    Expression<String>? simulado,
    Expression<DateTime>? iniciadaEm,
    Expression<DateTime>? terminadaEm,
    Expression<int>? duracaoSeg,
    Expression<int>? total,
    Expression<int>? certas,
    Expression<int>? erradas,
    Expression<int>? comAjuda,
    Expression<double>? percentagem,
    Expression<bool>? aprovado,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prova != null) 'prova': prova,
      if (nivel != null) 'nivel': nivel,
      if (simulado != null) 'simulado': simulado,
      if (iniciadaEm != null) 'iniciada_em': iniciadaEm,
      if (terminadaEm != null) 'terminada_em': terminadaEm,
      if (duracaoSeg != null) 'duracao_seg': duracaoSeg,
      if (total != null) 'total': total,
      if (certas != null) 'certas': certas,
      if (erradas != null) 'erradas': erradas,
      if (comAjuda != null) 'com_ajuda': comAjuda,
      if (percentagem != null) 'percentagem': percentagem,
      if (aprovado != null) 'aprovado': aprovado,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TentativasCompanion copyWith({
    Value<String>? id,
    Value<String>? prova,
    Value<int?>? nivel,
    Value<String?>? simulado,
    Value<DateTime>? iniciadaEm,
    Value<DateTime>? terminadaEm,
    Value<int>? duracaoSeg,
    Value<int>? total,
    Value<int>? certas,
    Value<int>? erradas,
    Value<int>? comAjuda,
    Value<double>? percentagem,
    Value<bool>? aprovado,
    Value<int>? rowid,
  }) {
    return TentativasCompanion(
      id: id ?? this.id,
      prova: prova ?? this.prova,
      nivel: nivel ?? this.nivel,
      simulado: simulado ?? this.simulado,
      iniciadaEm: iniciadaEm ?? this.iniciadaEm,
      terminadaEm: terminadaEm ?? this.terminadaEm,
      duracaoSeg: duracaoSeg ?? this.duracaoSeg,
      total: total ?? this.total,
      certas: certas ?? this.certas,
      erradas: erradas ?? this.erradas,
      comAjuda: comAjuda ?? this.comAjuda,
      percentagem: percentagem ?? this.percentagem,
      aprovado: aprovado ?? this.aprovado,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (prova.present) {
      map['prova'] = Variable<String>(prova.value);
    }
    if (nivel.present) {
      map['nivel'] = Variable<int>(nivel.value);
    }
    if (simulado.present) {
      map['simulado'] = Variable<String>(simulado.value);
    }
    if (iniciadaEm.present) {
      map['iniciada_em'] = Variable<DateTime>(iniciadaEm.value);
    }
    if (terminadaEm.present) {
      map['terminada_em'] = Variable<DateTime>(terminadaEm.value);
    }
    if (duracaoSeg.present) {
      map['duracao_seg'] = Variable<int>(duracaoSeg.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (certas.present) {
      map['certas'] = Variable<int>(certas.value);
    }
    if (erradas.present) {
      map['erradas'] = Variable<int>(erradas.value);
    }
    if (comAjuda.present) {
      map['com_ajuda'] = Variable<int>(comAjuda.value);
    }
    if (percentagem.present) {
      map['percentagem'] = Variable<double>(percentagem.value);
    }
    if (aprovado.present) {
      map['aprovado'] = Variable<bool>(aprovado.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TentativasCompanion(')
          ..write('id: $id, ')
          ..write('prova: $prova, ')
          ..write('nivel: $nivel, ')
          ..write('simulado: $simulado, ')
          ..write('iniciadaEm: $iniciadaEm, ')
          ..write('terminadaEm: $terminadaEm, ')
          ..write('duracaoSeg: $duracaoSeg, ')
          ..write('total: $total, ')
          ..write('certas: $certas, ')
          ..write('erradas: $erradas, ')
          ..write('comAjuda: $comAjuda, ')
          ..write('percentagem: $percentagem, ')
          ..write('aprovado: $aprovado, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RespostasTable extends Respostas
    with TableInfo<$RespostasTable, RespostaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RespostasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tentativaMeta = const VerificationMeta(
    'tentativa',
  );
  @override
  late final GeneratedColumn<String> tentativa = GeneratedColumn<String>(
    'tentativa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questaoMeta = const VerificationMeta(
    'questao',
  );
  @override
  late final GeneratedColumn<String> questao = GeneratedColumn<String>(
    'questao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posicaoMeta = const VerificationMeta(
    'posicao',
  );
  @override
  late final GeneratedColumn<int> posicao = GeneratedColumn<int>(
    'posicao',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _letraMeta = const VerificationMeta('letra');
  @override
  late final GeneratedColumn<String> letra = GeneratedColumn<String>(
    'letra',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctaMeta = const VerificationMeta(
    'correcta',
  );
  @override
  late final GeneratedColumn<bool> correcta = GeneratedColumn<bool>(
    'correcta',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correcta" IN (0, 1))',
    ),
  );
  static const VerificationMeta _usouDicaMeta = const VerificationMeta(
    'usouDica',
  );
  @override
  late final GeneratedColumn<bool> usouDica = GeneratedColumn<bool>(
    'usou_dica',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("usou_dica" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _viuRespostaMeta = const VerificationMeta(
    'viuResposta',
  );
  @override
  late final GeneratedColumn<bool> viuResposta = GeneratedColumn<bool>(
    'viu_resposta',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("viu_resposta" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _marcadaMeta = const VerificationMeta(
    'marcada',
  );
  @override
  late final GeneratedColumn<bool> marcada = GeneratedColumn<bool>(
    'marcada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("marcada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ordemAlternativasMeta = const VerificationMeta(
    'ordemAlternativas',
  );
  @override
  late final GeneratedColumn<String> ordemAlternativas =
      GeneratedColumn<String>(
        'ordem_alternativas',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tempoSegMeta = const VerificationMeta(
    'tempoSeg',
  );
  @override
  late final GeneratedColumn<int> tempoSeg = GeneratedColumn<int>(
    'tempo_seg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    tentativa,
    questao,
    posicao,
    letra,
    correcta,
    usouDica,
    viuResposta,
    marcada,
    ordemAlternativas,
    tempoSeg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'respostas';
  @override
  VerificationContext validateIntegrity(
    Insertable<RespostaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tentativa')) {
      context.handle(
        _tentativaMeta,
        tentativa.isAcceptableOrUnknown(data['tentativa']!, _tentativaMeta),
      );
    } else if (isInserting) {
      context.missing(_tentativaMeta);
    }
    if (data.containsKey('questao')) {
      context.handle(
        _questaoMeta,
        questao.isAcceptableOrUnknown(data['questao']!, _questaoMeta),
      );
    } else if (isInserting) {
      context.missing(_questaoMeta);
    }
    if (data.containsKey('posicao')) {
      context.handle(
        _posicaoMeta,
        posicao.isAcceptableOrUnknown(data['posicao']!, _posicaoMeta),
      );
    } else if (isInserting) {
      context.missing(_posicaoMeta);
    }
    if (data.containsKey('letra')) {
      context.handle(
        _letraMeta,
        letra.isAcceptableOrUnknown(data['letra']!, _letraMeta),
      );
    }
    if (data.containsKey('correcta')) {
      context.handle(
        _correctaMeta,
        correcta.isAcceptableOrUnknown(data['correcta']!, _correctaMeta),
      );
    } else if (isInserting) {
      context.missing(_correctaMeta);
    }
    if (data.containsKey('usou_dica')) {
      context.handle(
        _usouDicaMeta,
        usouDica.isAcceptableOrUnknown(data['usou_dica']!, _usouDicaMeta),
      );
    }
    if (data.containsKey('viu_resposta')) {
      context.handle(
        _viuRespostaMeta,
        viuResposta.isAcceptableOrUnknown(
          data['viu_resposta']!,
          _viuRespostaMeta,
        ),
      );
    }
    if (data.containsKey('marcada')) {
      context.handle(
        _marcadaMeta,
        marcada.isAcceptableOrUnknown(data['marcada']!, _marcadaMeta),
      );
    }
    if (data.containsKey('ordem_alternativas')) {
      context.handle(
        _ordemAlternativasMeta,
        ordemAlternativas.isAcceptableOrUnknown(
          data['ordem_alternativas']!,
          _ordemAlternativasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ordemAlternativasMeta);
    }
    if (data.containsKey('tempo_seg')) {
      context.handle(
        _tempoSegMeta,
        tempoSeg.isAcceptableOrUnknown(data['tempo_seg']!, _tempoSegMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tentativa, questao};
  @override
  RespostaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RespostaRow(
      tentativa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tentativa'],
      )!,
      questao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questao'],
      )!,
      posicao: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posicao'],
      )!,
      letra: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}letra'],
      ),
      correcta: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correcta'],
      )!,
      usouDica: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}usou_dica'],
      )!,
      viuResposta: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}viu_resposta'],
      )!,
      marcada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}marcada'],
      )!,
      ordemAlternativas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ordem_alternativas'],
      )!,
      tempoSeg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tempo_seg'],
      )!,
    );
  }

  @override
  $RespostasTable createAlias(String alias) {
    return $RespostasTable(attachedDatabase, alias);
  }
}

class RespostaRow extends DataClass implements Insertable<RespostaRow> {
  final String tentativa;
  final String questao;
  final int posicao;

  /// Letra ORIGINAL escolhida (as alternativas são baralhadas na apresentação)
  final String? letra;
  final bool correcta;
  final bool usouDica;
  final bool viuResposta;
  final bool marcada;

  /// JSON: letras pela ordem em que foram mostradas
  final String ordemAlternativas;
  final int tempoSeg;
  const RespostaRow({
    required this.tentativa,
    required this.questao,
    required this.posicao,
    this.letra,
    required this.correcta,
    required this.usouDica,
    required this.viuResposta,
    required this.marcada,
    required this.ordemAlternativas,
    required this.tempoSeg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tentativa'] = Variable<String>(tentativa);
    map['questao'] = Variable<String>(questao);
    map['posicao'] = Variable<int>(posicao);
    if (!nullToAbsent || letra != null) {
      map['letra'] = Variable<String>(letra);
    }
    map['correcta'] = Variable<bool>(correcta);
    map['usou_dica'] = Variable<bool>(usouDica);
    map['viu_resposta'] = Variable<bool>(viuResposta);
    map['marcada'] = Variable<bool>(marcada);
    map['ordem_alternativas'] = Variable<String>(ordemAlternativas);
    map['tempo_seg'] = Variable<int>(tempoSeg);
    return map;
  }

  RespostasCompanion toCompanion(bool nullToAbsent) {
    return RespostasCompanion(
      tentativa: Value(tentativa),
      questao: Value(questao),
      posicao: Value(posicao),
      letra: letra == null && nullToAbsent
          ? const Value.absent()
          : Value(letra),
      correcta: Value(correcta),
      usouDica: Value(usouDica),
      viuResposta: Value(viuResposta),
      marcada: Value(marcada),
      ordemAlternativas: Value(ordemAlternativas),
      tempoSeg: Value(tempoSeg),
    );
  }

  factory RespostaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RespostaRow(
      tentativa: serializer.fromJson<String>(json['tentativa']),
      questao: serializer.fromJson<String>(json['questao']),
      posicao: serializer.fromJson<int>(json['posicao']),
      letra: serializer.fromJson<String?>(json['letra']),
      correcta: serializer.fromJson<bool>(json['correcta']),
      usouDica: serializer.fromJson<bool>(json['usouDica']),
      viuResposta: serializer.fromJson<bool>(json['viuResposta']),
      marcada: serializer.fromJson<bool>(json['marcada']),
      ordemAlternativas: serializer.fromJson<String>(json['ordemAlternativas']),
      tempoSeg: serializer.fromJson<int>(json['tempoSeg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tentativa': serializer.toJson<String>(tentativa),
      'questao': serializer.toJson<String>(questao),
      'posicao': serializer.toJson<int>(posicao),
      'letra': serializer.toJson<String?>(letra),
      'correcta': serializer.toJson<bool>(correcta),
      'usouDica': serializer.toJson<bool>(usouDica),
      'viuResposta': serializer.toJson<bool>(viuResposta),
      'marcada': serializer.toJson<bool>(marcada),
      'ordemAlternativas': serializer.toJson<String>(ordemAlternativas),
      'tempoSeg': serializer.toJson<int>(tempoSeg),
    };
  }

  RespostaRow copyWith({
    String? tentativa,
    String? questao,
    int? posicao,
    Value<String?> letra = const Value.absent(),
    bool? correcta,
    bool? usouDica,
    bool? viuResposta,
    bool? marcada,
    String? ordemAlternativas,
    int? tempoSeg,
  }) => RespostaRow(
    tentativa: tentativa ?? this.tentativa,
    questao: questao ?? this.questao,
    posicao: posicao ?? this.posicao,
    letra: letra.present ? letra.value : this.letra,
    correcta: correcta ?? this.correcta,
    usouDica: usouDica ?? this.usouDica,
    viuResposta: viuResposta ?? this.viuResposta,
    marcada: marcada ?? this.marcada,
    ordemAlternativas: ordemAlternativas ?? this.ordemAlternativas,
    tempoSeg: tempoSeg ?? this.tempoSeg,
  );
  RespostaRow copyWithCompanion(RespostasCompanion data) {
    return RespostaRow(
      tentativa: data.tentativa.present ? data.tentativa.value : this.tentativa,
      questao: data.questao.present ? data.questao.value : this.questao,
      posicao: data.posicao.present ? data.posicao.value : this.posicao,
      letra: data.letra.present ? data.letra.value : this.letra,
      correcta: data.correcta.present ? data.correcta.value : this.correcta,
      usouDica: data.usouDica.present ? data.usouDica.value : this.usouDica,
      viuResposta: data.viuResposta.present
          ? data.viuResposta.value
          : this.viuResposta,
      marcada: data.marcada.present ? data.marcada.value : this.marcada,
      ordemAlternativas: data.ordemAlternativas.present
          ? data.ordemAlternativas.value
          : this.ordemAlternativas,
      tempoSeg: data.tempoSeg.present ? data.tempoSeg.value : this.tempoSeg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RespostaRow(')
          ..write('tentativa: $tentativa, ')
          ..write('questao: $questao, ')
          ..write('posicao: $posicao, ')
          ..write('letra: $letra, ')
          ..write('correcta: $correcta, ')
          ..write('usouDica: $usouDica, ')
          ..write('viuResposta: $viuResposta, ')
          ..write('marcada: $marcada, ')
          ..write('ordemAlternativas: $ordemAlternativas, ')
          ..write('tempoSeg: $tempoSeg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tentativa,
    questao,
    posicao,
    letra,
    correcta,
    usouDica,
    viuResposta,
    marcada,
    ordemAlternativas,
    tempoSeg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RespostaRow &&
          other.tentativa == this.tentativa &&
          other.questao == this.questao &&
          other.posicao == this.posicao &&
          other.letra == this.letra &&
          other.correcta == this.correcta &&
          other.usouDica == this.usouDica &&
          other.viuResposta == this.viuResposta &&
          other.marcada == this.marcada &&
          other.ordemAlternativas == this.ordemAlternativas &&
          other.tempoSeg == this.tempoSeg);
}

class RespostasCompanion extends UpdateCompanion<RespostaRow> {
  final Value<String> tentativa;
  final Value<String> questao;
  final Value<int> posicao;
  final Value<String?> letra;
  final Value<bool> correcta;
  final Value<bool> usouDica;
  final Value<bool> viuResposta;
  final Value<bool> marcada;
  final Value<String> ordemAlternativas;
  final Value<int> tempoSeg;
  final Value<int> rowid;
  const RespostasCompanion({
    this.tentativa = const Value.absent(),
    this.questao = const Value.absent(),
    this.posicao = const Value.absent(),
    this.letra = const Value.absent(),
    this.correcta = const Value.absent(),
    this.usouDica = const Value.absent(),
    this.viuResposta = const Value.absent(),
    this.marcada = const Value.absent(),
    this.ordemAlternativas = const Value.absent(),
    this.tempoSeg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RespostasCompanion.insert({
    required String tentativa,
    required String questao,
    required int posicao,
    this.letra = const Value.absent(),
    required bool correcta,
    this.usouDica = const Value.absent(),
    this.viuResposta = const Value.absent(),
    this.marcada = const Value.absent(),
    required String ordemAlternativas,
    this.tempoSeg = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tentativa = Value(tentativa),
       questao = Value(questao),
       posicao = Value(posicao),
       correcta = Value(correcta),
       ordemAlternativas = Value(ordemAlternativas);
  static Insertable<RespostaRow> custom({
    Expression<String>? tentativa,
    Expression<String>? questao,
    Expression<int>? posicao,
    Expression<String>? letra,
    Expression<bool>? correcta,
    Expression<bool>? usouDica,
    Expression<bool>? viuResposta,
    Expression<bool>? marcada,
    Expression<String>? ordemAlternativas,
    Expression<int>? tempoSeg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tentativa != null) 'tentativa': tentativa,
      if (questao != null) 'questao': questao,
      if (posicao != null) 'posicao': posicao,
      if (letra != null) 'letra': letra,
      if (correcta != null) 'correcta': correcta,
      if (usouDica != null) 'usou_dica': usouDica,
      if (viuResposta != null) 'viu_resposta': viuResposta,
      if (marcada != null) 'marcada': marcada,
      if (ordemAlternativas != null) 'ordem_alternativas': ordemAlternativas,
      if (tempoSeg != null) 'tempo_seg': tempoSeg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RespostasCompanion copyWith({
    Value<String>? tentativa,
    Value<String>? questao,
    Value<int>? posicao,
    Value<String?>? letra,
    Value<bool>? correcta,
    Value<bool>? usouDica,
    Value<bool>? viuResposta,
    Value<bool>? marcada,
    Value<String>? ordemAlternativas,
    Value<int>? tempoSeg,
    Value<int>? rowid,
  }) {
    return RespostasCompanion(
      tentativa: tentativa ?? this.tentativa,
      questao: questao ?? this.questao,
      posicao: posicao ?? this.posicao,
      letra: letra ?? this.letra,
      correcta: correcta ?? this.correcta,
      usouDica: usouDica ?? this.usouDica,
      viuResposta: viuResposta ?? this.viuResposta,
      marcada: marcada ?? this.marcada,
      ordemAlternativas: ordemAlternativas ?? this.ordemAlternativas,
      tempoSeg: tempoSeg ?? this.tempoSeg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tentativa.present) {
      map['tentativa'] = Variable<String>(tentativa.value);
    }
    if (questao.present) {
      map['questao'] = Variable<String>(questao.value);
    }
    if (posicao.present) {
      map['posicao'] = Variable<int>(posicao.value);
    }
    if (letra.present) {
      map['letra'] = Variable<String>(letra.value);
    }
    if (correcta.present) {
      map['correcta'] = Variable<bool>(correcta.value);
    }
    if (usouDica.present) {
      map['usou_dica'] = Variable<bool>(usouDica.value);
    }
    if (viuResposta.present) {
      map['viu_resposta'] = Variable<bool>(viuResposta.value);
    }
    if (marcada.present) {
      map['marcada'] = Variable<bool>(marcada.value);
    }
    if (ordemAlternativas.present) {
      map['ordem_alternativas'] = Variable<String>(ordemAlternativas.value);
    }
    if (tempoSeg.present) {
      map['tempo_seg'] = Variable<int>(tempoSeg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespostasCompanion(')
          ..write('tentativa: $tentativa, ')
          ..write('questao: $questao, ')
          ..write('posicao: $posicao, ')
          ..write('letra: $letra, ')
          ..write('correcta: $correcta, ')
          ..write('usouDica: $usouDica, ')
          ..write('viuResposta: $viuResposta, ')
          ..write('marcada: $marcada, ')
          ..write('ordemAlternativas: $ordemAlternativas, ')
          ..write('tempoSeg: $tempoSeg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LicencasTable extends Licencas
    with TableInfo<$LicencasTable, LicencaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LicencasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtoMeta = const VerificationMeta(
    'produto',
  );
  @override
  late final GeneratedColumn<String> produto = GeneratedColumn<String>(
    'produto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provasMeta = const VerificationMeta('provas');
  @override
  late final GeneratedColumn<String> provas = GeneratedColumn<String>(
    'provas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validoAteMeta = const VerificationMeta(
    'validoAte',
  );
  @override
  late final GeneratedColumn<DateTime> validoAte = GeneratedColumn<DateTime>(
    'valido_ate',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conteudoMeta = const VerificationMeta(
    'conteudo',
  );
  @override
  late final GeneratedColumn<String> conteudo = GeneratedColumn<String>(
    'conteudo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assinaturaMeta = const VerificationMeta(
    'assinatura',
  );
  @override
  late final GeneratedColumn<String> assinatura = GeneratedColumn<String>(
    'assinatura',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recebidaEmMeta = const VerificationMeta(
    'recebidaEm',
  );
  @override
  late final GeneratedColumn<DateTime> recebidaEm = GeneratedColumn<DateTime>(
    'recebida_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    produto,
    tipo,
    provas,
    validoAte,
    conteudo,
    assinatura,
    recebidaEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'licencas';
  @override
  VerificationContext validateIntegrity(
    Insertable<LicencaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('produto')) {
      context.handle(
        _produtoMeta,
        produto.isAcceptableOrUnknown(data['produto']!, _produtoMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('provas')) {
      context.handle(
        _provasMeta,
        provas.isAcceptableOrUnknown(data['provas']!, _provasMeta),
      );
    } else if (isInserting) {
      context.missing(_provasMeta);
    }
    if (data.containsKey('valido_ate')) {
      context.handle(
        _validoAteMeta,
        validoAte.isAcceptableOrUnknown(data['valido_ate']!, _validoAteMeta),
      );
    }
    if (data.containsKey('conteudo')) {
      context.handle(
        _conteudoMeta,
        conteudo.isAcceptableOrUnknown(data['conteudo']!, _conteudoMeta),
      );
    } else if (isInserting) {
      context.missing(_conteudoMeta);
    }
    if (data.containsKey('assinatura')) {
      context.handle(
        _assinaturaMeta,
        assinatura.isAcceptableOrUnknown(data['assinatura']!, _assinaturaMeta),
      );
    } else if (isInserting) {
      context.missing(_assinaturaMeta);
    }
    if (data.containsKey('recebida_em')) {
      context.handle(
        _recebidaEmMeta,
        recebidaEm.isAcceptableOrUnknown(data['recebida_em']!, _recebidaEmMeta),
      );
    } else if (isInserting) {
      context.missing(_recebidaEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LicencaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LicencaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      produto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produto'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      provas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provas'],
      )!,
      validoAte: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valido_ate'],
      ),
      conteudo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conteudo'],
      )!,
      assinatura: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assinatura'],
      )!,
      recebidaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recebida_em'],
      )!,
    );
  }

  @override
  $LicencasTable createAlias(String alias) {
    return $LicencasTable(attachedDatabase, alias);
  }
}

class LicencaRow extends DataClass implements Insertable<LicencaRow> {
  final String id;
  final String produto;
  final String tipo;

  /// JSON: provas cobertas
  final String provas;
  final DateTime? validoAte;

  /// Texto assinado tal como veio do servidor
  final String conteudo;
  final String assinatura;
  final DateTime recebidaEm;
  const LicencaRow({
    required this.id,
    required this.produto,
    required this.tipo,
    required this.provas,
    this.validoAte,
    required this.conteudo,
    required this.assinatura,
    required this.recebidaEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['produto'] = Variable<String>(produto);
    map['tipo'] = Variable<String>(tipo);
    map['provas'] = Variable<String>(provas);
    if (!nullToAbsent || validoAte != null) {
      map['valido_ate'] = Variable<DateTime>(validoAte);
    }
    map['conteudo'] = Variable<String>(conteudo);
    map['assinatura'] = Variable<String>(assinatura);
    map['recebida_em'] = Variable<DateTime>(recebidaEm);
    return map;
  }

  LicencasCompanion toCompanion(bool nullToAbsent) {
    return LicencasCompanion(
      id: Value(id),
      produto: Value(produto),
      tipo: Value(tipo),
      provas: Value(provas),
      validoAte: validoAte == null && nullToAbsent
          ? const Value.absent()
          : Value(validoAte),
      conteudo: Value(conteudo),
      assinatura: Value(assinatura),
      recebidaEm: Value(recebidaEm),
    );
  }

  factory LicencaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LicencaRow(
      id: serializer.fromJson<String>(json['id']),
      produto: serializer.fromJson<String>(json['produto']),
      tipo: serializer.fromJson<String>(json['tipo']),
      provas: serializer.fromJson<String>(json['provas']),
      validoAte: serializer.fromJson<DateTime?>(json['validoAte']),
      conteudo: serializer.fromJson<String>(json['conteudo']),
      assinatura: serializer.fromJson<String>(json['assinatura']),
      recebidaEm: serializer.fromJson<DateTime>(json['recebidaEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'produto': serializer.toJson<String>(produto),
      'tipo': serializer.toJson<String>(tipo),
      'provas': serializer.toJson<String>(provas),
      'validoAte': serializer.toJson<DateTime?>(validoAte),
      'conteudo': serializer.toJson<String>(conteudo),
      'assinatura': serializer.toJson<String>(assinatura),
      'recebidaEm': serializer.toJson<DateTime>(recebidaEm),
    };
  }

  LicencaRow copyWith({
    String? id,
    String? produto,
    String? tipo,
    String? provas,
    Value<DateTime?> validoAte = const Value.absent(),
    String? conteudo,
    String? assinatura,
    DateTime? recebidaEm,
  }) => LicencaRow(
    id: id ?? this.id,
    produto: produto ?? this.produto,
    tipo: tipo ?? this.tipo,
    provas: provas ?? this.provas,
    validoAte: validoAte.present ? validoAte.value : this.validoAte,
    conteudo: conteudo ?? this.conteudo,
    assinatura: assinatura ?? this.assinatura,
    recebidaEm: recebidaEm ?? this.recebidaEm,
  );
  LicencaRow copyWithCompanion(LicencasCompanion data) {
    return LicencaRow(
      id: data.id.present ? data.id.value : this.id,
      produto: data.produto.present ? data.produto.value : this.produto,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      provas: data.provas.present ? data.provas.value : this.provas,
      validoAte: data.validoAte.present ? data.validoAte.value : this.validoAte,
      conteudo: data.conteudo.present ? data.conteudo.value : this.conteudo,
      assinatura: data.assinatura.present
          ? data.assinatura.value
          : this.assinatura,
      recebidaEm: data.recebidaEm.present
          ? data.recebidaEm.value
          : this.recebidaEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LicencaRow(')
          ..write('id: $id, ')
          ..write('produto: $produto, ')
          ..write('tipo: $tipo, ')
          ..write('provas: $provas, ')
          ..write('validoAte: $validoAte, ')
          ..write('conteudo: $conteudo, ')
          ..write('assinatura: $assinatura, ')
          ..write('recebidaEm: $recebidaEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    produto,
    tipo,
    provas,
    validoAte,
    conteudo,
    assinatura,
    recebidaEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LicencaRow &&
          other.id == this.id &&
          other.produto == this.produto &&
          other.tipo == this.tipo &&
          other.provas == this.provas &&
          other.validoAte == this.validoAte &&
          other.conteudo == this.conteudo &&
          other.assinatura == this.assinatura &&
          other.recebidaEm == this.recebidaEm);
}

class LicencasCompanion extends UpdateCompanion<LicencaRow> {
  final Value<String> id;
  final Value<String> produto;
  final Value<String> tipo;
  final Value<String> provas;
  final Value<DateTime?> validoAte;
  final Value<String> conteudo;
  final Value<String> assinatura;
  final Value<DateTime> recebidaEm;
  final Value<int> rowid;
  const LicencasCompanion({
    this.id = const Value.absent(),
    this.produto = const Value.absent(),
    this.tipo = const Value.absent(),
    this.provas = const Value.absent(),
    this.validoAte = const Value.absent(),
    this.conteudo = const Value.absent(),
    this.assinatura = const Value.absent(),
    this.recebidaEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LicencasCompanion.insert({
    required String id,
    required String produto,
    required String tipo,
    required String provas,
    this.validoAte = const Value.absent(),
    required String conteudo,
    required String assinatura,
    required DateTime recebidaEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       produto = Value(produto),
       tipo = Value(tipo),
       provas = Value(provas),
       conteudo = Value(conteudo),
       assinatura = Value(assinatura),
       recebidaEm = Value(recebidaEm);
  static Insertable<LicencaRow> custom({
    Expression<String>? id,
    Expression<String>? produto,
    Expression<String>? tipo,
    Expression<String>? provas,
    Expression<DateTime>? validoAte,
    Expression<String>? conteudo,
    Expression<String>? assinatura,
    Expression<DateTime>? recebidaEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produto != null) 'produto': produto,
      if (tipo != null) 'tipo': tipo,
      if (provas != null) 'provas': provas,
      if (validoAte != null) 'valido_ate': validoAte,
      if (conteudo != null) 'conteudo': conteudo,
      if (assinatura != null) 'assinatura': assinatura,
      if (recebidaEm != null) 'recebida_em': recebidaEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LicencasCompanion copyWith({
    Value<String>? id,
    Value<String>? produto,
    Value<String>? tipo,
    Value<String>? provas,
    Value<DateTime?>? validoAte,
    Value<String>? conteudo,
    Value<String>? assinatura,
    Value<DateTime>? recebidaEm,
    Value<int>? rowid,
  }) {
    return LicencasCompanion(
      id: id ?? this.id,
      produto: produto ?? this.produto,
      tipo: tipo ?? this.tipo,
      provas: provas ?? this.provas,
      validoAte: validoAte ?? this.validoAte,
      conteudo: conteudo ?? this.conteudo,
      assinatura: assinatura ?? this.assinatura,
      recebidaEm: recebidaEm ?? this.recebidaEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (produto.present) {
      map['produto'] = Variable<String>(produto.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (provas.present) {
      map['provas'] = Variable<String>(provas.value);
    }
    if (validoAte.present) {
      map['valido_ate'] = Variable<DateTime>(validoAte.value);
    }
    if (conteudo.present) {
      map['conteudo'] = Variable<String>(conteudo.value);
    }
    if (assinatura.present) {
      map['assinatura'] = Variable<String>(assinatura.value);
    }
    if (recebidaEm.present) {
      map['recebida_em'] = Variable<DateTime>(recebidaEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LicencasCompanion(')
          ..write('id: $id, ')
          ..write('produto: $produto, ')
          ..write('tipo: $tipo, ')
          ..write('provas: $provas, ')
          ..write('validoAte: $validoAte, ')
          ..write('conteudo: $conteudo, ')
          ..write('assinatura: $assinatura, ')
          ..write('recebidaEm: $recebidaEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferenciasTable extends Preferencias
    with TableInfo<$PreferenciasTable, PreferenciaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenciasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chaveMeta = const VerificationMeta('chave');
  @override
  late final GeneratedColumn<String> chave = GeneratedColumn<String>(
    'chave',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [chave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferencias';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenciaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chave')) {
      context.handle(
        _chaveMeta,
        chave.isAcceptableOrUnknown(data['chave']!, _chaveMeta),
      );
    } else if (isInserting) {
      context.missing(_chaveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chave};
  @override
  PreferenciaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenciaRow(
      chave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
    );
  }

  @override
  $PreferenciasTable createAlias(String alias) {
    return $PreferenciasTable(attachedDatabase, alias);
  }
}

class PreferenciaRow extends DataClass implements Insertable<PreferenciaRow> {
  final String chave;
  final String valor;
  const PreferenciaRow({required this.chave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chave'] = Variable<String>(chave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  PreferenciasCompanion toCompanion(bool nullToAbsent) {
    return PreferenciasCompanion(chave: Value(chave), valor: Value(valor));
  }

  factory PreferenciaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenciaRow(
      chave: serializer.fromJson<String>(json['chave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chave': serializer.toJson<String>(chave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  PreferenciaRow copyWith({String? chave, String? valor}) =>
      PreferenciaRow(chave: chave ?? this.chave, valor: valor ?? this.valor);
  PreferenciaRow copyWithCompanion(PreferenciasCompanion data) {
    return PreferenciaRow(
      chave: data.chave.present ? data.chave.value : this.chave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenciaRow(')
          ..write('chave: $chave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenciaRow &&
          other.chave == this.chave &&
          other.valor == this.valor);
}

class PreferenciasCompanion extends UpdateCompanion<PreferenciaRow> {
  final Value<String> chave;
  final Value<String> valor;
  final Value<int> rowid;
  const PreferenciasCompanion({
    this.chave = const Value.absent(),
    this.valor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferenciasCompanion.insert({
    required String chave,
    required String valor,
    this.rowid = const Value.absent(),
  }) : chave = Value(chave),
       valor = Value(valor);
  static Insertable<PreferenciaRow> custom({
    Expression<String>? chave,
    Expression<String>? valor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chave != null) 'chave': chave,
      if (valor != null) 'valor': valor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferenciasCompanion copyWith({
    Value<String>? chave,
    Value<String>? valor,
    Value<int>? rowid,
  }) {
    return PreferenciasCompanion(
      chave: chave ?? this.chave,
      valor: valor ?? this.valor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chave.present) {
      map['chave'] = Variable<String>(chave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenciasCompanion(')
          ..write('chave: $chave, ')
          ..write('valor: $valor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$UserDb extends GeneratedDatabase {
  _$UserDb(QueryExecutor e) : super(e);
  $UserDbManager get managers => $UserDbManager(this);
  late final $PerfilTable perfil = $PerfilTable(this);
  late final $ObjectivosTable objectivos = $ObjectivosTable(this);
  late final $TentativasTable tentativas = $TentativasTable(this);
  late final $RespostasTable respostas = $RespostasTable(this);
  late final $LicencasTable licencas = $LicencasTable(this);
  late final $PreferenciasTable preferencias = $PreferenciasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    perfil,
    objectivos,
    tentativas,
    respostas,
    licencas,
    preferencias,
  ];
}

typedef $$PerfilTableCreateCompanionBuilder =
    PerfilCompanion Function({
      Value<int> id,
      required String nome,
      required String avatar,
      required DateTime criadoEm,
    });
typedef $$PerfilTableUpdateCompanionBuilder =
    PerfilCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> avatar,
      Value<DateTime> criadoEm,
    });

class $$PerfilTableFilterComposer extends Composer<_$UserDb, $PerfilTable> {
  $$PerfilTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PerfilTableOrderingComposer extends Composer<_$UserDb, $PerfilTable> {
  $$PerfilTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PerfilTableAnnotationComposer extends Composer<_$UserDb, $PerfilTable> {
  $$PerfilTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);
}

class $$PerfilTableTableManager
    extends
        RootTableManager<
          _$UserDb,
          $PerfilTable,
          PerfilRow,
          $$PerfilTableFilterComposer,
          $$PerfilTableOrderingComposer,
          $$PerfilTableAnnotationComposer,
          $$PerfilTableCreateCompanionBuilder,
          $$PerfilTableUpdateCompanionBuilder,
          (PerfilRow, BaseReferences<_$UserDb, $PerfilTable, PerfilRow>),
          PerfilRow,
          PrefetchHooks Function()
        > {
  $$PerfilTableTableManager(_$UserDb db, $PerfilTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PerfilTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PerfilTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PerfilTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> avatar = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => PerfilCompanion(
                id: id,
                nome: nome,
                avatar: avatar,
                criadoEm: criadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String avatar,
                required DateTime criadoEm,
              }) => PerfilCompanion.insert(
                id: id,
                nome: nome,
                avatar: avatar,
                criadoEm: criadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PerfilTable, PerfilRow>(table),
                  BaseReferences<_$UserDb, $PerfilTable, PerfilRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PerfilTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDb,
      $PerfilTable,
      PerfilRow,
      $$PerfilTableFilterComposer,
      $$PerfilTableOrderingComposer,
      $$PerfilTableAnnotationComposer,
      $$PerfilTableCreateCompanionBuilder,
      $$PerfilTableUpdateCompanionBuilder,
      (PerfilRow, BaseReferences<_$UserDb, $PerfilTable, PerfilRow>),
      PerfilRow,
      PrefetchHooks Function()
    >;
typedef $$ObjectivosTableCreateCompanionBuilder =
    ObjectivosCompanion Function({
      required String oferta,
      required DateTime criadoEm,
      Value<int> rowid,
    });
typedef $$ObjectivosTableUpdateCompanionBuilder =
    ObjectivosCompanion Function({
      Value<String> oferta,
      Value<DateTime> criadoEm,
      Value<int> rowid,
    });

class $$ObjectivosTableFilterComposer
    extends Composer<_$UserDb, $ObjectivosTable> {
  $$ObjectivosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get oferta => $composableBuilder(
    column: $table.oferta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ObjectivosTableOrderingComposer
    extends Composer<_$UserDb, $ObjectivosTable> {
  $$ObjectivosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get oferta => $composableBuilder(
    column: $table.oferta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ObjectivosTableAnnotationComposer
    extends Composer<_$UserDb, $ObjectivosTable> {
  $$ObjectivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get oferta =>
      $composableBuilder(column: $table.oferta, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);
}

class $$ObjectivosTableTableManager
    extends
        RootTableManager<
          _$UserDb,
          $ObjectivosTable,
          ObjectivoRow,
          $$ObjectivosTableFilterComposer,
          $$ObjectivosTableOrderingComposer,
          $$ObjectivosTableAnnotationComposer,
          $$ObjectivosTableCreateCompanionBuilder,
          $$ObjectivosTableUpdateCompanionBuilder,
          (
            ObjectivoRow,
            BaseReferences<_$UserDb, $ObjectivosTable, ObjectivoRow>,
          ),
          ObjectivoRow,
          PrefetchHooks Function()
        > {
  $$ObjectivosTableTableManager(_$UserDb db, $ObjectivosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObjectivosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObjectivosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObjectivosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> oferta = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObjectivosCompanion(
                oferta: oferta,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String oferta,
                required DateTime criadoEm,
                Value<int> rowid = const Value.absent(),
              }) => ObjectivosCompanion.insert(
                oferta: oferta,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ObjectivosTable, ObjectivoRow>(table),
                  BaseReferences<_$UserDb, $ObjectivosTable, ObjectivoRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ObjectivosTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDb,
      $ObjectivosTable,
      ObjectivoRow,
      $$ObjectivosTableFilterComposer,
      $$ObjectivosTableOrderingComposer,
      $$ObjectivosTableAnnotationComposer,
      $$ObjectivosTableCreateCompanionBuilder,
      $$ObjectivosTableUpdateCompanionBuilder,
      (ObjectivoRow, BaseReferences<_$UserDb, $ObjectivosTable, ObjectivoRow>),
      ObjectivoRow,
      PrefetchHooks Function()
    >;
typedef $$TentativasTableCreateCompanionBuilder =
    TentativasCompanion Function({
      required String id,
      required String prova,
      Value<int?> nivel,
      Value<String?> simulado,
      required DateTime iniciadaEm,
      required DateTime terminadaEm,
      required int duracaoSeg,
      required int total,
      required int certas,
      required int erradas,
      required int comAjuda,
      required double percentagem,
      required bool aprovado,
      Value<int> rowid,
    });
typedef $$TentativasTableUpdateCompanionBuilder =
    TentativasCompanion Function({
      Value<String> id,
      Value<String> prova,
      Value<int?> nivel,
      Value<String?> simulado,
      Value<DateTime> iniciadaEm,
      Value<DateTime> terminadaEm,
      Value<int> duracaoSeg,
      Value<int> total,
      Value<int> certas,
      Value<int> erradas,
      Value<int> comAjuda,
      Value<double> percentagem,
      Value<bool> aprovado,
      Value<int> rowid,
    });

class $$TentativasTableFilterComposer
    extends Composer<_$UserDb, $TentativasTable> {
  $$TentativasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nivel => $composableBuilder(
    column: $table.nivel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get simulado => $composableBuilder(
    column: $table.simulado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get iniciadaEm => $composableBuilder(
    column: $table.iniciadaEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get terminadaEm => $composableBuilder(
    column: $table.terminadaEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duracaoSeg => $composableBuilder(
    column: $table.duracaoSeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get certas => $composableBuilder(
    column: $table.certas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get erradas => $composableBuilder(
    column: $table.erradas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get comAjuda => $composableBuilder(
    column: $table.comAjuda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentagem => $composableBuilder(
    column: $table.percentagem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aprovado => $composableBuilder(
    column: $table.aprovado,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TentativasTableOrderingComposer
    extends Composer<_$UserDb, $TentativasTable> {
  $$TentativasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nivel => $composableBuilder(
    column: $table.nivel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get simulado => $composableBuilder(
    column: $table.simulado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get iniciadaEm => $composableBuilder(
    column: $table.iniciadaEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get terminadaEm => $composableBuilder(
    column: $table.terminadaEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duracaoSeg => $composableBuilder(
    column: $table.duracaoSeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get certas => $composableBuilder(
    column: $table.certas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get erradas => $composableBuilder(
    column: $table.erradas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get comAjuda => $composableBuilder(
    column: $table.comAjuda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentagem => $composableBuilder(
    column: $table.percentagem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aprovado => $composableBuilder(
    column: $table.aprovado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TentativasTableAnnotationComposer
    extends Composer<_$UserDb, $TentativasTable> {
  $$TentativasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prova =>
      $composableBuilder(column: $table.prova, builder: (column) => column);

  GeneratedColumn<int> get nivel =>
      $composableBuilder(column: $table.nivel, builder: (column) => column);

  GeneratedColumn<String> get simulado =>
      $composableBuilder(column: $table.simulado, builder: (column) => column);

  GeneratedColumn<DateTime> get iniciadaEm => $composableBuilder(
    column: $table.iniciadaEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get terminadaEm => $composableBuilder(
    column: $table.terminadaEm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duracaoSeg => $composableBuilder(
    column: $table.duracaoSeg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get certas =>
      $composableBuilder(column: $table.certas, builder: (column) => column);

  GeneratedColumn<int> get erradas =>
      $composableBuilder(column: $table.erradas, builder: (column) => column);

  GeneratedColumn<int> get comAjuda =>
      $composableBuilder(column: $table.comAjuda, builder: (column) => column);

  GeneratedColumn<double> get percentagem => $composableBuilder(
    column: $table.percentagem,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get aprovado =>
      $composableBuilder(column: $table.aprovado, builder: (column) => column);
}

class $$TentativasTableTableManager
    extends
        RootTableManager<
          _$UserDb,
          $TentativasTable,
          TentativaRow,
          $$TentativasTableFilterComposer,
          $$TentativasTableOrderingComposer,
          $$TentativasTableAnnotationComposer,
          $$TentativasTableCreateCompanionBuilder,
          $$TentativasTableUpdateCompanionBuilder,
          (
            TentativaRow,
            BaseReferences<_$UserDb, $TentativasTable, TentativaRow>,
          ),
          TentativaRow,
          PrefetchHooks Function()
        > {
  $$TentativasTableTableManager(_$UserDb db, $TentativasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TentativasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TentativasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TentativasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> prova = const Value.absent(),
                Value<int?> nivel = const Value.absent(),
                Value<String?> simulado = const Value.absent(),
                Value<DateTime> iniciadaEm = const Value.absent(),
                Value<DateTime> terminadaEm = const Value.absent(),
                Value<int> duracaoSeg = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> certas = const Value.absent(),
                Value<int> erradas = const Value.absent(),
                Value<int> comAjuda = const Value.absent(),
                Value<double> percentagem = const Value.absent(),
                Value<bool> aprovado = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TentativasCompanion(
                id: id,
                prova: prova,
                nivel: nivel,
                simulado: simulado,
                iniciadaEm: iniciadaEm,
                terminadaEm: terminadaEm,
                duracaoSeg: duracaoSeg,
                total: total,
                certas: certas,
                erradas: erradas,
                comAjuda: comAjuda,
                percentagem: percentagem,
                aprovado: aprovado,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String prova,
                Value<int?> nivel = const Value.absent(),
                Value<String?> simulado = const Value.absent(),
                required DateTime iniciadaEm,
                required DateTime terminadaEm,
                required int duracaoSeg,
                required int total,
                required int certas,
                required int erradas,
                required int comAjuda,
                required double percentagem,
                required bool aprovado,
                Value<int> rowid = const Value.absent(),
              }) => TentativasCompanion.insert(
                id: id,
                prova: prova,
                nivel: nivel,
                simulado: simulado,
                iniciadaEm: iniciadaEm,
                terminadaEm: terminadaEm,
                duracaoSeg: duracaoSeg,
                total: total,
                certas: certas,
                erradas: erradas,
                comAjuda: comAjuda,
                percentagem: percentagem,
                aprovado: aprovado,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TentativasTable, TentativaRow>(table),
                  BaseReferences<_$UserDb, $TentativasTable, TentativaRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TentativasTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDb,
      $TentativasTable,
      TentativaRow,
      $$TentativasTableFilterComposer,
      $$TentativasTableOrderingComposer,
      $$TentativasTableAnnotationComposer,
      $$TentativasTableCreateCompanionBuilder,
      $$TentativasTableUpdateCompanionBuilder,
      (TentativaRow, BaseReferences<_$UserDb, $TentativasTable, TentativaRow>),
      TentativaRow,
      PrefetchHooks Function()
    >;
typedef $$RespostasTableCreateCompanionBuilder =
    RespostasCompanion Function({
      required String tentativa,
      required String questao,
      required int posicao,
      Value<String?> letra,
      required bool correcta,
      Value<bool> usouDica,
      Value<bool> viuResposta,
      Value<bool> marcada,
      required String ordemAlternativas,
      Value<int> tempoSeg,
      Value<int> rowid,
    });
typedef $$RespostasTableUpdateCompanionBuilder =
    RespostasCompanion Function({
      Value<String> tentativa,
      Value<String> questao,
      Value<int> posicao,
      Value<String?> letra,
      Value<bool> correcta,
      Value<bool> usouDica,
      Value<bool> viuResposta,
      Value<bool> marcada,
      Value<String> ordemAlternativas,
      Value<int> tempoSeg,
      Value<int> rowid,
    });

class $$RespostasTableFilterComposer
    extends Composer<_$UserDb, $RespostasTable> {
  $$RespostasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tentativa => $composableBuilder(
    column: $table.tentativa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questao => $composableBuilder(
    column: $table.questao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posicao => $composableBuilder(
    column: $table.posicao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get letra => $composableBuilder(
    column: $table.letra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correcta => $composableBuilder(
    column: $table.correcta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usouDica => $composableBuilder(
    column: $table.usouDica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viuResposta => $composableBuilder(
    column: $table.viuResposta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get marcada => $composableBuilder(
    column: $table.marcada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ordemAlternativas => $composableBuilder(
    column: $table.ordemAlternativas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempoSeg => $composableBuilder(
    column: $table.tempoSeg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RespostasTableOrderingComposer
    extends Composer<_$UserDb, $RespostasTable> {
  $$RespostasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tentativa => $composableBuilder(
    column: $table.tentativa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questao => $composableBuilder(
    column: $table.questao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posicao => $composableBuilder(
    column: $table.posicao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get letra => $composableBuilder(
    column: $table.letra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correcta => $composableBuilder(
    column: $table.correcta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usouDica => $composableBuilder(
    column: $table.usouDica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viuResposta => $composableBuilder(
    column: $table.viuResposta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get marcada => $composableBuilder(
    column: $table.marcada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ordemAlternativas => $composableBuilder(
    column: $table.ordemAlternativas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempoSeg => $composableBuilder(
    column: $table.tempoSeg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RespostasTableAnnotationComposer
    extends Composer<_$UserDb, $RespostasTable> {
  $$RespostasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tentativa =>
      $composableBuilder(column: $table.tentativa, builder: (column) => column);

  GeneratedColumn<String> get questao =>
      $composableBuilder(column: $table.questao, builder: (column) => column);

  GeneratedColumn<int> get posicao =>
      $composableBuilder(column: $table.posicao, builder: (column) => column);

  GeneratedColumn<String> get letra =>
      $composableBuilder(column: $table.letra, builder: (column) => column);

  GeneratedColumn<bool> get correcta =>
      $composableBuilder(column: $table.correcta, builder: (column) => column);

  GeneratedColumn<bool> get usouDica =>
      $composableBuilder(column: $table.usouDica, builder: (column) => column);

  GeneratedColumn<bool> get viuResposta => $composableBuilder(
    column: $table.viuResposta,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get marcada =>
      $composableBuilder(column: $table.marcada, builder: (column) => column);

  GeneratedColumn<String> get ordemAlternativas => $composableBuilder(
    column: $table.ordemAlternativas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tempoSeg =>
      $composableBuilder(column: $table.tempoSeg, builder: (column) => column);
}

class $$RespostasTableTableManager
    extends
        RootTableManager<
          _$UserDb,
          $RespostasTable,
          RespostaRow,
          $$RespostasTableFilterComposer,
          $$RespostasTableOrderingComposer,
          $$RespostasTableAnnotationComposer,
          $$RespostasTableCreateCompanionBuilder,
          $$RespostasTableUpdateCompanionBuilder,
          (RespostaRow, BaseReferences<_$UserDb, $RespostasTable, RespostaRow>),
          RespostaRow,
          PrefetchHooks Function()
        > {
  $$RespostasTableTableManager(_$UserDb db, $RespostasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RespostasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RespostasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RespostasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tentativa = const Value.absent(),
                Value<String> questao = const Value.absent(),
                Value<int> posicao = const Value.absent(),
                Value<String?> letra = const Value.absent(),
                Value<bool> correcta = const Value.absent(),
                Value<bool> usouDica = const Value.absent(),
                Value<bool> viuResposta = const Value.absent(),
                Value<bool> marcada = const Value.absent(),
                Value<String> ordemAlternativas = const Value.absent(),
                Value<int> tempoSeg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RespostasCompanion(
                tentativa: tentativa,
                questao: questao,
                posicao: posicao,
                letra: letra,
                correcta: correcta,
                usouDica: usouDica,
                viuResposta: viuResposta,
                marcada: marcada,
                ordemAlternativas: ordemAlternativas,
                tempoSeg: tempoSeg,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tentativa,
                required String questao,
                required int posicao,
                Value<String?> letra = const Value.absent(),
                required bool correcta,
                Value<bool> usouDica = const Value.absent(),
                Value<bool> viuResposta = const Value.absent(),
                Value<bool> marcada = const Value.absent(),
                required String ordemAlternativas,
                Value<int> tempoSeg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RespostasCompanion.insert(
                tentativa: tentativa,
                questao: questao,
                posicao: posicao,
                letra: letra,
                correcta: correcta,
                usouDica: usouDica,
                viuResposta: viuResposta,
                marcada: marcada,
                ordemAlternativas: ordemAlternativas,
                tempoSeg: tempoSeg,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RespostasTable, RespostaRow>(table),
                  BaseReferences<_$UserDb, $RespostasTable, RespostaRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RespostasTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDb,
      $RespostasTable,
      RespostaRow,
      $$RespostasTableFilterComposer,
      $$RespostasTableOrderingComposer,
      $$RespostasTableAnnotationComposer,
      $$RespostasTableCreateCompanionBuilder,
      $$RespostasTableUpdateCompanionBuilder,
      (RespostaRow, BaseReferences<_$UserDb, $RespostasTable, RespostaRow>),
      RespostaRow,
      PrefetchHooks Function()
    >;
typedef $$LicencasTableCreateCompanionBuilder =
    LicencasCompanion Function({
      required String id,
      required String produto,
      required String tipo,
      required String provas,
      Value<DateTime?> validoAte,
      required String conteudo,
      required String assinatura,
      required DateTime recebidaEm,
      Value<int> rowid,
    });
typedef $$LicencasTableUpdateCompanionBuilder =
    LicencasCompanion Function({
      Value<String> id,
      Value<String> produto,
      Value<String> tipo,
      Value<String> provas,
      Value<DateTime?> validoAte,
      Value<String> conteudo,
      Value<String> assinatura,
      Value<DateTime> recebidaEm,
      Value<int> rowid,
    });

class $$LicencasTableFilterComposer extends Composer<_$UserDb, $LicencasTable> {
  $$LicencasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produto => $composableBuilder(
    column: $table.produto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provas => $composableBuilder(
    column: $table.provas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validoAte => $composableBuilder(
    column: $table.validoAte,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conteudo => $composableBuilder(
    column: $table.conteudo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assinatura => $composableBuilder(
    column: $table.assinatura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recebidaEm => $composableBuilder(
    column: $table.recebidaEm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LicencasTableOrderingComposer
    extends Composer<_$UserDb, $LicencasTable> {
  $$LicencasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produto => $composableBuilder(
    column: $table.produto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provas => $composableBuilder(
    column: $table.provas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validoAte => $composableBuilder(
    column: $table.validoAte,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conteudo => $composableBuilder(
    column: $table.conteudo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assinatura => $composableBuilder(
    column: $table.assinatura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recebidaEm => $composableBuilder(
    column: $table.recebidaEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LicencasTableAnnotationComposer
    extends Composer<_$UserDb, $LicencasTable> {
  $$LicencasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get produto =>
      $composableBuilder(column: $table.produto, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get provas =>
      $composableBuilder(column: $table.provas, builder: (column) => column);

  GeneratedColumn<DateTime> get validoAte =>
      $composableBuilder(column: $table.validoAte, builder: (column) => column);

  GeneratedColumn<String> get conteudo =>
      $composableBuilder(column: $table.conteudo, builder: (column) => column);

  GeneratedColumn<String> get assinatura => $composableBuilder(
    column: $table.assinatura,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recebidaEm => $composableBuilder(
    column: $table.recebidaEm,
    builder: (column) => column,
  );
}

class $$LicencasTableTableManager
    extends
        RootTableManager<
          _$UserDb,
          $LicencasTable,
          LicencaRow,
          $$LicencasTableFilterComposer,
          $$LicencasTableOrderingComposer,
          $$LicencasTableAnnotationComposer,
          $$LicencasTableCreateCompanionBuilder,
          $$LicencasTableUpdateCompanionBuilder,
          (LicencaRow, BaseReferences<_$UserDb, $LicencasTable, LicencaRow>),
          LicencaRow,
          PrefetchHooks Function()
        > {
  $$LicencasTableTableManager(_$UserDb db, $LicencasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LicencasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LicencasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LicencasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> produto = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> provas = const Value.absent(),
                Value<DateTime?> validoAte = const Value.absent(),
                Value<String> conteudo = const Value.absent(),
                Value<String> assinatura = const Value.absent(),
                Value<DateTime> recebidaEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LicencasCompanion(
                id: id,
                produto: produto,
                tipo: tipo,
                provas: provas,
                validoAte: validoAte,
                conteudo: conteudo,
                assinatura: assinatura,
                recebidaEm: recebidaEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String produto,
                required String tipo,
                required String provas,
                Value<DateTime?> validoAte = const Value.absent(),
                required String conteudo,
                required String assinatura,
                required DateTime recebidaEm,
                Value<int> rowid = const Value.absent(),
              }) => LicencasCompanion.insert(
                id: id,
                produto: produto,
                tipo: tipo,
                provas: provas,
                validoAte: validoAte,
                conteudo: conteudo,
                assinatura: assinatura,
                recebidaEm: recebidaEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LicencasTable, LicencaRow>(table),
                  BaseReferences<_$UserDb, $LicencasTable, LicencaRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LicencasTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDb,
      $LicencasTable,
      LicencaRow,
      $$LicencasTableFilterComposer,
      $$LicencasTableOrderingComposer,
      $$LicencasTableAnnotationComposer,
      $$LicencasTableCreateCompanionBuilder,
      $$LicencasTableUpdateCompanionBuilder,
      (LicencaRow, BaseReferences<_$UserDb, $LicencasTable, LicencaRow>),
      LicencaRow,
      PrefetchHooks Function()
    >;
typedef $$PreferenciasTableCreateCompanionBuilder =
    PreferenciasCompanion Function({
      required String chave,
      required String valor,
      Value<int> rowid,
    });
typedef $$PreferenciasTableUpdateCompanionBuilder =
    PreferenciasCompanion Function({
      Value<String> chave,
      Value<String> valor,
      Value<int> rowid,
    });

class $$PreferenciasTableFilterComposer
    extends Composer<_$UserDb, $PreferenciasTable> {
  $$PreferenciasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenciasTableOrderingComposer
    extends Composer<_$UserDb, $PreferenciasTable> {
  $$PreferenciasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenciasTableAnnotationComposer
    extends Composer<_$UserDb, $PreferenciasTable> {
  $$PreferenciasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chave =>
      $composableBuilder(column: $table.chave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$PreferenciasTableTableManager
    extends
        RootTableManager<
          _$UserDb,
          $PreferenciasTable,
          PreferenciaRow,
          $$PreferenciasTableFilterComposer,
          $$PreferenciasTableOrderingComposer,
          $$PreferenciasTableAnnotationComposer,
          $$PreferenciasTableCreateCompanionBuilder,
          $$PreferenciasTableUpdateCompanionBuilder,
          (
            PreferenciaRow,
            BaseReferences<_$UserDb, $PreferenciasTable, PreferenciaRow>,
          ),
          PreferenciaRow,
          PrefetchHooks Function()
        > {
  $$PreferenciasTableTableManager(_$UserDb db, $PreferenciasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenciasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenciasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenciasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> chave = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreferenciasCompanion(
                chave: chave,
                valor: valor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String chave,
                required String valor,
                Value<int> rowid = const Value.absent(),
              }) => PreferenciasCompanion.insert(
                chave: chave,
                valor: valor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferenciasTable, PreferenciaRow>(table),
                  BaseReferences<_$UserDb, $PreferenciasTable, PreferenciaRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenciasTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDb,
      $PreferenciasTable,
      PreferenciaRow,
      $$PreferenciasTableFilterComposer,
      $$PreferenciasTableOrderingComposer,
      $$PreferenciasTableAnnotationComposer,
      $$PreferenciasTableCreateCompanionBuilder,
      $$PreferenciasTableUpdateCompanionBuilder,
      (
        PreferenciaRow,
        BaseReferences<_$UserDb, $PreferenciasTable, PreferenciaRow>,
      ),
      PreferenciaRow,
      PrefetchHooks Function()
    >;

class $UserDbManager {
  final _$UserDb _db;
  $UserDbManager(this._db);
  $$PerfilTableTableManager get perfil =>
      $$PerfilTableTableManager(_db, _db.perfil);
  $$ObjectivosTableTableManager get objectivos =>
      $$ObjectivosTableTableManager(_db, _db.objectivos);
  $$TentativasTableTableManager get tentativas =>
      $$TentativasTableTableManager(_db, _db.tentativas);
  $$RespostasTableTableManager get respostas =>
      $$RespostasTableTableManager(_db, _db.respostas);
  $$LicencasTableTableManager get licencas =>
      $$LicencasTableTableManager(_db, _db.licencas);
  $$PreferenciasTableTableManager get preferencias =>
      $$PreferenciasTableTableManager(_db, _db.preferencias);
}
