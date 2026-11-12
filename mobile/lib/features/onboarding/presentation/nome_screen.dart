import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 3 — O teu nome + avatar (guardados só no telemóvel). Também serve para editar o perfil.
class NomeScreen extends ConsumerStatefulWidget {
  const NomeScreen({super.key, this.editar = false});

  final bool editar;

  @override
  ConsumerState<NomeScreen> createState() => _NomeScreenState();
}

class _NomeScreenState extends ConsumerState<NomeScreen> {
  final _name = TextEditingController();
  int _avatar = 0;

  @override
  void initState() {
    super.initState();
    ref.read(utilizadorRepoProvider).perfil().then((p) {
      if (p == null || !mounted) return;
      setState(() {
        _name.text = p.nome;
        _avatar = avatars.indexWhere((a) => a.$1 == p.avatar).clamp(0, avatars.length - 1);
      });
    });
    _name.addListener(() => setState(() {}));
  }

  Future<void> _continuar() async {
    await ref.read(utilizadorRepoProvider).gravarPerfil(nome: _name.text.trim(), avatar: avatars[_avatar].$1);
    ref.invalidate(perfilProvider);
    if (!mounted) return;
    if (widget.editar) {
      context.pop();
    } else {
      context.go(Routes.objectivos);
    }
  }

  static const avatars = [
    ('🦁', Color(0xFFFFF1C7)),
    ('🐢', Color(0xFFDCF8E5)),
    ('🐬', Color(0xFFDDF0FD)),
    ('🦩', Color(0xFFFDE3E7)),
    ('🦉', Color(0xFFEDE9FE)),
    ('🦒', Color(0xFFFFEDD5)),
    ('🐘', Color(0xFFD5F8F0)),
    ('🐝', Color(0xFFFEF9C3)),
  ];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              if (!widget.editar) ...[
                LinearBar(value: 0.5, color: AppColors.primary, background: AppColors.primaryLight, height: 6),
                const SizedBox(height: 8),
                const Text('Passo 1 de 2', style: TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
              const SizedBox(height: 20),
              Text(
                'Como te chamas?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
              const SizedBox(height: 4),
              const Text('Só fica guardado no teu telemóvel.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
              const SizedBox(height: 24),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                maxLength: 30,
                style: TextStyle(fontSize: 16, color: AppColors.ink),
                decoration: InputDecoration(
                  hintText: 'O teu nome',
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: AppColors.border, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text('Escolhe um avatar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < avatars.length; i++)
                    GestureDetector(
                      onTap: () => setState(() => _avatar = i),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: avatars[i].$2,
                          borderRadius: BorderRadius.circular(18),
                          border: i == _avatar
                              ? Border.all(color: AppColors.primary, width: 3)
                              : null,
                        ),
                        child: Text(avatars[i].$1, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                label: widget.editar ? 'Guardar' : 'Continuar',
                onPressed: _name.text.trim().isEmpty ? null : _continuar,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
