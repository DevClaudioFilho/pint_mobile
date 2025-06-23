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
  late Future<List<Map<String, dynamic>>> _commentsFuture;
  final _commentController = TextEditingController();
  final _linkController = TextEditingController();
  final Set<String> _comentariosDenunciados = {};
  final Set<String> _comentariosCurtidos = {};

  @override
  void initState() {
    super.initState();
    _postFuture = _forumService
        .fetchPostById(widget.postId)
        .then(
          (p) =>
              p ??
              Post(
                id: widget.postId,
                titulo: 'Post não encontrado',
                descricao: 'Nenhuma descrição disponível.',
                autor: 'Desconhecido',
                estrelas: 0,
                forumId: '',
              ),
        );

    _refreshComments();
    _carregarReacoes();
  }

  void _refreshComments() {
    setState(() {
      _commentsFuture = _forumService.fetchComentarios(widget.postId);
    });
  }

  Future<void> _addComment() async {
    final texto = _commentController.text.trim();
    final link = _linkController.text.trim();
    if (texto.isNotEmpty) {
      await _forumService.addComentario(
        widget.postId,
        '1', // 🔑 Exemplo: ID do usuário logado (pode ajustar)
        texto,
        link,
      );
      _commentController.clear();
      _linkController.clear();
      _refreshComments();
    }
  }

  void _openLinkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final linkFieldController = TextEditingController(
          text: _linkController.text,
        );
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

  Future<void> _carregarReacoes() async {
    final denuncias = await _forumService.buscarReacoes(
      widget.postId,
      'denuncia',
      '1',
    );
    final curtidas = await _forumService.buscarReacoes(
      widget.postId,
      'curtir',
      '1',
    );
    setState(() {
      _comentariosDenunciados.addAll(denuncias);
      _comentariosCurtidos.addAll(curtidas);
    });
  }

  Future<void> _registrarReacao(String tipo, String comentarioId) async {
    bool isRemover = false;
    if (tipo == 'denuncia') {
      if (_comentariosDenunciados.contains(comentarioId)) {
        _comentariosDenunciados.remove(comentarioId);
        isRemover = true;
      } else {
        _comentariosDenunciados.add(comentarioId);
      }
    } else if (tipo == 'curtir') {
      if (_comentariosCurtidos.contains(comentarioId)) {
        _comentariosCurtidos.remove(comentarioId);
        isRemover = true;
      } else {
        _comentariosCurtidos.add(comentarioId);
      }
    }

    if (isRemover) {
      await _forumService.removerReacao(widget.postId, tipo, '1');
    } else {
      await _forumService.registrarReacao(
        widget.postId,
        comentarioId,
        tipo,
        '1',
      );
    }
    _carregarReacoes();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isRemover
              ? (tipo == 'denuncia' ? 'Denúncia removida' : 'Curtida removida')
              : (tipo == 'denuncia'
                  ? 'Comentário denunciado'
                  : 'Comentário curtido'),
        ),
      ),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/avatar.jpg'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.autor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(post.descricao),
                const SizedBox(height: 24),
                const Text(
                  'Comentários',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        color: Colors.blue,
                      ),
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
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _commentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar comentários'),
                      );
                    }
                    final comments = snapshot.data!;
                    return Column(
                      children:
                          comments.map((comment) {
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
                                          backgroundImage: AssetImage(
                                            'assets/avatar.jpg',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          comment['autor'] ?? 'Desconhecido',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            Icons.flag,
                                            color:
                                                _comentariosDenunciados
                                                        .contains(comment['id'])
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                          onPressed:
                                              () => _registrarReacao(
                                                'denuncia',
                                                comment['id'],
                                              ),
                                          tooltip: 'Denunciar',
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_upward,
                                            color:
                                                _comentariosCurtidos.contains(
                                                      comment['id'],
                                                    )
                                                    ? Colors.green
                                                    : Colors.grey,
                                          ),
                                          onPressed:
                                              () => _registrarReacao(
                                                'curtir',
                                                comment['id'],
                                              ),
                                          tooltip: 'Curtir',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(comment['texto']),
                                    if (comment['link'] != null &&
                                        comment['link'].toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            comment['link'],
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
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
