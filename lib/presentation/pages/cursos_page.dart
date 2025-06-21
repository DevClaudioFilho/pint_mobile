import 'package:flutter/material.dart';
import '../../../core/services/curso_service.dart';
import '../../../data/models/curso.dart';

class CursosPage extends StatefulWidget {
  const CursosPage({super.key});

  @override
  State<CursosPage> createState() => _CursosPageState();
}

class _CursosPageState extends State<CursosPage> {
  final _searchController = TextEditingController();
  final _cursoService = CursoService();
  late Future<List<Curso>> _cursosFuture;

  // Filtros
  String? _categoriaFiltro;
  String? _tipoFiltro;
  int? _estrelasFiltro;

  @override
  void initState() {
    super.initState();
    _cursosFuture = _cursoService.fetchCursos();
  }

  void _pesquisar() {
    setState(() {
      _cursosFuture = _cursoService.fetchCursos(
        search: _searchController.text,
        categoria: _categoriaFiltro,
        nivel: _tipoFiltro,
        estrelas: _estrelasFiltro,
      );
    });
  }

  void _abrirDialogFiltro() {
    String? categoriaTemp = _categoriaFiltro;
    String? tipoTemp = _tipoFiltro;
    int? estrelasTemp = _estrelasFiltro;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Selecione os filtros'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: categoriaTemp ?? '',
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: const [
                  DropdownMenuItem(value: '', child: Text('Nenhum')),
                  DropdownMenuItem(value: 'Mobile', child: Text('Mobile')),
                  DropdownMenuItem(value: 'Web', child: Text('Web')),
                  DropdownMenuItem(
                    value: 'Linguagem',
                    child: Text('Linguagem'),
                  ),
                ],
                onChanged: (v) {
                  categoriaTemp = (v != null && v.isEmpty) ? null : v;
                },
              ),
              DropdownButtonFormField<String>(
                value: tipoTemp ?? '',
                decoration: const InputDecoration(labelText: 'Tipo de curso'),
                items: const [
                  DropdownMenuItem(value: '', child: Text('Nenhum')),
                  DropdownMenuItem(value: 'Básico', child: Text('Básico')),
                  DropdownMenuItem(
                    value: 'Intermediário',
                    child: Text('Intermediário'),
                  ),
                  DropdownMenuItem(value: 'Avançado', child: Text('Avançado')),
                ],
                onChanged: (v) {
                  tipoTemp = (v != null && v.isEmpty) ? null : v;
                },
              ),
              DropdownButtonFormField<String>(
                value: estrelasTemp?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Estrelas'),
                items: [
                  const DropdownMenuItem(value: '', child: Text('Nenhum')),
                  ...List.generate(5, (i) {
                    return DropdownMenuItem(
                      value: (i + 1).toString(),
                      child: Text('${i + 1} estrelas'),
                    );
                  }),
                ],
                onChanged: (v) {
                  estrelasTemp =
                      (v != null && v.isEmpty) ? null : int.tryParse(v ?? '');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _categoriaFiltro = categoriaTemp;
                  _tipoFiltro = tipoTemp;
                  _estrelasFiltro = estrelasTemp;
                  _pesquisar();
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
              label: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCursoCard(Curso curso) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/cursos/id', arguments: curso);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.6,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  'https://images.pexels.com/photos/326875/pexels-photo-326875.jpeg?cs=srgb&dl=adorable-animal-blur-326875.jpg&fm=jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                curso.titulo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text(
                '20 JAN - 8 MARCH',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      size: 12,
                      color: Colors.amber,
                    );
                  }),
                  const Spacer(),
                  Text(
                    '${curso.id}/20 P',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter search terms',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _pesquisar,
                    ),
                  ),
                  onSubmitted: (_) => _pesquisar(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _abrirDialogFiltro,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Curso>>(
              future: _cursosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar cursos'));
                }
                final cursos = snapshot.data!;
                if (cursos.isEmpty) {
                  return const Center(child: Text('Nenhum curso encontrado'));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: cursos.length,
                  itemBuilder: (context, index) {
                    return _buildCursoCard(cursos[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
