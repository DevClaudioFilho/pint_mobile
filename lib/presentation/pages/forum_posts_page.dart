import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/pages/post_page.dart';
import '../../../core/services/forum_service.dart';
import '../../../data/models/forum.dart';

class ForumPostsPage extends StatefulWidget {
  final String categoria;
  const ForumPostsPage({super.key, required this.categoria});

  @override
  State<ForumPostsPage> createState() => _ForumPostsPageState();
}

class _ForumPostsPageState extends State<ForumPostsPage> {
  final ForumService _forumService = ForumService();
  late Future<List<Forum>> _postsFuture;
  List<Forum> _posts = [];
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _postsFuture = _loadPosts();
  }

  Future<List<Forum>> _loadPosts() async {
    final data = await _forumService.fetchForums();
    // Simulação: filtra pelo nome da categoria no título
    _posts =
        data
            .where(
              (p) => p.titulo.toLowerCase().contains(
                widget.categoria.toLowerCase(),
              ),
            )
            .toList();
    return _posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts em ${widget.categoria}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter search terms',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Forum>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar posts'));
                  }

                  var filtered = _posts;
                  if (_searchTerm.isNotEmpty) {
                    filtered =
                        filtered
                            .where(
                              (p) => p.titulo.toLowerCase().contains(
                                _searchTerm.toLowerCase(),
                              ),
                            )
                            .toList();
                  }

                  if (filtered.isEmpty) {
                    return const Center(child: Text('Nenhum post encontrado'));
                  }

                  return ListView(
                    children:
                        filtered.map((p) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => PostPage(
                                        titulo: p.titulo,
                                        descricao: p.descricao,
                                        autor: p.autor,
                                        estrelas: p.estrelas,
                                      ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 16,
                                          backgroundImage: AssetImage(
                                            'assets/avatar.png',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          p.autor,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              index < p.estrelas
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              size: 16,
                                              color: Colors.amber,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      p.titulo,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(p.descricao),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
