import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/list.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';

part 'list_localidad_state.dart';
part 'list_localidad_event.dart';

class ListLocalidadBloc extends Bloc<ListLocalidadEvent, ListLocalidadState> {
  final ListLocalidadUseCase _listLocalidadUseCase;

  

  ListLocalidadBloc(this._listLocalidadUseCase) : super(ListLocalidadInitial()) {
    on<ListLocalidad>((event, emit) async {
      emit(ListLocalidadLoading());

        print('🔍 DEBUG Bloc: id=${event.id}, nombre=${event.nombre}, codPostal=${event.codPostal}, provinciaId=${event.provinciaId}');


      final resp = await _listLocalidadUseCase(event.id, event.nombre, event.codPostal,event.provinciaId);

      resp.fold(
        (f) => emit(ListLocalidadFailure(failure: f)),
        (p) => emit(ListLocalidadSuccess(localidades: p)),
      );
    });
  }
}