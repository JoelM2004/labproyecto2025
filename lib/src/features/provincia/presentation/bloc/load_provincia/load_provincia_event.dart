part of 'load_provincia_bloc.dart';

sealed class LoadProvinciaEvent {}

class LoadProvincia extends LoadProvinciaEvent {
  final int id;
  LoadProvincia({required this.id});
}