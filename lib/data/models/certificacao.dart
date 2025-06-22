class Certificacao {
  final String id;
  final String titulo;
  final double progresso;
  final String? dataInicio;
  final String? dataFim;

  Certificacao({
    required this.id,
    required this.titulo,
    required this.progresso,
    this.dataInicio,
    this.dataFim,
  });

  factory Certificacao.fromMap(Map<String, dynamic> map) {
    return Certificacao(
      id: map['id'],
      titulo: map['titulo'],
      progresso: (map['progresso'] as num).toDouble(),
      dataInicio: map['dataInicio'],
      dataFim: map['dataFim'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'progresso': progresso,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
    };
  }
}
