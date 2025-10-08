part of 'load_provincia_bloc.dart';

sealed class LoadProvinciaState {}

final class LoadProvinciaInitial extends LoadProvinciaState {}

final class LoadProvinciaLoading extends LoadProvinciaState {}

final class LoadProvinciaSuccess extends LoadProvinciaState {
  final Provincia provincia;
  LoadProvinciaSuccess({required this.provincia});
}

final class LoadProvinciaFailure extends LoadProvinciaState {
  final Failure failure;
  LoadProvinciaFailure({required this.failure});
}