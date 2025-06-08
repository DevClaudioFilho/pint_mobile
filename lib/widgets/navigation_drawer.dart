import 'package:flutter/material.dart';
import 'package:flutter_application/pages/cursos/main.dart';
import 'package:flutter_application/pages/forums/main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Botão de fechar
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop(); // fecha o drawer
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // DrawerHeader(
                  //   decoration: BoxDecoration(
                  //     color: Colors.deepPurple,
                  //   ),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       'Menu',
                  //       style: TextStyle(color: Colors.white, fontSize: 24),
                  //     ),
                  //   ),
                  // ),
                  drawerItem(icon: Icons.home, text: 'Home', onTap: () {}),
                  // drawerItem(context, Icons.home, 'Home', const HomePage()),
                  drawerItem(
                      icon: Icons.book,
                      text: 'Cursos',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const CursosPage()),
                        );
                      },
                    ),
                  drawerItem(
                      icon: Icons.book,
                      text: 'Forum',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const ForumsPage()),
                        );
                      },
                    ),

                  // drawerItem(context, Icons.book, 'Cursos', const CursosPage()),
                  // drawerItem(context, Icons.school, 'Meus Cursos', const MeusCursosPage()),
                  // drawerItem(context, Icons.forum, 'Fóruns', const ForumsPage()),
                  // drawerItem(context, Icons.settings, 'Definições', const DefinicoesPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget drawerItem({required IconData icon, required String text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
// COM NAVEGACAO
  // Widget drawerItem(BuildContext context, IconData icon, String title, Widget page) {
  //   return ListTile(
  //     leading: Icon(icon),
  //     title: Text(title),
  //     onTap: () {
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  //     },
  //   );
//   }
// }
