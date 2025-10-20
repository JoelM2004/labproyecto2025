part of 'login_usuario_bloc.dart';

sealed class LoginUsuarioEvent {}

class LoginUsuario extends LoginUsuarioEvent {
  final String cuenta;
  final String contrasena;
  LoginUsuario({required this.cuenta, required this.contrasena});
}