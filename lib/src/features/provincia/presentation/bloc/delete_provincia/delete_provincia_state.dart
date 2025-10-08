part of 'delete_provincia_bloc.dart';

sealed class DeleteProvinciaState {}

final class DeleteProvinciaInitial extends DeleteProvinciaState {}

final class DeleteProvinciaLoading extends DeleteProvinciaState {}

final class DeleteProvinciaSuccess extends DeleteProvinciaState {
  final bool provincia;
  DeleteProvinciaSuccess({required this.provincia});
}

final class DeleteProvinciaFailure extends DeleteProvinciaState {
  final Failure failure;
  DeleteProvinciaFailure({required this.failure});
}