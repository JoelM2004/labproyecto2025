part of 'list_localidad_bloc.dart';

sealed class ListLocalidadState {}

final class ListLocalidadInitial extends ListLocalidadState {}

final class ListLocalidadLoading extends ListLocalidadState {}

final class ListLocalidadSuccess extends ListLocalidadState {
  final List<Localidad> localidades;
  ListLocalidadSuccess({required this.localidades});
}

final class ListLocalidadFailure extends ListLocalidadState {
  final Failure failure;
  ListLocalidadFailure({required this.failure});
}