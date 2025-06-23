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

  // FORUNS
  await db.insert('forums', {
    'id': '1',
    'nome': 'Dúvidas Gerais',
    'imagem': 'assets/banner.jpg',
  });
  await db.insert('forums', {
    'id': '2',
    'nome': 'Sugestões',
    'imagem': 'assets/banner.jpg',
  });

  // POSTS
  await db.insert('posts', {
    'id': '101',
    'forumId': '1',
    'titulo': 'Problema com Provider',
    'descricao': 'Não consigo gerenciar estado no meu app.',
    'autor': 'João',
    'estrelas': 4.0,
  });
  await db.insert('posts', {
    'id': '102',
    'forumId': '2',
    'titulo': 'Ideia para novo recurso',
    'descricao': 'Que tal integrar com API externa?',
    'autor': 'Maria',
    'estrelas': 5.0,
  });

  // COMENTARIOS
  await db.insert('comentarios', {
    'id': '1001',
    'postId': '101',
    'profileId': '2',
    'texto': 'Já tentou usar Riverpod?',
    'link': '',
  });
  await db.insert('comentarios', {
    'id': '1002',
    'postId': '102',
    'profileId': '1',
    'texto': 'Boa ideia, podemos planejar!',
    'link': 'https://flutter.dev',
  });

  // CURSOS
  await db.insert('cursos', {
    'id': '201',
    'titulo': 'Curso Flutter',
    'categoria': 'Mobile',
    'nivel': 'Intermediário',
    'estrelas': 4.5,
    'dataLimite': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
  });
  await db.insert('cursos', {
    'id': '202',
    'titulo': 'Curso Dart',
    'categoria': 'Linguagem',
    'nivel': 'Básico',
    'estrelas': 4.0,
    'dataLimite': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
  });

  // AULAS
  await db.insert('aulas', {
    'id': '301',
    'cursoId': '201',
    'titulo': 'Primeiros passos no Flutter',
    'descricao': 'Introdução ao framework.',
    'videoUrl': 'https://www.youtube.com/watch?v=fq4N0hgOWzU',
    'professor': 'Carlos Silva',
    'avaliacao': 4.5,
    'thumbnail': 'https://img.youtube.com/vi/fq4N0hgOWzU/0.jpg',
  });
  await db.insert('aulas', {
    'id': '302',
    'cursoId': '202',
    'titulo': 'Sintaxe básica do Dart',
    'descricao': 'Visão geral da linguagem.',
    'videoUrl': 'https://www.youtube.com/watch?v=AqCMFXEmf3w',
    'professor': 'Ana Pereira',
    'avaliacao': 4.0,
    'thumbnail': 'https://img.youtube.com/vi/AqCMFXEmf3w/0.jpg',
  });

  // INSCRIÇÕES
  await db.insert('inscricoes', {
    'id': '401',
    'cursoId': '201',
    'profileId': '1',
    'dataInscricao': DateTime.now().toIso8601String(),
  });
  await db.insert('inscricoes', {
    'id': '402',
    'cursoId': '202',
    'profileId': '1',
    'dataInscricao': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
  });

  // CERTIFICACOES
  await db.insert('certificacoes', {
    'id': '501',
    'cursoId': '201',
    'titulo': 'Certificação Flutter',
    'profileId': '1',
    'progresso': 0.0,
    'dataInicio': null,
    'dataFim': null,
  });
  await db.insert('certificacoes', {
    'id': '502',
    'cursoId': '202',
    'titulo': 'Certificação Dart',
    'profileId': '1',
    'progresso': 50.0,
    'dataInicio': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
    'dataFim': null,
  });
  await db.insert('certificacoes', {
    'id': '503',
    'cursoId': '202',
    'titulo': 'Certificação Dart Finalizada',
    'profileId': '1',
    'progresso': 100.0,
    'dataInicio': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
    'dataFim': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
  });
}
