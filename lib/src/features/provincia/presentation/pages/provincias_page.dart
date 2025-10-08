import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/delete_provincia/delete_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/list_provincia/list_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/widgets/dialogs/provincia_form_dialog.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/widgets/provincia_filter_section.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/widgets/provincia_list_section.dart';


class ProvinciasPage extends StatefulWidget {
  const ProvinciasPage({super.key});

  @override
  State<ProvinciasPage> createState() => _ProvinciasPageState();
}

class _ProvinciasPageState extends State<ProvinciasPage> {
  int? filtroId;
  String? filtroNombre;
  int? filtroCodPostal;

  @override
  void initState() {
    super.initState();
    _loadProvincias();
  }

  void _loadProvincias() {
    context.read<ListProvinciaBloc>().add(
          ListProvincia(
            id: filtroId,
            nombre: filtroNombre,
            codPostal: filtroCodPostal,
          ),
        );
  }

  void _applyFilters(int? id, String? nombre, int? codPostal) {
    setState(() {
      filtroId = id;
      filtroNombre = nombre;
      filtroCodPostal = codPostal;
    });
    _loadProvincias();
  }

  void _clearFilters() {
    setState(() {
      filtroId = null;
      filtroNombre = null;
      filtroCodPostal = null;
    });
    _loadProvincias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Provincias',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteProvinciaBloc, DeleteProvinciaState>(
            listener: (context, state) {
              if (state is DeleteProvinciaSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Provincia  eliminada'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _loadProvincias();
              } else if (state is DeleteProvinciaFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al eliminar la provincia'),
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
                alignment: Alignment.center, // Botón a la derecha
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (dialogContext) => ProvinciaFormDialog(
                        onSuccess: _loadProvincias,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Nueva Provincia',
                   style: TextStyle(color: Colors.white)
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
            ProvinciaFilterSection(
              onApplyFilters: _applyFilters,
              onClearFilters: _clearFilters,
            ),
            Expanded(
              child: ProvinciaListSection(
                onRefresh: _loadProvincias,
              ),
            ),
          ],
        ),
      )
    );
  }
}