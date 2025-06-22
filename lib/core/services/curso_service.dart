import 'dart:async';
import 'package:flutter_application/data/models/aula.dart';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';
import '../../data/models/curso.dart';

class CursoService {
  Future<List<Curso>> fetchCursos({
    String? search,
    String? categoria,
    String? nivel,
    int? estrelas,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay API
    final db = await DatabaseHelper().db;

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      whereClauses.add('titulo LIKE ?');
      whereArgs.add('%$search%');
    }
    if (categoria != null && categoria.isNotEmpty) {
      whereClauses.add('categoria = ?');
      whereArgs.add(categoria);
    }
    if (nivel != null && nivel.isNotEmpty) {
      whereClauses.add('nivel = ?');
      whereArgs.add(nivel);
    }
    if (estrelas != null) {
      whereClauses.add('estrelas >= ?');
      whereArgs.add(estrelas.toDouble());
    }

    final result = await db.query(
      'cursos',
      where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
      whereArgs: whereArgs,
    );

    return result.map((e) => Curso.fromMap(e)).toList();
  }

  Future<void> insertCurso(Curso curso) async {
    final db = await DatabaseHelper().db;
    await db.insert('cursos', curso.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

    Future<Curso> fetchCursoById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final db = await DatabaseHelper().db;
    final result = await db.query('cursos', where: 'id = ?', whereArgs: [id], limit: 1);
    return Curso.fromMap(result.first);
  }

  Future<List<Aula>> fetchAulasByCurso(String cursoId) async {
    await Future.delayed(const Duration(seconds: 1));
    final db = await DatabaseHelper().db;
    final result = await db.query('aulas', where: 'cursoId = ?', whereArgs: [cursoId]);
    return result.map((e) => Aula.fromMap(e)).toList();
  }
}
