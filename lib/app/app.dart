import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/auth_service.dart';
import 'routes.dart';
import 'themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Meu App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue, // Altere de Colors.purple (ou outro) para Colors.blue
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
        routes: AppRoutes.routes,
        initialRoute: '/',
      ),
    );
  }
}
