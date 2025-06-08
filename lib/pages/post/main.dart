import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/app_bar.dart';
import 'package:flutter_application/widgets/navigation_drawer.dart';

class PostPage extends StatefulWidget {
  final Map<String, dynamic> postData;

  const PostPage({Key? key, required this.postData}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLoading = true;
  late Map<String, dynamic> postData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<void> fetchPost() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      postData = widget.postData;
      // Se campos faltarem, adicione default:
      postData['categorias'] = postData['categorias'] ?? <String>[];
      postData['comentarios'] = postData['comentarios'] ?? <Map<String, dynamic>>[];
      isLoading = false;
    });
  }

  void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Denunciar comentário", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Você tem certeza que quer denunciar esse comentário?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Comentário denunciado")));
            },
            icon: const Icon(Icons.check),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            label: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  Widget buildComment(Map<String, dynamic> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(backgroundImage: AssetImage('assets/avatar.jpg'), radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment['autor'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(onPressed: () => showReportDialog(context), icon: const Icon(Icons.report_gmailerrorred)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_upward)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_downward)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment['texto'], style: const TextStyle(fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStarRating(double rating) {
    int fullStars = rating.floor();
    return Row(children: List.generate(5, (i) => Icon(i < fullStars ? Icons.star : Icons.star_border, color: Colors.blue, size: 16)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(onMenuPressed: openDrawer, title: "Post"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(postData['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(children: [
                  const CircleAvatar(child: Icon(Icons.person, size: 16)),
                  const SizedBox(width: 8),
                  Text("${postData['autor'] ?? ''} - ${(postData['nota'] as num).toDouble()}/5"),
                  const Spacer(),
                  buildStarRating((postData['nota'] as num).toDouble()),
                ]),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: (postData['categorias'] as List).map((c) => Chip(label: Text(c))).toList()),
                const SizedBox(height: 16),
                Text(postData['description'] ?? ''),
                const SizedBox(height: 24),
                const Text('Comentários', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Digite seu comentário...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                  ),
                ),
                const SizedBox(height: 24),
                ...(postData['comentarios'] as List).map<Widget>((c) => buildComment(c)).toList(),
              ]),
            ),
    );
  }
}
