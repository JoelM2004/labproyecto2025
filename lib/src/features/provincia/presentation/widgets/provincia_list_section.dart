import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/list_provincia/list_provincia_bloc.dart';
import 'provincia_list_item.dart';
import 'provincia_pagination.dart';

class ProvinciaListSection extends StatefulWidget {
  final VoidCallback onRefresh;

  const ProvinciaListSection({
    super.key,
    required this.onRefresh,
  });

  @override
  State<ProvinciaListSection> createState() => _ProvinciaListSectionState();
}

class _ProvinciaListSectionState extends State<ProvinciaListSection> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListProvinciaBloc, ListProvinciaState>(
      builder: (context, state) {
        if (state is ListProvinciaLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ListProvinciaFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                const Text(
                  'Error al listar las provincias',
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

        if (state is ListProvinciaSuccess) {
          if (state.provincias.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay provincias',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea una nueva provincia para comenzar',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final totalPages = (state.provincias.length / _itemsPerPage).ceil();
          final startIndex = (_currentPage - 1) * _itemsPerPage;
          final endIndex = (startIndex + _itemsPerPage > state.provincias.length)
              ? state.provincias.length
              : startIndex + _itemsPerPage;
          final currentProvincias = state.provincias.sublist(startIndex, endIndex);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${state.provincias.length} provincia${state.provincias.length != 1 ? 's' : ''}',
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
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: currentProvincias.length,
                    itemBuilder: (context, index) {
                      return ProvinciaListItem(
                        provincia: currentProvincias[index],
                        onRefresh: widget.onRefresh,
                      );
                    },
                  ),
                ),
              ),
              if (totalPages > 1)
                ProvinciaPagination(
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
        }

        return const SizedBox.shrink();
      },
    );
  }
}