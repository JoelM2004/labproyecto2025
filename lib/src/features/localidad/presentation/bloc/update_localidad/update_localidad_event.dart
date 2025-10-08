part of 'update_localidad_bloc.dart';

sealed class UpdateLocalidadEvent {}

class UpdateLocalidad extends UpdateLocalidadEvent {
  final Localidad localidad;
  UpdateLocalidad({required this.localidad});
}