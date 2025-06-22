import 'package:flutter/material.dart';
import 'package:flutter_application/core/db/database_helper.dart';
import 'package:flutter_application/core/db/database_seed.dart';
import 'package:sqflite/sqflite.dart';
import 'app/app.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbPath = await getDatabasesPath();
  final dbFile = join(dbPath, 'app_database.db');
  await deleteDatabase(dbFile);

  final db = await DatabaseHelper().db;
  print('💾 Banco inicializado: ${await db.getVersion()}');

  runApp(MyApp());
}
