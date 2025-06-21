import 'package:flutter/material.dart';
import '../widgets/comment_widget.dart';

class PostPage extends StatefulWidget {
  final String titulo;
  final String descricao;
  final String autor;
  final int estrelas;

  const PostPage({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.autor,
    required this.estrelas,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comentarios = [
    {'autor': 'Claudio', 'comentario': 'Excelente aula!'},
    {'autor': 'Afonso', 'comentario': 'Muito bom, parabéns!'},
  ];

  void _enviarComentario() {
    final texto = _commentController.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        _comentarios.insert(0, {'autor': 'Você', 'comentario': texto});
        _commentController.clear();
      });
    }
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Escreva seu comentário...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _enviarComentario,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text('Send'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.purpleAccent,
                  child: Icon(Icons.person, size: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.autor,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < widget.estrelas
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
              widget.titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.descricao),
            const SizedBox(height: 16),
            const Text(
              'Comentarios',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCommentInput(),
            const SizedBox(height: 12),
            ..._comentarios.map((c) => CommentWidget(
                  autor: c['autor']!,
                  comentario: c['comentario']!,
                )),
          ],
        ),
      ),
    );
  }
}
