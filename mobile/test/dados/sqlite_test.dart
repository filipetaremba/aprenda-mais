import 'package:aprova_mais/data/content/content_db.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sqlite em memória funciona', () async {
    final db = ContentDb(NativeDatabase.memory());
    await db.gravarMeta('x', '1');
    expect(await db.lerMeta('x'), '1');
    await db.close();
  });
}
