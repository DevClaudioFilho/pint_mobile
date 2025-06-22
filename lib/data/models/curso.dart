class Curso {
  final String id;
  final String titulo;
  final String categoria;
  final String nivel;
  final DateTime dataLimite;

  Curso({required this.id, required this.titulo, required this.categoria, required this.nivel, required this.dataLimite});

  factory Curso.fromMap(Map<String, dynamic> map) {
    return Curso(
      id: map['id'],
      titulo: map['titulo'],
      categoria: map['categoria'],
      nivel: map['nivel'],
      dataLimite: DateTime.parse(map['dataLimite']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'categoria': categoria,
      'nivel': nivel,
      'dataLimite': dataLimite.toIso8601String(),
    };
  }

}
