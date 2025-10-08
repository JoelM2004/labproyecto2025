import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/save.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';

part 'save_localidad_state.dart';
part 'save_localidad_event.dart';

class SaveLocalidadBloc extends Bloc<SaveLocalidadEvent, SaveLocalidadState> {
  final SaveLocalidadUseCase _saveLocalidadUseCase;

  SaveLocalidadBloc(this._saveLocalidadUseCase) : super(SaveLocalidadInitial()) {
    on<SaveLocalidad>((event, emit) async {
      emit(SaveLocalidadLoading());

      final resp = await _saveLocalidadUseCase(event.localidad);

      resp.fold(
        (f) => emit(SaveLocalidadFailure(failure: f)),
        (p) => emit(SaveLocalidadSuccess(localidad: p)),
      );
    });
  }
}