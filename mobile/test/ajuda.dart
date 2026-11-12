import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aprova_mais/data/content/content_db.dart';
import 'package:aprova_mais/data/user/user_db.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

ContentDb contentEmMemoria() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return ContentDb(NativeDatabase.memory());
}

UserDb userEmMemoria() => UserDb(NativeDatabase.memory());

Map<String, dynamic> questao(String codigo, int nivel, {String tipo = 'escolha_multipla', String? dica, List<String> imagens = const []}) => {
      'codigo': codigo,
      'tipo': tipo,
      'tema': 'MAT-FUNCOES',
      'enunciado': tipo == 'verdadeiro_falso' ? r'$2 + 2 = 4$' : r'Quanto é $1 + 1$?',
      'imagens': imagens,
      'dica': dica,
      'ano': 2025,
      'alternativas': tipo == 'verdadeiro_falso'
          ? [
              {'letra': 'V', 'texto': 'Verdadeiro', 'imagem': null},
              {'letra': 'F', 'texto': 'Falso', 'imagem': null},
            ]
          : [
              for (final (i, t) in ['1', '2', '3', '4'].indexed) {'letra': 'ABCD'[i], 'texto': t, 'imagem': null},
            ],
      'resposta': {'letra': tipo == 'verdadeiro_falso' ? 'V' : 'B', 'origem': 'gabarito_oficial', 'confianca': null},
      'explicacao': {'texto': r'Porque $1 + 1 = 2$.', 'origem': 'proposta_ia', 'revisto': false},
      'dificuldade': 1,
      'nivel': nivel,
      'estado': 'publicada',
    };

/// conteudo_app pequeno: 1 prova (TST-MAT), níveis 1–2 com 2 questões cada, 1 oferta, 2 produtos.
Map<String, dynamic> conteudoApp({int versao = 1}) => {
      'formato': 1,
      'tipo': 'conteudo_app',
      'versao': versao,
      'gerado_em': '2026-11-12T00:00:00Z',
      'meta': {'nota_minima_padrao': 70, 'niveis_gratis': 2},
      'catalogo': {
        'grupos_exame': [
          {'codigo': 'TST', 'nome': 'Grupo de teste', 'instituicoes': ['UNITST'], 'tem_gabarito': true},
        ],
        'instituicoes': [
          {'codigo': 'UNITST', 'sigla': 'UniTeste', 'nome': 'Universidade de Teste', 'grupo_exame': 'TST', 'provincias': ['Sofala']},
        ],
        'disciplinas': [
          {'codigo': 'MAT', 'nome': 'Matemática', 'icone': null},
        ],
        'temas': [
          {'codigo': 'MAT-FUNCOES', 'disciplina': 'MAT', 'nome': 'Funções'},
        ],
        'provas': [
          {'codigo': 'TST-MAT', 'grupo_exame': 'TST', 'disciplina': 'MAT', 'nome': 'Matemática', 'duracao_min': 30, 'num_questoes': 6},
        ],
        'cursos': [
          {
            'codigo': 'UNITST-ENG-INF',
            'slug': 'unitst-eng-inf',
            'instituicao': 'UNITST',
            'curso': 'ENGENHARIA-INFORMATICA',
            'nome': 'Engenharia Informática',
            'icone': '💻',
            'nome_original': 'Licenciatura em Engenharia Informática',
            'faculdade': 'Faculdade de Ciências',
            'local': ['Beira'],
            'regimes': ['laboral'],
            'provas': [
              {'prova': 'TST-MAT', 'peso': 100},
            ],
          },
        ],
      },
      'niveis': [
        for (var n = 1; n <= 10; n++) {'prova': 'TST-MAT', 'numero': n, 'titulo': 'Nível $n', 'descricao': null, 'nota_minima': null},
      ],
      'produtos': [
        {'codigo': 'TST-MAT-NIVEIS', 'nome': 'Matemática · TST', 'descricao': 'Níveis 3 a 10', 'tipo': 'niveis', 'preco_mt': 59, 'epoca': null, 'ordem': 0, 'provas': ['TST-MAT']},
        {'codigo': 'TST-MAT-SIMULADOS', 'nome': 'Simulados de Matemática', 'descricao': null, 'tipo': 'simulados', 'preco_mt': 49, 'epoca': null, 'ordem': 1, 'provas': ['TST-MAT']},
      ],
      'simulados': <Map<String, dynamic>>[],
      'exames': [
        {
          'prova': 'TST-MAT',
          'textos_base': <String, dynamic>{},
          'questoes': [
            questao('TST-MAT-2025-001', 1, dica: r'Soma $1$ com $1$.'),
            questao('TST-MAT-2025-002', 1, tipo: 'verdadeiro_falso'),
            questao('TST-MAT-2025-003', 2),
            questao('TST-MAT-2025-004', 2),
          ],
        },
      ],
    };

/// PNG de 1×1 px
final png1px = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==');

