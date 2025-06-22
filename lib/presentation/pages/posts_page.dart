import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/forum_service.dart';
import 'package:flutter_application/data/models/post.dart';

class PostsPage extends StatefulWidget {
  final String forumName;

  const PostsPage({super.key, required this.forumName});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _forumService = ForumService();
  late Future<List<Post>> _postsFuture;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _postsFuture = _forumService.fetchPostsForForum(widget.forumName);
  }

  void _openCreatePostDialog() async {
    final result = await showDialog<Post>(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final descriptionController = TextEditingController();
        final authorController = TextEditingController();

        return AlertDialog(
          title: const Text('Criar novo post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Autor'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    authorController.text.isNotEmpty) {
                  final newPost = await _forumService.createPost(
                    titleController.text,
                    descriptionController.text,
                    authorController.text,
                    widget.forumName,
                  );
                  Navigator.of(context).pop(newPost);
                }
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _postsFuture = _forumService.fetchPostsForForum(widget.forumName);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post criado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts - ${widget.forumName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openCreatePostDialog,
            tooltip: 'Criar novo post',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar posts',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar posts'));
                  }
                  var posts = snapshot.data!;
                  if (_searchTerm.isNotEmpty) {
                    posts = posts.where((p) =>
                      p.titulo.toLowerCase().contains(_searchTerm.toLowerCase()) ||
                      p.descricao.toLowerCase().contains(_searchTerm.toLowerCase())
                    ).toList();
                  }

                  if (posts.isEmpty) {
                    return const Center(child: Text('Nenhum post encontrado'));
                  }

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/post',
                              arguments: post.id,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 12,
                                      backgroundImage: AssetImage('assets/avatar.jpg'),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(post.autor,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(5, (i) {
                                        return Icon(
                                          i < post.estrelas
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
                                  post.titulo,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  post.descricao,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
