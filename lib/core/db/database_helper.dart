// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_seed.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profiles (
        id TEXT PRIMARY KEY,
        nome TEXT,
        email TEXT UNIQUE,
        senha TEXT,
        morada TEXT,
        codigoPostal TEXT,
        avatarUrl TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE cursos (
        id TEXT PRIMARY KEY,
        titulo TEXT,
        categoria TEXT,
        nivel TEXT,
        estrelas REAL,
        dataLimite TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE aulas (
        id TEXT PRIMARY KEY,
        cursoId TEXT,
        titulo TEXT,
        descricao TEXT,
        videoUrl TEXT,
        professor TEXT,
        avaliacao REAL,
        thumbnail TEXT,
        FOREIGN KEY (cursoId) REFERENCES cursos(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE certificacoes (
        id TEXT PRIMARY KEY,
        cursoId TEXT,
        titulo TEXT,
        profileId TEXT,
        progresso REAL,
        dataInicio TEXT,
        dataFim TEXT,
        FOREIGN KEY (cursoId) REFERENCES cursos(id) ON DELETE CASCADE,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE inscricoes (
        id TEXT PRIMARY KEY,
        cursoId TEXT,
        profileId TEXT,
        dataInscricao TEXT,
        FOREIGN KEY (cursoId) REFERENCES cursos(id) ON DELETE CASCADE,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE forums (
        id TEXT PRIMARY KEY,
        nome TEXT,
        imagem TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE posts (
        id TEXT PRIMARY KEY,
        forumId TEXT,
        titulo TEXT,
        descricao TEXT,
        autor TEXT,
        estrelas REAL,
        FOREIGN KEY (forumId) REFERENCES forums(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE comentarios (
        id TEXT PRIMARY KEY,
        postId TEXT,
        profileId TEXT,
        texto TEXT,
        link TEXT,
        FOREIGN KEY (postId) REFERENCES posts(id) ON DELETE CASCADE,
        FOREIGN KEY (profileId) REFERENCES profiles(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE reacoes (
        id TEXT PRIMARY KEY,
        postId TEXT,
        comentarioId TEXT,
        tipo TEXT,
        usuario TEXT,
        FOREIGN KEY (postId) REFERENCES posts(id) ON DELETE CASCADE,
        FOREIGN KEY (comentarioId) REFERENCES comentarios(id) ON DELETE CASCADE
      );
    ''');

    await populate(db);
    print('💾 Banco criado e seed inserido');
  }
}
