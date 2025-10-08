part of 'list_provincia_bloc.dart';

sealed class ListProvinciaEvent {}

class ListProvincia extends ListProvinciaEvent {
  final int ?id;
  final String ?nombre;
  final int ?codPostal;
  ListProvincia({this.nombre,this.codPostal,this.id});
}