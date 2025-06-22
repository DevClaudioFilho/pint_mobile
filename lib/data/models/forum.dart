class Forum {
  final String id;
  final String nome;
  final String imagem;

  Forum({
    required this.id,
    required this.nome,
    required this.imagem,
  });

  factory Forum.fromMap(Map<String, dynamic> map) {
    return Forum(
      id: map['id'],
      nome: map['nome'],
      imagem: map['imagem'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'imagem': imagem,
    };
  }
}
