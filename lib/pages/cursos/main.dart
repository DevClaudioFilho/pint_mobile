// cursos_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/app_bar.dart';
import 'package:flutter_application/widgets/chip.dart';
import 'package:flutter_application/widgets/course_card.dart';
import 'package:flutter_application/widgets/navigation_drawer.dart';
import './curso.dart';

class CursosPage extends StatefulWidget {
  const CursosPage({Key? key}) : super(key: key);

  @override
  State<CursosPage> createState() => _CursosPageState();
}

class _CursosPageState extends State<CursosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> cursos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCursos();
  }

  Future<void> fetchCursos() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      cursos = [
        {
          'title': 'Python initialization',
          'status': '4/20 P',
          'nota': 3,
          'esgotado': false,
          'professor': 'Claudio Filho',
          'notaTotal': 4.5,
          'categorias': ['Categoria', 'Categoria'],
          'description': 'Descrição do curso.',
          'modulos': [
            {
              'title': 'Python initialization',
              'notaTotal': 4.5,
              'nota': 3,
            }
          ]
        },
        // outros cursos...
      ];
      isLoading = false;
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget categoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(label: Text(label), backgroundColor: Colors.grey.shade200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(onMenuPressed: openDrawer,title: "Curso"),
      extendBodyBehindAppBar: true,
      body: isLoading
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
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          6,
                          (index) => CategoryChip(label:'Categoria'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cursos.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CursoPage(cursoData: cursos[index]),
                            ),
                          );
                        },
                        child: CourseCard(
                          title: cursos[index]['title'],
                          status: cursos[index]['status'],
                          nota: cursos[index]['nota'],
                          esgotado: cursos[index]['esgotado'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 