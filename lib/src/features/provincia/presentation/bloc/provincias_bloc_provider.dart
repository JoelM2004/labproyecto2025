import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'delete_provincia/delete_provincia_bloc.dart';
import 'list_provincia/list_provincia_bloc.dart';
import 'load_provincia/load_provincia_bloc.dart';
import 'save_provincia/save_provincia_bloc.dart';
import 'update_provincia/update_provincia_bloc.dart';

class ProvinciaBlocProviders {
  static final providers = [
    BlocProvider<LoadProvinciaBloc>(
      create: (_) => GetIt.instance.get<LoadProvinciaBloc>(),
    ),
    BlocProvider<SaveProvinciaBloc>(
      create: (_) => GetIt.instance.get<SaveProvinciaBloc>(),
    ),
    BlocProvider<UpdateProvinciaBloc>(
      create: (_) => GetIt.instance.get<UpdateProvinciaBloc>(),
    ),
    BlocProvider<ListProvinciaBloc>(
      create: (_) => GetIt.instance.get<ListProvinciaBloc>(),
    ),
    BlocProvider<DeleteProvinciaBloc>(
      create: (_) => GetIt.instance.get<DeleteProvinciaBloc>(),
    ),
  ];
}