import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/load.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';

part 'load_provincia_state.dart';
part 'load_provincia_event.dart';

class LoadProvinciaBloc extends Bloc<LoadProvinciaEvent, LoadProvinciaState> {
  final LoadProvinciaUseCase _loadProvinciaUseCase;

  LoadProvinciaBloc(this._loadProvinciaUseCase) : super(LoadProvinciaInitial()) {
    on<LoadProvincia>((event, emit) async {
      emit(LoadProvinciaLoading());

      final resp = await _loadProvinciaUseCase(event.id);

      resp.fold(
        (f) => emit(LoadProvinciaFailure(failure: f)),
        (p) => emit(LoadProvinciaSuccess(provincia: p)),
      );
    });
  }
}