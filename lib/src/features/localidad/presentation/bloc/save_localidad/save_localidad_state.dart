part of 'save_localidad_bloc.dart';

sealed class SaveLocalidadState {}

final class SaveLocalidadInitial extends SaveLocalidadState {}

final class SaveLocalidadLoading extends SaveLocalidadState {}

final class SaveLocalidadSuccess extends SaveLocalidadState {
  final bool localidad;
  SaveLocalidadSuccess({required this.localidad});
}

final class SaveLocalidadFailure extends SaveLocalidadState {
  final Failure failure;
  SaveLocalidadFailure({required this.failure});
}