import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../presentation/widgets/main_bottom_nav.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const AuthScaffold({
    super.key,
    required this.child,
    required this.title,
  });

  bool _showBottomNav(String routeName) {
    return [
      '/cursos',
      '/forums',
      '/profile',
      '/certificados',
    ].contains(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthService>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: child,
      bottomNavigationBar: _showBottomNav(routeName)
          ? const MainBottomNav()
          : null,
    );
  }
}
