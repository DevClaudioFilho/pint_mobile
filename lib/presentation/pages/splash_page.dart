import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/auth_service.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      final auth = context.read<AuthService>();
      if (auth.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/cursos');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
