import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/forum_service.dart';
import 'package:flutter_application/data/models/post.dart';

class PostPage extends StatefulWidget {
  final String postId;

  const PostPage({super.key, required this.postId});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _forumService = ForumService();
  late Future<Post> _postFuture;
  final _commentController = TextEditingController();
  final _linkController = TextEditingController();

  final List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _postFuture = _forumService.fetchPostById(widget.postId).then((p) => p ??
        Post(
          id: widget.postId,
          titulo: 'Post não encontrado',
          descricao: 'Nenhuma descrição disponível.',
          autor: 'Desconhecido',
          estrelas: 0,
          forumName: '',
        ));
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add({
          'autor': 'Você',
          'texto': _commentController.text.trim(),
          'link': _linkController.text.trim(),
        });
        _commentController.clear();
        _linkController.clear();
      });
    }
  }

  void _openLinkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final linkFieldController = TextEditingController(text: _linkController.text);
        return AlertDialog(
          title: const Text('Adicionar link/anexo'),
          content: TextField(
            controller: linkFieldController,
            decoration: const InputDecoration(hintText: 'Cole o link aqui'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _linkController.text = linkFieldController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: FutureBuilder<Post>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar post'));
          }
          final post = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  post.titulo,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/avatar.jpg'),
                    ),
                    const SizedBox(width: 8),
                    Text(post.autor,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(post.descricao),
                const SizedBox(height: 24),
                const Text(
                  'Comentários',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Digite seu comentário...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _addComment,
                    ),
                  ),
                ),
                if (_linkController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Anexo: ${_linkController.text}',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blue),
                    ),
                  ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _openLinkDialog,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Adicionar link/anexo'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ..._comments.map((comment) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundImage:
                                    AssetImage('assets/avatar.jpg'),
                              ),
                              const SizedBox(width: 8),
                              Text(comment['autor'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.flag),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Comentário denunciado')),
                                  );
                                },
                                tooltip: 'Denunciar',
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_upward),
                                onPressed: () {},
                                tooltip: 'Curtir',
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_downward),
                                onPressed: () {},
                                tooltip: 'Descurtir',
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(comment['texto']),
                          if (comment['link'] != null &&
                              comment['link'].toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: GestureDetector(
                                onTap: () {
                                  // abrir link - opcional
                                },
                                child: Text(
                                  comment['link'],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
