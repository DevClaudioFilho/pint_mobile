import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/aula_service.dart';
import 'package:flutter_application/data/models/aula.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AulaPage extends StatefulWidget {
  final String aulaId;

  const AulaPage({super.key, required this.aulaId});

  @override
  State<AulaPage> createState() => _AulaPageState();
}

class _AulaPageState extends State<AulaPage> {
  final _aulaService = AulaService();
  late Future<Aula> _aulaFuture;
  late Future<List<Map<String, dynamic>>> _comentariosFuture;
  YoutubePlayerController? _controller;

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final Set<String> _curtidos = {};
  final Set<String> _denunciados = {};

  @override
  void initState() {
    super.initState();
    _aulaFuture = _aulaService.fetchAula(widget.aulaId);
    _comentariosFuture = _aulaService.fetchComentarios(widget.aulaId);
    _carregarReacoes();
  }

  void _setupVideo(String url) {
    final videoId = YoutubePlayerController.convertUrlToId(url);
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  Future<void> _carregarReacoes() async {
    final curtidas = await _aulaService.buscarReacoes(
      widget.aulaId,
      'curtir',
      '1',
    );
    final denuncias = await _aulaService.buscarReacoes(
      widget.aulaId,
      'denuncia',
      '1',
    );
    setState(() {
      _curtidos.addAll(curtidas);
      _denunciados.addAll(denuncias);
    });
  }

  Future<void> _enviarComentario() async {
    final texto = _commentController.text.trim();
    final link = _linkController.text.trim();
    if (texto.isNotEmpty) {
      await _aulaService.addComentario(widget.aulaId, '1', texto, link);
      _commentController.clear();
      _linkController.clear();
      setState(() {
        _comentariosFuture = _aulaService.fetchComentarios(widget.aulaId);
      });
    }
  }

  Future<void> _registrarReacao(String tipo, String comentarioId) async {
    bool remover = false;
    if (tipo == 'curtir') {
      if (_curtidos.contains(comentarioId)) {
        await _aulaService.removerReacao(
          widget.aulaId,
          comentarioId,
          tipo,
          '1',
        );
        _curtidos.remove(comentarioId);
        remover = true;
      } else {
        await _aulaService.registrarReacao(
          widget.aulaId,
          comentarioId,
          tipo,
          '1',
        );
        _curtidos.add(comentarioId);
      }
    } else if (tipo == 'denuncia') {
      if (_denunciados.contains(comentarioId)) {
        await _aulaService.removerReacao(
          widget.aulaId,
          comentarioId,
          tipo,
          '1',
        );
        _denunciados.remove(comentarioId);
        remover = true;
      } else {
        await _aulaService.registrarReacao(
          widget.aulaId,
          comentarioId,
          tipo,
          '1',
        );
        _denunciados.add(comentarioId);
      }
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          remover
              ? (tipo == 'curtir' ? 'Curtida removida' : 'Denúncia removida')
              : (tipo == 'curtir'
                  ? 'Comentário curtido'
                  : 'Comentário denunciado'),
        ),
      ),
    );
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

  @override
  void dispose() {
    _controller?.close();
    _commentController.dispose();
    _linkController.dispose();
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
          if (snapshot.hasError || !snapshot.hasData) {
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
                Text(aula.descricao),
                const SizedBox(height: 16),
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
                      onPressed: _enviarComentario,
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
                const SizedBox(height: 12),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _comentariosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Text('Erro ao carregar comentários');
                    }
                    final comentarios = snapshot.data!;
                    return Column(
                      children:
                          comentarios.map((c) {
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
                                          c['autor'] ?? 'Desconhecido',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            Icons.flag,
                                            color:
                                                _denunciados.contains(c['id'])
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                          onPressed:
                                              () => _registrarReacao(
                                                'denuncia',
                                                c['id'],
                                              ),
                                          tooltip: 'Denunciar',
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_upward,
                                            color:
                                                _curtidos.contains(c['id'])
                                                    ? Colors.green
                                                    : Colors.grey,
                                          ),
                                          onPressed:
                                              () => _registrarReacao(
                                                'curtir',
                                                c['id'],
                                              ),
                                          tooltip: 'Curtir',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(c['texto'] ?? ''),
                                    if (c['link'] != null &&
                                        c['link'].toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Você pode implementar abrir link com url_launcher
                                          },
                                          child: Text(
                                            c['link'],
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
