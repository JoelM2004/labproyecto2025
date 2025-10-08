import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/delete_localidad/delete_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/list_localidad/list_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/widgets/dialogs/localidad_form_dialog.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/widgets/localidad_filter_section.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/widgets/localidad_list_section.dart';

class LocalidadesPage extends StatefulWidget {
  const LocalidadesPage({super.key});

  @override
  State<LocalidadesPage> createState() => _LocalidadesPageState();
}

class _LocalidadesPageState extends State<LocalidadesPage> {
  String? filtroNombre;
  int? filtroCodPostal;
  String? filtroProvinciaId;

  @override
  void initState() {
    super.initState();
    _loadLocalidades();
  }

  void _loadLocalidades() {
    context.read<ListLocalidadBloc>().add(
      ListLocalidad(
        // id: null,  // Removido porque no se usa
        nombre: filtroNombre,
        codPostal: filtroCodPostal,
        provinciaId: filtroProvinciaId,  // String? (e.g., "9")
      ),
    );
  }

  void _applyFilters(String? nombre, int? codPostal, String? provinciaId) {
    setState(() {
      filtroNombre = nombre;
      filtroCodPostal = codPostal;
      filtroProvinciaId = provinciaId;
    });

    // 🔍 DEBUG para verificar que provinciaId llegue correctamente como String?
    print('🔍 DEBUG Parent _applyFilters: nombre=$nombre, codPostal=$codPostal, provinciaId=$provinciaId');

    _loadLocalidades();
  }

  void _clearFilters() {
    setState(() {
      filtroNombre = null;
      filtroCodPostal = null;
      filtroProvinciaId = null;
    });
    _loadLocalidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Localidades',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteLocalidadBloc, DeleteLocalidadState>(
            listener: (context, state) {
              if (state is DeleteLocalidadSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Localidad eliminada'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _loadLocalidades();
              } else if (state is DeleteLocalidadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al eliminar la localidad'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.center,  // Corregido: centerRight para alinear a la derecha
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => LocalidadFormDialog(
                        onSuccess: _loadLocalidades,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white ),
                  label: const Text(
                    'Nueva Localidad',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            LocalidadFilterSection(
              onApplyFilters: _applyFilters,  // Ahora coincide la firma (sin id)
              onClearFilters: _clearFilters,
              // Opcional: Pasa valores iniciales basados en filtros actuales (para recargas)
              initialNombre: filtroNombre,
              initialCodPostal: filtroCodPostal,
              initialProvinciaId: filtroProvinciaId,
            ),
            Expanded(
              child: LocalidadListSection(
                onRefresh: _loadLocalidades,
              ),
            ),
          ],
        ),
      ),
    );
  }
}