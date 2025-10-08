import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/save.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';

part 'save_provincia_state.dart';
part 'save_provincia_event.dart';

class SaveProvinciaBloc extends Bloc<SaveProvinciaEvent, SaveProvinciaState> {
  final SaveProvinciaUseCase _saveProvinciaUseCase;

  SaveProvinciaBloc(this._saveProvinciaUseCase) : super(SaveProvinciaInitial()) {
    on<SaveProvincia>((event, emit) async {
      emit(SaveProvinciaLoading());

      final resp = await _saveProvinciaUseCase(event.provincia);

      resp.fold(
        (f) => emit(SaveProvinciaFailure(failure: f)),
        (p) => emit(SaveProvinciaSuccess(provincia: p)),
      );
    });
  }
}