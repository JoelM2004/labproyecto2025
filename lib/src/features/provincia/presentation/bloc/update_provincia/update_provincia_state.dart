part of 'update_provincia_bloc.dart';

sealed class UpdateProvinciaState {}

final class UpdateProvinciaInitial extends UpdateProvinciaState {}

final class UpdateProvinciaLoading extends UpdateProvinciaState {}

final class UpdateProvinciaSuccess extends UpdateProvinciaState {
  final bool provincia;
  UpdateProvinciaSuccess({required this.provincia});
}

final class UpdateProvinciaFailure extends UpdateProvinciaState {
  final Failure failure;
  UpdateProvinciaFailure({required this.failure});
}