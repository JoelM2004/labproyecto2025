part of 'load_localidad_bloc.dart';

sealed class LoadLocalidadEvent {}

class LoadLocalidad extends LoadLocalidadEvent {
  final int id;
  LoadLocalidad({required this.id});
}