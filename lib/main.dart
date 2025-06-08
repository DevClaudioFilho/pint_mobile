import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/course_card.dart';
import 'widgets/app_bar.dart';
import 'widgets/navigation_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> cursos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCursos();
  }

  Future<void> fetchCursos() async {
    await Future.delayed(Duration(seconds: 2)); // simula delay de API
    setState(() {
      cursos = [
        {
          'title': 'Python initialization',
          'status': '4/20 P',
          'nota': 3,
          'esgotado': false,
        },
        {
          'title': 'Python initialization',
          'status': 'FULL',
          'nota': 4,
          'esgotado': true,
        },
        {
          'title': 'Iniciação ao C',
          'status': '19/20 P',
          'nota': 5,
          'esgotado': false,
        },
        {
          'title': 'Python initialization',
          'status': '10/20 P',
          'nota': 4,
          'esgotado': false,
        },
        {
          'title': 'Python initialization',
          'status': '0/20 P',
          'nota': 2,
          'esgotado': false,
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
      appBar: CustomAppBar(onMenuPressed: openDrawer,title:"Curso"),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/banner.jpg',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'SOFTINSA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Qual é seu próximo curso?',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              sectionTitle('Categoria em alta'),
              courseList(),
              seeMoreButton(),
              sectionTitle('Próximos cursos síncronos'),
              courseList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget seeMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('veja mais', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  Widget courseList() {
    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cursos.length,
        itemBuilder:
            (context, index) => CourseCard(
              title: cursos[index]['title'],
              status: cursos[index]['status'],
              nota: cursos[index]['nota'],
              esgotado: cursos[index]['esgotado'],
            ),
      ),
    );
  }
}
