import 'dart:async';
import 'package:flutter_application/core/db/database_helper.dart';
import 'package:flutter_application/data/models/forum.dart';
import 'package:flutter_application/data/models/post.dart';
import 'package:sqflite/sqflite.dart';

class ForumService {
  Future<List<Forum>> fetchForums() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay de API
    final db = await DatabaseHelper().db;
    final result = await db.query('forums');
    return result.map((e) => Forum.fromMap(e)).toList();
  }

  Future<void> insertForum(Forum f) async {
    final db = await DatabaseHelper().db;
    await db.insert(
      'forums',
      f.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Post?> fetchPostById(String id) async {
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Post.fromMap(result.first);
    }
    return null;
  }

  Future<List<Post>> fetchPostsByForumName(String forumId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'posts',
      where: 'forumId = ?',
      whereArgs: [forumId],
    );
    return result.map((e) => Post.fromMap(e)).toList();
  }

  Future<void> insertPost(Post post) async {
    final db = await DatabaseHelper().db;
    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Post>> fetchPostsForForum(String forumId) async {
    final db = await DatabaseHelper().db;
    final maps = await db.query(
      'posts',
      where: 'forumId = ?',
      whereArgs: [forumId],
    );
    return maps.map((e) => Post.fromMap(e)).toList();
  }

  Future<void> addComentario(
    String postId,
    String profileId,
    String texto,
    String link,
  ) async {
    final db = await DatabaseHelper().db;
    await db.insert('comentarios', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'postId': postId,
      'profileId': profileId,
      'texto': texto,
      'link': link,
    });
  }

  Future<List<Map<String, dynamic>>> fetchComentarios(String postId) async {
    final db = await DatabaseHelper().db;
    return await db.rawQuery(
      '''
    SELECT c.*, p.nome as autor
    FROM comentarios c
    LEFT JOIN profiles p ON c.profileId = p.id
    WHERE c.postId = ?
    ORDER BY c.id DESC
  ''',
      [postId],
    );
  }

  Future<Post> createPost(
    String titulo,
    String descricao,
    String autor,
    String forumId,
  ) async {
    final db = await DatabaseHelper().db;
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      descricao: descricao,
      autor: autor,
      estrelas: 0,
      forumId: forumId,
    );
    await db.insert('posts', newPost.toMap());
    return newPost;
  }

  Future<List<Post>> fetchPostsByForumId(String forumId) async {
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'posts',
      where: 'forumId = ?',
      whereArgs: [forumId],
    );
    return result.map((e) => Post.fromMap(e)).toList();
  }

  Future<void> registrarReacao(
    String postId,
    String comentarioId,
    String tipo,
    String usuario,
  ) async {
    final db = await DatabaseHelper().db;
    await db.insert('reacoes', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'postId': postId,
      'tipo': tipo,
      'usuario': usuario,
    });
  }

  Future<void> removerReacao(String postId, String tipo, String usuario) async {
    final db = await DatabaseHelper().db;
    await db.delete(
      'reacoes',
      where: 'postId = ? AND tipo = ? AND usuario = ?',
      whereArgs: [postId, tipo, usuario],
    );
  }

  Future<List<String>> buscarReacoes(
    String postId,
    String tipo,
    String usuario,
  ) async {
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'reacoes',
      where: 'postId = ? AND tipo = ? AND usuario = ?',
      whereArgs: [postId, tipo, usuario],
    );

    // Se seu banco não tem comentarioId, ajuste o campo que armazena o id do comentário
    return result
        .map((e) => (e['comentarioId'] ?? '') as String)
        .where((id) => id.isNotEmpty)
        .toList();
  }
}
