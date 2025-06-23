class Certificacao {
  final String id;
  final String cursoId;
  final String titulo;
  final String profileId;
  final double progresso;
  final String? dataInicio;
  final String? dataFim;

  Certificacao({
    required this.id,
    required this.cursoId,
    required this.titulo,
    required this.profileId,
    required this.progresso,
    this.dataInicio,
    this.dataFim,
  });

  factory Certificacao.fromMap(Map<String, dynamic> map) {
    return Certificacao(
      id: map['id'],
      cursoId: map['cursoId'],
      titulo: map['titulo'],
      profileId: map['profileId'],
      progresso: (map['progresso'] as num).toDouble(),
      dataInicio: map['dataInicio'],
      dataFim: map['dataFim'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cursoId': cursoId,
      'titulo': titulo,
      'profileId': profileId,
      'progresso': progresso,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
    };
  }
}
