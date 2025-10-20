part of 'logout_usuario_bloc.dart';

sealed class LogoutUsuarioState {}

final class LogoutUsuarioInitial extends LogoutUsuarioState {}

final class LogoutUsuarioLoading extends LogoutUsuarioState {}

final class LogoutUsuarioSuccess extends LogoutUsuarioState {
  final bool resp;
  LogoutUsuarioSuccess({required this.resp});
}

final class LogoutUsuarioFailure extends LogoutUsuarioState {
  final Failure failure;
  LogoutUsuarioFailure({required this.failure});
}