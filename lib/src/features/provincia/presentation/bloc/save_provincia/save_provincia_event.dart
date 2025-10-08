part of 'save_provincia_bloc.dart';

sealed class SaveProvinciaEvent {}

class SaveProvincia extends SaveProvinciaEvent {
  final Provincia provincia;
  SaveProvincia({required this.provincia});
}