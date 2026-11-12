const _meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];

/// "Hoje", "Ontem" ou "12 Nov".
String dataRelativa(DateTime d, [DateTime? agora]) {
  final hoje = agora ?? DateTime.now();
  final dia = DateTime(d.year, d.month, d.day);
  final h = DateTime(hoje.year, hoje.month, hoje.day);
  final diff = h.difference(dia).inDays;
  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Ontem';
  return '${d.day} ${_meses[d.month - 1]}';
}

/// "22 min", "1 h 05 min", "45 s".
String duracao(int segundos) {
  if (segundos < 60) return '$segundos s';
  final m = segundos ~/ 60;
  if (m < 60) return '$m min';
  return '${m ~/ 60} h ${(m % 60).toString().padLeft(2, '0')} min';
}

/// Cronómetro: "01:12:45" ou "12:05".
String relogio(int segundos) {
  final s = segundos < 0 ? 0 : segundos;
  final h = s ~/ 3600, m = (s % 3600) ~/ 60, r = s % 60;
  String d2(int x) => x.toString().padLeft(2, '0');
  return h > 0 ? '${d2(h)}:${d2(m)}:${d2(r)}' : '${d2(m)}:${d2(r)}';
}

String percentagem(double p) => '${p.round()}%';
