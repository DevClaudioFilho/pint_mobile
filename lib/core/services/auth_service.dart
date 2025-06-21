import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  bool get isAuthenticated => _token != null;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula requisição

    // Simula credenciais fixas
    // if (email == 't@t.com' && password == '123456') {
      _token = 'fake_token_${DateTime.now().millisecondsSinceEpoch}';
      notifyListeners();
    // } else {
    //   throw Exception('Credenciais inválidas');
    // }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
