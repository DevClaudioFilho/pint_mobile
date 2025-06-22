import 'package:flutter_application/core/db/database_helper.dart';
import 'package:flutter_application/data/models/profile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  Profile? _currentUser;

  bool get isAuthenticated => _currentUser != null;
  Profile? get currentUser => _currentUser;

  Future<void> login(String email, String senha) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay

    final db = await DatabaseHelper().db;
    final result = await db.query(
      'profiles',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
      limit: 1,
    );

    if (result.isNotEmpty) {
      _currentUser = Profile.fromMap(result.first);
      notifyListeners();
    } else {
      throw Exception('Email ou senha inválidos');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> loadSession() async {
    // Simula carregar de uma sessão persistida
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
