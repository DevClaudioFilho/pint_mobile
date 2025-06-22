class Profile {
  final String id;
  final String nome;
  final String email;
  final String morada;
  final String codigoPostal;
  final String avatarUrl;

  Profile({
    required this.id,
    required this.nome,
    required this.email,
    required this.morada,
    required this.codigoPostal,
    required this.avatarUrl,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      morada: map['morada'],
      codigoPostal: map['codigoPostal'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'morada': morada,
      'codigoPostal': codigoPostal,
      'avatarUrl': avatarUrl,
    };
  }
}
