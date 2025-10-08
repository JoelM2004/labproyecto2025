import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/save_localidad/save_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/update_localidad/update_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/list_provincia/list_provincia_bloc.dart';

class LocalidadFormDialog extends StatefulWidget {
  final Localidad? localidad;
  final VoidCallback onSuccess;

  const LocalidadFormDialog({
    super.key,
    this.localidad,
    required this.onSuccess,
  });

  @override
  State<LocalidadFormDialog> createState() => _LocalidadFormDialogState();
}

class _LocalidadFormDialogState extends State<LocalidadFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _codPostalController;

  String? _selectedProvinciaId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.localidad?.nombre ?? '');
    _codPostalController = TextEditingController(
      text: widget.localidad?.codPostal.toString() ?? '',
    );

    // Guardar el ID de la provincia si existe
    if (widget.localidad != null && widget.localidad!.provinciaId != null) {
      _selectedProvinciaId = widget.localidad!.provinciaId.toString();
    }
    
    // Cargar provincias al iniciar
    context.read<ListProvinciaBloc>().add(ListProvincia(nombre: '', id: 0));
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codPostalController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.localidad != null;

  void _submit() {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    final localidad = Localidad(
      id: widget.localidad?.id ?? 0,
      nombre: _nombreController.text.trim(),
      codPostal: int.tryParse(_codPostalController.text.trim()) ?? 0,
      provinciaId: _selectedProvinciaId ?? "",
    );

    // 🔍 Imprimir valores antes de enviar al Bloc
    print("=== DATOS A ${isEditing ? 'ACTUALIZAR' : 'CREAR'} ===");
    print("ID: ${localidad.id}");
    print("Nombre: ${localidad.nombre}");
    print("Código Postal: ${localidad.codPostal}");
    print("Provincia ID: ${localidad.provinciaId}");
    print("==============================");

    if (isEditing) {
      context.read<UpdateLocalidadBloc>().add(UpdateLocalidad(localidad: localidad));
    } else {
      context.read<SaveLocalidadBloc>().add(SaveLocalidad(localidad: localidad));
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SaveLocalidadBloc, SaveLocalidadState>(
          listener: (context, state) {
            if (state is SaveLocalidadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Localidad creada exitosamente'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              widget.onSuccess();
              Navigator.of(context).pop();
            } else if (state is SaveLocalidadFailure) {
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
        BlocListener<UpdateLocalidadBloc, UpdateLocalidadState>(
          listener: (context, state) {
            if (state is UpdateLocalidadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Localidad actualizada'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              widget.onSuccess();
              Navigator.of(context).pop();
            } else if (state is UpdateLocalidadFailure) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al actualizar la localidad'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
      child: AlertDialog(
        title: Text(isEditing ? 'Editar Localidad' : 'Nueva Localidad'),
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
                const SizedBox(height: 16),

                BlocBuilder<ListProvinciaBloc, ListProvinciaState>(
                  builder: (context, state) {
                    if (state is ListProvinciaLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ListProvinciaFailure) {
                      return Text('Error al cargar provincias: ${state.failure}');
                    } else if (state is ListProvinciaSuccess) {
                      final provincias = state.provincias
                          .map((provincia) => {
                                'id': provincia.id.toString(),
                                'nombre': provincia.nombre,
                              })
                          .toList();

                      // Verificar si el valor seleccionado existe en la lista
                      final valueExists = provincias.any((p) => p['id'] == _selectedProvinciaId);
                      final currentValue = valueExists ? _selectedProvinciaId : null;

                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Provincia *',
                          prefixIcon: const Icon(Icons.map_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        value: currentValue,
                        items: provincias.map((provincia) {
                          return DropdownMenuItem<String>(
                            value: provincia['id'],
                            child: Text(provincia['nombre']!),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedProvinciaId = value;
                                });
                              },
                        validator: (value) {
                          if (value == null) {
                            return 'Debe seleccionar una provincia';
                          }
                          return null;
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
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