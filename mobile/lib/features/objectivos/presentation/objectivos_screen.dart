import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 4 — Escolher objectivo (curso + instituição).
class ObjectivosScreen extends StatefulWidget {
  const ObjectivosScreen({super.key});

  @override
  State<ObjectivosScreen> createState() => _ObjectivosScreenState();
}

class _ObjectivosScreenState extends State<ObjectivosScreen> {
  String _filtro = 'Todas';
  final Set<int> _sel = {0};

  static const _ofertas = [
    ('💻', 'Engenharia Informática', 'UniZambeze', 'Matemática · Física', AppColors.primary),
    ('🩺', 'Medicina', 'UEM', 'Biologia · Química', Color(0xFFFDE3E7)),
    ('🏗️', 'Engenharia Civil', 'UniZambeze', 'Matemática · Física', Color(0xFFFEF3C7)),
    ('💻', 'Engenharia Informática', 'UP', 'Matemática · Inglês', Color(0xFFDCF8E5)),
  ];

  @override
  Widget build(BuildContext context) {
    final lista = [
      for (var i = 0; i < _ofertas.length; i++)
        if (_filtro == 'Todas' || _ofertas[i].$3 == _filtro) i,
    ];
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LinearBar(value: 1, color: AppColors.primary, background: AppColors.primaryLight, height: 6),
                    const SizedBox(height: 20),
                    const Text('O que queres preparar?',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const Text('Podes escolher mais de um.',
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppColors.muted),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Pesquisar curso…',
                                hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final f in ['Todas', 'UEM', 'UP', 'UniZambeze'])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChipFilter(
                                label: f,
                                selected: f == _filtro,
                                onTap: () => setState(() => _filtro = f),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              itemCount: lista.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, k) {
                final i = lista[k];
                final o = _ofertas[i];
                final sel = _sel.contains(i);
                return AppCard(
                  onTap: () => setState(() => sel ? _sel.remove(i) : _sel.add(i)),
                  border: Border.all(
                    color: sel ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                  child: Row(
                    children: [
                      EmojiBox(o.$1, background: o.$5),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.$2,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                            Text('${o.$3} · ${o.$4}',
                                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      SelectCircle(selected: sel),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                label: 'Continuar · ${_sel.length} seleccionado${_sel.length == 1 ? '' : 's'}',
                onPressed: _sel.isEmpty
                    ? null
                    : () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(Routes.inicio, (_) => false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
