import 'package:flutter_application/core/db/database_helper.dart';
import 'package:flutter_application/data/models/profile.dart';

class ProfileService {
  Future<Profile?> fetchProfileById(String id) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Profile.fromMap(result.first);
    }
    return null;
  }

  Future<Profile> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    final db = await DatabaseHelper().db;
    final result = await db.query('profiles', limit: 1);
    return Profile.fromMap(result.first);
  }

  Future<void> updateProfile(Profile profile) async {
    final db = await DatabaseHelper().db;
    await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }
}
