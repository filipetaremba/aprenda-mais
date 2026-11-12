// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_db.dart';

// ignore_for_file: type=lint
class $GruposExameTable extends GruposExame
    with TableInfo<$GruposExameTable, GrupoExameRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GruposExameTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _temGabaritoMeta = const VerificationMeta(
    'temGabarito',
  );
  @override
  late final GeneratedColumn<bool> temGabarito = GeneratedColumn<bool>(
    'tem_gabarito',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tem_gabarito" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [codigo, nome, temGabarito];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grupos_exame';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrupoExameRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('tem_gabarito')) {
      context.handle(
        _temGabaritoMeta,
        temGabarito.isAcceptableOrUnknown(
          data['tem_gabarito']!,
          _temGabaritoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  GrupoExameRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrupoExameRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      temGabarito: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tem_gabarito'],
      )!,
    );
  }

  @override
  $GruposExameTable createAlias(String alias) {
    return $GruposExameTable(attachedDatabase, alias);
  }
}

class GrupoExameRow extends DataClass implements Insertable<GrupoExameRow> {
  final String codigo;
  final String nome;
  final bool temGabarito;
  const GrupoExameRow({
    required this.codigo,
    required this.nome,
    required this.temGabarito,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['nome'] = Variable<String>(nome);
    map['tem_gabarito'] = Variable<bool>(temGabarito);
    return map;
  }

  GruposExameCompanion toCompanion(bool nullToAbsent) {
    return GruposExameCompanion(
      codigo: Value(codigo),
      nome: Value(nome),
      temGabarito: Value(temGabarito),
    );
  }

  factory GrupoExameRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrupoExameRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      nome: serializer.fromJson<String>(json['nome']),
      temGabarito: serializer.fromJson<bool>(json['temGabarito']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'nome': serializer.toJson<String>(nome),
      'temGabarito': serializer.toJson<bool>(temGabarito),
    };
  }

