import 'package:flutter/material.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/pages/localidades_page.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/pages/provincias_page.dart';
import 'package:labproyecto2025/src/features/shared/presentation/pages/home_page.dart';
import 'package:labproyecto2025/src/features/shared/presentation/pages/splash_page.dart';
import 'package:labproyecto2025/src/features/usuario/presentation/pages/login.dart';

class AppRoutes {
  static const splash = "/";
  static const login="/login";
  static const home = '/home';
  static const provincias= '/provincias';
  static const localidades= '/localidades';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SessionCheckScreen(),
    login:(context)=>const LoginPageModern(),
    home:(context)=>const HomePage(),
    provincias:(context)=>const ProvinciasPage(),
    localidades:(context)=>const LocalidadesPage()
  };
}