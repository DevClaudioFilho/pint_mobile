import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application/core/services/curso_service.dart';
import 'package:flutter_application/data/models/aula.dart';
import 'package:flutter_application/data/models/curso.dart';

class CursoPage extends StatefulWidget {
  final String cursoId;

  const CursoPage({super.key, required this.cursoId});

  @override
  State<CursoPage> createState() => _CursoPageState();
}

class _CursoPageState extends State<CursoPage> {
  final _cursoService = CursoService();
  late Future<Curso> _cursoFuture;
  late Future<List<Aula>> _aulasFuture;
  bool _inscrito = false;
  bool _inscricaoAberta = false;

  @override
  void initState() {
    super.initState();
    _cursoFuture = _cursoService.fetchCursoById(widget.cursoId);
    _aulasFuture = _cursoService.fetchAulasByCurso(widget.cursoId);
    _verificarInscricao();
  }

  Future<void> _verificarInscricao() async {
    final inscrito = await _cursoService.verificarInscricao(
      widget.cursoId,
      '1', // Exemplo: profileId fixo, substitua pelo real
    );
    final curso = await _cursoService.fetchCursoById(widget.cursoId);
    final aberta = DateTime.now().isBefore(curso.dataLimite);
    setState(() {
      _inscrito = inscrito;
      _inscricaoAberta = aberta;
    });
  }

  Future<void> _alternarInscricao() async {
    if (_inscrito) {
      await _cursoService.desinscreverDoCurso(widget.cursoId, '1');
    } else {
      await _cursoService.inscreverEmCurso(widget.cursoId, '1');
    }
    await _verificarInscricao();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _inscrito ? 'Inscrição cancelada' : 'Inscrição realizada',
        ),
      ),
    );
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
          if (!snapshot.hasData) {
            return const Center(child: Text('Curso não encontrado'));
          }

          final curso = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  curso.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Text('Claudio Filho - 4.5/5'),
                    const SizedBox(width: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        );
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
                Text(
                  'Data-limite de inscrição: ${DateFormat('dd/MM/yyyy').format(curso.dataLimite)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (_inscricaoAberta)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _alternarInscricao,
                      icon: Icon(_inscrito ? Icons.check : Icons.add),
                      label: Text(_inscrito ? 'Inscrito' : 'Inscrever-se'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _inscrito ? Colors.green : Colors.lightBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                else
                  const Text(
                    'Inscrição esgotada. Você não pode mais se inscrever neste curso.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
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
                            enabled: _inscrito,
                            onTap: _inscrito
                                ? () {
                                    Navigator.pushNamed(
                                      context,
                                      '/aula',
                                      arguments: aula.id,
                                    );
                                  }
                                : null,
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
