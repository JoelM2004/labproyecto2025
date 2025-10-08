// screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:labproyecto2025/src/app/routes.dart';
import 'package:labproyecto2025/src/features/shared/presentation/widgets/section_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
    );
  }
}