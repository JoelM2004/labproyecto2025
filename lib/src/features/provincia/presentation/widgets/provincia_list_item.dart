import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/delete_provincia/delete_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/widgets/dialogs/provincia_form_dialog.dart';
import '../../domain/entities/provincia.dart';

class ProvinciaListItem extends StatelessWidget {
  final Provincia provincia;
  final VoidCallback onRefresh;

  const ProvinciaListItem({
    super.key,
    required this.provincia,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
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
                  '#${provincia.id}',
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
                    provincia.nombre,
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
                        'CP: ${provincia.codPostal}',
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
                  builder: (dialogContext) => ProvinciaFormDialog(
                    provincia: provincia,
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
                    title: 'Eliminar Provincia',
                    message: '¿Estás seguro de que deseas eliminar "${provincia.nombre}"?',
                  ),
                );

                if (confirm == true && context.mounted) {
                  context.read<DeleteProvinciaBloc>().add(
                        DeleteProvincia(id: provincia.id),
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