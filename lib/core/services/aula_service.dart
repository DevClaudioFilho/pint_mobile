import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../../data/models/aula.dart';

class AulaService {
  Future<Aula> fetchAula(String id) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query('aulas', where: 'id = ?', whereArgs: [id], limit: 1);

    return Aula.fromMap(result.first);
  }

  Future<List<Aula>> fetchAulasByCurso(String cursoId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query('aulas', where: 'cursoId = ?', whereArgs: [cursoId]);
    return result.map((e) => Aula.fromMap(e)).toList();
  }

  Future<void> insertAula(Aula aula) async {
    final db = await DatabaseHelper().db;
    await db.insert('aulas', aula.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
