import 'dart:async';
import '../../data/models/curso.dart';
import '../../data/models/aula.dart';

class CursoService {
  /// Simula busca de cursos com filtros
  Future<List<Curso>> fetchCursos({
    String? search,
    String? categoria,
    String? nivel,
    int? estrelas,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // simula delay da API

    final cursos = _mockCursos();

    // Aplica filtros
    return cursos.where((c) {
      final matchSearch = search == null || search.isEmpty || c.titulo.toLowerCase().contains(search.toLowerCase());
      final matchCategoria = categoria == null || categoria.isEmpty || c.categoria == categoria;
      final matchNivel = nivel == null || nivel.isEmpty || c.nivel == nivel;
      return matchSearch && matchCategoria && matchNivel;
    }).toList();
  }

  /// Simula busca de um curso específico
  Future<Curso> fetchCursoById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final curso = _mockCursos().firstWhere(
      (c) => c.id == id,
      orElse: () => Curso(id: id, titulo: 'Curso não encontrado', categoria: 'Desconhecido', nivel: 'Desconhecido', dataLimite: DateTime.now()),
    );
    return curso;
  }

  /// Simula busca de aulas de um curso
  Future<List<Aula>> fetchAulasByCurso(String cursoId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockAulas().where((a) => a.id.startsWith(cursoId)).toList().isNotEmpty
        ? _mockAulas().where((a) => a.id.startsWith(cursoId)).toList()
        : _mockAulas(); // fallback para simulação
  }

  /// Cursos mockados
List<Curso> _mockCursos() {
  return [
    Curso(
      id: '1',
      titulo: 'Flutter para Iniciantes',
      categoria: 'Mobile',
      nivel: 'Básico',
      dataLimite: DateTime(2024, 12, 31),
    ),
    Curso(
      id: '2',
      titulo: 'Dart Avançado',
      categoria: 'Linguagem',
      nivel: 'Avançado',
      dataLimite: DateTime(2026, 10, 1),
    ),
    Curso(
      id: '3',
      titulo: 'Desenvolvimento Web com Flutter',
      categoria: 'Web',
      nivel: 'Intermediário',
      dataLimite: DateTime(2024, 9, 15),
    ),
  ];
}


  /// Aulas mockadas
  List<Aula> _mockAulas() {
    return [
      Aula(
        id: '1-1',
        titulo: 'Introdução ao Flutter',
        avaliacao: 4.0,
        thumbnail: 'https://img.youtube.com/vi/BBAyRBTfsOU/0.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU',
        descricao: 'Uma introdução ao framework Flutter.',
        professor: 'Claudio Filho',
      ),
      Aula(
        id: '1-2',
        titulo: 'Widgets básicos',
        avaliacao: 4.5,
        thumbnail: 'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        descricao: 'Como usar widgets básicos no Flutter.',
        professor: 'Afonso Silva',
      ),
      Aula(
        id: '2-1',
        titulo: 'Dart Collections',
        avaliacao: 5.0,
        thumbnail: 'https://img.youtube.com/vi/5F-6n_2XWR8/0.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=5F-6n_2XWR8',
        descricao: 'Manipulação de listas e mapas no Dart.',
        professor: 'Maria Souza',
      ),
    ];
  }
}
