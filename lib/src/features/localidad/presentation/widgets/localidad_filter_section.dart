import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/list_provincia/list_provincia_bloc.dart';

class LocalidadFilterSection extends StatefulWidget {
  final Function(String?, int?, String?) onApplyFilters;  // Actualizado: sin id, provinciaId como String?
  final VoidCallback onClearFilters;

  final String? initialNombre;
  final int? initialCodPostal;
  final String? initialProvinciaId;  // Siempre String para dropdown

  const LocalidadFilterSection({
    Key? key,
    required this.onApplyFilters,
    required this.onClearFilters,
    this.initialNombre,
    this.initialCodPostal,
    this.initialProvinciaId,
  }) : super(key: key);

  @override
  State<LocalidadFilterSection> createState() => _LocalidadFilterSectionState();
}

class _LocalidadFilterSectionState extends State<LocalidadFilterSection> {
  final _nombreController = TextEditingController();
  final _codPostalController = TextEditingController();

  List<Map<String, dynamic>> _provincias = [];
  String? _filtroProvinciaId; // provincia seleccionada (String)
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Cargar provincias
    context.read<ListProvinciaBloc>().add(ListProvincia(nombre: null, codPostal: null, id: null));

    // Setea valores iniciales
    _nombreController.text = widget.initialNombre ?? '';
    _codPostalController.text = widget.initialCodPostal?.toString() ?? '';
    _filtroProvinciaId = widget.initialProvinciaId;
  }

  @override
  void didUpdateWidget(covariant LocalidadFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialNombre != oldWidget.initialNombre) _nombreController.text = widget.initialNombre ?? '';
    if (widget.initialCodPostal != oldWidget.initialCodPostal) _codPostalController.text = widget.initialCodPostal?.toString() ?? '';
    if (widget.initialProvinciaId != oldWidget.initialProvinciaId) {
      setState(() {
        _filtroProvinciaId = widget.initialProvinciaId;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codPostalController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _nombreController.clear();
    _codPostalController.clear();
    setState(() {
      _filtroProvinciaId = null;
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListProvinciaBloc, ListProvinciaState>(
      listener: (context, state) {
        if (state is ListProvinciaSuccess) {
          setState(() {
            _provincias = state.provincias
                .map((p) => {'id': p.id.toString(), 'nombre': p.nombre})
                .toList();

            // Si hay initialProvinciaId y coincide, lo asignamos
            if (_filtroProvinciaId == null && widget.initialProvinciaId != null) {
              final exists = _provincias.any((p) => p['id'] == widget.initialProvinciaId);
              if (exists) _filtroProvinciaId = widget.initialProvinciaId;
            }
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.filter_list, color: Colors.blue[700]),
              title: const Text('Filtros', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: const Icon(Icons.text_fields),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _codPostalController,
                      decoration: InputDecoration(
                        labelText: 'Código Postal',
                        prefixIcon: const Icon(Icons.mail_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Provincia',
                        prefixIcon: const Icon(Icons.map_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      value: _filtroProvinciaId != null && _provincias.any((p) => p['id'] == _filtroProvinciaId)
                          ? _filtroProvinciaId
                          : null,
                      items: _provincias.map((provincia) {
                        return DropdownMenuItem<String>(
                          value: provincia['id'],
                          child: Text(provincia['nombre']),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _filtroProvinciaId = value),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _clearFields,
                            icon: const Icon(Icons.clear),
                            label: const Text('Limpiar'),
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Asegurar que se envíe provinciaId aunque no se toque el dropdown
                            final provinciaIdToSend = _filtroProvinciaId ?? widget.initialProvinciaId;

                            // 🔍 DEBUG
                            print('🔍 DEBUG LocalidadFilterSection:');
                            print('  - Nombre: ${_nombreController.text.isEmpty ? null : _nombreController.text}');
                            print('  - CodPostal: ${_codPostalController.text.isEmpty ? null : int.tryParse(_codPostalController.text)}');
                            print('  - ProvinciaId: $provinciaIdToSend');  // Debería mostrar "9"

                            widget.onApplyFilters(
                              _nombreController.text.isEmpty ? null : _nombreController.text,
                              _codPostalController.text.isEmpty ? null : int.tryParse(_codPostalController.text),
                              provinciaIdToSend,  // String? directamente
                            );
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Buscar'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}