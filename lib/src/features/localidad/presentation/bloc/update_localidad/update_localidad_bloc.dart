import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/update.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';

part 'update_localidad_state.dart';
part 'update_localidad_event.dart';

class UpdateLocalidadBloc extends Bloc<UpdateLocalidadEvent, UpdateLocalidadState> {
  final UpdateLocalidadUseCase _updateLocalidadUseCase;

  UpdateLocalidadBloc(this._updateLocalidadUseCase) : super(UpdateLocalidadInitial()) {
    on<UpdateLocalidad>((event, emit) async {
      emit(UpdateLocalidadLoading());

      final resp = await _updateLocalidadUseCase(event.localidad);

      resp.fold(
        (f) => emit(UpdateLocalidadFailure(failure: f)),
        (p) => emit(UpdateLocalidadSuccess(localidad: p)),
      );
    });
  }
}