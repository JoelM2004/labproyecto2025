part of 'load_localidad_bloc.dart';

sealed class LoadLocalidadState {}

final class LoadLocalidadInitial extends LoadLocalidadState {}

final class LoadLocalidadLoading extends LoadLocalidadState {}

final class LoadLocalidadSuccess extends LoadLocalidadState {
  final Localidad localidad;
  LoadLocalidadSuccess({required this.localidad});
}

final class LoadLocalidadFailure extends LoadLocalidadState {
  final Failure failure;
  LoadLocalidadFailure({required this.failure});
}