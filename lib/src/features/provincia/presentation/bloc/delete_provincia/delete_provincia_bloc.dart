import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/delete.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';

part 'delete_provincia_state.dart';
part 'delete_provincia_event.dart';

class DeleteProvinciaBloc extends Bloc<DeleteProvinciaEvent, DeleteProvinciaState> {
  final DeleteProvinciaUseCase _deleteProvinciaUseCase;

  DeleteProvinciaBloc(this._deleteProvinciaUseCase) : super(DeleteProvinciaInitial()) {
    on<DeleteProvincia>((event, emit) async {
      emit(DeleteProvinciaLoading());

      final resp = await _deleteProvinciaUseCase(event.id);

      resp.fold(
        (f) => emit(DeleteProvinciaFailure(failure: f)),
        (p) => emit(DeleteProvinciaSuccess(provincia: p)),
      );
    });
  }
}