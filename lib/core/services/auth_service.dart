import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {  // Agora herda de ChangeNotifier
  Map<String, dynamic>? _currentUser;

  Future<Map<String, dynamic>> login(String email, String senha) async {
    final url = Uri.parse('https://backend-8pyn.onrender.com');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _currentUser = data['user'];
        notifyListeners();  // Notifica listeners sobre a alteração
        return data;
      } else {
        throw Exception(data['message'] ?? 'Login falhou');
      }
    } else {
      throw Exception('Erro de conexão: ${response.statusCode}');
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();  // Notifica listeners que o usuário deslogou
  }

  bool get isAuthenticated => _currentUser != null;

  Map<String, dynamic>? get currentUser => _currentUser;
}
