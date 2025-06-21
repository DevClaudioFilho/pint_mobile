import 'dart:async';
import '../../../data/models/aula.dart';

class AulaService {
  Future<Aula> fetchAula(String id) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula API
    return Aula(
      id: id,
      titulo: 'Introdução ao Python',
      descricao: 'Descrição da aula $id',
      professor: 'Claudio Filho',
      videoUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU',
      thumbnail: 'https://img.youtube.com/vi/BBAyRBTfsOU/0.jpg',
      avaliacao: 4.5,
    );
  }
}
