import 'package:flutter/material.dart';
import 'package:flutter_application/pages/post/main.dart';
import 'package:flutter_application/widgets/app_bar.dart';
import 'package:flutter_application/widgets/chip.dart';
import 'package:flutter_application/widgets/navigation_drawer.dart';
import 'package:flutter_application/widgets/post_card.dart';

class ForumPage extends StatefulWidget {
  final Map<String, dynamic> forumData;

  const ForumPage({Key? key, required this.forumData}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Map<String, dynamic> forum;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForumData();
  }

  Future<void> fetchForumData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      forum = {
        'title': 'Introdução ao Flutter',
        'categorias': ['Mobile', 'Dart', 'UI'],
        'description': 'Aprenda a desenvolver aplicativos móveis com Flutter.',
        'posts': [
          {
            'title': 'Widgets Básicos',
            'nota': 4.0,
            'image': 'assets/banner.jpg',
            'autor': 'TESTE',
            'description': 'Explicação sobre widgets básicos',
            'categorias': ['Dart', 'Widgets'],
            'comentarios': [
              {'autor': 'João', 'texto': 'Muito útil!'},
              {'autor': 'Maria', 'texto': 'Explicou bem.'},
            ],
          },
          {
            'title': 'Gerenciamento de Estado',
            'nota': 4.5,
            'image': 'assets/banner.jpg',
            'autor': 'TESTE',
            'description': 'Tudo sobre Provider e Bloc',
            'categorias': ['State', 'Flutter'],
            'comentarios': [
              {'autor': 'Carlos', 'texto': 'Entendi o Provider.'},
            ],
          },
        ],
      };
      isLoading = false;
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget buildStarRating(double rating) {
    int fullStars = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < fullStars ? Icons.star : Icons.star_border,
          color: Colors.blue,
          size: 16,
        ),
      ),
    );
  }

  Widget buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            post['image'] ?? 'assets/banner.jpg',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                buildStarRating((post['nota'] as num).toDouble()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(onMenuPressed: openDrawer, title: "Forum"),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Search', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter search terms',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          forum['categorias'].length,
                          (index) => CategoryChip(label: forum['categorias'][index]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Novo post'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...forum['posts'].map<Widget>((post) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PostPage(postData: post)),
                          );
                        },
                        child: PostCard(
                          autor: post['autor'],
                          title: post['title'],
                          description: post['description'],
                          nota: (post['nota'] as num).toDouble(),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
      ),
    );
  }
}
