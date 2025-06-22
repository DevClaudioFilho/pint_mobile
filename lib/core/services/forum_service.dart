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
    await db.insert('forums', f.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Post> fetchPostById(String id) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query('posts', where: 'id = ?', whereArgs: [id], limit: 1);
   
    return Post.fromMap(result.first);

  }

  Future<List<Post>> fetchPostsByForumName(String forumName) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query('posts', where: 'forumName = ?', whereArgs: [forumName]);
    return result.map((e) => Post.fromMap(e)).toList();
  }

  Future<void> insertPost(Post post) async {
    final db = await DatabaseHelper().db;
    await db.insert('posts', post.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Post>> fetchPostsForForum(String forumName) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'posts',
      where: 'forumName = ?',
      whereArgs: [forumName],
    );
    return result.map((e) => Post.fromMap(e)).toList();
  }

  Future<Post> createPost(String titulo, String descricao, String autor, String forumName) async {
    final db = await DatabaseHelper().db;
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      descricao: descricao,
      autor: autor,
      estrelas: 0,
      forumName: forumName,
    );
    await db.insert('posts', newPost.toMap());
    return newPost;
  }

}