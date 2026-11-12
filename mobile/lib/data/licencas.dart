import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import 'user/user_db.dart';

/// Licença já verificada (assinatura Ed25519 válida).
class Licenca {
  const Licenca({
    required this.id,
    required this.estudante,
    required this.produto,
    required this.tipo,
    required this.provas,
    required this.validoAte,
    required this.emitidaEm,
    required this.conteudo,
    required this.assinatura,
  });

  final String id;
  final String estudante;
  final String produto;

  /// niveis | simulados
  final String tipo;
  final List<String> provas;
  final DateTime? validoAte;
  final DateTime emitidaEm;
  final String conteudo;
  final String assinatura;

  bool valida([DateTime? agora]) => validoAte == null || validoAte!.isAfter(agora ?? DateTime.now());
  bool cobre(String prova, String tipoLicenca) => tipo == tipoLicenca && provas.contains(prova);
}

/// Verifica licenças OFFLINE com a chave pública embutida (32 bytes, base64).
class VerificadorLicencas {
  VerificadorLicencas(String chavePublicaBase64)
      : _chave = SimplePublicKey(base64Decode(chavePublicaBase64), type: KeyPairType.ed25519);

  final SimplePublicKey _chave;
  final _algoritmo = Ed25519();

  /// Devolve a licença se a assinatura for válida e o conteúdo bem formado; null caso contrário.
  Future<Licenca?> verificar(String conteudo, String assinaturaBase64) async {
    try {
      final ok = await _algoritmo.verify(
        utf8.encode(conteudo),
        signature: Signature(base64Decode(assinaturaBase64), publicKey: _chave),
      );
      if (!ok) return null;
      final j = jsonDecode(conteudo) as Map<String, dynamic>;
      if (j['v'] != 1) return null;
      return Licenca(
        id: j['id'] as String,
        estudante: j['estudante'] as String,
        produto: j['produto'] as String,
        tipo: j['tipo'] as String,
        provas: [for (final p in j['provas'] as List) p as String],
        validoAte: j['valido_ate'] == null ? null : DateTime.parse(j['valido_ate'] as String),
        emitidaEm: DateTime.parse(j['emitida_em'] as String),
        conteudo: conteudo,
        assinatura: assinaturaBase64,
      );
    } catch (_) {
      return null;
    }
  }
}

/// Licenças guardadas na user.db. A assinatura é verificada ao guardar E ao ler
/// (uma licença alterada no telemóvel é simplesmente ignorada).
class LicencasRepo {
  LicencasRepo(this.db, this.verificador);

  final UserDb db;
  final VerificadorLicencas verificador;

  /// Guarda as licenças vindas do servidor ({licenca, assinatura}). Com [substituir], as que
  /// o servidor já não devolve (revogadas/expiradas) são removidas. Devolve as aceites.
  Future<List<Licenca>> guardar(List<Map<String, dynamic>> doServidor, {bool substituir = false}) async {
    final aceites = <Licenca>[];
    for (final l in doServidor) {
      final v = await verificador.verificar(l['licenca'] as String, l['assinatura'] as String);
      if (v != null) aceites.add(v);
    }
    await db.transaction(() async {
      if (substituir) await db.delete(db.licencas).go();
      for (final l in aceites) {
        await db.into(db.licencas).insertOnConflictUpdate(LicencasCompanion.insert(
              id: l.id,
              produto: l.produto,
              tipo: l.tipo,
              provas: jsonEncode(l.provas),
              validoAte: Value(l.validoAte),
              conteudo: l.conteudo,
              assinatura: l.assinatura,
              recebidaEm: DateTime.now(),
            ));
      }
    });
    return aceites;
  }

  /// Licenças com assinatura válida e dentro da validade.
  Future<List<Licenca>> validas([DateTime? agora]) async {
    final out = <Licenca>[];
    for (final r in await db.select(db.licencas).get()) {
      final v = await verificador.verificar(r.conteudo, r.assinatura);
      if (v != null && v.valida(agora)) out.add(v);
    }
    return out;
  }
}
