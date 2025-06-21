import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String autor;
  final String comentario;

  const CommentWidget({
    super.key,
    required this.autor,
    required this.comentario,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.purpleAccent,
            child: Icon(Icons.person, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  autor,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(comentario),
              ],
            ),
          ),
          const Icon(Icons.info_outline, size: 16),
          const SizedBox(width: 4),
          const Icon(Icons.expand_less, size: 16),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more, size: 16),
        ],
      ),
    );
  }
}
