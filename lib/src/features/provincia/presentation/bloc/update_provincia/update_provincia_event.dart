part of 'update_provincia_bloc.dart';

sealed class UpdateProvinciaEvent {}

class UpdateProvincia extends UpdateProvinciaEvent {
  final Provincia provincia;
  UpdateProvincia({required this.provincia});
}