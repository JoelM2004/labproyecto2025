import 'package:flutter/material.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/pages/localidades_page.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/pages/provincias_page.dart';
import 'package:labproyecto2025/src/features/shared/presentation/pages/home_page.dart';

class AppRoutes {
  static const home = '/';
  static const provincias= '/provincias';
  static const localidades= '/localidades';

  static Map<String, WidgetBuilder> routes = {
    home:(context)=>const HomePage(),
    provincias:(context)=>const ProvinciasPage(),
    localidades:(context)=>const LocalidadesPage()
  };
}