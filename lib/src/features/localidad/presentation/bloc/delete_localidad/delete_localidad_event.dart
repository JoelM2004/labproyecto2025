part of 'delete_localidad_bloc.dart';

sealed class DeleteLocalidadEvent {}

class DeleteLocalidad extends DeleteLocalidadEvent {
  final int id;
  DeleteLocalidad({required this.id});
}