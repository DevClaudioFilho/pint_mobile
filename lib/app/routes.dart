import 'package:flutter/material.dart';
import 'package:flutter_application/app/auth_scaffold.dart';
import 'package:flutter_application/presentation/pages/aula_page.dart';
import 'package:flutter_application/presentation/pages/certificacoes_page.dart';
import 'package:flutter_application/presentation/pages/curso_page.dart';
import 'package:flutter_application/presentation/pages/cursos_page.dart';
import 'package:flutter_application/presentation/pages/forums_page.dart';
import 'package:flutter_application/presentation/pages/login_page.dart';
import 'package:flutter_application/presentation/pages/profile_page.dart';

import '../presentation/pages/splash_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const SplashPage(),
    '/login': (context) => const LoginPage(),

    '/cursos':
        (context) => const AuthScaffold(child: CursosPage(), title: 'Cursos'),
    '/cursos/id':
        (context) => const AuthScaffold(child: CursoPage(), title: 'Curso'),

    '/aula': (context) {
      final aulaId = ModalRoute.of(context)!.settings.arguments as String;
      return AuthScaffold(title: 'Aula', child: AulaPage(aulaId: aulaId));
    },

    '/forums':
        (context) => const AuthScaffold(child: ForumsPage(), title: 'Forums'),

    '/profile':
        (context) => const AuthScaffold(child: ProfilePage(), title: 'Perfil'),
    
      '/certificados':
        (context) => const AuthScaffold(child: CertificacoesPage(), title: 'Certificações'),
  };
}
