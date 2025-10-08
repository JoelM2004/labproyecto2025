import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/delete.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';

part 'delete_localidad_state.dart';
part 'delete_localidad_event.dart';

class DeleteLocalidadBloc extends Bloc<DeleteLocalidadEvent, DeleteLocalidadState> {
  final DeleteLocalidadUseCase _deleteLocalidadUseCase;

  DeleteLocalidadBloc(this._deleteLocalidadUseCase) : super(DeleteLocalidadInitial()) {
    on<DeleteLocalidad>((event, emit) async {
      emit(DeleteLocalidadLoading());

      final resp = await _deleteLocalidadUseCase(event.id);

      resp.fold(
        (f) => emit(DeleteLocalidadFailure(failure: f)),
        (p) => emit(DeleteLocalidadSuccess(localidad: p)),
      );
    });
  }
}