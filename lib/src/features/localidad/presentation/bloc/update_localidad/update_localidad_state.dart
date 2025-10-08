part of 'update_localidad_bloc.dart';

sealed class UpdateLocalidadState {}

final class UpdateLocalidadInitial extends UpdateLocalidadState {}

final class UpdateLocalidadLoading extends UpdateLocalidadState {}

final class UpdateLocalidadSuccess extends UpdateLocalidadState {
  final bool localidad;
  UpdateLocalidadSuccess({required this.localidad});
}

final class UpdateLocalidadFailure extends UpdateLocalidadState {
  final Failure failure;
  UpdateLocalidadFailure({required this.failure});
}