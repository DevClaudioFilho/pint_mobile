import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrimeiroLoginPage extends StatefulWidget {
  final int userId;

  const PrimeiroLoginPage({super.key, required this.userId});

  @override
  State<PrimeiroLoginPage> createState() => _PrimeiroLoginPageState();
}

class _PrimeiroLoginPageState extends State<PrimeiroLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;

  Future<void> _alterarSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final response = await http.post(
        Uri.parse('https://backend-8pyn.onrender.com/alterar-senha'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'novaSenha': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso.')),
        );
        Navigator.pushReplacementNamed(context, '/cursos');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao alterar senha.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao conectar ao servidor.')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Primeiro Login - Alterar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Por favor, defina sua nova senha.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Nova Senha'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe a nova senha';
                      if (value.length < 6) return 'Senha deve ter no mínimo 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirme a Nova Senha'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Confirme a nova senha';
                      if (value != _passwordController.text) return 'As senhas não conferem';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _alterarSenha,
                          child: const Text('Alterar Senha'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