  GrupoExameRow copyWith({String? codigo, String? nome, bool? temGabarito}) =>
      GrupoExameRow(
        codigo: codigo ?? this.codigo,
        nome: nome ?? this.nome,
        temGabarito: temGabarito ?? this.temGabarito,
      );
  GrupoExameRow copyWithCompanion(GruposExameCompanion data) {
    return GrupoExameRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nome: data.nome.present ? data.nome.value : this.nome,
      temGabarito: data.temGabarito.present
          ? data.temGabarito.value
          : this.temGabarito,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrupoExameRow(')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('temGabarito: $temGabarito')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(codigo, nome, temGabarito);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrupoExameRow &&
          other.codigo == this.codigo &&
          other.nome == this.nome &&
          other.temGabarito == this.temGabarito);
}

class GruposExameCompanion extends UpdateCompanion<GrupoExameRow> {
  final Value<String> codigo;
  final Value<String> nome;
  final Value<bool> temGabarito;
  final Value<int> rowid;
  const GruposExameCompanion({
    this.codigo = const Value.absent(),
    this.nome = const Value.absent(),
    this.temGabarito = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GruposExameCompanion.insert({
    required String codigo,
    required String nome,
    this.temGabarito = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       nome = Value(nome);
  static Insertable<GrupoExameRow> custom({
    Expression<String>? codigo,
    Expression<String>? nome,
    Expression<bool>? temGabarito,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (nome != null) 'nome': nome,
      if (temGabarito != null) 'tem_gabarito': temGabarito,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GruposExameCompanion copyWith({
    Value<String>? codigo,
    Value<String>? nome,
    Value<bool>? temGabarito,
    Value<int>? rowid,
  }) {
    return GruposExameCompanion(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      temGabarito: temGabarito ?? this.temGabarito,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (temGabarito.present) {
      map['tem_gabarito'] = Variable<bool>(temGabarito.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GruposExameCompanion(')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('temGabarito: $temGabarito, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstituicoesTable extends Instituicoes
    with TableInfo<$InstituicoesTable, InstituicaoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstituicoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siglaMeta = const VerificationMeta('sigla');
  @override
  late final GeneratedColumn<String> sigla = GeneratedColumn<String>(
    'sigla',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _grupoExameMeta = const VerificationMeta(
    'grupoExame',
  );
  @override
  late final GeneratedColumn<String> grupoExame = GeneratedColumn<String>(
    'grupo_exame',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [codigo, sigla, nome, grupoExame];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'instituicoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstituicaoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('sigla')) {
      context.handle(
        _siglaMeta,
        sigla.isAcceptableOrUnknown(data['sigla']!, _siglaMeta),
      );
    } else if (isInserting) {
      context.missing(_siglaMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('grupo_exame')) {
      context.handle(
        _grupoExameMeta,
        grupoExame.isAcceptableOrUnknown(data['grupo_exame']!, _grupoExameMeta),
      );
    } else if (isInserting) {
      context.missing(_grupoExameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  InstituicaoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstituicaoRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      sigla: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sigla'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      grupoExame: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grupo_exame'],
      )!,
    );
  }

  @override
  $InstituicoesTable createAlias(String alias) {
    return $InstituicoesTable(attachedDatabase, alias);
  }
}

class InstituicaoRow extends DataClass implements Insertable<InstituicaoRow> {
  final String codigo;
  final String sigla;
  final String nome;
  final String grupoExame;
  const InstituicaoRow({
    required this.codigo,
    required this.sigla,
    required this.nome,
    required this.grupoExame,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['sigla'] = Variable<String>(sigla);
    map['nome'] = Variable<String>(nome);
    map['grupo_exame'] = Variable<String>(grupoExame);
    return map;
  }

  InstituicoesCompanion toCompanion(bool nullToAbsent) {
    return InstituicoesCompanion(
      codigo: Value(codigo),
      sigla: Value(sigla),
      nome: Value(nome),
      grupoExame: Value(grupoExame),
    );
  }

  factory InstituicaoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstituicaoRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      sigla: serializer.fromJson<String>(json['sigla']),
      nome: serializer.fromJson<String>(json['nome']),
      grupoExame: serializer.fromJson<String>(json['grupoExame']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'sigla': serializer.toJson<String>(sigla),
      'nome': serializer.toJson<String>(nome),
      'grupoExame': serializer.toJson<String>(grupoExame),
    };
  }

  InstituicaoRow copyWith({
    String? codigo,
    String? sigla,
    String? nome,
    String? grupoExame,
  }) => InstituicaoRow(
    codigo: codigo ?? this.codigo,
    sigla: sigla ?? this.sigla,
    nome: nome ?? this.nome,
    grupoExame: grupoExame ?? this.grupoExame,
  );
  InstituicaoRow copyWithCompanion(InstituicoesCompanion data) {
    return InstituicaoRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      sigla: data.sigla.present ? data.sigla.value : this.sigla,
      nome: data.nome.present ? data.nome.value : this.nome,
      grupoExame: data.grupoExame.present
          ? data.grupoExame.value
          : this.grupoExame,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstituicaoRow(')
          ..write('codigo: $codigo, ')
          ..write('sigla: $sigla, ')
          ..write('nome: $nome, ')
          ..write('grupoExame: $grupoExame')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(codigo, sigla, nome, grupoExame);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstituicaoRow &&
          other.codigo == this.codigo &&
          other.sigla == this.sigla &&
          other.nome == this.nome &&
          other.grupoExame == this.grupoExame);
}

class InstituicoesCompanion extends UpdateCompanion<InstituicaoRow> {
  final Value<String> codigo;
  final Value<String> sigla;
  final Value<String> nome;
  final Value<String> grupoExame;
  final Value<int> rowid;
  const InstituicoesCompanion({
    this.codigo = const Value.absent(),
    this.sigla = const Value.absent(),
    this.nome = const Value.absent(),
    this.grupoExame = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstituicoesCompanion.insert({
    required String codigo,
    required String sigla,
    required String nome,
    required String grupoExame,
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       sigla = Value(sigla),
       nome = Value(nome),
       grupoExame = Value(grupoExame);
  static Insertable<InstituicaoRow> custom({
    Expression<String>? codigo,
    Expression<String>? sigla,
    Expression<String>? nome,
    Expression<String>? grupoExame,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (sigla != null) 'sigla': sigla,
      if (nome != null) 'nome': nome,
      if (grupoExame != null) 'grupo_exame': grupoExame,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstituicoesCompanion copyWith({
    Value<String>? codigo,
    Value<String>? sigla,
    Value<String>? nome,
    Value<String>? grupoExame,
    Value<int>? rowid,
  }) {
    return InstituicoesCompanion(
      codigo: codigo ?? this.codigo,
      sigla: sigla ?? this.sigla,
      nome: nome ?? this.nome,
      grupoExame: grupoExame ?? this.grupoExame,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (sigla.present) {
      map['sigla'] = Variable<String>(sigla.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (grupoExame.present) {
      map['grupo_exame'] = Variable<String>(grupoExame.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstituicoesCompanion(')
          ..write('codigo: $codigo, ')
          ..write('sigla: $sigla, ')
          ..write('nome: $nome, ')
          ..write('grupoExame: $grupoExame, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DisciplinasTable extends Disciplinas
    with TableInfo<$DisciplinasTable, DisciplinaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DisciplinasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _iconeMeta = const VerificationMeta('icone');
  @override
  late final GeneratedColumn<String> icone = GeneratedColumn<String>(
    'icone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [codigo, nome, icone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'disciplinas';
  @override
  VerificationContext validateIntegrity(
    Insertable<DisciplinaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('icone')) {
      context.handle(
        _iconeMeta,
        icone.isAcceptableOrUnknown(data['icone']!, _iconeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  DisciplinaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DisciplinaRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      icone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icone'],
      ),
    );
  }

  @override
  $DisciplinasTable createAlias(String alias) {
    return $DisciplinasTable(attachedDatabase, alias);
  }
}

class DisciplinaRow extends DataClass implements Insertable<DisciplinaRow> {
  final String codigo;
  final String nome;
  final String? icone;
  const DisciplinaRow({required this.codigo, required this.nome, this.icone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || icone != null) {
      map['icone'] = Variable<String>(icone);
    }
    return map;
  }

  DisciplinasCompanion toCompanion(bool nullToAbsent) {
    return DisciplinasCompanion(
      codigo: Value(codigo),
      nome: Value(nome),
      icone: icone == null && nullToAbsent
          ? const Value.absent()
          : Value(icone),
    );
  }

  factory DisciplinaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DisciplinaRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      nome: serializer.fromJson<String>(json['nome']),
      icone: serializer.fromJson<String?>(json['icone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'nome': serializer.toJson<String>(nome),
      'icone': serializer.toJson<String?>(icone),
    };
  }

  DisciplinaRow copyWith({
    String? codigo,
    String? nome,
    Value<String?> icone = const Value.absent(),
  }) => DisciplinaRow(
    codigo: codigo ?? this.codigo,
    nome: nome ?? this.nome,
    icone: icone.present ? icone.value : this.icone,
  );
  DisciplinaRow copyWithCompanion(DisciplinasCompanion data) {
    return DisciplinaRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nome: data.nome.present ? data.nome.value : this.nome,
      icone: data.icone.present ? data.icone.value : this.icone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DisciplinaRow(')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(codigo, nome, icone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DisciplinaRow &&
          other.codigo == this.codigo &&
          other.nome == this.nome &&
          other.icone == this.icone);
}

class DisciplinasCompanion extends UpdateCompanion<DisciplinaRow> {
  final Value<String> codigo;
  final Value<String> nome;
  final Value<String?> icone;
  final Value<int> rowid;
  const DisciplinasCompanion({
    this.codigo = const Value.absent(),
    this.nome = const Value.absent(),
    this.icone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DisciplinasCompanion.insert({
    required String codigo,
    required String nome,
    this.icone = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       nome = Value(nome);
  static Insertable<DisciplinaRow> custom({
    Expression<String>? codigo,
    Expression<String>? nome,
    Expression<String>? icone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (nome != null) 'nome': nome,
      if (icone != null) 'icone': icone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DisciplinasCompanion copyWith({
    Value<String>? codigo,
    Value<String>? nome,
    Value<String?>? icone,
    Value<int>? rowid,
  }) {
    return DisciplinasCompanion(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (icone.present) {
      map['icone'] = Variable<String>(icone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DisciplinasCompanion(')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemasTable extends Temas with TableInfo<$TemasTable, TemaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _disciplinaMeta = const VerificationMeta(
    'disciplina',
  );
  @override
  late final GeneratedColumn<String> disciplina = GeneratedColumn<String>(
    'disciplina',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [codigo, disciplina, nome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temas';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('disciplina')) {
      context.handle(
        _disciplinaMeta,
        disciplina.isAcceptableOrUnknown(data['disciplina']!, _disciplinaMeta),
      );
    } else if (isInserting) {
      context.missing(_disciplinaMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  TemaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemaRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      disciplina: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disciplina'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
    );
  }

  @override
  $TemasTable createAlias(String alias) {
    return $TemasTable(attachedDatabase, alias);
  }
}

class TemaRow extends DataClass implements Insertable<TemaRow> {
  final String codigo;
  final String disciplina;
  final String nome;
  const TemaRow({
    required this.codigo,
    required this.disciplina,
    required this.nome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['disciplina'] = Variable<String>(disciplina);
    map['nome'] = Variable<String>(nome);
    return map;
  }

  TemasCompanion toCompanion(bool nullToAbsent) {
    return TemasCompanion(
      codigo: Value(codigo),
      disciplina: Value(disciplina),
      nome: Value(nome),
    );
  }

  factory TemaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemaRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      disciplina: serializer.fromJson<String>(json['disciplina']),
      nome: serializer.fromJson<String>(json['nome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'disciplina': serializer.toJson<String>(disciplina),
      'nome': serializer.toJson<String>(nome),
    };
  }

  TemaRow copyWith({String? codigo, String? disciplina, String? nome}) =>
      TemaRow(
        codigo: codigo ?? this.codigo,
        disciplina: disciplina ?? this.disciplina,
        nome: nome ?? this.nome,
      );
  TemaRow copyWithCompanion(TemasCompanion data) {
    return TemaRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      disciplina: data.disciplina.present
          ? data.disciplina.value
          : this.disciplina,
      nome: data.nome.present ? data.nome.value : this.nome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemaRow(')
          ..write('codigo: $codigo, ')
          ..write('disciplina: $disciplina, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(codigo, disciplina, nome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemaRow &&
          other.codigo == this.codigo &&
          other.disciplina == this.disciplina &&
          other.nome == this.nome);
}

class TemasCompanion extends UpdateCompanion<TemaRow> {
  final Value<String> codigo;
  final Value<String> disciplina;
  final Value<String> nome;
  final Value<int> rowid;
  const TemasCompanion({
    this.codigo = const Value.absent(),
    this.disciplina = const Value.absent(),
    this.nome = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemasCompanion.insert({
    required String codigo,
    required String disciplina,
    required String nome,
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       disciplina = Value(disciplina),
       nome = Value(nome);
  static Insertable<TemaRow> custom({
    Expression<String>? codigo,
    Expression<String>? disciplina,
    Expression<String>? nome,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (disciplina != null) 'disciplina': disciplina,
      if (nome != null) 'nome': nome,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemasCompanion copyWith({
    Value<String>? codigo,
    Value<String>? disciplina,
    Value<String>? nome,
    Value<int>? rowid,
  }) {
    return TemasCompanion(
      codigo: codigo ?? this.codigo,
      disciplina: disciplina ?? this.disciplina,
      nome: nome ?? this.nome,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (disciplina.present) {
      map['disciplina'] = Variable<String>(disciplina.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemasCompanion(')
          ..write('codigo: $codigo, ')
          ..write('disciplina: $disciplina, ')
          ..write('nome: $nome, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProvasTable extends Provas with TableInfo<$ProvasTable, ProvaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grupoExameMeta = const VerificationMeta(
    'grupoExame',
  );
  @override
  late final GeneratedColumn<String> grupoExame = GeneratedColumn<String>(
    'grupo_exame',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _disciplinaMeta = const VerificationMeta(
    'disciplina',
  );
  @override
  late final GeneratedColumn<String> disciplina = GeneratedColumn<String>(
    'disciplina',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _varianteMeta = const VerificationMeta(
    'variante',
  );
  @override
  late final GeneratedColumn<String> variante = GeneratedColumn<String>(
    'variante',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _duracaoMinMeta = const VerificationMeta(
    'duracaoMin',
  );
  @override
  late final GeneratedColumn<int> duracaoMin = GeneratedColumn<int>(
    'duracao_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numQuestoesMeta = const VerificationMeta(
    'numQuestoes',
  );
  @override
  late final GeneratedColumn<int> numQuestoes = GeneratedColumn<int>(
    'num_questoes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questoesDeMeta = const VerificationMeta(
    'questoesDe',
  );
  @override
  late final GeneratedColumn<String> questoesDe = GeneratedColumn<String>(
    'questoes_de',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    codigo,
    grupoExame,
    disciplina,
    variante,
    nome,
    duracaoMin,
    numQuestoes,
    questoesDe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provas';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProvaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('grupo_exame')) {
      context.handle(
        _grupoExameMeta,
        grupoExame.isAcceptableOrUnknown(data['grupo_exame']!, _grupoExameMeta),
      );
    } else if (isInserting) {
      context.missing(_grupoExameMeta);
    }
    if (data.containsKey('disciplina')) {
      context.handle(
        _disciplinaMeta,
        disciplina.isAcceptableOrUnknown(data['disciplina']!, _disciplinaMeta),
      );
    } else if (isInserting) {
      context.missing(_disciplinaMeta);
    }
    if (data.containsKey('variante')) {
      context.handle(
        _varianteMeta,
        variante.isAcceptableOrUnknown(data['variante']!, _varianteMeta),
      );
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('duracao_min')) {
      context.handle(
        _duracaoMinMeta,
        duracaoMin.isAcceptableOrUnknown(data['duracao_min']!, _duracaoMinMeta),
      );
    }
    if (data.containsKey('num_questoes')) {
      context.handle(
        _numQuestoesMeta,
        numQuestoes.isAcceptableOrUnknown(
          data['num_questoes']!,
          _numQuestoesMeta,
        ),
      );
    }
    if (data.containsKey('questoes_de')) {
      context.handle(
        _questoesDeMeta,
        questoesDe.isAcceptableOrUnknown(data['questoes_de']!, _questoesDeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  ProvaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProvaRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      grupoExame: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grupo_exame'],
      )!,
      disciplina: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disciplina'],
      )!,
      variante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variante'],
      ),
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      duracaoMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duracao_min'],
      ),
      numQuestoes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_questoes'],
      ),
      questoesDe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questoes_de'],
      ),
    );
  }

  @override
  $ProvasTable createAlias(String alias) {
    return $ProvasTable(attachedDatabase, alias);
  }
}

class ProvaRow extends DataClass implements Insertable<ProvaRow> {
  final String codigo;
  final String grupoExame;
  final String disciplina;
  final String? variante;
  final String nome;
  final int? duracaoMin;
  final int? numQuestoes;

  /// Prova sem questões próprias: as questões são as desta (mesma disciplina, outro exame)
  final String? questoesDe;
  const ProvaRow({
    required this.codigo,
    required this.grupoExame,
    required this.disciplina,
    this.variante,
    required this.nome,
    this.duracaoMin,
    this.numQuestoes,
    this.questoesDe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['grupo_exame'] = Variable<String>(grupoExame);
    map['disciplina'] = Variable<String>(disciplina);
    if (!nullToAbsent || variante != null) {
      map['variante'] = Variable<String>(variante);
    }
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || duracaoMin != null) {
      map['duracao_min'] = Variable<int>(duracaoMin);
    }
    if (!nullToAbsent || numQuestoes != null) {
      map['num_questoes'] = Variable<int>(numQuestoes);
    }
    if (!nullToAbsent || questoesDe != null) {
      map['questoes_de'] = Variable<String>(questoesDe);
    }
    return map;
  }

  ProvasCompanion toCompanion(bool nullToAbsent) {
    return ProvasCompanion(
      codigo: Value(codigo),
      grupoExame: Value(grupoExame),
      disciplina: Value(disciplina),
      variante: variante == null && nullToAbsent
          ? const Value.absent()
          : Value(variante),
      nome: Value(nome),
      duracaoMin: duracaoMin == null && nullToAbsent
          ? const Value.absent()
          : Value(duracaoMin),
      numQuestoes: numQuestoes == null && nullToAbsent
          ? const Value.absent()
          : Value(numQuestoes),
      questoesDe: questoesDe == null && nullToAbsent
          ? const Value.absent()
          : Value(questoesDe),
    );
  }

  factory ProvaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProvaRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      grupoExame: serializer.fromJson<String>(json['grupoExame']),
      disciplina: serializer.fromJson<String>(json['disciplina']),
      variante: serializer.fromJson<String?>(json['variante']),
      nome: serializer.fromJson<String>(json['nome']),
      duracaoMin: serializer.fromJson<int?>(json['duracaoMin']),
      numQuestoes: serializer.fromJson<int?>(json['numQuestoes']),
      questoesDe: serializer.fromJson<String?>(json['questoesDe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'grupoExame': serializer.toJson<String>(grupoExame),
      'disciplina': serializer.toJson<String>(disciplina),
      'variante': serializer.toJson<String?>(variante),
      'nome': serializer.toJson<String>(nome),
      'duracaoMin': serializer.toJson<int?>(duracaoMin),
      'numQuestoes': serializer.toJson<int?>(numQuestoes),
      'questoesDe': serializer.toJson<String?>(questoesDe),
    };
  }

  ProvaRow copyWith({
    String? codigo,
    String? grupoExame,
    String? disciplina,
    Value<String?> variante = const Value.absent(),
    String? nome,
    Value<int?> duracaoMin = const Value.absent(),
    Value<int?> numQuestoes = const Value.absent(),
    Value<String?> questoesDe = const Value.absent(),
  }) => ProvaRow(
    codigo: codigo ?? this.codigo,
    grupoExame: grupoExame ?? this.grupoExame,
    disciplina: disciplina ?? this.disciplina,
    variante: variante.present ? variante.value : this.variante,
    nome: nome ?? this.nome,
    duracaoMin: duracaoMin.present ? duracaoMin.value : this.duracaoMin,
    numQuestoes: numQuestoes.present ? numQuestoes.value : this.numQuestoes,
    questoesDe: questoesDe.present ? questoesDe.value : this.questoesDe,
  );
  ProvaRow copyWithCompanion(ProvasCompanion data) {
    return ProvaRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      grupoExame: data.grupoExame.present
          ? data.grupoExame.value
          : this.grupoExame,
      disciplina: data.disciplina.present
          ? data.disciplina.value
          : this.disciplina,
      variante: data.variante.present ? data.variante.value : this.variante,
      nome: data.nome.present ? data.nome.value : this.nome,
      duracaoMin: data.duracaoMin.present
          ? data.duracaoMin.value
          : this.duracaoMin,
      numQuestoes: data.numQuestoes.present
          ? data.numQuestoes.value
          : this.numQuestoes,
      questoesDe: data.questoesDe.present
          ? data.questoesDe.value
          : this.questoesDe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProvaRow(')
          ..write('codigo: $codigo, ')
          ..write('grupoExame: $grupoExame, ')
          ..write('disciplina: $disciplina, ')
          ..write('variante: $variante, ')
          ..write('nome: $nome, ')
          ..write('duracaoMin: $duracaoMin, ')
          ..write('numQuestoes: $numQuestoes, ')
          ..write('questoesDe: $questoesDe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    codigo,
    grupoExame,
    disciplina,
    variante,
    nome,
    duracaoMin,
    numQuestoes,
    questoesDe,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProvaRow &&
          other.codigo == this.codigo &&
          other.grupoExame == this.grupoExame &&
          other.disciplina == this.disciplina &&
          other.variante == this.variante &&
          other.nome == this.nome &&
          other.duracaoMin == this.duracaoMin &&
          other.numQuestoes == this.numQuestoes &&
          other.questoesDe == this.questoesDe);
}

class ProvasCompanion extends UpdateCompanion<ProvaRow> {
  final Value<String> codigo;
  final Value<String> grupoExame;
  final Value<String> disciplina;
  final Value<String?> variante;
  final Value<String> nome;
  final Value<int?> duracaoMin;
  final Value<int?> numQuestoes;
  final Value<String?> questoesDe;
  final Value<int> rowid;
  const ProvasCompanion({
    this.codigo = const Value.absent(),
    this.grupoExame = const Value.absent(),
    this.disciplina = const Value.absent(),
    this.variante = const Value.absent(),
    this.nome = const Value.absent(),
    this.duracaoMin = const Value.absent(),
    this.numQuestoes = const Value.absent(),
    this.questoesDe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProvasCompanion.insert({
    required String codigo,
    required String grupoExame,
    required String disciplina,
    this.variante = const Value.absent(),
    required String nome,
    this.duracaoMin = const Value.absent(),
    this.numQuestoes = const Value.absent(),
    this.questoesDe = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       grupoExame = Value(grupoExame),
       disciplina = Value(disciplina),
       nome = Value(nome);
  static Insertable<ProvaRow> custom({
    Expression<String>? codigo,
    Expression<String>? grupoExame,
    Expression<String>? disciplina,
    Expression<String>? variante,
    Expression<String>? nome,
    Expression<int>? duracaoMin,
    Expression<int>? numQuestoes,
    Expression<String>? questoesDe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (grupoExame != null) 'grupo_exame': grupoExame,
      if (disciplina != null) 'disciplina': disciplina,
      if (variante != null) 'variante': variante,
      if (nome != null) 'nome': nome,
      if (duracaoMin != null) 'duracao_min': duracaoMin,
      if (numQuestoes != null) 'num_questoes': numQuestoes,
      if (questoesDe != null) 'questoes_de': questoesDe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProvasCompanion copyWith({
    Value<String>? codigo,
    Value<String>? grupoExame,
    Value<String>? disciplina,
    Value<String?>? variante,
    Value<String>? nome,
    Value<int?>? duracaoMin,
    Value<int?>? numQuestoes,
    Value<String?>? questoesDe,
    Value<int>? rowid,
  }) {
    return ProvasCompanion(
      codigo: codigo ?? this.codigo,
      grupoExame: grupoExame ?? this.grupoExame,
      disciplina: disciplina ?? this.disciplina,
      variante: variante ?? this.variante,
      nome: nome ?? this.nome,
      duracaoMin: duracaoMin ?? this.duracaoMin,
      numQuestoes: numQuestoes ?? this.numQuestoes,
      questoesDe: questoesDe ?? this.questoesDe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (grupoExame.present) {
      map['grupo_exame'] = Variable<String>(grupoExame.value);
    }
    if (disciplina.present) {
      map['disciplina'] = Variable<String>(disciplina.value);
    }
    if (variante.present) {
      map['variante'] = Variable<String>(variante.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (duracaoMin.present) {
      map['duracao_min'] = Variable<int>(duracaoMin.value);
    }
    if (numQuestoes.present) {
      map['num_questoes'] = Variable<int>(numQuestoes.value);
    }
    if (questoesDe.present) {
      map['questoes_de'] = Variable<String>(questoesDe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvasCompanion(')
          ..write('codigo: $codigo, ')
          ..write('grupoExame: $grupoExame, ')
          ..write('disciplina: $disciplina, ')
          ..write('variante: $variante, ')
          ..write('nome: $nome, ')
          ..write('duracaoMin: $duracaoMin, ')
          ..write('numQuestoes: $numQuestoes, ')
          ..write('questoesDe: $questoesDe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfertasTable extends Ofertas with TableInfo<$OfertasTable, OfertaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfertasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instituicaoMeta = const VerificationMeta(
    'instituicao',
  );
  @override
  late final GeneratedColumn<String> instituicao = GeneratedColumn<String>(
    'instituicao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursoMeta = const VerificationMeta('curso');
  @override
  late final GeneratedColumn<String> curso = GeneratedColumn<String>(
    'curso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _iconeMeta = const VerificationMeta('icone');
  @override
  late final GeneratedColumn<String> icone = GeneratedColumn<String>(
    'icone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nomeOriginalMeta = const VerificationMeta(
    'nomeOriginal',
  );
  @override
  late final GeneratedColumn<String> nomeOriginal = GeneratedColumn<String>(
    'nome_original',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _faculdadeMeta = const VerificationMeta(
    'faculdade',
  );
  @override
  late final GeneratedColumn<String> faculdade = GeneratedColumn<String>(
    'faculdade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _locaisMeta = const VerificationMeta('locais');
  @override
  late final GeneratedColumn<String> locais = GeneratedColumn<String>(
    'locais',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    codigo,
    instituicao,
    curso,
    nome,
    icone,
    nomeOriginal,
    faculdade,
    locais,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ofertas';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfertaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('instituicao')) {
      context.handle(
        _instituicaoMeta,
        instituicao.isAcceptableOrUnknown(
          data['instituicao']!,
          _instituicaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instituicaoMeta);
    }
    if (data.containsKey('curso')) {
      context.handle(
        _cursoMeta,
        curso.isAcceptableOrUnknown(data['curso']!, _cursoMeta),
      );
    } else if (isInserting) {
      context.missing(_cursoMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('icone')) {
      context.handle(
        _iconeMeta,
        icone.isAcceptableOrUnknown(data['icone']!, _iconeMeta),
      );
    }
    if (data.containsKey('nome_original')) {
      context.handle(
        _nomeOriginalMeta,
        nomeOriginal.isAcceptableOrUnknown(
          data['nome_original']!,
          _nomeOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nomeOriginalMeta);
    }
    if (data.containsKey('faculdade')) {
      context.handle(
        _faculdadeMeta,
        faculdade.isAcceptableOrUnknown(data['faculdade']!, _faculdadeMeta),
      );
    }
    if (data.containsKey('locais')) {
      context.handle(
        _locaisMeta,
        locais.isAcceptableOrUnknown(data['locais']!, _locaisMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  OfertaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfertaRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      instituicao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instituicao'],
      )!,
      curso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}curso'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      icone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icone'],
      ),
      nomeOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_original'],
      )!,
      faculdade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faculdade'],
      )!,
      locais: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locais'],
      )!,
    );
  }

  @override
  $OfertasTable createAlias(String alias) {
    return $OfertasTable(attachedDatabase, alias);
  }
}

class OfertaRow extends DataClass implements Insertable<OfertaRow> {
  final String codigo;
  final String instituicao;
  final String curso;
  final String nome;
  final String? icone;
  final String nomeOriginal;
  final String faculdade;
  final String locais;
  const OfertaRow({
    required this.codigo,
    required this.instituicao,
    required this.curso,
    required this.nome,
    this.icone,
    required this.nomeOriginal,
    required this.faculdade,
    required this.locais,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['instituicao'] = Variable<String>(instituicao);
    map['curso'] = Variable<String>(curso);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || icone != null) {
      map['icone'] = Variable<String>(icone);
    }
    map['nome_original'] = Variable<String>(nomeOriginal);
    map['faculdade'] = Variable<String>(faculdade);
    map['locais'] = Variable<String>(locais);
    return map;
  }

  OfertasCompanion toCompanion(bool nullToAbsent) {
    return OfertasCompanion(
      codigo: Value(codigo),
      instituicao: Value(instituicao),
      curso: Value(curso),
      nome: Value(nome),
      icone: icone == null && nullToAbsent
          ? const Value.absent()
          : Value(icone),
      nomeOriginal: Value(nomeOriginal),
      faculdade: Value(faculdade),
      locais: Value(locais),
    );
  }

  factory OfertaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfertaRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      instituicao: serializer.fromJson<String>(json['instituicao']),
      curso: serializer.fromJson<String>(json['curso']),
      nome: serializer.fromJson<String>(json['nome']),
      icone: serializer.fromJson<String?>(json['icone']),
      nomeOriginal: serializer.fromJson<String>(json['nomeOriginal']),
      faculdade: serializer.fromJson<String>(json['faculdade']),
      locais: serializer.fromJson<String>(json['locais']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'instituicao': serializer.toJson<String>(instituicao),
      'curso': serializer.toJson<String>(curso),
      'nome': serializer.toJson<String>(nome),
      'icone': serializer.toJson<String?>(icone),
      'nomeOriginal': serializer.toJson<String>(nomeOriginal),
      'faculdade': serializer.toJson<String>(faculdade),
      'locais': serializer.toJson<String>(locais),
    };
  }

  OfertaRow copyWith({
    String? codigo,
    String? instituicao,
    String? curso,
    String? nome,
    Value<String?> icone = const Value.absent(),
    String? nomeOriginal,
    String? faculdade,
    String? locais,
  }) => OfertaRow(
    codigo: codigo ?? this.codigo,
    instituicao: instituicao ?? this.instituicao,
    curso: curso ?? this.curso,
    nome: nome ?? this.nome,
    icone: icone.present ? icone.value : this.icone,
    nomeOriginal: nomeOriginal ?? this.nomeOriginal,
    faculdade: faculdade ?? this.faculdade,
    locais: locais ?? this.locais,
  );
  OfertaRow copyWithCompanion(OfertasCompanion data) {
    return OfertaRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      instituicao: data.instituicao.present
          ? data.instituicao.value
          : this.instituicao,
      curso: data.curso.present ? data.curso.value : this.curso,
      nome: data.nome.present ? data.nome.value : this.nome,
      icone: data.icone.present ? data.icone.value : this.icone,
      nomeOriginal: data.nomeOriginal.present
          ? data.nomeOriginal.value
          : this.nomeOriginal,
      faculdade: data.faculdade.present ? data.faculdade.value : this.faculdade,
      locais: data.locais.present ? data.locais.value : this.locais,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfertaRow(')
          ..write('codigo: $codigo, ')
          ..write('instituicao: $instituicao, ')
          ..write('curso: $curso, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone, ')
          ..write('nomeOriginal: $nomeOriginal, ')
          ..write('faculdade: $faculdade, ')
          ..write('locais: $locais')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    codigo,
    instituicao,
    curso,
    nome,
    icone,
    nomeOriginal,
    faculdade,
    locais,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfertaRow &&
          other.codigo == this.codigo &&
          other.instituicao == this.instituicao &&
          other.curso == this.curso &&
          other.nome == this.nome &&
          other.icone == this.icone &&
          other.nomeOriginal == this.nomeOriginal &&
          other.faculdade == this.faculdade &&
          other.locais == this.locais);
}

class OfertasCompanion extends UpdateCompanion<OfertaRow> {
  final Value<String> codigo;
  final Value<String> instituicao;
  final Value<String> curso;
  final Value<String> nome;
  final Value<String?> icone;
  final Value<String> nomeOriginal;
  final Value<String> faculdade;
  final Value<String> locais;
  final Value<int> rowid;
  const OfertasCompanion({
    this.codigo = const Value.absent(),
    this.instituicao = const Value.absent(),
    this.curso = const Value.absent(),
    this.nome = const Value.absent(),
    this.icone = const Value.absent(),
    this.nomeOriginal = const Value.absent(),
    this.faculdade = const Value.absent(),
    this.locais = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfertasCompanion.insert({
    required String codigo,
    required String instituicao,
    required String curso,
    required String nome,
    this.icone = const Value.absent(),
    required String nomeOriginal,
    this.faculdade = const Value.absent(),
    this.locais = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       instituicao = Value(instituicao),
       curso = Value(curso),
       nome = Value(nome),
       nomeOriginal = Value(nomeOriginal);
  static Insertable<OfertaRow> custom({
    Expression<String>? codigo,
    Expression<String>? instituicao,
    Expression<String>? curso,
    Expression<String>? nome,
    Expression<String>? icone,
    Expression<String>? nomeOriginal,
    Expression<String>? faculdade,
    Expression<String>? locais,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (instituicao != null) 'instituicao': instituicao,
      if (curso != null) 'curso': curso,
      if (nome != null) 'nome': nome,
      if (icone != null) 'icone': icone,
      if (nomeOriginal != null) 'nome_original': nomeOriginal,
      if (faculdade != null) 'faculdade': faculdade,
      if (locais != null) 'locais': locais,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfertasCompanion copyWith({
    Value<String>? codigo,
    Value<String>? instituicao,
    Value<String>? curso,
    Value<String>? nome,
    Value<String?>? icone,
    Value<String>? nomeOriginal,
    Value<String>? faculdade,
    Value<String>? locais,
    Value<int>? rowid,
  }) {
    return OfertasCompanion(
      codigo: codigo ?? this.codigo,
      instituicao: instituicao ?? this.instituicao,
      curso: curso ?? this.curso,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      nomeOriginal: nomeOriginal ?? this.nomeOriginal,
      faculdade: faculdade ?? this.faculdade,
      locais: locais ?? this.locais,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (instituicao.present) {
      map['instituicao'] = Variable<String>(instituicao.value);
    }
    if (curso.present) {
      map['curso'] = Variable<String>(curso.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (icone.present) {
      map['icone'] = Variable<String>(icone.value);
    }
    if (nomeOriginal.present) {
      map['nome_original'] = Variable<String>(nomeOriginal.value);
    }
    if (faculdade.present) {
      map['faculdade'] = Variable<String>(faculdade.value);
    }
    if (locais.present) {
      map['locais'] = Variable<String>(locais.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfertasCompanion(')
          ..write('codigo: $codigo, ')
          ..write('instituicao: $instituicao, ')
          ..write('curso: $curso, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone, ')
          ..write('nomeOriginal: $nomeOriginal, ')
          ..write('faculdade: $faculdade, ')
          ..write('locais: $locais, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfertaProvaTable extends OfertaProva
    with TableInfo<$OfertaProvaTable, OfertaProvaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfertaProvaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ofertaMeta = const VerificationMeta('oferta');
  @override
  late final GeneratedColumn<String> oferta = GeneratedColumn<String>(
    'oferta',
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
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<int> peso = GeneratedColumn<int>(
    'peso',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [oferta, prova, peso, ordem];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'oferta_prova';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfertaProvaRow> instance, {
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
    if (data.containsKey('prova')) {
      context.handle(
        _provaMeta,
        prova.isAcceptableOrUnknown(data['prova']!, _provaMeta),
      );
    } else if (isInserting) {
      context.missing(_provaMeta);
    }
    if (data.containsKey('peso')) {
      context.handle(
        _pesoMeta,
        peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta),
      );
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {oferta, prova};
  @override
  OfertaProvaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfertaProvaRow(
      oferta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oferta'],
      )!,
      prova: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prova'],
      )!,
      peso: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peso'],
      ),
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $OfertaProvaTable createAlias(String alias) {
    return $OfertaProvaTable(attachedDatabase, alias);
  }
}

class OfertaProvaRow extends DataClass implements Insertable<OfertaProvaRow> {
  final String oferta;
  final String prova;
  final int? peso;
  final int ordem;
  const OfertaProvaRow({
    required this.oferta,
    required this.prova,
    this.peso,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['oferta'] = Variable<String>(oferta);
    map['prova'] = Variable<String>(prova);
    if (!nullToAbsent || peso != null) {
      map['peso'] = Variable<int>(peso);
    }
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  OfertaProvaCompanion toCompanion(bool nullToAbsent) {
    return OfertaProvaCompanion(
      oferta: Value(oferta),
      prova: Value(prova),
      peso: peso == null && nullToAbsent ? const Value.absent() : Value(peso),
      ordem: Value(ordem),
    );
  }

  factory OfertaProvaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfertaProvaRow(
      oferta: serializer.fromJson<String>(json['oferta']),
      prova: serializer.fromJson<String>(json['prova']),
      peso: serializer.fromJson<int?>(json['peso']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'oferta': serializer.toJson<String>(oferta),
      'prova': serializer.toJson<String>(prova),
      'peso': serializer.toJson<int?>(peso),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  OfertaProvaRow copyWith({
    String? oferta,
    String? prova,
    Value<int?> peso = const Value.absent(),
    int? ordem,
  }) => OfertaProvaRow(
    oferta: oferta ?? this.oferta,
    prova: prova ?? this.prova,
    peso: peso.present ? peso.value : this.peso,
    ordem: ordem ?? this.ordem,
  );
  OfertaProvaRow copyWithCompanion(OfertaProvaCompanion data) {
    return OfertaProvaRow(
      oferta: data.oferta.present ? data.oferta.value : this.oferta,
      prova: data.prova.present ? data.prova.value : this.prova,
      peso: data.peso.present ? data.peso.value : this.peso,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfertaProvaRow(')
          ..write('oferta: $oferta, ')
          ..write('prova: $prova, ')
          ..write('peso: $peso, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(oferta, prova, peso, ordem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfertaProvaRow &&
          other.oferta == this.oferta &&
          other.prova == this.prova &&
          other.peso == this.peso &&
          other.ordem == this.ordem);
}

class OfertaProvaCompanion extends UpdateCompanion<OfertaProvaRow> {
  final Value<String> oferta;
  final Value<String> prova;
  final Value<int?> peso;
  final Value<int> ordem;
  final Value<int> rowid;
  const OfertaProvaCompanion({
    this.oferta = const Value.absent(),
    this.prova = const Value.absent(),
    this.peso = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfertaProvaCompanion.insert({
    required String oferta,
    required String prova,
    this.peso = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : oferta = Value(oferta),
       prova = Value(prova);
  static Insertable<OfertaProvaRow> custom({
    Expression<String>? oferta,
    Expression<String>? prova,
    Expression<int>? peso,
    Expression<int>? ordem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (oferta != null) 'oferta': oferta,
      if (prova != null) 'prova': prova,
      if (peso != null) 'peso': peso,
      if (ordem != null) 'ordem': ordem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfertaProvaCompanion copyWith({
    Value<String>? oferta,
    Value<String>? prova,
    Value<int?>? peso,
    Value<int>? ordem,
    Value<int>? rowid,
  }) {
    return OfertaProvaCompanion(
      oferta: oferta ?? this.oferta,
      prova: prova ?? this.prova,
      peso: peso ?? this.peso,
      ordem: ordem ?? this.ordem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (oferta.present) {
      map['oferta'] = Variable<String>(oferta.value);
    }
    if (prova.present) {
      map['prova'] = Variable<String>(prova.value);
    }
    if (peso.present) {
      map['peso'] = Variable<int>(peso.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfertaProvaCompanion(')
          ..write('oferta: $oferta, ')
          ..write('prova: $prova, ')
          ..write('peso: $peso, ')
          ..write('ordem: $ordem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NiveisTable extends Niveis with TableInfo<$NiveisTable, NivelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NiveisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _provaMeta = const VerificationMeta('prova');
  @override
  late final GeneratedColumn<String> prova = GeneratedColumn<String>(
    'prova',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notaMinimaMeta = const VerificationMeta(
    'notaMinima',
  );
  @override
  late final GeneratedColumn<int> notaMinima = GeneratedColumn<int>(
    'nota_minima',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    prova,
    numero,
    titulo,
    descricao,
    notaMinima,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'niveis';
  @override
  VerificationContext validateIntegrity(
    Insertable<NivelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('prova')) {
      context.handle(
        _provaMeta,
        prova.isAcceptableOrUnknown(data['prova']!, _provaMeta),
      );
    } else if (isInserting) {
      context.missing(_provaMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    }
    if (data.containsKey('nota_minima')) {
      context.handle(
        _notaMinimaMeta,
        notaMinima.isAcceptableOrUnknown(data['nota_minima']!, _notaMinimaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {prova, numero};
  @override
  NivelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NivelRow(
      prova: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prova'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      ),
      notaMinima: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nota_minima'],
      ),
    );
  }

  @override
  $NiveisTable createAlias(String alias) {
    return $NiveisTable(attachedDatabase, alias);
  }
}

class NivelRow extends DataClass implements Insertable<NivelRow> {
  final String prova;
  final int numero;
  final String titulo;
  final String? descricao;
  final int? notaMinima;
  const NivelRow({
    required this.prova,
    required this.numero,
    required this.titulo,
    this.descricao,
    this.notaMinima,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['prova'] = Variable<String>(prova);
    map['numero'] = Variable<int>(numero);
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    if (!nullToAbsent || notaMinima != null) {
      map['nota_minima'] = Variable<int>(notaMinima);
    }
    return map;
  }

  NiveisCompanion toCompanion(bool nullToAbsent) {
    return NiveisCompanion(
      prova: Value(prova),
      numero: Value(numero),
      titulo: Value(titulo),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      notaMinima: notaMinima == null && nullToAbsent
          ? const Value.absent()
          : Value(notaMinima),
    );
  }

  factory NivelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NivelRow(
      prova: serializer.fromJson<String>(json['prova']),
      numero: serializer.fromJson<int>(json['numero']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      notaMinima: serializer.fromJson<int?>(json['notaMinima']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'prova': serializer.toJson<String>(prova),
      'numero': serializer.toJson<int>(numero),
      'titulo': serializer.toJson<String>(titulo),
      'descricao': serializer.toJson<String?>(descricao),
      'notaMinima': serializer.toJson<int?>(notaMinima),
    };
  }

  NivelRow copyWith({
    String? prova,
    int? numero,
    String? titulo,
    Value<String?> descricao = const Value.absent(),
    Value<int?> notaMinima = const Value.absent(),
  }) => NivelRow(
    prova: prova ?? this.prova,
    numero: numero ?? this.numero,
    titulo: titulo ?? this.titulo,
    descricao: descricao.present ? descricao.value : this.descricao,
    notaMinima: notaMinima.present ? notaMinima.value : this.notaMinima,
  );
  NivelRow copyWithCompanion(NiveisCompanion data) {
    return NivelRow(
      prova: data.prova.present ? data.prova.value : this.prova,
      numero: data.numero.present ? data.numero.value : this.numero,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      notaMinima: data.notaMinima.present
          ? data.notaMinima.value
          : this.notaMinima,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NivelRow(')
          ..write('prova: $prova, ')
          ..write('numero: $numero, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('notaMinima: $notaMinima')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(prova, numero, titulo, descricao, notaMinima);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NivelRow &&
          other.prova == this.prova &&
          other.numero == this.numero &&
          other.titulo == this.titulo &&
          other.descricao == this.descricao &&
          other.notaMinima == this.notaMinima);
}

class NiveisCompanion extends UpdateCompanion<NivelRow> {
  final Value<String> prova;
  final Value<int> numero;
  final Value<String> titulo;
  final Value<String?> descricao;
  final Value<int?> notaMinima;
  final Value<int> rowid;
  const NiveisCompanion({
    this.prova = const Value.absent(),
    this.numero = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.notaMinima = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NiveisCompanion.insert({
    required String prova,
    required int numero,
    required String titulo,
    this.descricao = const Value.absent(),
    this.notaMinima = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : prova = Value(prova),
       numero = Value(numero),
       titulo = Value(titulo);
  static Insertable<NivelRow> custom({
    Expression<String>? prova,
    Expression<int>? numero,
    Expression<String>? titulo,
    Expression<String>? descricao,
    Expression<int>? notaMinima,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (prova != null) 'prova': prova,
      if (numero != null) 'numero': numero,
      if (titulo != null) 'titulo': titulo,
      if (descricao != null) 'descricao': descricao,
      if (notaMinima != null) 'nota_minima': notaMinima,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NiveisCompanion copyWith({
    Value<String>? prova,
    Value<int>? numero,
    Value<String>? titulo,
    Value<String?>? descricao,
    Value<int?>? notaMinima,
    Value<int>? rowid,
  }) {
    return NiveisCompanion(
      prova: prova ?? this.prova,
      numero: numero ?? this.numero,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      notaMinima: notaMinima ?? this.notaMinima,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (prova.present) {
      map['prova'] = Variable<String>(prova.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (notaMinima.present) {
      map['nota_minima'] = Variable<int>(notaMinima.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NiveisCompanion(')
          ..write('prova: $prova, ')
          ..write('numero: $numero, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('notaMinima: $notaMinima, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TextosBaseTable extends TextosBase
    with TableInfo<$TextosBaseTable, TextoBaseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextosBaseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textoMeta = const VerificationMeta('texto');
  @override
  late final GeneratedColumn<String> texto = GeneratedColumn<String>(
    'texto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [codigo, titulo, texto];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'textos_base';
  @override
  VerificationContext validateIntegrity(
    Insertable<TextoBaseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    }
    if (data.containsKey('texto')) {
      context.handle(
        _textoMeta,
        texto.isAcceptableOrUnknown(data['texto']!, _textoMeta),
      );
    } else if (isInserting) {
      context.missing(_textoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  TextoBaseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TextoBaseRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      ),
      texto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}texto'],
      )!,
    );
  }

  @override
  $TextosBaseTable createAlias(String alias) {
    return $TextosBaseTable(attachedDatabase, alias);
  }
}

class TextoBaseRow extends DataClass implements Insertable<TextoBaseRow> {
  final String codigo;
  final String? titulo;
  final String texto;
  const TextoBaseRow({required this.codigo, this.titulo, required this.texto});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || titulo != null) {
      map['titulo'] = Variable<String>(titulo);
    }
    map['texto'] = Variable<String>(texto);
    return map;
  }

  TextosBaseCompanion toCompanion(bool nullToAbsent) {
    return TextosBaseCompanion(
      codigo: Value(codigo),
      titulo: titulo == null && nullToAbsent
          ? const Value.absent()
          : Value(titulo),
      texto: Value(texto),
    );
  }

  factory TextoBaseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TextoBaseRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      titulo: serializer.fromJson<String?>(json['titulo']),
      texto: serializer.fromJson<String>(json['texto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'titulo': serializer.toJson<String?>(titulo),
      'texto': serializer.toJson<String>(texto),
    };
  }

  TextoBaseRow copyWith({
    String? codigo,
    Value<String?> titulo = const Value.absent(),
    String? texto,
  }) => TextoBaseRow(
    codigo: codigo ?? this.codigo,
    titulo: titulo.present ? titulo.value : this.titulo,
    texto: texto ?? this.texto,
  );
  TextoBaseRow copyWithCompanion(TextosBaseCompanion data) {
    return TextoBaseRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      texto: data.texto.present ? data.texto.value : this.texto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TextoBaseRow(')
          ..write('codigo: $codigo, ')
          ..write('titulo: $titulo, ')
          ..write('texto: $texto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(codigo, titulo, texto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextoBaseRow &&
          other.codigo == this.codigo &&
          other.titulo == this.titulo &&
          other.texto == this.texto);
}

class TextosBaseCompanion extends UpdateCompanion<TextoBaseRow> {
  final Value<String> codigo;
  final Value<String?> titulo;
  final Value<String> texto;
  final Value<int> rowid;
  const TextosBaseCompanion({
    this.codigo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.texto = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TextosBaseCompanion.insert({
    required String codigo,
    this.titulo = const Value.absent(),
    required String texto,
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       texto = Value(texto);
  static Insertable<TextoBaseRow> custom({
    Expression<String>? codigo,
    Expression<String>? titulo,
    Expression<String>? texto,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (titulo != null) 'titulo': titulo,
      if (texto != null) 'texto': texto,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TextosBaseCompanion copyWith({
    Value<String>? codigo,
    Value<String?>? titulo,
    Value<String>? texto,
    Value<int>? rowid,
  }) {
    return TextosBaseCompanion(
      codigo: codigo ?? this.codigo,
      titulo: titulo ?? this.titulo,
      texto: texto ?? this.texto,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextosBaseCompanion(')
          ..write('codigo: $codigo, ')
          ..write('titulo: $titulo, ')
          ..write('texto: $texto, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestoesTable extends Questoes
    with TableInfo<$QuestoesTable, QuestaoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temaMeta = const VerificationMeta('tema');
  @override
  late final GeneratedColumn<String> tema = GeneratedColumn<String>(
    'tema',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textoBaseMeta = const VerificationMeta(
    'textoBase',
  );
  @override
  late final GeneratedColumn<String> textoBase = GeneratedColumn<String>(
    'texto_base',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _enunciadoMeta = const VerificationMeta(
    'enunciado',
  );
  @override
  late final GeneratedColumn<String> enunciado = GeneratedColumn<String>(
    'enunciado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagensMeta = const VerificationMeta(
    'imagens',
  );
  @override
  late final GeneratedColumn<String> imagens = GeneratedColumn<String>(
    'imagens',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dicaMeta = const VerificationMeta('dica');
  @override
  late final GeneratedColumn<String> dica = GeneratedColumn<String>(
    'dica',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _explicacaoMeta = const VerificationMeta(
    'explicacao',
  );
  @override
  late final GeneratedColumn<String> explicacao = GeneratedColumn<String>(
    'explicacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anoMeta = const VerificationMeta('ano');
  @override
  late final GeneratedColumn<int> ano = GeneratedColumn<int>(
    'ano',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dificuldadeMeta = const VerificationMeta(
    'dificuldade',
  );
  @override
  late final GeneratedColumn<int> dificuldade = GeneratedColumn<int>(
    'dificuldade',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    codigo,
    tema,
    textoBase,
    tipo,
    enunciado,
    imagens,
    dica,
    explicacao,
    ano,
    dificuldade,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestaoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('tema')) {
      context.handle(
        _temaMeta,
        tema.isAcceptableOrUnknown(data['tema']!, _temaMeta),
      );
    }
    if (data.containsKey('texto_base')) {
      context.handle(
        _textoBaseMeta,
        textoBase.isAcceptableOrUnknown(data['texto_base']!, _textoBaseMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('enunciado')) {
      context.handle(
        _enunciadoMeta,
        enunciado.isAcceptableOrUnknown(data['enunciado']!, _enunciadoMeta),
      );
    } else if (isInserting) {
      context.missing(_enunciadoMeta);
    }
    if (data.containsKey('imagens')) {
      context.handle(
        _imagensMeta,
        imagens.isAcceptableOrUnknown(data['imagens']!, _imagensMeta),
      );
    }
    if (data.containsKey('dica')) {
      context.handle(
        _dicaMeta,
        dica.isAcceptableOrUnknown(data['dica']!, _dicaMeta),
      );
    }
    if (data.containsKey('explicacao')) {
      context.handle(
        _explicacaoMeta,
        explicacao.isAcceptableOrUnknown(data['explicacao']!, _explicacaoMeta),
      );
    } else if (isInserting) {
      context.missing(_explicacaoMeta);
    }
    if (data.containsKey('ano')) {
      context.handle(
        _anoMeta,
        ano.isAcceptableOrUnknown(data['ano']!, _anoMeta),
      );
    }
    if (data.containsKey('dificuldade')) {
      context.handle(
        _dificuldadeMeta,
        dificuldade.isAcceptableOrUnknown(
          data['dificuldade']!,
          _dificuldadeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  QuestaoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestaoRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      tema: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tema'],
      ),
      textoBase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}texto_base'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      enunciado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enunciado'],
      )!,
      imagens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imagens'],
      )!,
      dica: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dica'],
      ),
      explicacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explicacao'],
      )!,
      ano: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ano'],
      ),
      dificuldade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dificuldade'],
      ),
    );
  }

  @override
  $QuestoesTable createAlias(String alias) {
    return $QuestoesTable(attachedDatabase, alias);
  }
}

class QuestaoRow extends DataClass implements Insertable<QuestaoRow> {
  final String codigo;
  final String? tema;
  final String? textoBase;

  /// escolha_multipla | verdadeiro_falso
  final String tipo;
  final String enunciado;

  /// JSON: lista de nomes de imagem
  final String imagens;
  final String? dica;
  final String explicacao;
  final int? ano;
  final int? dificuldade;
  const QuestaoRow({
    required this.codigo,
    this.tema,
    this.textoBase,
    required this.tipo,
    required this.enunciado,
    required this.imagens,
    this.dica,
    required this.explicacao,
    this.ano,
    this.dificuldade,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || tema != null) {
      map['tema'] = Variable<String>(tema);
    }
    if (!nullToAbsent || textoBase != null) {
      map['texto_base'] = Variable<String>(textoBase);
    }
    map['tipo'] = Variable<String>(tipo);
    map['enunciado'] = Variable<String>(enunciado);
    map['imagens'] = Variable<String>(imagens);
    if (!nullToAbsent || dica != null) {
      map['dica'] = Variable<String>(dica);
    }
    map['explicacao'] = Variable<String>(explicacao);
    if (!nullToAbsent || ano != null) {
      map['ano'] = Variable<int>(ano);
    }
    if (!nullToAbsent || dificuldade != null) {
      map['dificuldade'] = Variable<int>(dificuldade);
    }
    return map;
  }

  QuestoesCompanion toCompanion(bool nullToAbsent) {
    return QuestoesCompanion(
      codigo: Value(codigo),
      tema: tema == null && nullToAbsent ? const Value.absent() : Value(tema),
      textoBase: textoBase == null && nullToAbsent
          ? const Value.absent()
          : Value(textoBase),
      tipo: Value(tipo),
      enunciado: Value(enunciado),
      imagens: Value(imagens),
      dica: dica == null && nullToAbsent ? const Value.absent() : Value(dica),
      explicacao: Value(explicacao),
      ano: ano == null && nullToAbsent ? const Value.absent() : Value(ano),
      dificuldade: dificuldade == null && nullToAbsent
          ? const Value.absent()
          : Value(dificuldade),
    );
  }

  factory QuestaoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestaoRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      tema: serializer.fromJson<String?>(json['tema']),
      textoBase: serializer.fromJson<String?>(json['textoBase']),
      tipo: serializer.fromJson<String>(json['tipo']),
      enunciado: serializer.fromJson<String>(json['enunciado']),
      imagens: serializer.fromJson<String>(json['imagens']),
      dica: serializer.fromJson<String?>(json['dica']),
      explicacao: serializer.fromJson<String>(json['explicacao']),
      ano: serializer.fromJson<int?>(json['ano']),
      dificuldade: serializer.fromJson<int?>(json['dificuldade']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'tema': serializer.toJson<String?>(tema),
      'textoBase': serializer.toJson<String?>(textoBase),
      'tipo': serializer.toJson<String>(tipo),
      'enunciado': serializer.toJson<String>(enunciado),
      'imagens': serializer.toJson<String>(imagens),
      'dica': serializer.toJson<String?>(dica),
      'explicacao': serializer.toJson<String>(explicacao),
      'ano': serializer.toJson<int?>(ano),
      'dificuldade': serializer.toJson<int?>(dificuldade),
    };
  }

  QuestaoRow copyWith({
    String? codigo,
    Value<String?> tema = const Value.absent(),
    Value<String?> textoBase = const Value.absent(),
    String? tipo,
    String? enunciado,
    String? imagens,
    Value<String?> dica = const Value.absent(),
    String? explicacao,
    Value<int?> ano = const Value.absent(),
    Value<int?> dificuldade = const Value.absent(),
  }) => QuestaoRow(
    codigo: codigo ?? this.codigo,
    tema: tema.present ? tema.value : this.tema,
    textoBase: textoBase.present ? textoBase.value : this.textoBase,
    tipo: tipo ?? this.tipo,
    enunciado: enunciado ?? this.enunciado,
    imagens: imagens ?? this.imagens,
    dica: dica.present ? dica.value : this.dica,
    explicacao: explicacao ?? this.explicacao,
    ano: ano.present ? ano.value : this.ano,
    dificuldade: dificuldade.present ? dificuldade.value : this.dificuldade,
  );
  QuestaoRow copyWithCompanion(QuestoesCompanion data) {
    return QuestaoRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      tema: data.tema.present ? data.tema.value : this.tema,
      textoBase: data.textoBase.present ? data.textoBase.value : this.textoBase,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      enunciado: data.enunciado.present ? data.enunciado.value : this.enunciado,
      imagens: data.imagens.present ? data.imagens.value : this.imagens,
      dica: data.dica.present ? data.dica.value : this.dica,
      explicacao: data.explicacao.present
          ? data.explicacao.value
          : this.explicacao,
      ano: data.ano.present ? data.ano.value : this.ano,
      dificuldade: data.dificuldade.present
          ? data.dificuldade.value
          : this.dificuldade,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestaoRow(')
          ..write('codigo: $codigo, ')
          ..write('tema: $tema, ')
          ..write('textoBase: $textoBase, ')
          ..write('tipo: $tipo, ')
          ..write('enunciado: $enunciado, ')
          ..write('imagens: $imagens, ')
          ..write('dica: $dica, ')
          ..write('explicacao: $explicacao, ')
          ..write('ano: $ano, ')
          ..write('dificuldade: $dificuldade')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    codigo,
    tema,
    textoBase,
    tipo,
    enunciado,
    imagens,
    dica,
    explicacao,
    ano,
    dificuldade,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestaoRow &&
          other.codigo == this.codigo &&
          other.tema == this.tema &&
          other.textoBase == this.textoBase &&
          other.tipo == this.tipo &&
          other.enunciado == this.enunciado &&
          other.imagens == this.imagens &&
          other.dica == this.dica &&
          other.explicacao == this.explicacao &&
          other.ano == this.ano &&
          other.dificuldade == this.dificuldade);
}

class QuestoesCompanion extends UpdateCompanion<QuestaoRow> {
  final Value<String> codigo;
  final Value<String?> tema;
  final Value<String?> textoBase;
  final Value<String> tipo;
  final Value<String> enunciado;
  final Value<String> imagens;
  final Value<String?> dica;
  final Value<String> explicacao;
  final Value<int?> ano;
  final Value<int?> dificuldade;
  final Value<int> rowid;
  const QuestoesCompanion({
    this.codigo = const Value.absent(),
    this.tema = const Value.absent(),
    this.textoBase = const Value.absent(),
    this.tipo = const Value.absent(),
    this.enunciado = const Value.absent(),
    this.imagens = const Value.absent(),
    this.dica = const Value.absent(),
    this.explicacao = const Value.absent(),
    this.ano = const Value.absent(),
    this.dificuldade = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestoesCompanion.insert({
    required String codigo,
    this.tema = const Value.absent(),
    this.textoBase = const Value.absent(),
    required String tipo,
    required String enunciado,
    this.imagens = const Value.absent(),
    this.dica = const Value.absent(),
    required String explicacao,
    this.ano = const Value.absent(),
    this.dificuldade = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       tipo = Value(tipo),
       enunciado = Value(enunciado),
       explicacao = Value(explicacao);
  static Insertable<QuestaoRow> custom({
    Expression<String>? codigo,
    Expression<String>? tema,
    Expression<String>? textoBase,
    Expression<String>? tipo,
    Expression<String>? enunciado,
    Expression<String>? imagens,
    Expression<String>? dica,
    Expression<String>? explicacao,
    Expression<int>? ano,
    Expression<int>? dificuldade,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (tema != null) 'tema': tema,
      if (textoBase != null) 'texto_base': textoBase,
      if (tipo != null) 'tipo': tipo,
      if (enunciado != null) 'enunciado': enunciado,
      if (imagens != null) 'imagens': imagens,
      if (dica != null) 'dica': dica,
      if (explicacao != null) 'explicacao': explicacao,
      if (ano != null) 'ano': ano,
      if (dificuldade != null) 'dificuldade': dificuldade,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestoesCompanion copyWith({
    Value<String>? codigo,
    Value<String?>? tema,
    Value<String?>? textoBase,
    Value<String>? tipo,
    Value<String>? enunciado,
    Value<String>? imagens,
    Value<String?>? dica,
    Value<String>? explicacao,
    Value<int?>? ano,
    Value<int?>? dificuldade,
    Value<int>? rowid,
  }) {
    return QuestoesCompanion(
      codigo: codigo ?? this.codigo,
      tema: tema ?? this.tema,
      textoBase: textoBase ?? this.textoBase,
      tipo: tipo ?? this.tipo,
      enunciado: enunciado ?? this.enunciado,
      imagens: imagens ?? this.imagens,
      dica: dica ?? this.dica,
      explicacao: explicacao ?? this.explicacao,
      ano: ano ?? this.ano,
      dificuldade: dificuldade ?? this.dificuldade,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (tema.present) {
      map['tema'] = Variable<String>(tema.value);
    }
    if (textoBase.present) {
      map['texto_base'] = Variable<String>(textoBase.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (enunciado.present) {
      map['enunciado'] = Variable<String>(enunciado.value);
    }
    if (imagens.present) {
      map['imagens'] = Variable<String>(imagens.value);
    }
    if (dica.present) {
      map['dica'] = Variable<String>(dica.value);
    }
    if (explicacao.present) {
      map['explicacao'] = Variable<String>(explicacao.value);
    }
    if (ano.present) {
      map['ano'] = Variable<int>(ano.value);
    }
    if (dificuldade.present) {
      map['dificuldade'] = Variable<int>(dificuldade.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestoesCompanion(')
          ..write('codigo: $codigo, ')
          ..write('tema: $tema, ')
          ..write('textoBase: $textoBase, ')
          ..write('tipo: $tipo, ')
          ..write('enunciado: $enunciado, ')
          ..write('imagens: $imagens, ')
          ..write('dica: $dica, ')
          ..write('explicacao: $explicacao, ')
          ..write('ano: $ano, ')
          ..write('dificuldade: $dificuldade, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestaoProvaTable extends QuestaoProva
    with TableInfo<$QuestaoProvaTable, QuestaoProvaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestaoProvaTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [questao, prova, nivel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questao_prova';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestaoProvaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('questao')) {
      context.handle(
        _questaoMeta,
        questao.isAcceptableOrUnknown(data['questao']!, _questaoMeta),
      );
    } else if (isInserting) {
      context.missing(_questaoMeta);
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
    } else if (isInserting) {
      context.missing(_nivelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questao, prova};
  @override
  QuestaoProvaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestaoProvaRow(
      questao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questao'],
      )!,
      prova: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prova'],
      )!,
      nivel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nivel'],
      )!,
    );
  }

  @override
  $QuestaoProvaTable createAlias(String alias) {
    return $QuestaoProvaTable(attachedDatabase, alias);
  }
}

class QuestaoProvaRow extends DataClass implements Insertable<QuestaoProvaRow> {
  final String questao;
  final String prova;
  final int nivel;
  const QuestaoProvaRow({
    required this.questao,
    required this.prova,
    required this.nivel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['questao'] = Variable<String>(questao);
    map['prova'] = Variable<String>(prova);
    map['nivel'] = Variable<int>(nivel);
    return map;
  }

  QuestaoProvaCompanion toCompanion(bool nullToAbsent) {
    return QuestaoProvaCompanion(
      questao: Value(questao),
      prova: Value(prova),
      nivel: Value(nivel),
    );
  }

  factory QuestaoProvaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestaoProvaRow(
      questao: serializer.fromJson<String>(json['questao']),
      prova: serializer.fromJson<String>(json['prova']),
      nivel: serializer.fromJson<int>(json['nivel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questao': serializer.toJson<String>(questao),
      'prova': serializer.toJson<String>(prova),
      'nivel': serializer.toJson<int>(nivel),
    };
  }

  QuestaoProvaRow copyWith({String? questao, String? prova, int? nivel}) =>
      QuestaoProvaRow(
        questao: questao ?? this.questao,
        prova: prova ?? this.prova,
        nivel: nivel ?? this.nivel,
      );
  QuestaoProvaRow copyWithCompanion(QuestaoProvaCompanion data) {
    return QuestaoProvaRow(
      questao: data.questao.present ? data.questao.value : this.questao,
      prova: data.prova.present ? data.prova.value : this.prova,
      nivel: data.nivel.present ? data.nivel.value : this.nivel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestaoProvaRow(')
          ..write('questao: $questao, ')
          ..write('prova: $prova, ')
          ..write('nivel: $nivel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questao, prova, nivel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestaoProvaRow &&
          other.questao == this.questao &&
          other.prova == this.prova &&
          other.nivel == this.nivel);
}

class QuestaoProvaCompanion extends UpdateCompanion<QuestaoProvaRow> {
  final Value<String> questao;
  final Value<String> prova;
  final Value<int> nivel;
  final Value<int> rowid;
  const QuestaoProvaCompanion({
    this.questao = const Value.absent(),
    this.prova = const Value.absent(),
    this.nivel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestaoProvaCompanion.insert({
    required String questao,
    required String prova,
    required int nivel,
    this.rowid = const Value.absent(),
  }) : questao = Value(questao),
       prova = Value(prova),
       nivel = Value(nivel);
  static Insertable<QuestaoProvaRow> custom({
    Expression<String>? questao,
    Expression<String>? prova,
    Expression<int>? nivel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questao != null) 'questao': questao,
      if (prova != null) 'prova': prova,
      if (nivel != null) 'nivel': nivel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestaoProvaCompanion copyWith({
    Value<String>? questao,
    Value<String>? prova,
    Value<int>? nivel,
    Value<int>? rowid,
  }) {
    return QuestaoProvaCompanion(
      questao: questao ?? this.questao,
      prova: prova ?? this.prova,
      nivel: nivel ?? this.nivel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questao.present) {
      map['questao'] = Variable<String>(questao.value);
    }
    if (prova.present) {
      map['prova'] = Variable<String>(prova.value);
    }
    if (nivel.present) {
      map['nivel'] = Variable<int>(nivel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestaoProvaCompanion(')
          ..write('questao: $questao, ')
          ..write('prova: $prova, ')
          ..write('nivel: $nivel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlternativasTable extends Alternativas
    with TableInfo<$AlternativasTable, AlternativaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlternativasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _letraMeta = const VerificationMeta('letra');
  @override
  late final GeneratedColumn<String> letra = GeneratedColumn<String>(
    'letra',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textoMeta = const VerificationMeta('texto');
  @override
  late final GeneratedColumn<String> texto = GeneratedColumn<String>(
    'texto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagemMeta = const VerificationMeta('imagem');
  @override
  late final GeneratedColumn<String> imagem = GeneratedColumn<String>(
    'imagem',
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
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correcta" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    questao,
    letra,
    texto,
    imagem,
    correcta,
    ordem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alternativas';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlternativaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('questao')) {
      context.handle(
        _questaoMeta,
        questao.isAcceptableOrUnknown(data['questao']!, _questaoMeta),
      );
    } else if (isInserting) {
      context.missing(_questaoMeta);
    }
    if (data.containsKey('letra')) {
      context.handle(
        _letraMeta,
        letra.isAcceptableOrUnknown(data['letra']!, _letraMeta),
      );
    } else if (isInserting) {
      context.missing(_letraMeta);
    }
    if (data.containsKey('texto')) {
      context.handle(
        _textoMeta,
        texto.isAcceptableOrUnknown(data['texto']!, _textoMeta),
      );
    }
    if (data.containsKey('imagem')) {
      context.handle(
        _imagemMeta,
        imagem.isAcceptableOrUnknown(data['imagem']!, _imagemMeta),
      );
    }
    if (data.containsKey('correcta')) {
      context.handle(
        _correctaMeta,
        correcta.isAcceptableOrUnknown(data['correcta']!, _correctaMeta),
      );
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    } else if (isInserting) {
      context.missing(_ordemMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questao, letra};
  @override
  AlternativaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlternativaRow(
      questao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questao'],
      )!,
      letra: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}letra'],
      )!,
      texto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}texto'],
      ),
      imagem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imagem'],
      ),
      correcta: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correcta'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $AlternativasTable createAlias(String alias) {
    return $AlternativasTable(attachedDatabase, alias);
  }
}

class AlternativaRow extends DataClass implements Insertable<AlternativaRow> {
  final String questao;
  final String letra;
  final String? texto;
  final String? imagem;
  final bool correcta;
  final int ordem;
  const AlternativaRow({
    required this.questao,
    required this.letra,
    this.texto,
    this.imagem,
    required this.correcta,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['questao'] = Variable<String>(questao);
    map['letra'] = Variable<String>(letra);
    if (!nullToAbsent || texto != null) {
      map['texto'] = Variable<String>(texto);
    }
    if (!nullToAbsent || imagem != null) {
      map['imagem'] = Variable<String>(imagem);
    }
    map['correcta'] = Variable<bool>(correcta);
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  AlternativasCompanion toCompanion(bool nullToAbsent) {
    return AlternativasCompanion(
      questao: Value(questao),
      letra: Value(letra),
      texto: texto == null && nullToAbsent
          ? const Value.absent()
          : Value(texto),
      imagem: imagem == null && nullToAbsent
          ? const Value.absent()
          : Value(imagem),
      correcta: Value(correcta),
      ordem: Value(ordem),
    );
  }

  factory AlternativaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlternativaRow(
      questao: serializer.fromJson<String>(json['questao']),
      letra: serializer.fromJson<String>(json['letra']),
      texto: serializer.fromJson<String?>(json['texto']),
      imagem: serializer.fromJson<String?>(json['imagem']),
      correcta: serializer.fromJson<bool>(json['correcta']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questao': serializer.toJson<String>(questao),
      'letra': serializer.toJson<String>(letra),
      'texto': serializer.toJson<String?>(texto),
      'imagem': serializer.toJson<String?>(imagem),
      'correcta': serializer.toJson<bool>(correcta),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  AlternativaRow copyWith({
    String? questao,
    String? letra,
    Value<String?> texto = const Value.absent(),
    Value<String?> imagem = const Value.absent(),
    bool? correcta,
    int? ordem,
  }) => AlternativaRow(
    questao: questao ?? this.questao,
    letra: letra ?? this.letra,
    texto: texto.present ? texto.value : this.texto,
    imagem: imagem.present ? imagem.value : this.imagem,
    correcta: correcta ?? this.correcta,
    ordem: ordem ?? this.ordem,
  );
  AlternativaRow copyWithCompanion(AlternativasCompanion data) {
    return AlternativaRow(
      questao: data.questao.present ? data.questao.value : this.questao,
      letra: data.letra.present ? data.letra.value : this.letra,
      texto: data.texto.present ? data.texto.value : this.texto,
      imagem: data.imagem.present ? data.imagem.value : this.imagem,
      correcta: data.correcta.present ? data.correcta.value : this.correcta,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlternativaRow(')
          ..write('questao: $questao, ')
          ..write('letra: $letra, ')
          ..write('texto: $texto, ')
          ..write('imagem: $imagem, ')
          ..write('correcta: $correcta, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(questao, letra, texto, imagem, correcta, ordem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlternativaRow &&
          other.questao == this.questao &&
          other.letra == this.letra &&
          other.texto == this.texto &&
          other.imagem == this.imagem &&
          other.correcta == this.correcta &&
          other.ordem == this.ordem);
}

class AlternativasCompanion extends UpdateCompanion<AlternativaRow> {
  final Value<String> questao;
  final Value<String> letra;
  final Value<String?> texto;
  final Value<String?> imagem;
  final Value<bool> correcta;
  final Value<int> ordem;
  final Value<int> rowid;
  const AlternativasCompanion({
    this.questao = const Value.absent(),
    this.letra = const Value.absent(),
    this.texto = const Value.absent(),
    this.imagem = const Value.absent(),
    this.correcta = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlternativasCompanion.insert({
    required String questao,
    required String letra,
    this.texto = const Value.absent(),
    this.imagem = const Value.absent(),
    this.correcta = const Value.absent(),
    required int ordem,
    this.rowid = const Value.absent(),
  }) : questao = Value(questao),
       letra = Value(letra),
       ordem = Value(ordem);
  static Insertable<AlternativaRow> custom({
    Expression<String>? questao,
    Expression<String>? letra,
    Expression<String>? texto,
    Expression<String>? imagem,
    Expression<bool>? correcta,
    Expression<int>? ordem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questao != null) 'questao': questao,
      if (letra != null) 'letra': letra,
      if (texto != null) 'texto': texto,
      if (imagem != null) 'imagem': imagem,
      if (correcta != null) 'correcta': correcta,
      if (ordem != null) 'ordem': ordem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlternativasCompanion copyWith({
    Value<String>? questao,
    Value<String>? letra,
    Value<String?>? texto,
    Value<String?>? imagem,
    Value<bool>? correcta,
    Value<int>? ordem,
    Value<int>? rowid,
  }) {
    return AlternativasCompanion(
      questao: questao ?? this.questao,
      letra: letra ?? this.letra,
      texto: texto ?? this.texto,
      imagem: imagem ?? this.imagem,
      correcta: correcta ?? this.correcta,
      ordem: ordem ?? this.ordem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questao.present) {
      map['questao'] = Variable<String>(questao.value);
    }
    if (letra.present) {
      map['letra'] = Variable<String>(letra.value);
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    if (imagem.present) {
      map['imagem'] = Variable<String>(imagem.value);
    }
    if (correcta.present) {
      map['correcta'] = Variable<bool>(correcta.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlternativasCompanion(')
          ..write('questao: $questao, ')
          ..write('letra: $letra, ')
          ..write('texto: $texto, ')
          ..write('imagem: $imagem, ')
          ..write('correcta: $correcta, ')
          ..write('ordem: $ordem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SimuladosTable extends Simulados
    with TableInfo<$SimuladosTable, SimuladoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SimuladosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ofertaMeta = const VerificationMeta('oferta');
  @override
  late final GeneratedColumn<String> oferta = GeneratedColumn<String>(
    'oferta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duracaoMinMeta = const VerificationMeta(
    'duracaoMin',
  );
  @override
  late final GeneratedColumn<int> duracaoMin = GeneratedColumn<int>(
    'duracao_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numPerguntasMeta = const VerificationMeta(
    'numPerguntas',
  );
  @override
  late final GeneratedColumn<int> numPerguntas = GeneratedColumn<int>(
    'num_perguntas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gratuitoMeta = const VerificationMeta(
    'gratuito',
  );
  @override
  late final GeneratedColumn<bool> gratuito = GeneratedColumn<bool>(
    'gratuito',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gratuito" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    codigo,
    prova,
    oferta,
    titulo,
    duracaoMin,
    numPerguntas,
    gratuito,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'simulados';
  @override
  VerificationContext validateIntegrity(
    Insertable<SimuladoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('prova')) {
      context.handle(
        _provaMeta,
        prova.isAcceptableOrUnknown(data['prova']!, _provaMeta),
      );
    }
    if (data.containsKey('oferta')) {
      context.handle(
        _ofertaMeta,
        oferta.isAcceptableOrUnknown(data['oferta']!, _ofertaMeta),
      );
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('duracao_min')) {
      context.handle(
        _duracaoMinMeta,
        duracaoMin.isAcceptableOrUnknown(data['duracao_min']!, _duracaoMinMeta),
      );
    } else if (isInserting) {
      context.missing(_duracaoMinMeta);
    }
    if (data.containsKey('num_perguntas')) {
      context.handle(
        _numPerguntasMeta,
        numPerguntas.isAcceptableOrUnknown(
          data['num_perguntas']!,
          _numPerguntasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numPerguntasMeta);
    }
    if (data.containsKey('gratuito')) {
      context.handle(
        _gratuitoMeta,
        gratuito.isAcceptableOrUnknown(data['gratuito']!, _gratuitoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  SimuladoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SimuladoRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      prova: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prova'],
      ),
      oferta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oferta'],
      ),
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      duracaoMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duracao_min'],
      )!,
      numPerguntas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_perguntas'],
      )!,
      gratuito: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}gratuito'],
      )!,
    );
  }

  @override
  $SimuladosTable createAlias(String alias) {
    return $SimuladosTable(attachedDatabase, alias);
  }
}

class SimuladoRow extends DataClass implements Insertable<SimuladoRow> {
  final String codigo;
  final String? prova;
  final String? oferta;
  final String titulo;
  final int duracaoMin;
  final int numPerguntas;
  final bool gratuito;
  const SimuladoRow({
    required this.codigo,
    this.prova,
    this.oferta,
    required this.titulo,
    required this.duracaoMin,
    required this.numPerguntas,
    required this.gratuito,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || prova != null) {
      map['prova'] = Variable<String>(prova);
    }
    if (!nullToAbsent || oferta != null) {
      map['oferta'] = Variable<String>(oferta);
    }
    map['titulo'] = Variable<String>(titulo);
    map['duracao_min'] = Variable<int>(duracaoMin);
    map['num_perguntas'] = Variable<int>(numPerguntas);
    map['gratuito'] = Variable<bool>(gratuito);
    return map;
  }

  SimuladosCompanion toCompanion(bool nullToAbsent) {
    return SimuladosCompanion(
      codigo: Value(codigo),
      prova: prova == null && nullToAbsent
          ? const Value.absent()
          : Value(prova),
      oferta: oferta == null && nullToAbsent
          ? const Value.absent()
          : Value(oferta),
      titulo: Value(titulo),
      duracaoMin: Value(duracaoMin),
      numPerguntas: Value(numPerguntas),
      gratuito: Value(gratuito),
    );
  }

  factory SimuladoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SimuladoRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      prova: serializer.fromJson<String?>(json['prova']),
      oferta: serializer.fromJson<String?>(json['oferta']),
      titulo: serializer.fromJson<String>(json['titulo']),
      duracaoMin: serializer.fromJson<int>(json['duracaoMin']),
      numPerguntas: serializer.fromJson<int>(json['numPerguntas']),
      gratuito: serializer.fromJson<bool>(json['gratuito']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'prova': serializer.toJson<String?>(prova),
      'oferta': serializer.toJson<String?>(oferta),
      'titulo': serializer.toJson<String>(titulo),
      'duracaoMin': serializer.toJson<int>(duracaoMin),
      'numPerguntas': serializer.toJson<int>(numPerguntas),
      'gratuito': serializer.toJson<bool>(gratuito),
    };
  }

  SimuladoRow copyWith({
    String? codigo,
    Value<String?> prova = const Value.absent(),
    Value<String?> oferta = const Value.absent(),
    String? titulo,
    int? duracaoMin,
    int? numPerguntas,
    bool? gratuito,
  }) => SimuladoRow(
    codigo: codigo ?? this.codigo,
    prova: prova.present ? prova.value : this.prova,
    oferta: oferta.present ? oferta.value : this.oferta,
    titulo: titulo ?? this.titulo,
    duracaoMin: duracaoMin ?? this.duracaoMin,
    numPerguntas: numPerguntas ?? this.numPerguntas,
    gratuito: gratuito ?? this.gratuito,
  );
  SimuladoRow copyWithCompanion(SimuladosCompanion data) {
    return SimuladoRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      prova: data.prova.present ? data.prova.value : this.prova,
      oferta: data.oferta.present ? data.oferta.value : this.oferta,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      duracaoMin: data.duracaoMin.present
          ? data.duracaoMin.value
          : this.duracaoMin,
      numPerguntas: data.numPerguntas.present
          ? data.numPerguntas.value
          : this.numPerguntas,
      gratuito: data.gratuito.present ? data.gratuito.value : this.gratuito,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SimuladoRow(')
          ..write('codigo: $codigo, ')
          ..write('prova: $prova, ')
          ..write('oferta: $oferta, ')
          ..write('titulo: $titulo, ')
          ..write('duracaoMin: $duracaoMin, ')
          ..write('numPerguntas: $numPerguntas, ')
          ..write('gratuito: $gratuito')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    codigo,
    prova,
    oferta,
    titulo,
    duracaoMin,
    numPerguntas,
    gratuito,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SimuladoRow &&
          other.codigo == this.codigo &&
          other.prova == this.prova &&
          other.oferta == this.oferta &&
          other.titulo == this.titulo &&
          other.duracaoMin == this.duracaoMin &&
          other.numPerguntas == this.numPerguntas &&
          other.gratuito == this.gratuito);
}

class SimuladosCompanion extends UpdateCompanion<SimuladoRow> {
  final Value<String> codigo;
  final Value<String?> prova;
  final Value<String?> oferta;
  final Value<String> titulo;
  final Value<int> duracaoMin;
  final Value<int> numPerguntas;
  final Value<bool> gratuito;
  final Value<int> rowid;
  const SimuladosCompanion({
    this.codigo = const Value.absent(),
    this.prova = const Value.absent(),
    this.oferta = const Value.absent(),
    this.titulo = const Value.absent(),
    this.duracaoMin = const Value.absent(),
    this.numPerguntas = const Value.absent(),
    this.gratuito = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SimuladosCompanion.insert({
    required String codigo,
    this.prova = const Value.absent(),
    this.oferta = const Value.absent(),
    required String titulo,
    required int duracaoMin,
    required int numPerguntas,
    this.gratuito = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       titulo = Value(titulo),
       duracaoMin = Value(duracaoMin),
       numPerguntas = Value(numPerguntas);
  static Insertable<SimuladoRow> custom({
    Expression<String>? codigo,
    Expression<String>? prova,
    Expression<String>? oferta,
    Expression<String>? titulo,
    Expression<int>? duracaoMin,
    Expression<int>? numPerguntas,
    Expression<bool>? gratuito,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (prova != null) 'prova': prova,
      if (oferta != null) 'oferta': oferta,
      if (titulo != null) 'titulo': titulo,
      if (duracaoMin != null) 'duracao_min': duracaoMin,
      if (numPerguntas != null) 'num_perguntas': numPerguntas,
      if (gratuito != null) 'gratuito': gratuito,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SimuladosCompanion copyWith({
    Value<String>? codigo,
    Value<String?>? prova,
    Value<String?>? oferta,
    Value<String>? titulo,
    Value<int>? duracaoMin,
    Value<int>? numPerguntas,
    Value<bool>? gratuito,
    Value<int>? rowid,
  }) {
    return SimuladosCompanion(
      codigo: codigo ?? this.codigo,
      prova: prova ?? this.prova,
      oferta: oferta ?? this.oferta,
      titulo: titulo ?? this.titulo,
      duracaoMin: duracaoMin ?? this.duracaoMin,
      numPerguntas: numPerguntas ?? this.numPerguntas,
      gratuito: gratuito ?? this.gratuito,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (prova.present) {
      map['prova'] = Variable<String>(prova.value);
    }
    if (oferta.present) {
      map['oferta'] = Variable<String>(oferta.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (duracaoMin.present) {
      map['duracao_min'] = Variable<int>(duracaoMin.value);
    }
    if (numPerguntas.present) {
      map['num_perguntas'] = Variable<int>(numPerguntas.value);
    }
    if (gratuito.present) {
      map['gratuito'] = Variable<bool>(gratuito.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SimuladosCompanion(')
          ..write('codigo: $codigo, ')
          ..write('prova: $prova, ')
          ..write('oferta: $oferta, ')
          ..write('titulo: $titulo, ')
          ..write('duracaoMin: $duracaoMin, ')
          ..write('numPerguntas: $numPerguntas, ')
          ..write('gratuito: $gratuito, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProdutosTable extends Produtos
    with TableInfo<$ProdutosTable, ProdutoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdutosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _precoMtMeta = const VerificationMeta(
    'precoMt',
  );
  @override
  late final GeneratedColumn<int> precoMt = GeneratedColumn<int>(
    'preco_mt',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _epocaMeta = const VerificationMeta('epoca');
  @override
  late final GeneratedColumn<String> epoca = GeneratedColumn<String>(
    'epoca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    codigo,
    nome,
    descricao,
    tipo,
    precoMt,
    epoca,
    ordem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produtos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProdutoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('preco_mt')) {
      context.handle(
        _precoMtMeta,
        precoMt.isAcceptableOrUnknown(data['preco_mt']!, _precoMtMeta),
      );
    } else if (isInserting) {
      context.missing(_precoMtMeta);
    }
    if (data.containsKey('epoca')) {
      context.handle(
        _epocaMeta,
        epoca.isAcceptableOrUnknown(data['epoca']!, _epocaMeta),
      );
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  ProdutoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProdutoRow(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      precoMt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preco_mt'],
      )!,
      epoca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}epoca'],
      ),
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $ProdutosTable createAlias(String alias) {
    return $ProdutosTable(attachedDatabase, alias);
  }
}

class ProdutoRow extends DataClass implements Insertable<ProdutoRow> {
  final String codigo;
  final String nome;
  final String? descricao;

  /// niveis | simulados
  final String tipo;
  final int precoMt;
  final String? epoca;
  final int ordem;
  const ProdutoRow({
    required this.codigo,
    required this.nome,
    this.descricao,
    required this.tipo,
    required this.precoMt,
    this.epoca,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    map['tipo'] = Variable<String>(tipo);
    map['preco_mt'] = Variable<int>(precoMt);
    if (!nullToAbsent || epoca != null) {
      map['epoca'] = Variable<String>(epoca);
    }
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  ProdutosCompanion toCompanion(bool nullToAbsent) {
    return ProdutosCompanion(
      codigo: Value(codigo),
      nome: Value(nome),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      tipo: Value(tipo),
      precoMt: Value(precoMt),
      epoca: epoca == null && nullToAbsent
          ? const Value.absent()
          : Value(epoca),
      ordem: Value(ordem),
    );
  }

  factory ProdutoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProdutoRow(
      codigo: serializer.fromJson<String>(json['codigo']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      tipo: serializer.fromJson<String>(json['tipo']),
      precoMt: serializer.fromJson<int>(json['precoMt']),
      epoca: serializer.fromJson<String?>(json['epoca']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String?>(descricao),
      'tipo': serializer.toJson<String>(tipo),
      'precoMt': serializer.toJson<int>(precoMt),
      'epoca': serializer.toJson<String?>(epoca),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  ProdutoRow copyWith({
    String? codigo,
    String? nome,
    Value<String?> descricao = const Value.absent(),
    String? tipo,
    int? precoMt,
    Value<String?> epoca = const Value.absent(),
    int? ordem,
  }) => ProdutoRow(
    codigo: codigo ?? this.codigo,
    nome: nome ?? this.nome,
    descricao: descricao.present ? descricao.value : this.descricao,
    tipo: tipo ?? this.tipo,
    precoMt: precoMt ?? this.precoMt,
    epoca: epoca.present ? epoca.value : this.epoca,
    ordem: ordem ?? this.ordem,
  );
  ProdutoRow copyWithCompanion(ProdutosCompanion data) {
    return ProdutoRow(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      precoMt: data.precoMt.present ? data.precoMt.value : this.precoMt,
      epoca: data.epoca.present ? data.epoca.value : this.epoca,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProdutoRow(')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipo: $tipo, ')
          ..write('precoMt: $precoMt, ')
          ..write('epoca: $epoca, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(codigo, nome, descricao, tipo, precoMt, epoca, ordem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProdutoRow &&
          other.codigo == this.codigo &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.tipo == this.tipo &&
          other.precoMt == this.precoMt &&
          other.epoca == this.epoca &&
          other.ordem == this.ordem);
}

class ProdutosCompanion extends UpdateCompanion<ProdutoRow> {
  final Value<String> codigo;
  final Value<String> nome;
  final Value<String?> descricao;
  final Value<String> tipo;
  final Value<int> precoMt;
  final Value<String?> epoca;
  final Value<int> ordem;
  final Value<int> rowid;
  const ProdutosCompanion({
    this.codigo = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
    this.tipo = const Value.absent(),
    this.precoMt = const Value.absent(),
    this.epoca = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProdutosCompanion.insert({
    required String codigo,
    required String nome,
    this.descricao = const Value.absent(),
    required String tipo,
    required int precoMt,
    this.epoca = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       nome = Value(nome),
       tipo = Value(tipo),
       precoMt = Value(precoMt);
  static Insertable<ProdutoRow> custom({
    Expression<String>? codigo,
    Expression<String>? nome,
    Expression<String>? descricao,
    Expression<String>? tipo,
    Expression<int>? precoMt,
    Expression<String>? epoca,
    Expression<int>? ordem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
      if (tipo != null) 'tipo': tipo,
      if (precoMt != null) 'preco_mt': precoMt,
      if (epoca != null) 'epoca': epoca,
      if (ordem != null) 'ordem': ordem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProdutosCompanion copyWith({
    Value<String>? codigo,
    Value<String>? nome,
    Value<String?>? descricao,
    Value<String>? tipo,
    Value<int>? precoMt,
    Value<String?>? epoca,
    Value<int>? ordem,
    Value<int>? rowid,
  }) {
    return ProdutosCompanion(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      precoMt: precoMt ?? this.precoMt,
      epoca: epoca ?? this.epoca,
      ordem: ordem ?? this.ordem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (precoMt.present) {
      map['preco_mt'] = Variable<int>(precoMt.value);
    }
    if (epoca.present) {
      map['epoca'] = Variable<String>(epoca.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdutosCompanion(')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipo: $tipo, ')
          ..write('precoMt: $precoMt, ')
          ..write('epoca: $epoca, ')
          ..write('ordem: $ordem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProdutoProvaTable extends ProdutoProva
    with TableInfo<$ProdutoProvaTable, ProdutoProvaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdutoProvaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _provaMeta = const VerificationMeta('prova');
  @override
  late final GeneratedColumn<String> prova = GeneratedColumn<String>(
    'prova',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [produto, prova];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produto_prova';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProdutoProvaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('produto')) {
      context.handle(
        _produtoMeta,
        produto.isAcceptableOrUnknown(data['produto']!, _produtoMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoMeta);
    }
    if (data.containsKey('prova')) {
      context.handle(
        _provaMeta,
        prova.isAcceptableOrUnknown(data['prova']!, _provaMeta),
      );
    } else if (isInserting) {
      context.missing(_provaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {produto, prova};
  @override
  ProdutoProvaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProdutoProvaRow(
      produto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produto'],
      )!,
      prova: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prova'],
      )!,
    );
  }

  @override
  $ProdutoProvaTable createAlias(String alias) {
    return $ProdutoProvaTable(attachedDatabase, alias);
  }
}

class ProdutoProvaRow extends DataClass implements Insertable<ProdutoProvaRow> {
  final String produto;
  final String prova;
  const ProdutoProvaRow({required this.produto, required this.prova});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['produto'] = Variable<String>(produto);
    map['prova'] = Variable<String>(prova);
    return map;
  }

  ProdutoProvaCompanion toCompanion(bool nullToAbsent) {
    return ProdutoProvaCompanion(produto: Value(produto), prova: Value(prova));
  }

  factory ProdutoProvaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProdutoProvaRow(
      produto: serializer.fromJson<String>(json['produto']),
      prova: serializer.fromJson<String>(json['prova']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'produto': serializer.toJson<String>(produto),
      'prova': serializer.toJson<String>(prova),
    };
  }

  ProdutoProvaRow copyWith({String? produto, String? prova}) => ProdutoProvaRow(
    produto: produto ?? this.produto,
    prova: prova ?? this.prova,
  );
  ProdutoProvaRow copyWithCompanion(ProdutoProvaCompanion data) {
    return ProdutoProvaRow(
      produto: data.produto.present ? data.produto.value : this.produto,
      prova: data.prova.present ? data.prova.value : this.prova,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProdutoProvaRow(')
          ..write('produto: $produto, ')
          ..write('prova: $prova')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(produto, prova);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProdutoProvaRow &&
          other.produto == this.produto &&
          other.prova == this.prova);
}

class ProdutoProvaCompanion extends UpdateCompanion<ProdutoProvaRow> {
  final Value<String> produto;
  final Value<String> prova;
  final Value<int> rowid;
  const ProdutoProvaCompanion({
    this.produto = const Value.absent(),
    this.prova = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProdutoProvaCompanion.insert({
    required String produto,
    required String prova,
    this.rowid = const Value.absent(),
  }) : produto = Value(produto),
       prova = Value(prova);
  static Insertable<ProdutoProvaRow> custom({
    Expression<String>? produto,
    Expression<String>? prova,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (produto != null) 'produto': produto,
      if (prova != null) 'prova': prova,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProdutoProvaCompanion copyWith({
    Value<String>? produto,
    Value<String>? prova,
    Value<int>? rowid,
  }) {
    return ProdutoProvaCompanion(
      produto: produto ?? this.produto,
      prova: prova ?? this.prova,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (produto.present) {
      map['produto'] = Variable<String>(produto.value);
    }
    if (prova.present) {
      map['prova'] = Variable<String>(prova.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdutoProvaCompanion(')
          ..write('produto: $produto, ')
          ..write('prova: $prova, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PacotesInstaladosTable extends PacotesInstalados
    with TableInfo<$PacotesInstaladosTable, PacoteInstaladoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PacotesInstaladosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _provaMeta = const VerificationMeta('prova');
  @override
  late final GeneratedColumn<String> prova = GeneratedColumn<String>(
    'prova',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versaoMeta = const VerificationMeta('versao');
  @override
  late final GeneratedColumn<int> versao = GeneratedColumn<int>(
    'versao',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instaladoEmMeta = const VerificationMeta(
    'instaladoEm',
  );
  @override
  late final GeneratedColumn<DateTime> instaladoEm = GeneratedColumn<DateTime>(
    'instalado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [prova, versao, sha256, instaladoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pacotes_instalados';
  @override
  VerificationContext validateIntegrity(
    Insertable<PacoteInstaladoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('prova')) {
      context.handle(
        _provaMeta,
        prova.isAcceptableOrUnknown(data['prova']!, _provaMeta),
      );
    } else if (isInserting) {
      context.missing(_provaMeta);
    }
    if (data.containsKey('versao')) {
      context.handle(
        _versaoMeta,
        versao.isAcceptableOrUnknown(data['versao']!, _versaoMeta),
      );
    } else if (isInserting) {
      context.missing(_versaoMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('instalado_em')) {
      context.handle(
        _instaladoEmMeta,
        instaladoEm.isAcceptableOrUnknown(
          data['instalado_em']!,
          _instaladoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instaladoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {prova};
  @override
  PacoteInstaladoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PacoteInstaladoRow(
      prova: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prova'],
      )!,
      versao: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}versao'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      instaladoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}instalado_em'],
      )!,
    );
  }

  @override
  $PacotesInstaladosTable createAlias(String alias) {
    return $PacotesInstaladosTable(attachedDatabase, alias);
  }
}

class PacoteInstaladoRow extends DataClass
    implements Insertable<PacoteInstaladoRow> {
  final String prova;
  final int versao;
  final String sha256;
  final DateTime instaladoEm;
  const PacoteInstaladoRow({
    required this.prova,
    required this.versao,
    required this.sha256,
    required this.instaladoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['prova'] = Variable<String>(prova);
    map['versao'] = Variable<int>(versao);
    map['sha256'] = Variable<String>(sha256);
    map['instalado_em'] = Variable<DateTime>(instaladoEm);
    return map;
  }

  PacotesInstaladosCompanion toCompanion(bool nullToAbsent) {
    return PacotesInstaladosCompanion(
      prova: Value(prova),
      versao: Value(versao),
      sha256: Value(sha256),
      instaladoEm: Value(instaladoEm),
    );
  }

  factory PacoteInstaladoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PacoteInstaladoRow(
      prova: serializer.fromJson<String>(json['prova']),
      versao: serializer.fromJson<int>(json['versao']),
      sha256: serializer.fromJson<String>(json['sha256']),
      instaladoEm: serializer.fromJson<DateTime>(json['instaladoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'prova': serializer.toJson<String>(prova),
      'versao': serializer.toJson<int>(versao),
      'sha256': serializer.toJson<String>(sha256),
      'instaladoEm': serializer.toJson<DateTime>(instaladoEm),
    };
  }

  PacoteInstaladoRow copyWith({
    String? prova,
    int? versao,
    String? sha256,
    DateTime? instaladoEm,
  }) => PacoteInstaladoRow(
    prova: prova ?? this.prova,
    versao: versao ?? this.versao,
    sha256: sha256 ?? this.sha256,
    instaladoEm: instaladoEm ?? this.instaladoEm,
  );
  PacoteInstaladoRow copyWithCompanion(PacotesInstaladosCompanion data) {
    return PacoteInstaladoRow(
      prova: data.prova.present ? data.prova.value : this.prova,
      versao: data.versao.present ? data.versao.value : this.versao,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      instaladoEm: data.instaladoEm.present
          ? data.instaladoEm.value
          : this.instaladoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PacoteInstaladoRow(')
          ..write('prova: $prova, ')
          ..write('versao: $versao, ')
          ..write('sha256: $sha256, ')
          ..write('instaladoEm: $instaladoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(prova, versao, sha256, instaladoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PacoteInstaladoRow &&
          other.prova == this.prova &&
          other.versao == this.versao &&
          other.sha256 == this.sha256 &&
          other.instaladoEm == this.instaladoEm);
}

class PacotesInstaladosCompanion extends UpdateCompanion<PacoteInstaladoRow> {
  final Value<String> prova;
  final Value<int> versao;
  final Value<String> sha256;
  final Value<DateTime> instaladoEm;
  final Value<int> rowid;
  const PacotesInstaladosCompanion({
    this.prova = const Value.absent(),
    this.versao = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.instaladoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PacotesInstaladosCompanion.insert({
    required String prova,
    required int versao,
    required String sha256,
    required DateTime instaladoEm,
    this.rowid = const Value.absent(),
  }) : prova = Value(prova),
       versao = Value(versao),
       sha256 = Value(sha256),
       instaladoEm = Value(instaladoEm);
  static Insertable<PacoteInstaladoRow> custom({
    Expression<String>? prova,
    Expression<int>? versao,
    Expression<String>? sha256,
    Expression<DateTime>? instaladoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (prova != null) 'prova': prova,
      if (versao != null) 'versao': versao,
      if (sha256 != null) 'sha256': sha256,
      if (instaladoEm != null) 'instalado_em': instaladoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PacotesInstaladosCompanion copyWith({
    Value<String>? prova,
    Value<int>? versao,
    Value<String>? sha256,
    Value<DateTime>? instaladoEm,
    Value<int>? rowid,
  }) {
    return PacotesInstaladosCompanion(
      prova: prova ?? this.prova,
      versao: versao ?? this.versao,
      sha256: sha256 ?? this.sha256,
      instaladoEm: instaladoEm ?? this.instaladoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (prova.present) {
      map['prova'] = Variable<String>(prova.value);
    }
    if (versao.present) {
      map['versao'] = Variable<int>(versao.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (instaladoEm.present) {
      map['instalado_em'] = Variable<DateTime>(instaladoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PacotesInstaladosCompanion(')
          ..write('prova: $prova, ')
          ..write('versao: $versao, ')
          ..write('sha256: $sha256, ')
          ..write('instaladoEm: $instaladoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetaTable extends Meta with TableInfo<$MetaTable, MetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaRow> instance, {
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
  MetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaRow(
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
  $MetaTable createAlias(String alias) {
    return $MetaTable(attachedDatabase, alias);
  }
}

class MetaRow extends DataClass implements Insertable<MetaRow> {
  final String chave;
  final String valor;
  const MetaRow({required this.chave, required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chave'] = Variable<String>(chave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(chave: Value(chave), valor: Value(valor));
  }

  factory MetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaRow(
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

  MetaRow copyWith({String? chave, String? valor}) =>
      MetaRow(chave: chave ?? this.chave, valor: valor ?? this.valor);
  MetaRow copyWithCompanion(MetaCompanion data) {
    return MetaRow(
      chave: data.chave.present ? data.chave.value : this.chave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaRow(')
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
      (other is MetaRow &&
          other.chave == this.chave &&
          other.valor == this.valor);
}

class MetaCompanion extends UpdateCompanion<MetaRow> {
  final Value<String> chave;
  final Value<String> valor;
  final Value<int> rowid;
  const MetaCompanion({
    this.chave = const Value.absent(),
    this.valor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String chave,
    required String valor,
    this.rowid = const Value.absent(),
  }) : chave = Value(chave),
       valor = Value(valor);
  static Insertable<MetaRow> custom({
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

  MetaCompanion copyWith({
    Value<String>? chave,
    Value<String>? valor,
    Value<int>? rowid,
  }) {
    return MetaCompanion(
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
    return (StringBuffer('MetaCompanion(')
          ..write('chave: $chave, ')
          ..write('valor: $valor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ContentDb extends GeneratedDatabase {
  _$ContentDb(QueryExecutor e) : super(e);
  $ContentDbManager get managers => $ContentDbManager(this);
  late final $GruposExameTable gruposExame = $GruposExameTable(this);
  late final $InstituicoesTable instituicoes = $InstituicoesTable(this);
  late final $DisciplinasTable disciplinas = $DisciplinasTable(this);
  late final $TemasTable temas = $TemasTable(this);
  late final $ProvasTable provas = $ProvasTable(this);
  late final $OfertasTable ofertas = $OfertasTable(this);
  late final $OfertaProvaTable ofertaProva = $OfertaProvaTable(this);
  late final $NiveisTable niveis = $NiveisTable(this);
  late final $TextosBaseTable textosBase = $TextosBaseTable(this);
  late final $QuestoesTable questoes = $QuestoesTable(this);
  late final $QuestaoProvaTable questaoProva = $QuestaoProvaTable(this);
  late final $AlternativasTable alternativas = $AlternativasTable(this);
  late final $SimuladosTable simulados = $SimuladosTable(this);
  late final $ProdutosTable produtos = $ProdutosTable(this);
  late final $ProdutoProvaTable produtoProva = $ProdutoProvaTable(this);
  late final $PacotesInstaladosTable pacotesInstalados =
      $PacotesInstaladosTable(this);
  late final $MetaTable meta = $MetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    gruposExame,
    instituicoes,
    disciplinas,
    temas,
    provas,
    ofertas,
    ofertaProva,
    niveis,
    textosBase,
    questoes,
    questaoProva,
    alternativas,
    simulados,
    produtos,
    produtoProva,
    pacotesInstalados,
    meta,
  ];
}

typedef $$GruposExameTableCreateCompanionBuilder =
    GruposExameCompanion Function({
      required String codigo,
      required String nome,
      Value<bool> temGabarito,
      Value<int> rowid,
    });
typedef $$GruposExameTableUpdateCompanionBuilder =
    GruposExameCompanion Function({
      Value<String> codigo,
      Value<String> nome,
      Value<bool> temGabarito,
      Value<int> rowid,
    });

class $$GruposExameTableFilterComposer
    extends Composer<_$ContentDb, $GruposExameTable> {
  $$GruposExameTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get temGabarito => $composableBuilder(
    column: $table.temGabarito,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GruposExameTableOrderingComposer
    extends Composer<_$ContentDb, $GruposExameTable> {
  $$GruposExameTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get temGabarito => $composableBuilder(
    column: $table.temGabarito,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GruposExameTableAnnotationComposer
    extends Composer<_$ContentDb, $GruposExameTable> {
  $$GruposExameTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<bool> get temGabarito => $composableBuilder(
    column: $table.temGabarito,
    builder: (column) => column,
  );
}

class $$GruposExameTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $GruposExameTable,
          GrupoExameRow,
          $$GruposExameTableFilterComposer,
          $$GruposExameTableOrderingComposer,
          $$GruposExameTableAnnotationComposer,
          $$GruposExameTableCreateCompanionBuilder,
          $$GruposExameTableUpdateCompanionBuilder,
          (
            GrupoExameRow,
            BaseReferences<_$ContentDb, $GruposExameTable, GrupoExameRow>,
          ),
          GrupoExameRow,
          PrefetchHooks Function()
        > {
  $$GruposExameTableTableManager(_$ContentDb db, $GruposExameTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GruposExameTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GruposExameTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GruposExameTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<bool> temGabarito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GruposExameCompanion(
                codigo: codigo,
                nome: nome,
                temGabarito: temGabarito,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String nome,
                Value<bool> temGabarito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GruposExameCompanion.insert(
                codigo: codigo,
                nome: nome,
                temGabarito: temGabarito,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GruposExameTable, GrupoExameRow>(table),
                  BaseReferences<_$ContentDb, $GruposExameTable, GrupoExameRow>(
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

typedef $$GruposExameTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $GruposExameTable,
      GrupoExameRow,
      $$GruposExameTableFilterComposer,
      $$GruposExameTableOrderingComposer,
      $$GruposExameTableAnnotationComposer,
      $$GruposExameTableCreateCompanionBuilder,
      $$GruposExameTableUpdateCompanionBuilder,
      (
        GrupoExameRow,
        BaseReferences<_$ContentDb, $GruposExameTable, GrupoExameRow>,
      ),
      GrupoExameRow,
      PrefetchHooks Function()
    >;
typedef $$InstituicoesTableCreateCompanionBuilder =
    InstituicoesCompanion Function({
      required String codigo,
      required String sigla,
      required String nome,
      required String grupoExame,
      Value<int> rowid,
    });
typedef $$InstituicoesTableUpdateCompanionBuilder =
    InstituicoesCompanion Function({
      Value<String> codigo,
      Value<String> sigla,
      Value<String> nome,
      Value<String> grupoExame,
      Value<int> rowid,
    });

class $$InstituicoesTableFilterComposer
    extends Composer<_$ContentDb, $InstituicoesTable> {
  $$InstituicoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sigla => $composableBuilder(
    column: $table.sigla,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grupoExame => $composableBuilder(
    column: $table.grupoExame,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstituicoesTableOrderingComposer
    extends Composer<_$ContentDb, $InstituicoesTable> {
  $$InstituicoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sigla => $composableBuilder(
    column: $table.sigla,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grupoExame => $composableBuilder(
    column: $table.grupoExame,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstituicoesTableAnnotationComposer
    extends Composer<_$ContentDb, $InstituicoesTable> {
  $$InstituicoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get sigla =>
      $composableBuilder(column: $table.sigla, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get grupoExame => $composableBuilder(
    column: $table.grupoExame,
    builder: (column) => column,
  );
}

class $$InstituicoesTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $InstituicoesTable,
          InstituicaoRow,
          $$InstituicoesTableFilterComposer,
          $$InstituicoesTableOrderingComposer,
          $$InstituicoesTableAnnotationComposer,
          $$InstituicoesTableCreateCompanionBuilder,
          $$InstituicoesTableUpdateCompanionBuilder,
          (
            InstituicaoRow,
            BaseReferences<_$ContentDb, $InstituicoesTable, InstituicaoRow>,
          ),
          InstituicaoRow,
          PrefetchHooks Function()
        > {
  $$InstituicoesTableTableManager(_$ContentDb db, $InstituicoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstituicoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstituicoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstituicoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> sigla = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> grupoExame = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstituicoesCompanion(
                codigo: codigo,
                sigla: sigla,
                nome: nome,
                grupoExame: grupoExame,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String sigla,
                required String nome,
                required String grupoExame,
                Value<int> rowid = const Value.absent(),
              }) => InstituicoesCompanion.insert(
                codigo: codigo,
                sigla: sigla,
                nome: nome,
                grupoExame: grupoExame,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InstituicoesTable, InstituicaoRow>(table),
                  BaseReferences<
                    _$ContentDb,
                    $InstituicoesTable,
                    InstituicaoRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstituicoesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $InstituicoesTable,
      InstituicaoRow,
      $$InstituicoesTableFilterComposer,
      $$InstituicoesTableOrderingComposer,
      $$InstituicoesTableAnnotationComposer,
      $$InstituicoesTableCreateCompanionBuilder,
      $$InstituicoesTableUpdateCompanionBuilder,
      (
        InstituicaoRow,
        BaseReferences<_$ContentDb, $InstituicoesTable, InstituicaoRow>,
      ),
      InstituicaoRow,
      PrefetchHooks Function()
    >;
typedef $$DisciplinasTableCreateCompanionBuilder =
    DisciplinasCompanion Function({
      required String codigo,
      required String nome,
      Value<String?> icone,
      Value<int> rowid,
    });
typedef $$DisciplinasTableUpdateCompanionBuilder =
    DisciplinasCompanion Function({
      Value<String> codigo,
      Value<String> nome,
      Value<String?> icone,
      Value<int> rowid,
    });

class $$DisciplinasTableFilterComposer
    extends Composer<_$ContentDb, $DisciplinasTable> {
  $$DisciplinasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DisciplinasTableOrderingComposer
    extends Composer<_$ContentDb, $DisciplinasTable> {
  $$DisciplinasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DisciplinasTableAnnotationComposer
    extends Composer<_$ContentDb, $DisciplinasTable> {
  $$DisciplinasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get icone =>
      $composableBuilder(column: $table.icone, builder: (column) => column);
}

class $$DisciplinasTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $DisciplinasTable,
          DisciplinaRow,
          $$DisciplinasTableFilterComposer,
          $$DisciplinasTableOrderingComposer,
          $$DisciplinasTableAnnotationComposer,
          $$DisciplinasTableCreateCompanionBuilder,
          $$DisciplinasTableUpdateCompanionBuilder,
          (
            DisciplinaRow,
            BaseReferences<_$ContentDb, $DisciplinasTable, DisciplinaRow>,
          ),
          DisciplinaRow,
          PrefetchHooks Function()
        > {
  $$DisciplinasTableTableManager(_$ContentDb db, $DisciplinasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DisciplinasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DisciplinasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DisciplinasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> icone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DisciplinasCompanion(
                codigo: codigo,
                nome: nome,
                icone: icone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String nome,
                Value<String?> icone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DisciplinasCompanion.insert(
                codigo: codigo,
                nome: nome,
                icone: icone,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DisciplinasTable, DisciplinaRow>(table),
                  BaseReferences<_$ContentDb, $DisciplinasTable, DisciplinaRow>(
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

typedef $$DisciplinasTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $DisciplinasTable,
      DisciplinaRow,
      $$DisciplinasTableFilterComposer,
      $$DisciplinasTableOrderingComposer,
      $$DisciplinasTableAnnotationComposer,
      $$DisciplinasTableCreateCompanionBuilder,
      $$DisciplinasTableUpdateCompanionBuilder,
      (
        DisciplinaRow,
        BaseReferences<_$ContentDb, $DisciplinasTable, DisciplinaRow>,
      ),
      DisciplinaRow,
      PrefetchHooks Function()
    >;
typedef $$TemasTableCreateCompanionBuilder =
    TemasCompanion Function({
      required String codigo,
      required String disciplina,
      required String nome,
      Value<int> rowid,
    });
typedef $$TemasTableUpdateCompanionBuilder =
    TemasCompanion Function({
      Value<String> codigo,
      Value<String> disciplina,
      Value<String> nome,
      Value<int> rowid,
    });

class $$TemasTableFilterComposer extends Composer<_$ContentDb, $TemasTable> {
  $$TemasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get disciplina => $composableBuilder(
    column: $table.disciplina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TemasTableOrderingComposer extends Composer<_$ContentDb, $TemasTable> {
  $$TemasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get disciplina => $composableBuilder(
    column: $table.disciplina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemasTableAnnotationComposer
    extends Composer<_$ContentDb, $TemasTable> {
  $$TemasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get disciplina => $composableBuilder(
    column: $table.disciplina,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);
}

class $$TemasTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $TemasTable,
          TemaRow,
          $$TemasTableFilterComposer,
          $$TemasTableOrderingComposer,
          $$TemasTableAnnotationComposer,
          $$TemasTableCreateCompanionBuilder,
          $$TemasTableUpdateCompanionBuilder,
          (TemaRow, BaseReferences<_$ContentDb, $TemasTable, TemaRow>),
          TemaRow,
          PrefetchHooks Function()
        > {
  $$TemasTableTableManager(_$ContentDb db, $TemasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> disciplina = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemasCompanion(
                codigo: codigo,
                disciplina: disciplina,
                nome: nome,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String disciplina,
                required String nome,
                Value<int> rowid = const Value.absent(),
              }) => TemasCompanion.insert(
                codigo: codigo,
                disciplina: disciplina,
                nome: nome,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemasTable, TemaRow>(table),
                  BaseReferences<_$ContentDb, $TemasTable, TemaRow>(
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

typedef $$TemasTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $TemasTable,
      TemaRow,
      $$TemasTableFilterComposer,
      $$TemasTableOrderingComposer,
      $$TemasTableAnnotationComposer,
      $$TemasTableCreateCompanionBuilder,
      $$TemasTableUpdateCompanionBuilder,
      (TemaRow, BaseReferences<_$ContentDb, $TemasTable, TemaRow>),
      TemaRow,
      PrefetchHooks Function()
    >;
typedef $$ProvasTableCreateCompanionBuilder =
    ProvasCompanion Function({
      required String codigo,
      required String grupoExame,
      required String disciplina,
      Value<String?> variante,
      required String nome,
      Value<int?> duracaoMin,
      Value<int?> numQuestoes,
      Value<String?> questoesDe,
      Value<int> rowid,
    });
typedef $$ProvasTableUpdateCompanionBuilder =
    ProvasCompanion Function({
      Value<String> codigo,
      Value<String> grupoExame,
      Value<String> disciplina,
      Value<String?> variante,
      Value<String> nome,
      Value<int?> duracaoMin,
      Value<int?> numQuestoes,
      Value<String?> questoesDe,
      Value<int> rowid,
    });

class $$ProvasTableFilterComposer extends Composer<_$ContentDb, $ProvasTable> {
  $$ProvasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grupoExame => $composableBuilder(
    column: $table.grupoExame,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get disciplina => $composableBuilder(
    column: $table.disciplina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variante => $composableBuilder(
    column: $table.variante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duracaoMin => $composableBuilder(
    column: $table.duracaoMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numQuestoes => $composableBuilder(
    column: $table.numQuestoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questoesDe => $composableBuilder(
    column: $table.questoesDe,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProvasTableOrderingComposer
    extends Composer<_$ContentDb, $ProvasTable> {
  $$ProvasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grupoExame => $composableBuilder(
    column: $table.grupoExame,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get disciplina => $composableBuilder(
    column: $table.disciplina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variante => $composableBuilder(
    column: $table.variante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duracaoMin => $composableBuilder(
    column: $table.duracaoMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numQuestoes => $composableBuilder(
    column: $table.numQuestoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questoesDe => $composableBuilder(
    column: $table.questoesDe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProvasTableAnnotationComposer
    extends Composer<_$ContentDb, $ProvasTable> {
  $$ProvasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get grupoExame => $composableBuilder(
    column: $table.grupoExame,
    builder: (column) => column,
  );

  GeneratedColumn<String> get disciplina => $composableBuilder(
    column: $table.disciplina,
    builder: (column) => column,
  );

  GeneratedColumn<String> get variante =>
      $composableBuilder(column: $table.variante, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<int> get duracaoMin => $composableBuilder(
    column: $table.duracaoMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numQuestoes => $composableBuilder(
    column: $table.numQuestoes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questoesDe => $composableBuilder(
    column: $table.questoesDe,
    builder: (column) => column,
  );
}

class $$ProvasTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $ProvasTable,
          ProvaRow,
          $$ProvasTableFilterComposer,
          $$ProvasTableOrderingComposer,
          $$ProvasTableAnnotationComposer,
          $$ProvasTableCreateCompanionBuilder,
          $$ProvasTableUpdateCompanionBuilder,
          (ProvaRow, BaseReferences<_$ContentDb, $ProvasTable, ProvaRow>),
          ProvaRow,
          PrefetchHooks Function()
        > {
  $$ProvasTableTableManager(_$ContentDb db, $ProvasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProvasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProvasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProvasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> grupoExame = const Value.absent(),
                Value<String> disciplina = const Value.absent(),
                Value<String?> variante = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int?> duracaoMin = const Value.absent(),
                Value<int?> numQuestoes = const Value.absent(),
                Value<String?> questoesDe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProvasCompanion(
                codigo: codigo,
                grupoExame: grupoExame,
                disciplina: disciplina,
                variante: variante,
                nome: nome,
                duracaoMin: duracaoMin,
                numQuestoes: numQuestoes,
                questoesDe: questoesDe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String grupoExame,
                required String disciplina,
                Value<String?> variante = const Value.absent(),
                required String nome,
                Value<int?> duracaoMin = const Value.absent(),
                Value<int?> numQuestoes = const Value.absent(),
                Value<String?> questoesDe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProvasCompanion.insert(
                codigo: codigo,
                grupoExame: grupoExame,
                disciplina: disciplina,
                variante: variante,
                nome: nome,
                duracaoMin: duracaoMin,
                numQuestoes: numQuestoes,
                questoesDe: questoesDe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProvasTable, ProvaRow>(table),
                  BaseReferences<_$ContentDb, $ProvasTable, ProvaRow>(
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

typedef $$ProvasTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $ProvasTable,
      ProvaRow,
      $$ProvasTableFilterComposer,
      $$ProvasTableOrderingComposer,
      $$ProvasTableAnnotationComposer,
      $$ProvasTableCreateCompanionBuilder,
      $$ProvasTableUpdateCompanionBuilder,
      (ProvaRow, BaseReferences<_$ContentDb, $ProvasTable, ProvaRow>),
      ProvaRow,
      PrefetchHooks Function()
    >;
typedef $$OfertasTableCreateCompanionBuilder =
    OfertasCompanion Function({
      required String codigo,
      required String instituicao,
      required String curso,
      required String nome,
      Value<String?> icone,
      required String nomeOriginal,
      Value<String> faculdade,
      Value<String> locais,
      Value<int> rowid,
    });
typedef $$OfertasTableUpdateCompanionBuilder =
    OfertasCompanion Function({
      Value<String> codigo,
      Value<String> instituicao,
      Value<String> curso,
      Value<String> nome,
      Value<String?> icone,
      Value<String> nomeOriginal,
      Value<String> faculdade,
      Value<String> locais,
      Value<int> rowid,
    });

class $$OfertasTableFilterComposer
    extends Composer<_$ContentDb, $OfertasTable> {
  $$OfertasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instituicao => $composableBuilder(
    column: $table.instituicao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get curso => $composableBuilder(
    column: $table.curso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeOriginal => $composableBuilder(
    column: $table.nomeOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faculdade => $composableBuilder(
    column: $table.faculdade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locais => $composableBuilder(
    column: $table.locais,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfertasTableOrderingComposer
    extends Composer<_$ContentDb, $OfertasTable> {
  $$OfertasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instituicao => $composableBuilder(
    column: $table.instituicao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get curso => $composableBuilder(
    column: $table.curso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeOriginal => $composableBuilder(
    column: $table.nomeOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faculdade => $composableBuilder(
    column: $table.faculdade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locais => $composableBuilder(
    column: $table.locais,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfertasTableAnnotationComposer
    extends Composer<_$ContentDb, $OfertasTable> {
  $$OfertasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get instituicao => $composableBuilder(
    column: $table.instituicao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get curso =>
      $composableBuilder(column: $table.curso, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get icone =>
      $composableBuilder(column: $table.icone, builder: (column) => column);

  GeneratedColumn<String> get nomeOriginal => $composableBuilder(
    column: $table.nomeOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get faculdade =>
      $composableBuilder(column: $table.faculdade, builder: (column) => column);

  GeneratedColumn<String> get locais =>
      $composableBuilder(column: $table.locais, builder: (column) => column);
}

class $$OfertasTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $OfertasTable,
          OfertaRow,
          $$OfertasTableFilterComposer,
          $$OfertasTableOrderingComposer,
          $$OfertasTableAnnotationComposer,
          $$OfertasTableCreateCompanionBuilder,
          $$OfertasTableUpdateCompanionBuilder,
          (OfertaRow, BaseReferences<_$ContentDb, $OfertasTable, OfertaRow>),
          OfertaRow,
          PrefetchHooks Function()
        > {
  $$OfertasTableTableManager(_$ContentDb db, $OfertasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfertasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfertasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfertasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> instituicao = const Value.absent(),
                Value<String> curso = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> icone = const Value.absent(),
                Value<String> nomeOriginal = const Value.absent(),
                Value<String> faculdade = const Value.absent(),
                Value<String> locais = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfertasCompanion(
                codigo: codigo,
                instituicao: instituicao,
                curso: curso,
                nome: nome,
                icone: icone,
                nomeOriginal: nomeOriginal,
                faculdade: faculdade,
                locais: locais,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String instituicao,
                required String curso,
                required String nome,
                Value<String?> icone = const Value.absent(),
                required String nomeOriginal,
                Value<String> faculdade = const Value.absent(),
                Value<String> locais = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfertasCompanion.insert(
                codigo: codigo,
                instituicao: instituicao,
                curso: curso,
                nome: nome,
                icone: icone,
                nomeOriginal: nomeOriginal,
                faculdade: faculdade,
                locais: locais,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OfertasTable, OfertaRow>(table),
                  BaseReferences<_$ContentDb, $OfertasTable, OfertaRow>(
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

typedef $$OfertasTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $OfertasTable,
      OfertaRow,
      $$OfertasTableFilterComposer,
      $$OfertasTableOrderingComposer,
      $$OfertasTableAnnotationComposer,
      $$OfertasTableCreateCompanionBuilder,
      $$OfertasTableUpdateCompanionBuilder,
      (OfertaRow, BaseReferences<_$ContentDb, $OfertasTable, OfertaRow>),
      OfertaRow,
      PrefetchHooks Function()
    >;
typedef $$OfertaProvaTableCreateCompanionBuilder =
    OfertaProvaCompanion Function({
      required String oferta,
      required String prova,
      Value<int?> peso,
      Value<int> ordem,
      Value<int> rowid,
    });
typedef $$OfertaProvaTableUpdateCompanionBuilder =
    OfertaProvaCompanion Function({
      Value<String> oferta,
      Value<String> prova,
      Value<int?> peso,
      Value<int> ordem,
      Value<int> rowid,
    });

class $$OfertaProvaTableFilterComposer
    extends Composer<_$ContentDb, $OfertaProvaTable> {
  $$OfertaProvaTableFilterComposer({
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

  ColumnFilters<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfertaProvaTableOrderingComposer
    extends Composer<_$ContentDb, $OfertaProvaTable> {
  $$OfertaProvaTableOrderingComposer({
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

  ColumnOrderings<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfertaProvaTableAnnotationComposer
    extends Composer<_$ContentDb, $OfertaProvaTable> {
  $$OfertaProvaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get oferta =>
      $composableBuilder(column: $table.oferta, builder: (column) => column);

  GeneratedColumn<String> get prova =>
      $composableBuilder(column: $table.prova, builder: (column) => column);

  GeneratedColumn<int> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);
}

class $$OfertaProvaTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $OfertaProvaTable,
          OfertaProvaRow,
          $$OfertaProvaTableFilterComposer,
          $$OfertaProvaTableOrderingComposer,
          $$OfertaProvaTableAnnotationComposer,
          $$OfertaProvaTableCreateCompanionBuilder,
          $$OfertaProvaTableUpdateCompanionBuilder,
          (
            OfertaProvaRow,
            BaseReferences<_$ContentDb, $OfertaProvaTable, OfertaProvaRow>,
          ),
          OfertaProvaRow,
          PrefetchHooks Function()
        > {
  $$OfertaProvaTableTableManager(_$ContentDb db, $OfertaProvaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfertaProvaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfertaProvaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfertaProvaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> oferta = const Value.absent(),
                Value<String> prova = const Value.absent(),
                Value<int?> peso = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfertaProvaCompanion(
                oferta: oferta,
                prova: prova,
                peso: peso,
                ordem: ordem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String oferta,
                required String prova,
                Value<int?> peso = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfertaProvaCompanion.insert(
                oferta: oferta,
                prova: prova,
                peso: peso,
                ordem: ordem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OfertaProvaTable, OfertaProvaRow>(table),
                  BaseReferences<
                    _$ContentDb,
                    $OfertaProvaTable,
                    OfertaProvaRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfertaProvaTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $OfertaProvaTable,
      OfertaProvaRow,
      $$OfertaProvaTableFilterComposer,
      $$OfertaProvaTableOrderingComposer,
      $$OfertaProvaTableAnnotationComposer,
      $$OfertaProvaTableCreateCompanionBuilder,
      $$OfertaProvaTableUpdateCompanionBuilder,
      (
        OfertaProvaRow,
        BaseReferences<_$ContentDb, $OfertaProvaTable, OfertaProvaRow>,
      ),
      OfertaProvaRow,
      PrefetchHooks Function()
    >;
typedef $$NiveisTableCreateCompanionBuilder =
    NiveisCompanion Function({
      required String prova,
      required int numero,
      required String titulo,
      Value<String?> descricao,
      Value<int?> notaMinima,
      Value<int> rowid,
    });
typedef $$NiveisTableUpdateCompanionBuilder =
    NiveisCompanion Function({
      Value<String> prova,
      Value<int> numero,
      Value<String> titulo,
      Value<String?> descricao,
      Value<int?> notaMinima,
      Value<int> rowid,
    });

class $$NiveisTableFilterComposer extends Composer<_$ContentDb, $NiveisTable> {
  $$NiveisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notaMinima => $composableBuilder(
    column: $table.notaMinima,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NiveisTableOrderingComposer
    extends Composer<_$ContentDb, $NiveisTable> {
  $$NiveisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notaMinima => $composableBuilder(
    column: $table.notaMinima,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NiveisTableAnnotationComposer
    extends Composer<_$ContentDb, $NiveisTable> {
  $$NiveisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get prova =>
      $composableBuilder(column: $table.prova, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<int> get notaMinima => $composableBuilder(
    column: $table.notaMinima,
    builder: (column) => column,
  );
}

class $$NiveisTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $NiveisTable,
          NivelRow,
          $$NiveisTableFilterComposer,
          $$NiveisTableOrderingComposer,
          $$NiveisTableAnnotationComposer,
          $$NiveisTableCreateCompanionBuilder,
          $$NiveisTableUpdateCompanionBuilder,
          (NivelRow, BaseReferences<_$ContentDb, $NiveisTable, NivelRow>),
          NivelRow,
          PrefetchHooks Function()
        > {
  $$NiveisTableTableManager(_$ContentDb db, $NiveisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NiveisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NiveisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NiveisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> prova = const Value.absent(),
                Value<int> numero = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<int?> notaMinima = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NiveisCompanion(
                prova: prova,
                numero: numero,
                titulo: titulo,
                descricao: descricao,
                notaMinima: notaMinima,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String prova,
                required int numero,
                required String titulo,
                Value<String?> descricao = const Value.absent(),
                Value<int?> notaMinima = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NiveisCompanion.insert(
                prova: prova,
                numero: numero,
                titulo: titulo,
                descricao: descricao,
                notaMinima: notaMinima,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NiveisTable, NivelRow>(table),
                  BaseReferences<_$ContentDb, $NiveisTable, NivelRow>(
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

typedef $$NiveisTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $NiveisTable,
      NivelRow,
      $$NiveisTableFilterComposer,
      $$NiveisTableOrderingComposer,
      $$NiveisTableAnnotationComposer,
      $$NiveisTableCreateCompanionBuilder,
      $$NiveisTableUpdateCompanionBuilder,
      (NivelRow, BaseReferences<_$ContentDb, $NiveisTable, NivelRow>),
      NivelRow,
      PrefetchHooks Function()
    >;
typedef $$TextosBaseTableCreateCompanionBuilder =
    TextosBaseCompanion Function({
      required String codigo,
      Value<String?> titulo,
      required String texto,
      Value<int> rowid,
    });
typedef $$TextosBaseTableUpdateCompanionBuilder =
    TextosBaseCompanion Function({
      Value<String> codigo,
      Value<String?> titulo,
      Value<String> texto,
      Value<int> rowid,
    });

class $$TextosBaseTableFilterComposer
    extends Composer<_$ContentDb, $TextosBaseTable> {
  $$TextosBaseTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TextosBaseTableOrderingComposer
    extends Composer<_$ContentDb, $TextosBaseTable> {
  $$TextosBaseTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TextosBaseTableAnnotationComposer
    extends Composer<_$ContentDb, $TextosBaseTable> {
  $$TextosBaseTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get texto =>
      $composableBuilder(column: $table.texto, builder: (column) => column);
}

class $$TextosBaseTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $TextosBaseTable,
          TextoBaseRow,
          $$TextosBaseTableFilterComposer,
          $$TextosBaseTableOrderingComposer,
          $$TextosBaseTableAnnotationComposer,
          $$TextosBaseTableCreateCompanionBuilder,
          $$TextosBaseTableUpdateCompanionBuilder,
          (
            TextoBaseRow,
            BaseReferences<_$ContentDb, $TextosBaseTable, TextoBaseRow>,
          ),
          TextoBaseRow,
          PrefetchHooks Function()
        > {
  $$TextosBaseTableTableManager(_$ContentDb db, $TextosBaseTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextosBaseTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TextosBaseTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextosBaseTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String?> titulo = const Value.absent(),
                Value<String> texto = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TextosBaseCompanion(
                codigo: codigo,
                titulo: titulo,
                texto: texto,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                Value<String?> titulo = const Value.absent(),
                required String texto,
                Value<int> rowid = const Value.absent(),
              }) => TextosBaseCompanion.insert(
                codigo: codigo,
                titulo: titulo,
                texto: texto,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TextosBaseTable, TextoBaseRow>(table),
                  BaseReferences<_$ContentDb, $TextosBaseTable, TextoBaseRow>(
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

typedef $$TextosBaseTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $TextosBaseTable,
      TextoBaseRow,
      $$TextosBaseTableFilterComposer,
      $$TextosBaseTableOrderingComposer,
      $$TextosBaseTableAnnotationComposer,
      $$TextosBaseTableCreateCompanionBuilder,
      $$TextosBaseTableUpdateCompanionBuilder,
      (
        TextoBaseRow,
        BaseReferences<_$ContentDb, $TextosBaseTable, TextoBaseRow>,
      ),
      TextoBaseRow,
      PrefetchHooks Function()
    >;
typedef $$QuestoesTableCreateCompanionBuilder =
    QuestoesCompanion Function({
      required String codigo,
      Value<String?> tema,
      Value<String?> textoBase,
      required String tipo,
      required String enunciado,
      Value<String> imagens,
      Value<String?> dica,
      required String explicacao,
      Value<int?> ano,
      Value<int?> dificuldade,
      Value<int> rowid,
    });
typedef $$QuestoesTableUpdateCompanionBuilder =
    QuestoesCompanion Function({
      Value<String> codigo,
      Value<String?> tema,
      Value<String?> textoBase,
      Value<String> tipo,
      Value<String> enunciado,
      Value<String> imagens,
      Value<String?> dica,
      Value<String> explicacao,
      Value<int?> ano,
      Value<int?> dificuldade,
      Value<int> rowid,
    });

class $$QuestoesTableFilterComposer
    extends Composer<_$ContentDb, $QuestoesTable> {
  $$QuestoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tema => $composableBuilder(
    column: $table.tema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textoBase => $composableBuilder(
    column: $table.textoBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enunciado => $composableBuilder(
    column: $table.enunciado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagens => $composableBuilder(
    column: $table.imagens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dica => $composableBuilder(
    column: $table.dica,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explicacao => $composableBuilder(
    column: $table.explicacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ano => $composableBuilder(
    column: $table.ano,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dificuldade => $composableBuilder(
    column: $table.dificuldade,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestoesTableOrderingComposer
    extends Composer<_$ContentDb, $QuestoesTable> {
  $$QuestoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tema => $composableBuilder(
    column: $table.tema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textoBase => $composableBuilder(
    column: $table.textoBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enunciado => $composableBuilder(
    column: $table.enunciado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagens => $composableBuilder(
    column: $table.imagens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dica => $composableBuilder(
    column: $table.dica,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explicacao => $composableBuilder(
    column: $table.explicacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ano => $composableBuilder(
    column: $table.ano,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dificuldade => $composableBuilder(
    column: $table.dificuldade,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestoesTableAnnotationComposer
    extends Composer<_$ContentDb, $QuestoesTable> {
  $$QuestoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get tema =>
      $composableBuilder(column: $table.tema, builder: (column) => column);

  GeneratedColumn<String> get textoBase =>
      $composableBuilder(column: $table.textoBase, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get enunciado =>
      $composableBuilder(column: $table.enunciado, builder: (column) => column);

  GeneratedColumn<String> get imagens =>
      $composableBuilder(column: $table.imagens, builder: (column) => column);

  GeneratedColumn<String> get dica =>
      $composableBuilder(column: $table.dica, builder: (column) => column);

  GeneratedColumn<String> get explicacao => $composableBuilder(
    column: $table.explicacao,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ano =>
      $composableBuilder(column: $table.ano, builder: (column) => column);

  GeneratedColumn<int> get dificuldade => $composableBuilder(
    column: $table.dificuldade,
    builder: (column) => column,
  );
}

class $$QuestoesTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $QuestoesTable,
          QuestaoRow,
          $$QuestoesTableFilterComposer,
          $$QuestoesTableOrderingComposer,
          $$QuestoesTableAnnotationComposer,
          $$QuestoesTableCreateCompanionBuilder,
          $$QuestoesTableUpdateCompanionBuilder,
          (QuestaoRow, BaseReferences<_$ContentDb, $QuestoesTable, QuestaoRow>),
          QuestaoRow,
          PrefetchHooks Function()
        > {
  $$QuestoesTableTableManager(_$ContentDb db, $QuestoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String?> tema = const Value.absent(),
                Value<String?> textoBase = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> enunciado = const Value.absent(),
                Value<String> imagens = const Value.absent(),
                Value<String?> dica = const Value.absent(),
                Value<String> explicacao = const Value.absent(),
                Value<int?> ano = const Value.absent(),
                Value<int?> dificuldade = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestoesCompanion(
                codigo: codigo,
                tema: tema,
                textoBase: textoBase,
                tipo: tipo,
                enunciado: enunciado,
                imagens: imagens,
                dica: dica,
                explicacao: explicacao,
                ano: ano,
                dificuldade: dificuldade,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                Value<String?> tema = const Value.absent(),
                Value<String?> textoBase = const Value.absent(),
                required String tipo,
                required String enunciado,
                Value<String> imagens = const Value.absent(),
                Value<String?> dica = const Value.absent(),
                required String explicacao,
                Value<int?> ano = const Value.absent(),
                Value<int?> dificuldade = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestoesCompanion.insert(
                codigo: codigo,
                tema: tema,
                textoBase: textoBase,
                tipo: tipo,
                enunciado: enunciado,
                imagens: imagens,
                dica: dica,
                explicacao: explicacao,
                ano: ano,
                dificuldade: dificuldade,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestoesTable, QuestaoRow>(table),
                  BaseReferences<_$ContentDb, $QuestoesTable, QuestaoRow>(
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

typedef $$QuestoesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $QuestoesTable,
      QuestaoRow,
      $$QuestoesTableFilterComposer,
      $$QuestoesTableOrderingComposer,
      $$QuestoesTableAnnotationComposer,
      $$QuestoesTableCreateCompanionBuilder,
      $$QuestoesTableUpdateCompanionBuilder,
      (QuestaoRow, BaseReferences<_$ContentDb, $QuestoesTable, QuestaoRow>),
      QuestaoRow,
      PrefetchHooks Function()
    >;
typedef $$QuestaoProvaTableCreateCompanionBuilder =
    QuestaoProvaCompanion Function({
      required String questao,
      required String prova,
      required int nivel,
      Value<int> rowid,
    });
typedef $$QuestaoProvaTableUpdateCompanionBuilder =
    QuestaoProvaCompanion Function({
      Value<String> questao,
      Value<String> prova,
      Value<int> nivel,
      Value<int> rowid,
    });

class $$QuestaoProvaTableFilterComposer
    extends Composer<_$ContentDb, $QuestaoProvaTable> {
  $$QuestaoProvaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questao => $composableBuilder(
    column: $table.questao,
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
}

class $$QuestaoProvaTableOrderingComposer
    extends Composer<_$ContentDb, $QuestaoProvaTable> {
  $$QuestaoProvaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questao => $composableBuilder(
    column: $table.questao,
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
}

class $$QuestaoProvaTableAnnotationComposer
    extends Composer<_$ContentDb, $QuestaoProvaTable> {
  $$QuestaoProvaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questao =>
      $composableBuilder(column: $table.questao, builder: (column) => column);

  GeneratedColumn<String> get prova =>
      $composableBuilder(column: $table.prova, builder: (column) => column);

  GeneratedColumn<int> get nivel =>
      $composableBuilder(column: $table.nivel, builder: (column) => column);
}

class $$QuestaoProvaTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $QuestaoProvaTable,
          QuestaoProvaRow,
          $$QuestaoProvaTableFilterComposer,
          $$QuestaoProvaTableOrderingComposer,
          $$QuestaoProvaTableAnnotationComposer,
          $$QuestaoProvaTableCreateCompanionBuilder,
          $$QuestaoProvaTableUpdateCompanionBuilder,
          (
            QuestaoProvaRow,
            BaseReferences<_$ContentDb, $QuestaoProvaTable, QuestaoProvaRow>,
          ),
          QuestaoProvaRow,
          PrefetchHooks Function()
        > {
  $$QuestaoProvaTableTableManager(_$ContentDb db, $QuestaoProvaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestaoProvaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestaoProvaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestaoProvaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> questao = const Value.absent(),
                Value<String> prova = const Value.absent(),
                Value<int> nivel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestaoProvaCompanion(
                questao: questao,
                prova: prova,
                nivel: nivel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questao,
                required String prova,
                required int nivel,
                Value<int> rowid = const Value.absent(),
              }) => QuestaoProvaCompanion.insert(
                questao: questao,
                prova: prova,
                nivel: nivel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestaoProvaTable, QuestaoProvaRow>(table),
                  BaseReferences<
                    _$ContentDb,
                    $QuestaoProvaTable,
                    QuestaoProvaRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestaoProvaTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $QuestaoProvaTable,
      QuestaoProvaRow,
      $$QuestaoProvaTableFilterComposer,
      $$QuestaoProvaTableOrderingComposer,
      $$QuestaoProvaTableAnnotationComposer,
      $$QuestaoProvaTableCreateCompanionBuilder,
      $$QuestaoProvaTableUpdateCompanionBuilder,
      (
        QuestaoProvaRow,
        BaseReferences<_$ContentDb, $QuestaoProvaTable, QuestaoProvaRow>,
      ),
      QuestaoProvaRow,
      PrefetchHooks Function()
    >;
typedef $$AlternativasTableCreateCompanionBuilder =
    AlternativasCompanion Function({
      required String questao,
      required String letra,
      Value<String?> texto,
      Value<String?> imagem,
      Value<bool> correcta,
      required int ordem,
      Value<int> rowid,
    });
typedef $$AlternativasTableUpdateCompanionBuilder =
    AlternativasCompanion Function({
      Value<String> questao,
      Value<String> letra,
      Value<String?> texto,
      Value<String?> imagem,
      Value<bool> correcta,
      Value<int> ordem,
      Value<int> rowid,
    });

class $$AlternativasTableFilterComposer
    extends Composer<_$ContentDb, $AlternativasTable> {
  $$AlternativasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questao => $composableBuilder(
    column: $table.questao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get letra => $composableBuilder(
    column: $table.letra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagem => $composableBuilder(
    column: $table.imagem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correcta => $composableBuilder(
    column: $table.correcta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlternativasTableOrderingComposer
    extends Composer<_$ContentDb, $AlternativasTable> {
  $$AlternativasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questao => $composableBuilder(
    column: $table.questao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get letra => $composableBuilder(
    column: $table.letra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagem => $composableBuilder(
    column: $table.imagem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correcta => $composableBuilder(
    column: $table.correcta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlternativasTableAnnotationComposer
    extends Composer<_$ContentDb, $AlternativasTable> {
  $$AlternativasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questao =>
      $composableBuilder(column: $table.questao, builder: (column) => column);

  GeneratedColumn<String> get letra =>
      $composableBuilder(column: $table.letra, builder: (column) => column);

  GeneratedColumn<String> get texto =>
      $composableBuilder(column: $table.texto, builder: (column) => column);

  GeneratedColumn<String> get imagem =>
      $composableBuilder(column: $table.imagem, builder: (column) => column);

  GeneratedColumn<bool> get correcta =>
      $composableBuilder(column: $table.correcta, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);
}

class $$AlternativasTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $AlternativasTable,
          AlternativaRow,
          $$AlternativasTableFilterComposer,
          $$AlternativasTableOrderingComposer,
          $$AlternativasTableAnnotationComposer,
          $$AlternativasTableCreateCompanionBuilder,
          $$AlternativasTableUpdateCompanionBuilder,
          (
            AlternativaRow,
            BaseReferences<_$ContentDb, $AlternativasTable, AlternativaRow>,
          ),
          AlternativaRow,
          PrefetchHooks Function()
        > {
  $$AlternativasTableTableManager(_$ContentDb db, $AlternativasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlternativasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlternativasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlternativasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> questao = const Value.absent(),
                Value<String> letra = const Value.absent(),
                Value<String?> texto = const Value.absent(),
                Value<String?> imagem = const Value.absent(),
                Value<bool> correcta = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlternativasCompanion(
                questao: questao,
                letra: letra,
                texto: texto,
                imagem: imagem,
                correcta: correcta,
                ordem: ordem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questao,
                required String letra,
                Value<String?> texto = const Value.absent(),
                Value<String?> imagem = const Value.absent(),
                Value<bool> correcta = const Value.absent(),
                required int ordem,
                Value<int> rowid = const Value.absent(),
              }) => AlternativasCompanion.insert(
                questao: questao,
                letra: letra,
                texto: texto,
                imagem: imagem,
                correcta: correcta,
                ordem: ordem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlternativasTable, AlternativaRow>(table),
                  BaseReferences<
                    _$ContentDb,
                    $AlternativasTable,
                    AlternativaRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlternativasTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $AlternativasTable,
      AlternativaRow,
      $$AlternativasTableFilterComposer,
      $$AlternativasTableOrderingComposer,
      $$AlternativasTableAnnotationComposer,
      $$AlternativasTableCreateCompanionBuilder,
      $$AlternativasTableUpdateCompanionBuilder,
      (
        AlternativaRow,
        BaseReferences<_$ContentDb, $AlternativasTable, AlternativaRow>,
      ),
      AlternativaRow,
      PrefetchHooks Function()
    >;
typedef $$SimuladosTableCreateCompanionBuilder =
    SimuladosCompanion Function({
      required String codigo,
      Value<String?> prova,
      Value<String?> oferta,
      required String titulo,
      required int duracaoMin,
      required int numPerguntas,
      Value<bool> gratuito,
      Value<int> rowid,
    });
typedef $$SimuladosTableUpdateCompanionBuilder =
    SimuladosCompanion Function({
      Value<String> codigo,
      Value<String?> prova,
      Value<String?> oferta,
      Value<String> titulo,
      Value<int> duracaoMin,
      Value<int> numPerguntas,
      Value<bool> gratuito,
      Value<int> rowid,
    });

class $$SimuladosTableFilterComposer
    extends Composer<_$ContentDb, $SimuladosTable> {
  $$SimuladosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oferta => $composableBuilder(
    column: $table.oferta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duracaoMin => $composableBuilder(
    column: $table.duracaoMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numPerguntas => $composableBuilder(
    column: $table.numPerguntas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gratuito => $composableBuilder(
    column: $table.gratuito,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SimuladosTableOrderingComposer
    extends Composer<_$ContentDb, $SimuladosTable> {
  $$SimuladosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oferta => $composableBuilder(
    column: $table.oferta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duracaoMin => $composableBuilder(
    column: $table.duracaoMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numPerguntas => $composableBuilder(
    column: $table.numPerguntas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gratuito => $composableBuilder(
    column: $table.gratuito,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SimuladosTableAnnotationComposer
    extends Composer<_$ContentDb, $SimuladosTable> {
  $$SimuladosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get prova =>
      $composableBuilder(column: $table.prova, builder: (column) => column);

  GeneratedColumn<String> get oferta =>
      $composableBuilder(column: $table.oferta, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<int> get duracaoMin => $composableBuilder(
    column: $table.duracaoMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numPerguntas => $composableBuilder(
    column: $table.numPerguntas,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get gratuito =>
      $composableBuilder(column: $table.gratuito, builder: (column) => column);
}

class $$SimuladosTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $SimuladosTable,
          SimuladoRow,
          $$SimuladosTableFilterComposer,
          $$SimuladosTableOrderingComposer,
          $$SimuladosTableAnnotationComposer,
          $$SimuladosTableCreateCompanionBuilder,
          $$SimuladosTableUpdateCompanionBuilder,
          (
            SimuladoRow,
            BaseReferences<_$ContentDb, $SimuladosTable, SimuladoRow>,
          ),
          SimuladoRow,
          PrefetchHooks Function()
        > {
  $$SimuladosTableTableManager(_$ContentDb db, $SimuladosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SimuladosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SimuladosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SimuladosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String?> prova = const Value.absent(),
                Value<String?> oferta = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<int> duracaoMin = const Value.absent(),
                Value<int> numPerguntas = const Value.absent(),
                Value<bool> gratuito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SimuladosCompanion(
                codigo: codigo,
                prova: prova,
                oferta: oferta,
                titulo: titulo,
                duracaoMin: duracaoMin,
                numPerguntas: numPerguntas,
                gratuito: gratuito,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                Value<String?> prova = const Value.absent(),
                Value<String?> oferta = const Value.absent(),
                required String titulo,
                required int duracaoMin,
                required int numPerguntas,
                Value<bool> gratuito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SimuladosCompanion.insert(
                codigo: codigo,
                prova: prova,
                oferta: oferta,
                titulo: titulo,
                duracaoMin: duracaoMin,
                numPerguntas: numPerguntas,
                gratuito: gratuito,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SimuladosTable, SimuladoRow>(table),
                  BaseReferences<_$ContentDb, $SimuladosTable, SimuladoRow>(
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

typedef $$SimuladosTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $SimuladosTable,
      SimuladoRow,
      $$SimuladosTableFilterComposer,
      $$SimuladosTableOrderingComposer,
      $$SimuladosTableAnnotationComposer,
      $$SimuladosTableCreateCompanionBuilder,
      $$SimuladosTableUpdateCompanionBuilder,
      (SimuladoRow, BaseReferences<_$ContentDb, $SimuladosTable, SimuladoRow>),
      SimuladoRow,
      PrefetchHooks Function()
    >;
typedef $$ProdutosTableCreateCompanionBuilder =
    ProdutosCompanion Function({
      required String codigo,
      required String nome,
      Value<String?> descricao,
      required String tipo,
      required int precoMt,
      Value<String?> epoca,
      Value<int> ordem,
      Value<int> rowid,
    });
typedef $$ProdutosTableUpdateCompanionBuilder =
    ProdutosCompanion Function({
      Value<String> codigo,
      Value<String> nome,
      Value<String?> descricao,
      Value<String> tipo,
      Value<int> precoMt,
      Value<String?> epoca,
      Value<int> ordem,
      Value<int> rowid,
    });

class $$ProdutosTableFilterComposer
    extends Composer<_$ContentDb, $ProdutosTable> {
  $$ProdutosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get precoMt => $composableBuilder(
    column: $table.precoMt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get epoca => $composableBuilder(
    column: $table.epoca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProdutosTableOrderingComposer
    extends Composer<_$ContentDb, $ProdutosTable> {
  $$ProdutosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get precoMt => $composableBuilder(
    column: $table.precoMt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get epoca => $composableBuilder(
    column: $table.epoca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdutosTableAnnotationComposer
    extends Composer<_$ContentDb, $ProdutosTable> {
  $$ProdutosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get precoMt =>
      $composableBuilder(column: $table.precoMt, builder: (column) => column);

  GeneratedColumn<String> get epoca =>
      $composableBuilder(column: $table.epoca, builder: (column) => column);

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);
}

class $$ProdutosTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $ProdutosTable,
          ProdutoRow,
          $$ProdutosTableFilterComposer,
          $$ProdutosTableOrderingComposer,
          $$ProdutosTableAnnotationComposer,
          $$ProdutosTableCreateCompanionBuilder,
          $$ProdutosTableUpdateCompanionBuilder,
          (ProdutoRow, BaseReferences<_$ContentDb, $ProdutosTable, ProdutoRow>),
          ProdutoRow,
          PrefetchHooks Function()
        > {
  $$ProdutosTableTableManager(_$ContentDb db, $ProdutosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdutosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdutosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdutosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> precoMt = const Value.absent(),
                Value<String?> epoca = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdutosCompanion(
                codigo: codigo,
                nome: nome,
                descricao: descricao,
                tipo: tipo,
                precoMt: precoMt,
                epoca: epoca,
                ordem: ordem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String nome,
                Value<String?> descricao = const Value.absent(),
                required String tipo,
                required int precoMt,
                Value<String?> epoca = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdutosCompanion.insert(
                codigo: codigo,
                nome: nome,
                descricao: descricao,
                tipo: tipo,
                precoMt: precoMt,
                epoca: epoca,
                ordem: ordem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProdutosTable, ProdutoRow>(table),
                  BaseReferences<_$ContentDb, $ProdutosTable, ProdutoRow>(
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

typedef $$ProdutosTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $ProdutosTable,
      ProdutoRow,
      $$ProdutosTableFilterComposer,
      $$ProdutosTableOrderingComposer,
      $$ProdutosTableAnnotationComposer,
      $$ProdutosTableCreateCompanionBuilder,
      $$ProdutosTableUpdateCompanionBuilder,
      (ProdutoRow, BaseReferences<_$ContentDb, $ProdutosTable, ProdutoRow>),
      ProdutoRow,
      PrefetchHooks Function()
    >;
typedef $$ProdutoProvaTableCreateCompanionBuilder =
    ProdutoProvaCompanion Function({
      required String produto,
      required String prova,
      Value<int> rowid,
    });
typedef $$ProdutoProvaTableUpdateCompanionBuilder =
    ProdutoProvaCompanion Function({
      Value<String> produto,
      Value<String> prova,
      Value<int> rowid,
    });

class $$ProdutoProvaTableFilterComposer
    extends Composer<_$ContentDb, $ProdutoProvaTable> {
  $$ProdutoProvaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get produto => $composableBuilder(
    column: $table.produto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProdutoProvaTableOrderingComposer
    extends Composer<_$ContentDb, $ProdutoProvaTable> {
  $$ProdutoProvaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get produto => $composableBuilder(
    column: $table.produto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdutoProvaTableAnnotationComposer
    extends Composer<_$ContentDb, $ProdutoProvaTable> {
  $$ProdutoProvaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get produto =>
      $composableBuilder(column: $table.produto, builder: (column) => column);

  GeneratedColumn<String> get prova =>
      $composableBuilder(column: $table.prova, builder: (column) => column);
}

class $$ProdutoProvaTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $ProdutoProvaTable,
          ProdutoProvaRow,
          $$ProdutoProvaTableFilterComposer,
          $$ProdutoProvaTableOrderingComposer,
          $$ProdutoProvaTableAnnotationComposer,
          $$ProdutoProvaTableCreateCompanionBuilder,
          $$ProdutoProvaTableUpdateCompanionBuilder,
          (
            ProdutoProvaRow,
            BaseReferences<_$ContentDb, $ProdutoProvaTable, ProdutoProvaRow>,
          ),
          ProdutoProvaRow,
          PrefetchHooks Function()
        > {
  $$ProdutoProvaTableTableManager(_$ContentDb db, $ProdutoProvaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdutoProvaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdutoProvaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdutoProvaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> produto = const Value.absent(),
                Value<String> prova = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdutoProvaCompanion(
                produto: produto,
                prova: prova,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String produto,
                required String prova,
                Value<int> rowid = const Value.absent(),
              }) => ProdutoProvaCompanion.insert(
                produto: produto,
                prova: prova,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProdutoProvaTable, ProdutoProvaRow>(table),
                  BaseReferences<
                    _$ContentDb,
                    $ProdutoProvaTable,
                    ProdutoProvaRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProdutoProvaTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $ProdutoProvaTable,
      ProdutoProvaRow,
      $$ProdutoProvaTableFilterComposer,
      $$ProdutoProvaTableOrderingComposer,
      $$ProdutoProvaTableAnnotationComposer,
      $$ProdutoProvaTableCreateCompanionBuilder,
      $$ProdutoProvaTableUpdateCompanionBuilder,
      (
        ProdutoProvaRow,
        BaseReferences<_$ContentDb, $ProdutoProvaTable, ProdutoProvaRow>,
      ),
      ProdutoProvaRow,
      PrefetchHooks Function()
    >;
typedef $$PacotesInstaladosTableCreateCompanionBuilder =
    PacotesInstaladosCompanion Function({
      required String prova,
      required int versao,
      required String sha256,
      required DateTime instaladoEm,
      Value<int> rowid,
    });
typedef $$PacotesInstaladosTableUpdateCompanionBuilder =
    PacotesInstaladosCompanion Function({
      Value<String> prova,
      Value<int> versao,
      Value<String> sha256,
      Value<DateTime> instaladoEm,
      Value<int> rowid,
    });

class $$PacotesInstaladosTableFilterComposer
    extends Composer<_$ContentDb, $PacotesInstaladosTable> {
  $$PacotesInstaladosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versao => $composableBuilder(
    column: $table.versao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get instaladoEm => $composableBuilder(
    column: $table.instaladoEm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PacotesInstaladosTableOrderingComposer
    extends Composer<_$ContentDb, $PacotesInstaladosTable> {
  $$PacotesInstaladosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get prova => $composableBuilder(
    column: $table.prova,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versao => $composableBuilder(
    column: $table.versao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get instaladoEm => $composableBuilder(
    column: $table.instaladoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PacotesInstaladosTableAnnotationComposer
    extends Composer<_$ContentDb, $PacotesInstaladosTable> {
  $$PacotesInstaladosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get prova =>
      $composableBuilder(column: $table.prova, builder: (column) => column);

  GeneratedColumn<int> get versao =>
      $composableBuilder(column: $table.versao, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<DateTime> get instaladoEm => $composableBuilder(
    column: $table.instaladoEm,
    builder: (column) => column,
  );
}

class $$PacotesInstaladosTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $PacotesInstaladosTable,
          PacoteInstaladoRow,
          $$PacotesInstaladosTableFilterComposer,
          $$PacotesInstaladosTableOrderingComposer,
          $$PacotesInstaladosTableAnnotationComposer,
          $$PacotesInstaladosTableCreateCompanionBuilder,
          $$PacotesInstaladosTableUpdateCompanionBuilder,
          (
            PacoteInstaladoRow,
            BaseReferences<
              _$ContentDb,
              $PacotesInstaladosTable,
              PacoteInstaladoRow
            >,
          ),
          PacoteInstaladoRow,
          PrefetchHooks Function()
        > {
  $$PacotesInstaladosTableTableManager(
    _$ContentDb db,
    $PacotesInstaladosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PacotesInstaladosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PacotesInstaladosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PacotesInstaladosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> prova = const Value.absent(),
                Value<int> versao = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<DateTime> instaladoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PacotesInstaladosCompanion(
                prova: prova,
                versao: versao,
                sha256: sha256,
                instaladoEm: instaladoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String prova,
                required int versao,
                required String sha256,
                required DateTime instaladoEm,
                Value<int> rowid = const Value.absent(),
              }) => PacotesInstaladosCompanion.insert(
                prova: prova,
                versao: versao,
                sha256: sha256,
                instaladoEm: instaladoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PacotesInstaladosTable, PacoteInstaladoRow>(
                    table,
                  ),
                  BaseReferences<
                    _$ContentDb,
                    $PacotesInstaladosTable,
                    PacoteInstaladoRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PacotesInstaladosTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $PacotesInstaladosTable,
      PacoteInstaladoRow,
      $$PacotesInstaladosTableFilterComposer,
      $$PacotesInstaladosTableOrderingComposer,
      $$PacotesInstaladosTableAnnotationComposer,
      $$PacotesInstaladosTableCreateCompanionBuilder,
      $$PacotesInstaladosTableUpdateCompanionBuilder,
      (
        PacoteInstaladoRow,
        BaseReferences<
          _$ContentDb,
          $PacotesInstaladosTable,
          PacoteInstaladoRow
        >,
      ),
      PacoteInstaladoRow,
      PrefetchHooks Function()
    >;
typedef $$MetaTableCreateCompanionBuilder =
    MetaCompanion Function({
      required String chave,
      required String valor,
      Value<int> rowid,
    });
typedef $$MetaTableUpdateCompanionBuilder =
    MetaCompanion Function({
      Value<String> chave,
      Value<String> valor,
      Value<int> rowid,
    });

class $$MetaTableFilterComposer extends Composer<_$ContentDb, $MetaTable> {
  $$MetaTableFilterComposer({
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

class $$MetaTableOrderingComposer extends Composer<_$ContentDb, $MetaTable> {
  $$MetaTableOrderingComposer({
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

class $$MetaTableAnnotationComposer extends Composer<_$ContentDb, $MetaTable> {
  $$MetaTableAnnotationComposer({
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

class $$MetaTableTableManager
    extends
        RootTableManager<
          _$ContentDb,
          $MetaTable,
          MetaRow,
          $$MetaTableFilterComposer,
          $$MetaTableOrderingComposer,
          $$MetaTableAnnotationComposer,
          $$MetaTableCreateCompanionBuilder,
          $$MetaTableUpdateCompanionBuilder,
          (MetaRow, BaseReferences<_$ContentDb, $MetaTable, MetaRow>),
          MetaRow,
          PrefetchHooks Function()
        > {
  $$MetaTableTableManager(_$ContentDb db, $MetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> chave = const Value.absent(),
                Value<String> valor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetaCompanion(chave: chave, valor: valor, rowid: rowid),
          createCompanionCallback:
              ({
                required String chave,
                required String valor,
                Value<int> rowid = const Value.absent(),
              }) => MetaCompanion.insert(
                chave: chave,
                valor: valor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetaTable, MetaRow>(table),
                  BaseReferences<_$ContentDb, $MetaTable, MetaRow>(
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

typedef $$MetaTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDb,
      $MetaTable,
      MetaRow,
      $$MetaTableFilterComposer,
      $$MetaTableOrderingComposer,
      $$MetaTableAnnotationComposer,
      $$MetaTableCreateCompanionBuilder,
      $$MetaTableUpdateCompanionBuilder,
      (MetaRow, BaseReferences<_$ContentDb, $MetaTable, MetaRow>),
      MetaRow,
      PrefetchHooks Function()
    >;

class $ContentDbManager {
  final _$ContentDb _db;
  $ContentDbManager(this._db);
  $$GruposExameTableTableManager get gruposExame =>
      $$GruposExameTableTableManager(_db, _db.gruposExame);
  $$InstituicoesTableTableManager get instituicoes =>
      $$InstituicoesTableTableManager(_db, _db.instituicoes);
  $$DisciplinasTableTableManager get disciplinas =>
      $$DisciplinasTableTableManager(_db, _db.disciplinas);
  $$TemasTableTableManager get temas =>
      $$TemasTableTableManager(_db, _db.temas);
  $$ProvasTableTableManager get provas =>
      $$ProvasTableTableManager(_db, _db.provas);
  $$OfertasTableTableManager get ofertas =>
      $$OfertasTableTableManager(_db, _db.ofertas);
  $$OfertaProvaTableTableManager get ofertaProva =>
      $$OfertaProvaTableTableManager(_db, _db.ofertaProva);
  $$NiveisTableTableManager get niveis =>
      $$NiveisTableTableManager(_db, _db.niveis);
  $$TextosBaseTableTableManager get textosBase =>
      $$TextosBaseTableTableManager(_db, _db.textosBase);
  $$QuestoesTableTableManager get questoes =>
      $$QuestoesTableTableManager(_db, _db.questoes);
  $$QuestaoProvaTableTableManager get questaoProva =>
      $$QuestaoProvaTableTableManager(_db, _db.questaoProva);
  $$AlternativasTableTableManager get alternativas =>
      $$AlternativasTableTableManager(_db, _db.alternativas);
  $$SimuladosTableTableManager get simulados =>
      $$SimuladosTableTableManager(_db, _db.simulados);
  $$ProdutosTableTableManager get produtos =>
      $$ProdutosTableTableManager(_db, _db.produtos);
  $$ProdutoProvaTableTableManager get produtoProva =>
      $$ProdutoProvaTableTableManager(_db, _db.produtoProva);
  $$PacotesInstaladosTableTableManager get pacotesInstalados =>
      $$PacotesInstaladosTableTableManager(_db, _db.pacotesInstalados);
  $$MetaTableTableManager get meta => $$MetaTableTableManager(_db, _db.meta);
}
