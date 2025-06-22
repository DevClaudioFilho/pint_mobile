import '../../data/models/post.dart';
import '../../data/models/forum.dart';

class ForumService {
  /// Simula busca dos fóruns (categorias)
  Future<List<Forum>> fetchForums() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Forum(nome: 'PYTHON', imagem: 'assets/python.png'),
      Forum(nome: 'C#', imagem: 'assets/csharp.png'),
      Forum(nome: 'DEVOPS', imagem: 'assets/devops.png'),
    ];
  }

  /// Simula busca de posts de um fórum específico
  Future<List<Post>> fetchPostsForForum(String forumName) async {
    await Future.delayed(const Duration(seconds: 1));

    final allPosts = _mockPosts();

    // Simula filtro pelo nome do fórum
    return allPosts.where((p) => p.forumName == forumName).toList();
  }

  /// Simula criação de post
  Future<Post> createPost(String titulo, String descricao, String autor, String forumName) async {
    await Future.delayed(const Duration(seconds: 1));
    return Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      descricao: descricao,
      autor: autor,
      estrelas: 0,
      forumName: forumName,
    );
  }

  Future<Post?> fetchPostById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final posts = _mockPosts();
    return posts.firstWhere(
      (p) => p.id == id,
    );
  }


  /// Mock de posts com associação ao fórum
  List<Post> _mockPosts() {
    return [
      Post(
        id: '1',
        titulo: 'Problemas na atualizacao do python',
        descricao: 'Descrição do post sobre python.',
        autor: 'Jose Beselga',
        estrelas: 3,
        forumName: 'PYTHON',
      ),
      Post(
        id: '2',
        titulo: 'Como se faz um ciclo em C',
        descricao: 'Descrição sobre ciclos em C.',
        autor: 'Afonso Rodrigues',
        estrelas: 2,
        forumName: 'C#',
      ),
      Post(
        id: '3',
        titulo: 'Versao 24.04 do ubuntu erros',
        descricao: 'Descrição sobre erros no Ubuntu.',
        autor: 'Claudio Pinho',
        estrelas: 4,
        forumName: 'DEVOPS',
      ),
    ];
  }
}
