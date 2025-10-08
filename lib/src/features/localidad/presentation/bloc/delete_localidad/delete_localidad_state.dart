part of 'delete_localidad_bloc.dart';

sealed class DeleteLocalidadState {}

final class DeleteLocalidadInitial extends DeleteLocalidadState {}

final class DeleteLocalidadLoading extends DeleteLocalidadState {}

final class DeleteLocalidadSuccess extends DeleteLocalidadState {
  final bool localidad;
  DeleteLocalidadSuccess({required this.localidad});
}

final class DeleteLocalidadFailure extends DeleteLocalidadState {
  final Failure failure;
  DeleteLocalidadFailure({required this.failure});
}