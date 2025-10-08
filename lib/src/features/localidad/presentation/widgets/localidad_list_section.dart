import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/list_localidad/list_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/list_provincia/list_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';
import 'localidad_list_item.dart';
import 'localidad_pagination.dart';

class LocalidadListSection extends StatefulWidget {
  final VoidCallback onRefresh;

  const LocalidadListSection({
    super.key,
    required this.onRefresh,
  });

  @override
  State<LocalidadListSection> createState() => _LocalidadListSectionState();
}

class _LocalidadListSectionState extends State<LocalidadListSection> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    // 🔹 Carga todas las provincias al iniciar
    context.read<ListProvinciaBloc>().add(
      ListProvincia(
        nombre: null,
        codPostal: null,
        id: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListLocalidadBloc, ListLocalidadState>(
      builder: (context, localidadState) {
        if (localidadState is ListLocalidadLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (localidadState is ListLocalidadFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                const Text(
                  'Error al listar las localidades',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: widget.onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (localidadState is ListLocalidadSuccess) {
          if (localidadState.localidades.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay localidades',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea una nueva localidad para comenzar',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final totalPages = (localidadState.localidades.length / _itemsPerPage).ceil();
          final startIndex = (_currentPage - 1) * _itemsPerPage;
          final endIndex = (startIndex + _itemsPerPage > localidadState.localidades.length)
              ? localidadState.localidades.length
              : startIndex + _itemsPerPage;
          final currentLocalidades = localidadState.localidades.sublist(startIndex, endIndex);

          // 🔹 Escucha el estado de las provincias
          return BlocBuilder<ListProvinciaBloc, ListProvinciaState>(
            builder: (context, provinciaState) {
              Map<int, Provincia>? provinciasMap;

              if (provinciaState is ListProvinciaSuccess) {
                // 🔹 Convierte la lista a mapa para búsqueda O(1)
                provinciasMap = {
                  for (var provincia in provinciaState.provincias)
                    provincia.id: provincia
                };
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${localidadState.localidades.length} localidad${localidadState.localidades.length != 1 ? 'es' : ''}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Página $_currentPage de $totalPages',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        widget.onRefresh();
                        // 🔹 También recarga las provincias
                        context.read<ListProvinciaBloc>().add(
                          ListProvincia(
                            nombre: null,
                            codPostal: null,
                            id: null,
                          ),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: currentLocalidades.length,
                        itemBuilder: (context, index) {
                          return LocalidadListItem(
                            localidad: currentLocalidades[index],
                            onRefresh: widget.onRefresh,
                            provinciasMap: provinciasMap, // 🔹 Pasa el mapa
                          );
                        },
                      ),
                    ),
                  ),
                  if (totalPages > 1)
                    LocalidadPagination(
                      currentPage: _currentPage,
                      totalPages: totalPages,
                      onPageChanged: (page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                    ),
                ],
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}