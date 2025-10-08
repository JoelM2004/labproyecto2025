import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProvinciaFilterSection extends StatefulWidget {
  final Function(int?, String?, int?) onApplyFilters;
  final VoidCallback onClearFilters;

  const ProvinciaFilterSection({
    super.key,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<ProvinciaFilterSection> createState() => _ProvinciaFilterSectionState();
}

class _ProvinciaFilterSectionState extends State<ProvinciaFilterSection> {
  final _idController = TextEditingController();
  final _nombreController = TextEditingController();
  final _codPostalController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _idController.dispose();
    _nombreController.dispose();
    _codPostalController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _idController.clear();
    _nombreController.clear();
    _codPostalController.clear();
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.filter_list, color: Colors.blue[700]),
            title: const Text(
              'Filtros',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _codPostalController,
                    decoration: InputDecoration(
                      labelText: 'Código Postal',
                      prefixIcon: const Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Solo permite números
                      LengthLimitingTextInputFormatter(4),     // Máximo 4 dígitos
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clearFields,
                          icon: const Icon(Icons.clear),
                          label: const Text('Limpiar'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.onApplyFilters(
                              (_idController.text.isEmpty ? null : _idController.text) as int?,
                              _nombreController.text.isEmpty ? null : _nombreController.text,
                              _codPostalController.text.isEmpty ? null : int.tryParse(_codPostalController.text),
                            );
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Buscar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}