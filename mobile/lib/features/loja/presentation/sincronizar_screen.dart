import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/activacao.dart';
import '../../../data/sincronizacao.dart';

/// Nova tela — Sincronização: pede as licenças ao servidor e descarrega os pacotes das provas
/// licenciadas (progresso visível, checksum, importação). Se falhar a meio, retoma depois.
/// Serve para depois de activar e para "Verificar actualizações".
class SincronizarScreen extends ConsumerStatefulWidget {
  const SincronizarScreen({super.key, this.depoisDeActivar = false});

  final bool depoisDeActivar;

  @override
  ConsumerState<SincronizarScreen> createState() => _SincronizarScreenState();
}

enum _Estado { aVerificar, aDescarregar, feito, semActivacao, erro }

class _SincronizarScreenState extends ConsumerState<SincronizarScreen> {
  _Estado _estado = _Estado.aVerificar;
  ProgressoSync? _progresso;
  String? _erro;
  int _instalados = 0;
  final Map<String, String> _nomes = {};

  @override
  void initState() {
    super.initState();
    _correr();
  }

  Future<void> _correr() async {
    setState(() {
      _estado = _Estado.aVerificar;
      _erro = null;
    });
    final sync = ref.read(sincronizadorProvider);
    final user = ref.read(utilizadorRepoProvider);
    try {
      final pacotes = await ref.read(activacaoProvider).actualizar();
      if (pacotes == null) {
        setState(() => _estado = _Estado.semActivacao);
        return;
      }
      for (final p in pacotes) {
        _nomes[p.prova] = (await ref.read(conteudoRepoProvider).prova(p.prova))?.nome ?? p.prova;
      }
      if (mounted) setState(() => _estado = _Estado.aDescarregar);
      _instalados = await sync.sincronizar(pacotes, token: (await user.token())!, progresso: (p) {
        if (mounted) setState(() => _progresso = p);
      });
      ref.refrescar();
      if (!mounted) return;
      if (widget.depoisDeActivar) {
        context.pushReplacement(Routes.concluido);
      } else {
        setState(() => _estado = _Estado.feito);
      }
    } catch (e) {
      ref.refrescar();
      if (mounted) {
        setState(() {
          _estado = _Estado.erro;
          _erro = e is ChecksumInvalido ? '${e.toString()} Vamos descarregá-lo de novo.' : ServicoActivacao.mensagemDe(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _progresso;
    final (icone, titulo, texto) = switch (_estado) {
      _Estado.aVerificar => (Icons.cloud_sync_rounded, 'A verificar as tuas compras…', 'Só demora um instante.'),
      _Estado.aDescarregar => (
          Icons.download_rounded,
          'A descarregar o conteúdo',
          p == null || p.total == 0
              ? 'A preparar…'
              : '${_nomes[p.prova] ?? p.prova} (${p.indice} de ${p.total})${p.fase == FaseSync.verificar ? ' · a verificar' : ''}',
        ),
      _Estado.feito => (
          Icons.check_circle_rounded,
          _instalados == 0 ? 'Está tudo actualizado' : 'Conteúdo actualizado',
          _instalados == 0 ? 'Já tens a versão mais recente de todas as tuas provas.' : '$_instalados ${_instalados == 1 ? 'prova actualizada' : 'provas actualizadas'}.',
        ),
      _Estado.semActivacao => (Icons.key_off_rounded, 'Ainda não activaste nenhum código', 'Quando pagares, recebes um código para activar aqui.'),
      _Estado.erro => (Icons.wifi_off_rounded, 'Não foi possível terminar', _erro ?? ''),
    };
    final aTrabalhar = _estado == _Estado.aVerificar || _estado == _Estado.aDescarregar;

    return PopScope(
      canPop: !aTrabalhar,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (!aTrabalhar)
                  Align(alignment: Alignment.centerLeft, child: HeaderIconButton(icon: Icons.close, onPressed: () => context.pop())),
                const Spacer(),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: _estado == _Estado.erro ? AppColors.errorLight : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(icone, size: 48, color: _estado == _Estado.erro ? AppColors.error : AppColors.primary),
                ),
                const SizedBox(height: 20),
                Text(titulo, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 6),
                Text(texto, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.inkSoft, height: 1.45)),
                const SizedBox(height: 24),
                if (aTrabalhar)
                  Column(
                    children: [
                      LinearBar(
                        value: _estado == _Estado.aVerificar || p == null ? 0.05 : p.fraccao,
                        color: AppColors.primary,
                        background: AppColors.primaryLight,
                        height: 10,
                      ),
                      const SizedBox(height: 8),
                      if (p != null && p.bytesTotal > 0)
                        Text('${(p.bytes / 1024).round()} de ${(p.bytesTotal / 1024).round()} KB',
                            style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      const SizedBox(height: 4),
                      const Text('Não feches a app. Se a ligação cair, continuamos depois de onde parou.',
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                const Spacer(),
                if (_estado == _Estado.erro) ...[
                  PrimaryButton(label: 'Tentar de novo', onPressed: _correr),
                  const SizedBox(height: 8),
                  SecondaryButton(label: 'Mais tarde', onPressed: () => context.go(Routes.inicio)),
                ],
                if (_estado == _Estado.semActivacao) PrimaryButton(label: '🔑 Activar um código', onPressed: () => context.pushReplacement(Routes.activar)),
                if (_estado == _Estado.feito) PrimaryButton(label: 'Voltar', onPressed: () => context.pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
