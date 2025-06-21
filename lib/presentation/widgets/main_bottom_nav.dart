import 'package:flutter/material.dart';

class MainBottomNav extends StatelessWidget {
  const MainBottomNav({super.key});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/cursos');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/forums');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/certificados');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';
    int currentIndex = 0;

    if (routeName.startsWith('/cursos')) {
      currentIndex = 0;
    } else if (routeName.startsWith('/forums')) {
      currentIndex = 1;
    } else if (routeName.startsWith('/profile')) {
      currentIndex = 2;
    } else if (routeName.startsWith('/certificados')) {
      currentIndex = 3;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Cursos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: 'Fóruns',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.badge),
          label: 'Certificados',
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
