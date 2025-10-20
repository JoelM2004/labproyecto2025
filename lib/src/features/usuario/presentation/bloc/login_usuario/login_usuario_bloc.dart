import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/usuario/domain/entities/usuario.dart';
import 'package:labproyecto2025/src/features/usuario/domain/use_cases/login.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';

part 'login_usuario_state.dart';
part 'login_usuario_event.dart';

class LoginUsuarioBloc extends Bloc<LoginUsuarioEvent, LoginUsuarioState> {
  final LoginUsuarioUseCase _loginUsuarioUseCase;

  LoginUsuarioBloc(this._loginUsuarioUseCase) : super(LoginUsuarioInitial()) {
    on<LoginUsuario>((event, emit) async {
      emit(LoginUsuarioLoading());

      final resp = await _loginUsuarioUseCase(event.cuenta, event.contrasena);

      resp.fold(
        (f) => emit(LoginUsuarioFailure(failure: f)),
        (p) => emit(LoginUsuarioSuccess(usuario: p)),
      );
    });
  }
}