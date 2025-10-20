// lib/src/app/app.dart
import 'package:flutter/material.dart';
import 'package:labproyecto2025/src/app/routes.dart';
import 'package:labproyecto2025/src/app/theme.dart';
import 'package:labproyecto2025/src/features/shared/presentation/pages/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Proyecto 2025',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const SessionCheckScreen(),
      onGenerateRoute: (settings) {
        // Usar onGenerateRoute para evitar conflicto con home
        final builder = AppRoutes.routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}