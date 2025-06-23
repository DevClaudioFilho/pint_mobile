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
  await db.insert('profiles', {
    'id': '3',
    'nome': 'Carlos Mendes',
    'email': 'carlos@exemplo.com',
    'senha': 'senha123',
    'morada': 'Rua Nova',
    'codigoPostal': '2345-678',
    'avatarUrl': 'https://via.placeholder.com/100',
  });

  // FORUNS
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
  await db.insert('forums', {
    'id': '3',
    'nome': 'Anúncios',
    'imagem': 'assets/images/forum3.png',
  });

  // POSTS
  await db.insert('posts', {
    'id': '101',
    'titulo': 'Como usar o Provider?',
    'descricao': 'Estou com dificuldade para gerenciar estado usando Provider.',
    'autor': 'João',
    'estrelas': 4.0,
    'forumId': '1',
  });
  await db.insert('posts', {
    'id': '102',
    'titulo': 'Flutter com Firebase',
    'descricao': 'Seria interessante ter um curso aprofundado de Firebase + Flutter.',
    'autor': 'Maria',
    'estrelas': 5.0,
    'forumId': '2',
  });
  await db.insert('posts', {
    'id': '103',
    'titulo': 'Nova versão do app disponível',
    'descricao': 'Lançamos uma nova versão com melhorias.',
    'autor': 'Carlos',
    'estrelas': 5.0,
    'forumId': '3',
  });

  // COMENTARIOS
  await db.insert('comentarios', {
    'id': '1001',
    'postId': '101',
    'profileId': '2',
    'texto': 'Ótima explicação!',
    'link': '',
  });
  await db.insert('comentarios', {
    'id': '1002',
    'postId': '101',
    'profileId': '3',
    'texto': 'Obrigado pela dica!',
    'link': 'https://flutter.dev',
  });
  await db.insert('comentarios', {
    'id': '1003',
    'postId': '102',
    'profileId': '1',
    'texto': 'Muito bom!',
    'link': '',
  });

  // CURSOS
  await db.insert('cursos', {
    'id': '201',
    'titulo': 'Curso de Flutter',
    'categoria': 'Mobile',
    'nivel': 'Intermediário',
    'estrelas': 4.5,
    'dataLimite': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
  });
  await db.insert('cursos', {
    'id': '202',
    'titulo': 'Curso de Dart',
    'categoria': 'Linguagem',
    'nivel': 'Básico',
    'estrelas': 4.0,
    'dataLimite': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
  });
  await db.insert('cursos', {
    'id': '203',
    'titulo': 'Curso de Firebase',
    'categoria': 'Backend',
    'nivel': 'Avançado',
    'estrelas': 4.8,
    'dataLimite': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
  });

  // AULAS
  await db.insert('aulas', {
    'id': '301',
    'cursoId': '201',
    'titulo': 'Introdução ao Flutter',
    'descricao': 'Aula inicial sobre o Flutter.',
    'videoUrl': 'https://www.youtube.com/watch?v=fq4N0hgOWzU',
    'professor': 'Carlos Silva',
    'avaliacao': 4.5,
    'thumbnail': 'https://img.youtube.com/vi/fq4N0hgOWzU/0.jpg',
  });
  await db.insert('aulas', {
    'id': '302',
    'cursoId': '202',
    'titulo': 'Sintaxe do Dart',
    'descricao': 'Aula sobre a sintaxe básica do Dart.',
    'videoUrl': 'https://www.youtube.com/watch?v=AqCMFXEmf3w',
    'professor': 'Ana Pereira',
    'avaliacao': 4.0,
    'thumbnail': 'https://img.youtube.com/vi/AqCMFXEmf3w/0.jpg',
  });
  await db.insert('aulas', {
    'id': '303',
    'cursoId': '203',
    'titulo': 'Configuração do Firebase',
    'descricao': 'Primeiros passos com Firebase.',
    'videoUrl': 'https://www.youtube.com/watch?v=9kRgVxULbag',
    'professor': 'Bruno Lima',
    'avaliacao': 4.8,
    'thumbnail': 'https://img.youtube.com/vi/9kRgVxULbag/0.jpg',
  });

  // CERTIFICACOES
  await db.insert('certificacoes', {
    'id': '401',
    'titulo': 'Certificação Flutter',
    'progresso': 0.0,
    'dataInicio': null,
    'dataFim': null,
  });
  await db.insert('certificacoes', {
    'id': '402',
    'titulo': 'Certificação Dart',
    'progresso': 50.0,
    'dataInicio': '2024-06-01',
    'dataFim': null,
  });
  await db.insert('certificacoes', {
    'id': '403',
    'titulo': 'Certificação Firebase',
    'progresso': 100.0,
    'dataInicio': '2024-05-01',
    'dataFim': '2024-06-01',
  });
}
