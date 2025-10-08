import 'package:flutter/material.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/widgets/dialogs/provincia_form_dialog.dart';

class ProvinciaFAB extends StatelessWidget {
  final VoidCallback onProvinciaCreated;

  const ProvinciaFAB({
    super.key,
    required this.onProvinciaCreated,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) => ProvinciaFormDialog(
            onSuccess: onProvinciaCreated,
          ),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Nueva Provincia'),
      backgroundColor: Colors.blue[700],
    );
  }
}