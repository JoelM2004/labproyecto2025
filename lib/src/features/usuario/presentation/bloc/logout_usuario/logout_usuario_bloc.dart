import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/usuario/domain/use_cases/logout.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';

part 'logout_usuario_state.dart';
part 'logout_usuario_event.dart';

class LogoutUsuarioBloc extends Bloc<LogoutUsuarioEvent, LogoutUsuarioState> {
  final LogoutUsuarioUseCase _logoutUsuarioUseCase;

  LogoutUsuarioBloc(this._logoutUsuarioUseCase) : super(LogoutUsuarioInitial()) {
    on<LogoutUsuario>((event, emit) async {
      emit(LogoutUsuarioLoading());

      final resp = await _logoutUsuarioUseCase();

      resp.fold(
        (f) => emit(LogoutUsuarioFailure(failure: f)),
        (p) => emit(LogoutUsuarioSuccess(resp: p)),
      );
    });
  }
}