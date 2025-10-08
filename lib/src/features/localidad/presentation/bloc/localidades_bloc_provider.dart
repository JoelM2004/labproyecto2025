import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'delete_localidad/delete_localidad_bloc.dart';
import 'list_localidad/list_localidad_bloc.dart';
import 'load_localidad/load_localidad_bloc.dart';
import 'save_localidad/save_localidad_bloc.dart';
import 'update_localidad/update_localidad_bloc.dart';

class LocalidadBlocProviders {
  static final providers = [
    BlocProvider<LoadLocalidadBloc>(
      create: (_) => GetIt.instance.get<LoadLocalidadBloc>(),
    ),
    BlocProvider<SaveLocalidadBloc>(
      create: (_) => GetIt.instance.get<SaveLocalidadBloc>(),
    ),
    BlocProvider<UpdateLocalidadBloc>(
      create: (_) => GetIt.instance.get<UpdateLocalidadBloc>(),
    ),
    BlocProvider<ListLocalidadBloc>(
      create: (_) => GetIt.instance.get<ListLocalidadBloc>(),
    ),
    BlocProvider<DeleteLocalidadBloc>(
      create: (_) => GetIt.instance.get<DeleteLocalidadBloc>(),
    ),
  ];
}