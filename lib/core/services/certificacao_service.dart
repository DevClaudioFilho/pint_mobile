import 'dart:async';
import 'package:flutter_application/core/db/database_helper.dart';
import 'package:flutter_application/data/models/certificacao.dart' show Certificacao;
import 'package:sqflite/sqflite.dart';


class CertificacaoService {
  Future<List<Certificacao>> fetchCertificacoes() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay de API
    final db = await DatabaseHelper().db;
    final result = await db.query('certificacoes');
    return result.map((e) => Certificacao.fromMap(e)).toList();
  }

  Future<void> insertCertificacao(Certificacao c) async {
    final db = await DatabaseHelper().db;
    await db.insert('certificacoes', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
