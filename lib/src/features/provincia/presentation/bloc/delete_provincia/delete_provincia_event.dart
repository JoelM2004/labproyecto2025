part of 'delete_provincia_bloc.dart';

sealed class DeleteProvinciaEvent {}

class DeleteProvincia extends DeleteProvinciaEvent {
  final int id;
  DeleteProvincia({required this.id});
}