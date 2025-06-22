import 'package:flutter/material.dart';

class SolicitarContaPage extends StatefulWidget {
  const SolicitarContaPage({super.key});

  @override
  State<SolicitarContaPage> createState() => _SolicitarContaPageState();
}

class _SolicitarContaPageState extends State<SolicitarContaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _numeroController = TextEditingController();
  bool _loading = false;

  Future<void> _solicitarConta() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      await Future.delayed(const Duration(seconds: 2)); // Simula API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação enviada com sucesso!')),
      );
      Navigator.pop(context); // Volta para o login
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/9/9a/Lisbon_Parque_das_Na%C3%A7%C3%B5es.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'Solicitar conta',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Preencha e solicite o login ou ',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'faça log in',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nomeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Nome'),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Informe o nome';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _numeroController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Número de funcionário'),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Informe o número';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _loading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _solicitarConta,
                            child: const Text(
                              'Solicitar conta',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
    );
  }
}
