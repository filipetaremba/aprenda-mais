import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 3 — O teu nome + avatar.
class NomeScreen extends StatefulWidget {
  const NomeScreen({super.key});

  @override
  State<NomeScreen> createState() => _NomeScreenState();
}

class _NomeScreenState extends State<NomeScreen> {
  final _name = TextEditingController(text: 'Filipe');
  int _avatar = 0;

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              const LinearBar(value: 0.5, color: AppColors.primary, background: AppColors.primaryLight, height: 6),
              const SizedBox(height: 8),
              const Text('Passo 1 de 2',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
              const SizedBox(height: 20),
              const Text(
                'Como te chamas?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
              const SizedBox(height: 4),
              const Text('Só fica guardado no teu telemóvel.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
              const SizedBox(height: 24),
              TextField(
                controller: _name,
                style: const TextStyle(fontSize: 16, color: AppColors.ink),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.border, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Escolhe um avatar',
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
                label: 'Continuar',
                onPressed: () => Navigator.of(context).pushNamed(Routes.objectivos),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
