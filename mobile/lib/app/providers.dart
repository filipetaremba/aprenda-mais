import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/activacao.dart';
import '../data/api.dart';
import '../data/content/content_db.dart';
import '../data/licencas.dart';
import '../data/repositorios.dart';
import '../data/sincronizacao.dart';
import '../data/user/user_db.dart';
import 'config.dart';
import 'theme/app_colors.dart';

// ───── Infra-estrutura (substituída nos testes com overrides) ─────

final contentDbProvider = Provider<ContentDb>((ref) => throw UnimplementedError('override em main()'));
final userDbProvider = Provider<UserDb>((ref) => throw UnimplementedError('override em main()'));

/// Pasta para conteúdo descarregado (pacotes: imagens e downloads)
final pastaConteudoProvider = Provider<Directory>((ref) => throw UnimplementedError('override em main()'));

final apiProvider = Provider<ApiCliente>((ref) => ApiCliente(baseUrl: AppConfig.apiUrl));
final verificadorProvider = Provider<VerificadorLicencas>((ref) => VerificadorLicencas(AppConfig.chavePublicaLicencas));

final conteudoRepoProvider = Provider((ref) => ConteudoRepo(ref.watch(contentDbProvider)));
final utilizadorRepoProvider = Provider((ref) => UtilizadorRepo(ref.watch(userDbProvider)));
final licencasRepoProvider = Provider((ref) => LicencasRepo(ref.watch(userDbProvider), ref.watch(verificadorProvider)));
final activacaoProvider = Provider((ref) => ServicoActivacao(
      api: ref.watch(apiProvider),
      user: ref.watch(utilizadorRepoProvider),
      licencas: ref.watch(licencasRepoProvider),
    ));
final sincronizadorProvider = Provider((ref) => Sincronizador(
      api: ref.watch(apiProvider),
      content: ref.watch(contentDbProvider),
      user: ref.watch(userDbProvider),
      pasta: ref.watch(pastaConteudoProvider),
    ));

// ───── Dados para as telas ─────

final perfilProvider = FutureProvider((ref) => ref.watch(utilizadorRepoProvider).perfil());
final objectivosProvider = FutureProvider((ref) => ref.watch(utilizadorRepoProvider).objectivos());
final licencasProvider = FutureProvider((ref) => ref.watch(licencasRepoProvider).validas());
final regrasProvider = FutureProvider((ref) => ref.watch(conteudoRepoProvider).regras());

final ofertasObjectivosProvider = FutureProvider((ref) async {
  final objectivos = await ref.watch(objectivosProvider.future);
  final ofertas = await ref.watch(conteudoRepoProvider).ofertas(codigos: objectivos);
  return [for (final c in objectivos) ...ofertas.where((o) => o.codigo == c)];
});

final provasObjectivosProvider = FutureProvider((ref) async {
  final objectivos = await ref.watch(objectivosProvider.future);
  return ref.watch(conteudoRepoProvider).provasDasOfertas(objectivos);
});

final detalheProvaProvider = FutureProvider.family<ProvaDetalhe?, String>((ref, prova) async {
  final licencas = await ref.watch(licencasProvider.future);
  ref.watch(progressoVersaoProvider);
  return detalheDaProva(ref.watch(conteudoRepoProvider), ref.watch(utilizadorRepoProvider), licencas, prova);
});

/// Detalhe de todas as provas dos objectivos (início, progresso).
final detalhesObjectivosProvider = FutureProvider((ref) async {
  final provas = await ref.watch(provasObjectivosProvider.future);
  final out = <ProvaDetalhe>[];
  for (final p in provas) {
    final d = await ref.watch(detalheProvaProvider(p.codigo).future);
    if (d != null) out.add(d);
  }
  return out;
});

final simuladosProvider = FutureProvider((ref) async {
  final provas = await ref.watch(provasObjectivosProvider.future);
  return ref.watch(conteudoRepoProvider).simulados(provas);
});

/// Contador que muda sempre que se grava uma tentativa (força o recálculo do progresso).
final progressoVersaoProvider = NotifierProvider<_Contador, int>(_Contador.new);

class _Contador extends Notifier<int> {
  @override
  int build() => 0;
  void incrementar() => state++;
}

// ───── Tema ─────

final temaEscuroProvider = NotifierProvider<TemaEscuro, bool>(TemaEscuro.new);

class TemaEscuro extends Notifier<bool> {
  @override
  bool build() => AppColors.escuro;

  Future<void> definir(bool escuro) async {
    AppColors.escuro = escuro;
    state = escuro;
    await ref.read(utilizadorRepoProvider).gravarTemaEscuro(escuro);
  }
}

/// Depois de mudar licenças, conteúdo ou progresso: recalcular o que depende disso.
extension WidgetRefRefrescar on WidgetRef {
  void refrescar() {
    invalidate(licencasProvider);
    invalidate(objectivosProvider);
    invalidate(perfilProvider);
    invalidate(regrasProvider);
    invalidate(simuladosProvider);
    invalidate(detalheProvaProvider);
    read(progressoVersaoProvider.notifier).incrementar();
  }
}
