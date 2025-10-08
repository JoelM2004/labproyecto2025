import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/load.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';

part 'load_localidad_state.dart';
part 'load_localidad_event.dart';

class LoadLocalidadBloc extends Bloc<LoadLocalidadEvent, LoadLocalidadState> {
  final LoadLocalidadUseCase _loadLocalidadUseCase;

  LoadLocalidadBloc(this._loadLocalidadUseCase) : super(LoadLocalidadInitial()) {
    on<LoadLocalidad>((event, emit) async {
      emit(LoadLocalidadLoading());

      final resp = await _loadLocalidadUseCase(event.id);

      resp.fold(
        (f) => emit(LoadLocalidadFailure(failure: f)),
        (p) => emit(LoadLocalidadSuccess(localidad: p)),
      );
    });
  }
}