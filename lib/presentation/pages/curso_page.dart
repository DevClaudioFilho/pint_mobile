import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/curso_service.dart';
import 'package:flutter_application/data/models/aula.dart';
import 'package:flutter_application/data/models/curso.dart';

class CursoPage extends StatefulWidget {
  const CursoPage({super.key});

  @override
  State<CursoPage> createState() => _CursoPageState();
}

class _CursoPageState extends State<CursoPage> {
  final _cursoService = CursoService();
  late Future<Curso> _cursoFuture;
  late Future<List<Aula>> _aulasFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cursoId = ModalRoute.of(context)!.settings.arguments as String;
    _cursoFuture = _cursoService.fetchCursoById(cursoId);
    _aulasFuture = _cursoService.fetchAulasByCurso(cursoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Curso>(
        future: _cursoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar curso'));
          }
          final curso = snapshot.data!;
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
                      children: aulas.map((aula) {
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
                              errorBuilder: (context, error, stackTrace) =>
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
        },
      ),
    );
  }
}
