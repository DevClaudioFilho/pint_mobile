class Aula {
  final String id;
  final String cursoId;
  final String titulo;
  final String descricao;
  final String videoUrl;
  final String professor;
  final double avaliacao;
  final String thumbnail;

  Aula({
    required this.id,
    required this.cursoId,
    required this.titulo,
    required this.descricao,
    required this.videoUrl,
    required this.professor,
    required this.avaliacao,
    required this.thumbnail,
  });

  factory Aula.fromMap(Map<String, dynamic> map) {
    return Aula(
      id: map['id'],
      cursoId: map['cursoId'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      videoUrl: map['videoUrl'],
      professor: map['professor'],
      avaliacao: (map['avaliacao'] as num).toDouble(),
      thumbnail: map['thumbnail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cursoId': cursoId,
      'titulo': titulo,
      'descricao': descricao,
      'videoUrl': videoUrl,
      'professor': professor,
      'avaliacao': avaliacao,
      'thumbnail': thumbnail,
    };
  }
}
