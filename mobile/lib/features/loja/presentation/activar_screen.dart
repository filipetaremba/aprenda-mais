import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/activacao.dart';

/// Máscara APV-XXXX-XXXX: maiúsculas, só o alfabeto dos códigos (sem 0/O/1/I/L), hífenes automáticos.
class MascaraCodigo extends TextInputFormatter {
  static const alfabeto = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';

  static String formatar(String entrada) {
    var s = entrada.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
    if (s.startsWith('APV')) s = s.substring(3);
    s = s.split('').where(alfabeto.contains).take(8).join();
    if (s.isEmpty) return '';
    return 'APV-${s.length <= 4 ? s : '${s.substring(0, 4)}-${s.substring(4)}'}';
  }

  static bool completo(String s) => RegExp(r'^APV-[2-9A-HJKMNP-Z]{4}-[2-9A-HJKMNP-Z]{4}$').hasMatch(s);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final f = formatar(newValue.text);
    return TextEditingValue(text: f, selection: TextSelection.collapsed(offset: f.length));
  }
}

/// Nova tela — Activar código (ou restaurar compra noutro telemóvel).
class ActivarScreen extends ConsumerStatefulWidget {
  const ActivarScreen({super.key, this.prova, this.restaurar = false});

  final String? prova;
  final bool restaurar;

  @override
  ConsumerState<ActivarScreen> createState() => _ActivarScreenState();
}

class _ActivarScreenState extends ConsumerState<ActivarScreen> {
  final _codigo = TextEditingController();
  final _telefone = TextEditingController();
  final _nome = TextEditingController();
  bool _aEnviar = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _codigo.addListener(() => setState(() {}));
    ref.read(utilizadorRepoProvider).perfil().then((p) {
      if (p != null && _nome.text.isEmpty) _nome.text = p.nome;
    });
  }

  @override
  void dispose() {
    _codigo.dispose();
    _telefone.dispose();
    _nome.dispose();
    super.dispose();
  }

  Future<void> _activar() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _aEnviar = true;
      _erro = null;
    });
    try {
      await ref.read(activacaoProvider).activar(
            codigo: _codigo.text,
            telefone: _telefone.text.trim().isEmpty ? null : _telefone.text.trim(),
            nome: _nome.text.trim().isEmpty ? null : _nome.text.trim(),
          );
      ref.refrescar();
      if (mounted) context.pushReplacement('${Routes.sincronizar}?activacao=1');
    } catch (e) {
      if (mounted) setState(() => _erro = ServicoActivacao.mensagemDe(e));
    } finally {
      if (mounted) setState(() => _aEnviar = false);
    }
  }

  InputDecoration _decoracao(String dica, {String? prefixo}) => InputDecoration(
        hintText: dica,
        hintStyle: const TextStyle(color: AppColors.muted),
        prefixText: prefixo,
        counterText: '',
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: AppColors.border, width: 2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      );

  @override
  Widget build(BuildContext context) {
    final completo = MascaraCodigo.completo(_codigo.text);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  HeaderIconButton(icon: Icons.chevron_left, onPressed: () => context.pop()),
                  Expanded(
                    child: Text(widget.restaurar ? 'Restaurar compra' : 'Activar código',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(22)),
                      child: Icon(widget.restaurar ? Icons.restore_rounded : Icons.key_rounded, color: AppColors.primary, size: 36),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.restaurar
                        ? 'Mudaste de telemóvel? Escreve o código que usaste e o mesmo número de telefone, ou um código de recuperação que te enviámos.'
                        : 'Escreve o código que recebeste por SMS ou WhatsApp depois de pagares.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.inkSoft, height: 1.5),
                  ),
                  const SizedBox(height: 22),
                  Text('Código', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                  const SizedBox(height: 6),
                  TextField(
                    key: const Key('campo-codigo'),
                    controller: _codigo,
                    inputFormatters: [MascaraCodigo()],
                    textCapitalization: TextCapitalization.characters,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: TextStyle(fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w700, color: AppColors.ink),
                    decoration: _decoracao('APV-XXXX-XXXX'),
                  ),
                  const SizedBox(height: 16),
                  Text(widget.restaurar ? 'Telefone (o mesmo da activação)' : 'Telefone (opcional)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _telefone,
                    keyboardType: TextInputType.phone,
                    maxLength: 13,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]'))],
                    style: TextStyle(fontSize: 16, color: AppColors.ink),
                    decoration: _decoracao('84 123 4567', prefixo: '🇲🇿 '),
                  ),
                  const Text('Serve para recuperares a compra se mudares de telemóvel.', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  if (!widget.restaurar) ...[
                    const SizedBox(height: 16),
                    Text('Nome (opcional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    const SizedBox(height: 6),
                    TextField(controller: _nome, maxLength: 60, style: TextStyle(fontSize: 16, color: AppColors.ink), decoration: _decoracao('O teu nome')),
                  ],
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                child: Column(
                  children: [
                    if (_erro != null)
                      Container(
                        key: const Key('erro-activacao'),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                            const SizedBox(width: 10),
                            Expanded(child: Text(_erro!, style: TextStyle(color: AppColors.ink, fontSize: 13, height: 1.45))),
                          ],
                        ),
                      ),
                    PrimaryButton(
                      label: _aEnviar ? 'A verificar…' : (widget.restaurar ? 'Restaurar' : 'Activar'),
                      onPressed: completo && !_aEnviar ? _activar : null,
                    ),
                    const SizedBox(height: 6),
                    const Text('🔒 Precisas de Internet só neste passo', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
