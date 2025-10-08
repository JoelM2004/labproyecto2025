import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/delete_localidad/delete_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/widgets/dialogs/localidad_form_dialog.dart';
import '../../domain/entities/localidad.dart';
import '../../../provincia/domain/entities/provincia.dart';

class LocalidadListItem extends StatelessWidget {
  final Localidad localidad;
  final VoidCallback onRefresh;
  final Map<int, Provincia>? provinciasMap;

  const LocalidadListItem({
    super.key,
    required this.localidad,
    required this.onRefresh,
    this.provinciasMap,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 Busca la provincia del mapa
    String provinciaNombre = "Cargando...";
    
    if (provinciasMap != null) {
      final provinciaId = int.tryParse(localidad.provinciaId.toString()) ?? 0;
      final provincia = provinciasMap![provinciaId];
      provinciaNombre = provincia?.nombre ?? "Sin provincia";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '#${localidad.id}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localidad.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.mail_outline, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'CP: ${localidad.codPostal}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.map_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Provincia: $provinciaNombre',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.orange[700],
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => LocalidadFormDialog(
                    localidad: localidad,
                    onSuccess: onRefresh,
                  ),
                );
              },
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red[700],
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(
                    title: 'Eliminar Localidad',
                    message: '¿Estás seguro de que deseas eliminar "${localidad.nombre}"?',
                  ),
                );

                if (confirm == true && context.mounted) {
                  context.read<DeleteLocalidadBloc>().add(
                        DeleteLocalidad(id: localidad.id),
                      );
                }
              },
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}