part of 'login_usuario_bloc.dart';

sealed class LoginUsuarioState {}

final class LoginUsuarioInitial extends LoginUsuarioState {}

final class LoginUsuarioLoading extends LoginUsuarioState {}

final class LoginUsuarioSuccess extends LoginUsuarioState {
  final Usuario usuario;
  LoginUsuarioSuccess({required this.usuario});
}

final class LoginUsuarioFailure extends LoginUsuarioState {
  final Failure failure;
  LoginUsuarioFailure({required this.failure});
}