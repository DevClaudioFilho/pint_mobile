import 'package:flutter/material.dart';
import 'package:flutter_application/app/auth_scaffold.dart';
import 'package:flutter_application/presentation/pages/aula_page.dart';
import 'package:flutter_application/presentation/pages/certificacoes_page.dart';
import 'package:flutter_application/presentation/pages/curso_page.dart';
import 'package:flutter_application/presentation/pages/cursos_page.dart';
import 'package:flutter_application/presentation/pages/forums_page.dart';
import 'package:flutter_application/presentation/pages/login_page.dart';
import 'package:flutter_application/presentation/pages/post_page.dart';
import 'package:flutter_application/presentation/pages/posts_page.dart';
import 'package:flutter_application/presentation/pages/primeiro_login_page.dart';
import 'package:flutter_application/presentation/pages/profile_page.dart';
import 'package:flutter_application/presentation/pages/solicitar_page.dart';
import 'package:flutter_application/presentation/pages/trocar_senha_page.dart';
import '../presentation/pages/splash_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const SplashPage(),
    '/login': (context) => const LoginPage(),
    '/solicitar-conta': (context) => const SolicitarContaPage(),
    '/primeiro-login': (context) {
      final arg = ModalRoute.of(context)!.settings.arguments;
      final userId = arg is int ? arg : int.tryParse(arg.toString());

      if (userId == null) {
        return const Scaffold(
          body: Center(
            child: Text('ID de usuário inválido para o primeiro login.'),
          ),
        );
      }

      return PrimeiroLoginPage(userId: userId);
    },



    '/cursos':
        (context) => const AuthScaffold(child: CursosPage(), title: 'Cursos'),

    '/cursos/id': (context) {
      final arg = ModalRoute.of(context)!.settings.arguments;
      final cursoId = arg is String ? arg : arg.toString() ?? '';

      return AuthScaffold(title: 'Curso', child: CursoPage(cursoId: cursoId));
    },

    '/aula': (context) {
      final aulaId = ModalRoute.of(context)!.settings.arguments as String;
      return AuthScaffold(title: 'Aula', child: AulaPage(aulaId: aulaId));
    },

    '/forums':
        (context) => const AuthScaffold(child: ForumsPage(), title: 'Forums'),
    '/post': (context) {
      final postId = ModalRoute.of(context)!.settings.arguments.toString();
      return PostPage(postId: postId);
    },

    '/profile':
        (context) => const AuthScaffold(child: ProfilePage(), title: 'Perfil'),

    '/certificados':
        (context) => const AuthScaffold(
          child: CertificacoesPage(),
          title: 'Certificações',
        ),
  };
}
