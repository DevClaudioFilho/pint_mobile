// aula_page.dart
import 'package:flutter/material.dart';

class AulaPage extends StatelessWidget {
  final Map<String, dynamic> aulaData;

  const AulaPage({Key? key, required this.aulaData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(aulaData['title'] ?? 'Aula')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              aulaData['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Nota: ${aulaData['nota']}/5'),
            const SizedBox(height: 12),
            Text('Descrição da aula aqui...'),
          ],
        ),
      ),
    );
  }
}
