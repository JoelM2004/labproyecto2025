part of 'save_provincia_bloc.dart';

sealed class SaveProvinciaState {}

final class SaveProvinciaInitial extends SaveProvinciaState {}

final class SaveProvinciaLoading extends SaveProvinciaState {}

final class SaveProvinciaSuccess extends SaveProvinciaState {
  final bool provincia;
  SaveProvinciaSuccess({required this.provincia});
}

final class SaveProvinciaFailure extends SaveProvinciaState {
  final Failure failure;
  SaveProvinciaFailure({required this.failure});
}