import 'dart:async';

class UserProfile {
  final String id;
  final String nome;
  final String email;
  final String morada;
  final String codigoPostal;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.nome,
    required this.email,
    required this.morada,
    required this.codigoPostal,
    required this.avatarUrl,
  });
}

class ProfileService {
  Future<UserProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserProfile(
      id: '#3515280',
      nome: 'Claudio Martins de Pinho filho',
      email: 'claudiofilhodf@softinsa.com',
      morada: 'Av.Sei la oque',
      codigoPostal: '351-1234',
      avatarUrl: 'https://images.pexels.com/photos/326875/pexels-photo-326875.jpeg?cs=srgb&dl=adorable-animal-blur-326875.jpg&fm=jpg',
    );
  }
}
