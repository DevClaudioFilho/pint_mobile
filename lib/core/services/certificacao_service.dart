import 'package:flutter_application/data/models/certificacao.dart';

class CertificacaoService {
  Future<List<Certificacao>> fetchCertificacoes() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay de API
    return [
      Certificacao(
        id: '1',
        titulo: 'Curso Flutter',
        progresso: 0.0,
      ),
      Certificacao(
        id: '2',
        titulo: 'Curso Avançado Dart',
        progresso: 50.0,
        dataInicio: DateTime(2025, 6, 25),
      ),
      Certificacao(
        id: '3',
        titulo: 'Curso Design Patterns',
        progresso: 100.0,
        dataInicio: DateTime(2025, 6, 20),
        dataFim: DateTime(2025, 6, 22),
      ),
    ];
  }
}
