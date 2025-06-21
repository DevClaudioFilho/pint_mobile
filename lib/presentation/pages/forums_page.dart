import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/pages/forum_posts_page.dart';
import '../../../core/services/forum_service.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({super.key});

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> {
  final ForumService _forumService = ForumService();
  late Future<List<ForumCategory>> _categoriesFuture;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _forumService.fetchCategories();
  }

  void _abrirCategoria(String nome) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ForumPostsPage(categoria: nome)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
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
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<ForumCategory>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar categorias'));
              }

              var categories = snapshot.data!;
              if (_searchTerm.isNotEmpty) {
                categories =
                    categories
                        .where(
                          (c) => c.nome.toLowerCase().contains(
                            _searchTerm.toLowerCase(),
                          ),
                        )
                        .toList();
              }

              if (categories.isEmpty) {
                return const Center(
                  child: Text('Nenhuma categoria encontrada'),
                );
              }

              return Column(
                children:
                    categories.map((c) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => _abrirCategoria(c.nome),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.asset(c.imagem, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
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
