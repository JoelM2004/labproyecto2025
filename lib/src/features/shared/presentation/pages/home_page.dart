// screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/app/routes.dart';
import 'package:labproyecto2025/src/core/session.dart';
import 'package:labproyecto2025/src/features/shared/presentation/widgets/section_card.dart';
import 'package:labproyecto2025/src/features/usuario/presentation/bloc/logout_usuario/logout_usuario_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 12),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Disparar evento de logout usando el BLoC del contexto padre
              context.read<LogoutUsuarioBloc>().add(LogoutUsuario());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutUsuarioBloc, LogoutUsuarioState>(
      listener: (context, state) {
        if (state is LogoutUsuarioSuccess) {
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Sesión cerrada exitosamente'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Navegar al login
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }

        if (state is LogoutUsuarioFailure) {
          // Mostrar mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text("Error al cerrar sesión: ${state.failure}"),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            Session.isAuthenticated 
                ? 'Hola, ${Session.currentUser?.nombres ?? "Usuario"}'
                : '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[700],
          elevation: 0,
          actions: [
            // Botón de logout con estado del BLoC
            BlocBuilder<LogoutUsuarioBloc, LogoutUsuarioState>(
              builder: (context, state) {
                if (state is LogoutUsuarioLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }

                return IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Cerrar Sesión',
                  onPressed: () => _showLogoutDialog(context),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar del usuario
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[700]?.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Selecciona una sección para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                
                SectionCard(
                  title: 'Provincias',
                  subtitle: 'Gestiona provincias',
                  icon: Icons.location_city,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.provincias);
                  },
                ),
                const SizedBox(height: 20),
                
                SectionCard(
                  title: 'Localidades',
                  subtitle: 'Administra localidades',
                  icon: Icons.assignment,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.localidades);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}