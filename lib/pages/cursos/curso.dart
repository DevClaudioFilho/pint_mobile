// curso_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/pages/Aula/aula_sync.dart';
import 'package:flutter_application/widgets/app_bar.dart';
import 'package:flutter_application/widgets/navigation_drawer.dart';

class CursoPage extends StatefulWidget {
  final Map<String, dynamic> cursoData;

  const CursoPage({Key? key, required this.cursoData}) : super(key: key);

  @override
  State<CursoPage> createState() => _CursoPageState();
}

class _CursoPageState extends State<CursoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Map<String, dynamic> curso;

  @override
  void initState() {
    super.initState();
    curso = widget.cursoData;
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

Widget buildModuleCard(Map<String, dynamic> modulo) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AulaPage(aulaData: modulo),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            modulo['image'] ?? 'assets/banner.jpg',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modulo['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                buildStarRating((modulo['nota'] as num).toDouble()),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(onMenuPressed: openDrawer),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      curso['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    curso['status'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${curso['professor']} - ${curso['notaTotal']}/5',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  buildStarRating(curso['notaTotal'].toDouble()),
                ],
              ),

              const SizedBox(height: 12),
              // Categorias
              Wrap(
                spacing: 8,
                children:
                    (curso['categorias'] as List)
                        .map(
                          (c) => Chip(
                            label: Text(c),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 12),
              // Descrição do curso
              Text(
                curso['description'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              // Botão de inscrição
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Inscrever'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Lista de módulos
              const Text(
                'Aulas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...curso['modulos']
                  .map<Widget>((modulo) => buildModuleCard(modulo))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
