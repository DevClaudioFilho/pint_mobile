import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String autor;
  final String title;
  final String description;
  final double nota;
  final String? avatar;

  const PostCard({
    super.key,
    required this.autor,
    required this.title,
    required this.description,
    required this.nota,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: Avatar + Autor + Estrelas
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: avatar != null
                    ? AssetImage(avatar!)
                    : const AssetImage('assets/avatar.jpg'),
              ),
              const SizedBox(width: 8),
              Text(
                autor,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < nota ? Icons.star : Icons.star_border,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Título do post
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          // Descrição
          Text(
            description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
