// forums_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/forums/forum.dart';
import 'package:flutter_application/widgets/app_bar.dart';
import 'package:flutter_application/widgets/forum_card.dart';
import 'package:flutter_application/widgets/navigation_drawer.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({Key? key}) : super(key: key);

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> forums = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForums();
  }

  Future<void> fetchForums() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      forums = [
        {
          "title": "PYTHON",
          "image": "assets/python_course.jpg",
          "categorias": ["Categoria", "Categoria", "Categoria"],
          "posts": [
            {
              "title": "Problemas na atualizacao do python",
              "autor": "Jose Beselga",
              "nota": 4.0,
              "description": "Lorem ipsum dolor sit amet...",
              "categorias": ["Categoria", "Categoria", "Categoria"],
              "comentarios": [
                {"autor": "Claudio", "texto": "Comentário aqui..."},
              ],
            },
          ],
        },
        {
          "title": "C#",
          "image": "assets/python_course.jpg",
          "categorias": [],
          "posts": [],
        },
        {
          "title": "DEVOPS",
          "image": "assets/python_course.jpg",
          "categorias": [],
          "posts": [],
        },
      ];
      isLoading = false;
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(onMenuPressed: openDrawer,title: "Forums"),
      extendBodyBehindAppBar: true,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Search', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter search terms',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: forums.length,
                      itemBuilder: (context, index) {
                        final forum = forums[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForumPage(forumData: forum),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ForumCard(
                              title: forum['title'],
                              imageAsset: forum['image'],
                            ),
                          ),
                          );
                          })
                    ],
                  ),
                ),
              ),
    );
  }
}

//         padding: const EdgeInsets.all(16),
//         children: forums.map((forum) {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (_) => ForumPage(forumData: forum),
//               ));
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(forum['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.asset(forum['image'], height: 140, width: double.infinity, fit: BoxFit.cover),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
