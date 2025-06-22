import 'package:flutter/material.dart';

class TrocarSenhaPage extends StatefulWidget {
  const TrocarSenhaPage({super.key});

  @override
  State<TrocarSenhaPage> createState() => _TrocarSenhaPageState();
}

class _TrocarSenhaPageState extends State<TrocarSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  void _trocarSenha() {
    if (_formKey.currentState!.validate()) {
      // Simular troca de senha
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso')),
      );
      Navigator.pushReplacementNamed(context, '/cursos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trocar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Primeiro acesso - Defina sua nova senha'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nova Senha'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a nova senha';
                  if (value.length < 6) return 'Senha muito curta';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _trocarSenha,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
