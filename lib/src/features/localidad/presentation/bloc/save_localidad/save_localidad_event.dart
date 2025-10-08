part of 'save_localidad_bloc.dart';

sealed class SaveLocalidadEvent {}

class SaveLocalidad extends SaveLocalidadEvent {
  final Localidad localidad;
  SaveLocalidad({required this.localidad});
}