import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application/data/models/profile.dart';
import 'package:flutter_application/core/services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _service = ProfileService();
  late Future<Profile> _profileFuture;
  File? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    _profileFuture = _service.fetchProfile();
  }

  Future<void> _escolherImagem(Profile profile) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagemSelecionada = File(picked.path);
      });
      await _service.updateAvatar(profile.id, picked.path);
      setState(() {
        _profileFuture = _service.fetchProfile();
      });
    }
  }

  void _showEditDialog(Profile profile) {
    final nomeController = TextEditingController(text: profile.nome);
    final emailController = TextEditingController(text: profile.email);
    final moradaController = TextEditingController(text: profile.morada);
    final codigoPostalController = TextEditingController(text: profile.codigoPostal);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar perfil'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: moradaController,
                decoration: const InputDecoration(labelText: 'Morada'),
              ),
              TextField(
                controller: codigoPostalController,
                decoration: const InputDecoration(labelText: 'Código Postal'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await _service.updateProfile(
                Profile(
                  id: profile.id,
                  nome: nomeController.text,
                  email: emailController.text,
                  morada: moradaController.text,
                  codigoPostal: codigoPostalController.text,
                  avatarUrl: profile.avatarUrl,
                ),
              );
              setState(() {
                _profileFuture = _service.fetchProfile();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil atualizado com sucesso')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Salvar'),
          )
        ],
      ),
    );
  }

  Widget _buildProfile(Profile profile) {
    final avatar = _imagemSelecionada != null
        ? FileImage(_imagemSelecionada!)
        : (profile.avatarUrl.isNotEmpty
            ? FileImage(File(profile.avatarUrl))
            : null);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          GestureDetector(
            onTap: () => _escolherImagem(profile),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: avatar,
              child: avatar == null ? const Icon(Icons.person, size: 50) : null,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('#${profile.id}', style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 16),
          TextField(
            enabled: false,
            controller: TextEditingController(text: profile.nome),
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          const SizedBox(height: 8),
          TextField(
            enabled: false,
            controller: TextEditingController(text: profile.email),
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: TextEditingController(text: profile.codigoPostal),
                  decoration: const InputDecoration(labelText: 'Código Postal'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: TextEditingController(text: profile.morada),
                  decoration: const InputDecoration(labelText: 'Morada'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showEditDialog(profile),
            icon: const Icon(Icons.edit),
            label: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Profile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar perfil'));
          }
          return _buildProfile(snapshot.data!);
        },
      ),
    );
  }
}
