part of 'list_localidad_bloc.dart';

sealed class ListLocalidadEvent {}

class ListLocalidad extends ListLocalidadEvent {
  final int ?id;
  final String ?nombre;
  final int ?codPostal;
  final String ?provinciaId;
  ListLocalidad({this.id ,this.nombre,this.codPostal,this.provinciaId});
}