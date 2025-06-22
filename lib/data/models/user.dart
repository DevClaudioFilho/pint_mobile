import 'perfil.dart';

class User {
  final int id;
  final String nome;
  final String email;
  final bool primeiroLogin;
  final List<Perfil> perfis;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.primeiroLogin,
    required this.perfis,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      primeiroLogin: json['primeiroLogin'] != 1,
      perfis: (json['perfis'] as List)
          .map((p) => Perfil.fromJson(p))
          .toList(),
    );
  }
}
