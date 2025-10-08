import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/save_provincia/save_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/update_provincia/update_provincia_bloc.dart';

class ProvinciaFormDialog extends StatefulWidget {
  final Provincia? provincia;
  final VoidCallback onSuccess;

  const ProvinciaFormDialog({
    super.key,
    this.provincia,
    required this.onSuccess,
  });

  @override
  State<ProvinciaFormDialog> createState() => _ProvinciaFormDialogState();
}

class _ProvinciaFormDialogState extends State<ProvinciaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _codPostalController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.provincia?.nombre ?? '');
    _codPostalController = TextEditingController(
    text: widget.provincia?.codPostal.toString() ?? ''
  );

  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codPostalController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.provincia != null;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final provincia = Provincia(
        id: widget.provincia?.id ?? 0,
        nombre: _nombreController.text.trim(),
        codPostal: int.tryParse(_codPostalController.text.trim()) ?? 0,
      );

      if (isEditing) {
        context.read<UpdateProvinciaBloc>().add(UpdateProvincia(provincia: provincia));
      } else {
        context.read<SaveProvinciaBloc>().add(SaveProvincia(provincia: provincia));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SaveProvinciaBloc, SaveProvinciaState>(
          listener: (context, state) {
            if (state is SaveProvinciaSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Provincia  creada exitosamente'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              widget.onSuccess();
              Navigator.of(context).pop();
            } else if (state is SaveProvinciaFailure) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.failure}'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        BlocListener<UpdateProvinciaBloc, UpdateProvinciaState>(
          listener: (context, state) {
            if (state is UpdateProvinciaSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Provincia actualizada'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              widget.onSuccess();
              Navigator.of(context).pop();
            } else if (state is UpdateProvinciaFailure) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al actualizar la provincia'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
      child: AlertDialog(
        title: Text(isEditing ? 'Editar Provincia' : 'Nueva Provincia'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre *',
                    prefixIcon: const Icon(Icons.location_city),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    if (value.trim().length < 3) {
                      return 'El nombre debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _codPostalController,
                  decoration: InputDecoration(
                    labelText: 'Código Postal *',
                    prefixIcon: const Icon(Icons.mail_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El código postal es requerido';
                    }
                    if (value.trim().length < 4) {
                      return 'Código postal inválido';
                    }
                    return null;
                  },
                  enabled: !_isLoading,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEditing ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }
}