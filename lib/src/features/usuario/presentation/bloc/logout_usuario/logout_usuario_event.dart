part of 'logout_usuario_bloc.dart';

sealed class LogoutUsuarioEvent {}

class LogoutUsuario extends LogoutUsuarioEvent {
  LogoutUsuario();
}