class Certificacao {
  final String id;
  final String titulo;
  final double progresso;
  final DateTime? dataInicio;
  final DateTime? dataFim;

  Certificacao({
    required this.id,
    required this.titulo,
    required this.progresso,
    this.dataInicio,
    this.dataFim,
  });
}
