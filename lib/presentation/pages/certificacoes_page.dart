import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/certificacao_service.dart';
import 'package:flutter_application/data/models/certificacao.dart';

class CertificacoesPage extends StatefulWidget {
  const CertificacoesPage({super.key});

  @override
  State<CertificacoesPage> createState() => _CertificacoesPageState();
}

class _CertificacoesPageState extends State<CertificacoesPage> {
  final _service = CertificacaoService();
  late Future<List<Certificacao>> _certificacoesFuture;

  @override
  void initState() {
    super.initState();
    _certificacoesFuture = _service.fetchCertificacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Certificações')),
      body: FutureBuilder<List<Certificacao>>(
        future: _certificacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar certificações'));
          }

          final certificacoes = snapshot.data!;
          final naoIniciados =
              certificacoes.where((c) => c.progresso == 0).toList();
          final emAndamento =
              certificacoes.where((c) => c.progresso > 0 && c.progresso < 100).toList();
          final finalizados =
              certificacoes.where((c) => c.progresso == 100).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection('Não iniciados', naoIniciados),
              const SizedBox(height: 16),
              _buildSection('Em andamento', emAndamento),
              const SizedBox(height: 16),
              _buildSection('Finalizados', finalizados),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Certificacao> list) {
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...list.map(_buildCard).toList(),
      ],
    );
  }

  Widget _buildCard(Certificacao c) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(c.titulo),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progresso: ${c.progresso.toStringAsFixed(1)}%'),
            if (c.dataInicio != null)
              Text('Início: ${c.dataInicio}'),
            if (c.dataFim != null)
              Text('Fim: ${c.dataFim}'),
          ],
        ),
        trailing: Icon(
          c.progresso == 100
              ? Icons.verified
              : c.progresso > 0
                  ? Icons.hourglass_bottom
                  : Icons.lock_outline,
          color: c.progresso == 100
              ? Colors.green
              : c.progresso > 0
                  ? Colors.orange
                  : Colors.grey,
        ),
        onTap: () {
          if (c.cursoId.isNotEmpty) {
            Navigator.pushNamed(
              context,
              '/cursos/id',
              arguments: c.cursoId,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Curso não vinculado')),
            );
          }
        },
      ),
    );
  }
}
