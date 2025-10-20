// lib/src/features/shared/presentation/pages/session_check_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:labproyecto2025/src/app/routes.dart';
import 'package:labproyecto2025/src/core/session.dart';
import 'package:labproyecto2025/src/features/usuario/data/datasource/usuario_remote_datasource.dart';
import 'package:labproyecto2025/src/features/shared/presentation/widgets/splash_screen.dart';

class SessionCheckScreen extends StatelessWidget {
  const SessionCheckScreen({super.key});

  Future<bool> _checkSession() async {
    try {
      final sl = GetIt.instance;
      
      // Intentar restaurar la sesión desde el token guardado
      final datasource = sl<UsuarioRemoteDatasource>();
      final hasSession = await datasource.restoreSession();
      
      if (hasSession && Session.isAuthenticated) {
        print('✅ Sesión encontrada: ${Session.fullName}');
        return true;
      } else {
        print('ℹ️ No hay sesión activa');
        return false;
      }
    } catch (e) {
      print('❌ Error al verificar sesión: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkSession(),
      builder: (context, snapshot) {
        // Mientras se verifica la sesión, mostrar splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Verificar si hay sesión
        final hasSession = snapshot.data ?? false;

        // Redirigir según el resultado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasSession) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        });

        // Mostrar splash mientras se navega
        return const SplashScreen();
      },
    );
  }
}