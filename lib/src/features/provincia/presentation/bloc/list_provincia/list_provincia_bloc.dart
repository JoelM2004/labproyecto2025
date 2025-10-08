import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/list.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';

part 'list_provincia_state.dart';
part 'list_provincia_event.dart';

class ListProvinciaBloc extends Bloc<ListProvinciaEvent, ListProvinciaState> {
  final ListProvinciaUseCase _listProvinciaUseCase;

  ListProvinciaBloc(this._listProvinciaUseCase) : super(ListProvinciaInitial()) {
    on<ListProvincia>((event, emit) async {
      emit(ListProvinciaLoading());

      final resp = await _listProvinciaUseCase(event.nombre,event.codPostal,event.id);

      resp.fold(
        (f) => emit(ListProvinciaFailure(failure: f)),
        (p) => emit(ListProvinciaSuccess(provincias: p)),
      );
    });
  }
}