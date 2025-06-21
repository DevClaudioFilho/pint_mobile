import '../../data/models/forum.dart';

class ForumCategory {
  final String nome;
  final String imagem;

  ForumCategory({
    required this.nome,
    required this.imagem,
  });
}

class ForumService {
  /// Simula rota da API que devolve lista de fóruns
  Future<List<Forum>> fetchForums() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay da API
    return [
      Forum(
        id: '1',
        autor: 'Jose Beselga',
        titulo: 'Problemas na atualizacao do python',
        descricao:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque suscipit ipsum quis eros congue, quis consectetur sem suscipit.',
        estrelas: 3,
      ),
      Forum(
        id: '2',
        autor: 'Claudio Pinho',
        titulo: 'Versao 24.04 do ubuntu erros',
        descricao:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque suscipit ipsum quis eros congue, quis consectetur sem suscipit.',
        estrelas: 3,
      ),
      Forum(
        id: '3',
        autor: 'Afonso Rodrigues',
        titulo: 'Como se faz um ciclo em C',
        descricao:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque suscipit ipsum quis eros congue, quis consectetur sem suscipit.',
        estrelas: 1,
      ),
    ];
  }

  /// Simula criação de fórum
  Future<Forum> createForum(String titulo, String descricao, String autor) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula chamada à API
    return Forum(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      descricao: descricao,
      autor: autor,
      estrelas: 0,
    );
  }

  /// Simula rota de API que devolve categorias dos fóruns
  Future<List<ForumCategory>> fetchCategories() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay da API
    return [
      ForumCategory(
        nome: 'PYTHON',
        imagem: 'assets/python.png',
      ),
      ForumCategory(
        nome: 'C#',
        imagem: 'assets/csharp.png',
      ),
      ForumCategory(
        nome: 'DEVOPS',
        imagem: 'assets/devops.png',
      ),
    ];
  }
}
