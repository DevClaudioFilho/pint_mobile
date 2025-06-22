import 'package:sqflite/sqflite.dart';

Future<void> populate(Database db) async {
  // PERFIS
  await db.insert('profiles', {
    'id': '1',
    'nome': 'João Silva',
    'email': 'joao@exemplo.com',
    'senha': '123456',
    'morada': 'Rua das Flores',
    'codigoPostal': '1234-567',
    'avatarUrl': 'https://via.placeholder.com/100',
  });
  await db.insert('profiles', {
    'id': '2',
    'nome': 'Maria Souza',
    'email': 'maria@exemplo.com',
    'senha': 'abcdef',
    'morada': 'Avenida Central',
    'codigoPostal': '7654-321',
    'avatarUrl': 'https://via.placeholder.com/100',
  });

  // CURSOS
  await db.insert('cursos', {
    'id': '1',
    'titulo': 'Curso de Flutter',
    'categoria': 'Mobile',
    'nivel': 'Intermediário',
    'estrelas': 4.5,
    'dataLimite': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
  });
  await db.insert('cursos', {
    'id': '2',
    'titulo': 'Curso de Dart',
    'categoria': 'Linguagem',
    'nivel': 'Básico',
    'estrelas': 4.0,
    'dataLimite': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
  });

  // AULAS
  await db.insert('aulas', {
    'id': '1',
    'cursoId': '1',
    'titulo': 'Introdução ao Flutter',
    'descricao': 'Aula inicial sobre o Flutter.',
    'videoUrl': 'https://www.youtube.com/watch?v=fq4N0hgOWzU',
    'professor': 'Carlos Silva',
    'avaliacao': 4.5,
    'thumbnail': 'https://img.youtube.com/vi/fq4N0hgOWzU/0.jpg',
  });
  await db.insert('aulas', {
    'id': '2',
    'cursoId': '2',
    'titulo': 'Sintaxe do Dart',
    'descricao': 'Aula sobre a sintaxe básica do Dart.',
    'videoUrl': 'https://www.youtube.com/watch?v=AqCMFXEmf3w',
    'professor': 'Ana Pereira',
    'avaliacao': 4.0,
    'thumbnail': 'https://img.youtube.com/vi/AqCMFXEmf3w/0.jpg',
  });

  // CERTIFICAÇÕES
  await db.insert('certificacoes', {
    'id': '1',
    'titulo': 'Certificação Flutter',
    'progresso': 0.0,
    'dataInicio': null,
    'dataFim': null,
  });
  await db.insert('certificacoes', {
    'id': '2',
    'titulo': 'Certificação Dart',
    'progresso': 50.0,
    'dataInicio': '2024-06-01',
    'dataFim': null,
  });
  await db.insert('certificacoes', {
    'id': '3',
    'titulo': 'Certificação Firebase',
    'progresso': 100.0,
    'dataInicio': '2024-05-01',
    'dataFim': '2024-06-01',
  });

  // FÓRUNS
  await db.insert('forums', {
    'id': '1',
    'nome': 'Dúvidas Gerais',
    'imagem': 'assets/images/forum1.png',
  });
  await db.insert('forums', {
    'id': '2',
    'nome': 'Sugestões',
    'imagem': 'assets/images/forum2.png',
  });

  // POSTS
  await db.insert('posts', {
    'id': '1',
    'titulo': 'Como usar o Provider?',
    'descricao': 'Estou com dificuldade para gerenciar estado usando Provider.',
    'autor': 'João',
    'estrelas': 4.0,
    'forumName': 'Dúvidas Gerais',
  });
  await db.insert('posts', {
    'id': '2',
    'titulo': 'Flutter com Firebase',
    'descricao': 'Seria interessante ter um curso aprofundado de Firebase + Flutter.',
    'autor': 'Maria',
    'estrelas': 5.0,
    'forumName': 'Sugestões',
  });
}
