class Post {
  final String id;
  final String titulo;
  final String descricao;
  final String autor;
  final double estrelas;
  final String forumId;

  Post({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.autor,
    required this.estrelas,
    required this.forumId,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      autor: map['autor'],
      estrelas: (map['estrelas'] as num).toDouble(),
      forumId: map['forumId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'autor': autor,
      'estrelas': estrelas,
      'forumId': forumId,
    };
  }
}
