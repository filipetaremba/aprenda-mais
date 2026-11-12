import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/formatos.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/user/user_db.dart';
import '../../../domain/regras.dart';

final tentativaProvider = FutureProvider.family<TentativaRow?, String>((ref, id) => ref.watch(utilizadorRepoProvider).tentativa(id));

/// Tela 10 — Resultado de um nível ou simulado.
class ResultadoScreen extends ConsumerWidget {
  const ResultadoScreen({super.key, required this.tentativa});

  final String tentativa;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tentativaProvider(tentativa)).value;
    if (t == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final perfil = ref.watch(perfilProvider).value;
    final d = ref.watch(detalheProvaProvider(t.prova)).value;
    final simulado = t.simulado != null;
    final nivel = d?.niveis.where((n) => n.numero == t.nivel).firstOrNull;
    final seguinte = d?.niveis.where((n) => n.numero == (t.nivel ?? 0) + 1).firstOrNull;
    final notaMinima = nivel?.notaMinima ?? d?.regras.notaMinimaPadrao ?? notaMinimaPadraoOmissao;
    final passou = t.percentagem >= notaMinima;
    final nome = perfil?.nome ?? '';
    final disciplina = d?.prova.disciplinaNome ?? t.prova;

    final String etiqueta;
    if (simulado) {
      etiqueta = passou ? '🎯 Bom resultado!' : '📚 Continua a praticar';
    } else if (passou && seguinte != null) {
      etiqueta = seguinte.estado == EstadoNivel.pago ? '🔒 Nível ${seguinte.numero} é pago' : '🎉 Nível ${seguinte.numero} desbloqueado!';
    } else if (passou) {
      etiqueta = '🏆 Concluíste todos os níveis!';
    } else {
      etiqueta = 'Precisas de $notaMinima% para passar';
    }

    void continuar() {
      if (simulado) {
        context.pop();
      } else if (!passou) {
        context.pushReplacement(Routes.quiz(t.prova, t.nivel!));
      } else if (seguinte == null) {
        context.pop();
      } else if (seguinte.estado == EstadoNivel.pago) {
        context.pushReplacement(Routes.lojaDe(t.prova));
      } else if (seguinte.estado == EstadoNivel.porDescarregar) {
        context.pushReplacement(Routes.sincronizar);
      } else {
        context.pushReplacement(Routes.nivel(t.prova, seguinte.numero));
      }
    }

    final rotuloContinuar = simulado
        ? 'Voltar'
        : !passou
            ? 'Tentar de novo'
            : seguinte == null
                ? 'Voltar aos níveis'
                : seguinte.estado == EstadoNivel.pago
                    ? 'Desbloquear o Nível ${seguinte.numero}'
                    : 'Continuar para o Nível ${seguinte.numero}';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 210,
                      child: Stack(
                        children: [
                          if (passou) const Positioned.fill(child: Confetti()),
                          Center(
                            child: RingProgress(
                              value: t.percentagem / 100,
                              size: 180,
                              stroke: 22,
                              center: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(percentagem(t.percentagem),
                                      style: TextStyle(
                                          fontSize: 38, fontWeight: FontWeight.w800, color: passou ? AppColors.primary : AppColors.error, height: 1.1)),
                                  Text('${t.certas} de ${t.total}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(color: passou ? AppColors.successLight : AppColors.accentLight, borderRadius: BorderRadius.circular(20)),
                        child: Text(etiqueta,
                            style: TextStyle(color: passou ? AppColors.success : AppColors.ink, fontWeight: FontWeight.w700, fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(passou ? 'Muito bem${nome.isEmpty ? '' : ', $nome'}!' : 'Quase lá${nome.isEmpty ? '' : ', $nome'}!',
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    Text(
                      simulado ? 'Simulado de $disciplina' : '$disciplina · Nível ${t.nivel} ${passou ? 'concluído' : ''}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(child: StatTile(value: '${t.certas}', label: 'certas', color: AppColors.success, background: AppColors.successLight)),
                        const SizedBox(width: 8),
                        Expanded(child: StatTile(value: '${t.erradas}', label: 'erradas', color: AppColors.error, background: AppColors.errorLight)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: simulado
                              ? StatTile(
                                  value: '${t.total - t.certas - t.erradas}',
                                  label: 'em branco',
                                  color: const Color(0xFFF59E0B),
                                  background: AppColors.accentLight)
                              : StatTile(value: '${t.comAjuda}', label: 'com ajuda', color: const Color(0xFFF59E0B), background: AppColors.accentLight),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: StatTile(
                              value: '${(t.duracaoSeg / 60).ceil()}′', label: 'tempo', color: AppColors.primary, background: AppColors.primaryLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (t.comAjuda > 0)
                      const Text('As perguntas em que viste a resposta não contam para a nota.',
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              SecondaryButton(label: 'Rever respostas', height: 48, onPressed: () => context.push(Routes.revisao(t.id))),
              const SizedBox(height: 12),
              PrimaryButton(label: rotuloContinuar, onPressed: continuar),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
