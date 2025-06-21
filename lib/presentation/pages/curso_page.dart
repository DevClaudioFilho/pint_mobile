import 'package:flutter/material.dart';
import '../../../core/services/curso_service.dart';
import '../../../data/models/curso.dart';
import '../../../data/models/aula.dart';

class CursoPage extends StatefulWidget {
  const CursoPage({super.key});

  @override
  State<CursoPage> createState() => _CursoPageState();
}

class _CursoPageState extends State<CursoPage> {
  final _cursoService = CursoService();
  late Future<List<Aula>> _aulasFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final curso = ModalRoute.of(context)!.settings.arguments as Curso;
    _aulasFuture = _fetchAulasMock(curso.id);
  }

  Future<List<Aula>> _fetchAulasMock(String cursoId) async {
    await Future.delayed(const Duration(seconds: 1)); // simula delay de API

    return [
      Aula(
        id: '1',
        titulo:
            'Design Leadership: How Top Design Leaders Build and Grow Successful...',
        avaliacao: 4.0,
        thumbnail: 'https://img.youtube.com/vi/BBAyRBTfsOU/0.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=BBAyRBTfsOU',
        descricao: 'Introdução ao design leadership',
        professor: 'Claudio Filho',
      ),
      Aula(
        id: '2',
        titulo:
            'Design Leadership: How Top Design Leaders Build and Grow Successful...',
        avaliacao: 5.0,
        thumbnail: 'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        descricao: 'Avançando no design leadership',
        professor: 'Afonso Silva',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final curso = ModalRoute.of(context)!.settings.arguments as Curso;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            curso.titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Text('Claudio Filho - 4.5/5'),
              const SizedBox(width: 4),
              Row(
                children: List.generate(5, (index) {
                  return const Icon(Icons.star, size: 16, color: Colors.amber);
                }),
              ),
              const Spacer(),
              const Text('0/20 P'),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(curso.categoria)),
              Chip(label: Text(curso.nivel)),
              const Chip(label: Text('Categoria')),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Pellentesque suscipit ipsum quis eros congue, quis consectetur sem suscipit.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Simular inscrição
              },
              icon: const Icon(Icons.add),
              label: const Text('Inscrever'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aulas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Aula>>(
            future: _aulasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar aulas'));
              }
              final aulas = snapshot.data!;
              if (aulas.isEmpty) {
                return const Center(child: Text('Nenhuma aula encontrada'));
              }
              return Column(
                children:
                    aulas.map((aula) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            aula.thumbnail,
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                          ),
                          title: Text(
                            aula.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < aula.avaliacao.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              );
                            }),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/aula',
                              arguments: aula.id,
                            );
                          },
                        ),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
