import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/widgets/comment_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../data/models/aula.dart';
import '../../../core/services/aula_service.dart';

class AulaPage extends StatefulWidget {
  final String aulaId;

  const AulaPage({super.key, required this.aulaId});

  @override
  State<AulaPage> createState() => _AulaPageState();
}

class _AulaPageState extends State<AulaPage> {
  final _aulaService = AulaService();
  late Future<Aula> _aulaFuture;
  YoutubePlayerController? _controller;
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comentarios = [
    {'autor': 'Claudio', 'comentario': 'Excelente aula!'},
    {'autor': 'Afonso', 'comentario': 'Muito bom, parabéns!'},
  ];

  @override
  void initState() {
    super.initState();
    _aulaFuture = _aulaService.fetchAula(widget.aulaId);
  }

  void _setupVideo(String url) {
    final videoId = YoutubePlayerController.convertUrlToId(url);
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  void _enviarComentario() {
    final texto = _commentController.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        _comentarios.insert(0, {'autor': 'Você', 'comentario': texto});
        _commentController.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller?.close();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Aula>(
        future: _aulaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar aula'));
          }

          final aula = snapshot.data!;
          if (_controller == null) {
            _setupVideo(aula.videoUrl);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(controller: _controller!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const CircleAvatar(child: Icon(Icons.person)),
                    const SizedBox(width: 8),
                    Text(
                      'Prof ${aula.professor}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  aula.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${aula.professor} - ${aula.avaliacao}/5'),
                    const SizedBox(width: 4),
                    Row(
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
                  ],
                ),
                const SizedBox(height: 4),
                Text(aula.descricao),
                const SizedBox(height: 16),
                const Text(
                  'Comentários',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Escreva seu comentário...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _enviarComentario,
                      child: const Text('Send'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._comentarios.map(
                  (c) => CommentWidget(
                    autor: c['autor']!,
                    comentario: c['comentario']!,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
