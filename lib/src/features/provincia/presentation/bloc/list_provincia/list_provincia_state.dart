part of 'list_provincia_bloc.dart';

sealed class ListProvinciaState {}

final class ListProvinciaInitial extends ListProvinciaState {}

final class ListProvinciaLoading extends ListProvinciaState {}

final class ListProvinciaSuccess extends ListProvinciaState {
  final List<Provincia> provincias;
  ListProvinciaSuccess({required this.provincias});
}

final class ListProvinciaFailure extends ListProvinciaState {
  final Failure failure;
  ListProvinciaFailure({required this.failure});
}