/// Pacote pago (níveis 3–10) da prova TST-MAT, como o backend gera em "Publicar prova".
Uint8List zipPacote({String prova = 'TST-MAT', int versao = 1}) {
  final pacote = {
    'formato': 1,
    'tipo': 'pacote',
    'prova': prova,
    'versao': versao,
    'gerado_em': '2026-11-12T00:00:00Z',
    'niveis_incluidos': [3, 4, 5, 6, 7, 8, 9, 10],
    'niveis': [
      for (var n = 1; n <= 10; n++) {'prova': prova, 'numero': n, 'titulo': 'Nível $n', 'descricao': null, 'nota_minima': null},
    ],
    'simulados': <Map<String, dynamic>>[],
    'conteudo': {
      'prova': prova,
      'textos_base': <String, dynamic>{},
      'questoes': [
        questao('TST-MAT-2025-010', 3, imagens: ['TST-MAT-2025-010.png']),
        questao('TST-MAT-2025-011', 3),
        questao('TST-MAT-2025-012', 4),
      ],
    },
  };
  final a = Archive()
    ..addFile(ArchiveFile.bytes('pacote.json', utf8.encode(jsonEncode(pacote))))
    ..addFile(ArchiveFile.bytes('imagens/TST-MAT-2025-010.png', png1px));
  return Uint8List.fromList(ZipEncoder().encode(a));
}

String sha256De(List<int> b) => crypto.sha256.convert(b).toString();

/// Par de chaves Ed25519 de teste e assinatura de licenças como o backend faz.
class ChavesTeste {
  ChavesTeste._(this._par, this.publicaBase64);

  final SimpleKeyPair _par;
  final String publicaBase64;

  static Future<ChavesTeste> gerar() async {
    final par = await Ed25519().newKeyPair();
    final pub = await par.extractPublicKey();
    return ChavesTeste._(par, base64Encode(pub.bytes));
  }

  Future<Map<String, String>> licenca({
    String id = 'lic-1',
    String estudante = 'est-1',
    String produto = 'TST-MAT-NIVEIS',
    String tipo = 'niveis',
    List<String> provas = const ['TST-MAT'],
    String? validoAte = '2099-03-31T23:59:59.000Z',
  }) async {
    final conteudo = jsonEncode({
      'v': 1,
      'id': id,
      'estudante': estudante,
      'produto': produto,
      'tipo': tipo,
      'provas': provas,
      'valido_ate': validoAte,
      'emitida_em': '2026-11-12T10:00:00.000Z',
    });
    final assinatura = await Ed25519().sign(utf8.encode(conteudo), keyPair: _par);
    return {'licenca': conteudo, 'assinatura': base64Encode(assinatura.bytes)};
  }
}

/// Servidor falso da API /api/v1 (activação, licenças e download com Range).
class ServidorFalso {
  ServidorFalso(this.chaves, {Uint8List? zip}) : zip = zip ?? zipPacote();

  final ChavesTeste chaves;
  final Uint8List zip;
  final pedidos = <http.BaseRequest>[];
  bool semInternet = false;
  final codigosValidos = {'APV-7K9Q-M2XZ'};
  final usados = <String>{};

  Map<String, dynamic> get _pacote => {
        'prova': 'TST-MAT',
        'versao': 1,
        'sha256': sha256De(zip),
        'tamanho_bytes': zip.length,
        'url': '/api/v1/pacotes/TST-MAT/download',
      };

  http.Response _erro(int s, String codigo, String msg) =>
      http.Response(jsonEncode({'erro': {'codigo': codigo, 'mensagem': msg}}), s, headers: {'content-type': 'application/json; charset=utf-8'});

  late final cliente = MockClient.streaming((pedido, corpoStream) async {
    pedidos.add(pedido);
    if (semInternet) throw const SocketException('sem rede');
    final corpo = await corpoStream.bytesToString();
    final caminho = pedido.url.path;
    if (caminho == '/api/v1/activacao' && pedido.method == 'POST') {
      final j = jsonDecode(corpo) as Map<String, dynamic>;
      final codigo = j['codigo'] as String;
      if (!codigosValidos.contains(codigo)) return _stream(_erro(404, 'CODIGO_INVALIDO', 'Código inválido.'));
      if (!usados.add(codigo)) return _stream(_erro(409, 'CODIGO_USADO', 'Este código já foi usado.'));
      final lic = await chaves.licenca();
      return _stream(http.Response(
        jsonEncode({
          'token': 'apv_tokendeteste_tokendeteste',
          'restaurado': false,
          'estudante': {'id': 'est-1', 'nome': j['nome'], 'telefone': j['telefone']},
          ...lic,
          'licencas': [lic],
          'pacotes': [_pacote],
        }),
        201,
      ));
    }
    if (caminho == '/api/v1/licencas') {
      if (pedido.headers['Authorization'] == null) return _stream(_erro(401, 'NAO_AUTENTICADO', 'Sem sessão'));
      final lic = await chaves.licenca();
      return _stream(http.Response(jsonEncode({'licencas': [lic], 'pacotes': [_pacote]}), 200));
    }
    if (caminho == '/api/v1/pacotes/TST-MAT/download') {
      final range = pedido.headers['Range'];
      if (range != null) {
        final inicio = int.parse(RegExp(r'bytes=(\d+)-').firstMatch(range)!.group(1)!);
        return http.StreamedResponse(Stream.value(zip.sublist(inicio)), 206, contentLength: zip.length - inicio);
      }
      return http.StreamedResponse(Stream.value(zip), 200, contentLength: zip.length);
    }
    if (caminho == '/api/v1/catalogo') {
      return _stream(http.Response(jsonEncode({'produtos': [], 'contactos': {'mpesa': '84 111 2222', 'whatsapp': '84 333 4444'}}), 200));
    }
    return _stream(_erro(404, 'NAO_ENCONTRADO', 'Endereço inexistente.'));
  });

  static http.StreamedResponse _stream(http.Response r) =>
      http.StreamedResponse(Stream.value(r.bodyBytes), r.statusCode, headers: {'content-type': 'application/json; charset=utf-8'});
}
