import 'dart:async';
import '../../data/models/curso.dart';

class CursoService {
  Future<List<Curso>> fetchCursos({String? search, String? categoria, String? nivel, int? estrelas}) async {
    await Future.delayed(const Duration(seconds: 1)); // simula delay da API

    List<Curso> cursos = [
      Curso(id: '1', titulo: 'Flutter para Iniciantes', categoria: 'Mobile', nivel: 'Básico'),
      Curso(id: '2', titulo: 'Dart Avançado', categoria: 'Linguagem', nivel: 'Avançado'),
      Curso(id: '3', titulo: 'Desenvolvimento Web com Flutter', categoria: 'Web', nivel: 'Intermediário'),
    ];

    // Simula filtros
    if (search != null && search.isNotEmpty) {
      cursos = cursos.where((c) => c.titulo.toLowerCase().contains(search.toLowerCase())).toList();
    }
    if (categoria != null && categoria.isNotEmpty) {
      cursos = cursos.where((c) => c.categoria == categoria).toList();
    }
    if (nivel != null && nivel.isNotEmpty) {
      cursos = cursos.where((c) => c.nivel == nivel).toList();
    }

    return cursos;
  }
}
