import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/update.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';

part 'update_provincia_state.dart';
part 'update_provincia_event.dart';

class UpdateProvinciaBloc extends Bloc<UpdateProvinciaEvent, UpdateProvinciaState> {
  final UpdateProvinciaUseCase _updateProvinciaUseCase;

  UpdateProvinciaBloc(this._updateProvinciaUseCase) : super(UpdateProvinciaInitial()) {
    on<UpdateProvincia>((event, emit) async {
      emit(UpdateProvinciaLoading());

      final resp = await _updateProvinciaUseCase(event.provincia);

      resp.fold(
        (f) => emit(UpdateProvinciaFailure(failure: f)),
        (p) => emit(UpdateProvinciaSuccess(provincia: p)),
      );
    });
  }
}