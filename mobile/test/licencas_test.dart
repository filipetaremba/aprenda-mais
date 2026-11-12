import 'package:aprova_mais/data/licencas.dart';
import 'package:aprova_mais/data/user/user_db.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import 'ajuda.dart';

void main() {
  late ChavesTeste chaves;
  late VerificadorLicencas verificador;

  setUpAll(() async {
    chaves = await ChavesTeste.gerar();
    verificador = VerificadorLicencas(chaves.publicaBase64);
  });

  test('licença assinada é verificada offline com a chave pública', () async {
    final l = await chaves.licenca();
    final v = await verificador.verificar(l['licenca']!, l['assinatura']!);
    expect(v, isNotNull);
    expect(v!.provas, ['TST-MAT']);
    expect(v.cobre('TST-MAT', 'niveis'), isTrue);
    expect(v.cobre('TST-MAT', 'simulados'), isFalse);
    expect(v.valida(), isTrue);
  });

  test('licença alterada ou assinada com outra chave é ignorada', () async {
    final l = await chaves.licenca();
    expect(await verificador.verificar(l['licenca']!.replaceAll('TST-MAT', 'TST-FIS'), l['assinatura']!), isNull);
    final outra = await ChavesTeste.gerar();
    expect(await VerificadorLicencas(outra.publicaBase64).verificar(l['licenca']!, l['assinatura']!), isNull);
    expect(await verificador.verificar('lixo', 'nao-e-base64!!'), isNull);
  });

  test('guardar: só entram as válidas; ao ler, as expiradas e as adulteradas na base são ignoradas', () async {
    final db = userEmMemoria();
    final repo = LicencasRepo(db, verificador);
    final boa = await chaves.licenca(id: 'boa');
    final expirada = await chaves.licenca(id: 'velha', validoAte: '2020-01-01T00:00:00.000Z');
    final falsa = {...await chaves.licenca(id: 'falsa'), 'assinatura': (await chaves.licenca(id: 'outra'))['assinatura']!};

    final aceites = await repo.guardar([boa, expirada, falsa]);
    expect(aceites.map((l) => l.id), ['boa', 'velha']);
    expect((await repo.validas()).map((l) => l.id), ['boa']);

    // Alguém altera a licença guardada no telemóvel para cobrir outra prova → deixa de valer
    await (db.update(db.licencas)..where((t) => t.id.equals('boa')))
        .write(LicencasCompanion(conteudo: Value(boa['licenca']!.replaceAll('TST-MAT', 'TST-FIS'))));
    expect(await repo.validas(), isEmpty);
    await db.close();
  });
}
