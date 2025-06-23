import 'package:sqflite/sqflite.dart';
import 'package:flutter_application/core/db/database_helper.dart';
import 'package:flutter_application/data/models/aula.dart';

class AulaService {
  Future<Aula> fetchAula(String aulaId) async {
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'aulas',
      where: 'id = ?',
      whereArgs: [aulaId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Aula.fromMap(result.first);
    }
    throw Exception('Aula não encontrada');
  }

  Future<List<Aula>> fetchAulasByCurso(String cursoId) async {
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'aulas',
      where: 'cursoId = ?',
      whereArgs: [cursoId],
    );
    return result.map((e) => Aula.fromMap(e)).toList();
  }

  Future<void> addComentario(
    String aulaId,
    String profileId,
    String texto,
    String link,
  ) async {
    final db = await DatabaseHelper().db;
    await db.insert('comentarios_aula', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'aulaId': aulaId,
      'profileId': profileId,
      'texto': texto,
      'link': link,
    });
  }

  Future<List<Map<String, dynamic>>> fetchComentarios(String aulaId) async {
    final db = await DatabaseHelper().db;
    return await db.rawQuery(
      '''
      SELECT c.*, p.nome as autor
      FROM comentarios_aula c
      LEFT JOIN profiles p ON c.profileId = p.id
      WHERE c.aulaId = ?
      ORDER BY c.id DESC
      ''',
      [aulaId],
    );
  }

  Future<void> registrarReacao(
    String aulaId,
    String comentarioId,
    String tipo,
    String usuario,
  ) async {
    final db = await DatabaseHelper().db;
    await db.insert('reacoes', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'postId': aulaId, // usando o mesmo campo, ou adapte se tiver campo aulaId
      'comentarioId': comentarioId,
      'tipo': tipo,
      'usuario': usuario,
    });
  }

  Future<void> removerReacao(
    String aulaId,
    String comentarioId,
    String tipo,
    String usuario,
  ) async {
    final db = await DatabaseHelper().db;
    await db.delete(
      'reacoes',
      where: 'postId = ? AND comentarioId = ? AND tipo = ? AND usuario = ?',
      whereArgs: [aulaId, comentarioId, tipo, usuario],
    );
  }

  Future<List<String>> buscarReacoes(
    String aulaId,
    String tipo,
    String usuario,
  ) async {
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'reacoes',
      columns: ['comentarioId'],
      where: 'postId = ? AND tipo = ? AND usuario = ?',
      whereArgs: [aulaId, tipo, usuario],
    );
    return result.map((e) => e['comentarioId'] as String).toList();
  }
}
