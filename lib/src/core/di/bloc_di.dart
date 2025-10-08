import 'package:get_it/get_it.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/delete_localidad/delete_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/list_localidad/list_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/load_localidad/load_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/save_localidad/save_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/update_localidad/update_localidad_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/delete_provincia/delete_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/list_provincia/list_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/load_provincia/load_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/save_provincia/save_provincia_bloc.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/update_provincia/update_provincia_bloc.dart';

final di = GetIt.instance;

void initBlocs() {
  di.registerFactory(() => LoadProvinciaBloc(di()));
  di.registerFactory(() => DeleteProvinciaBloc(di()));
  di.registerFactory(() => ListProvinciaBloc(di()));
  di.registerFactory(() => SaveProvinciaBloc(di()));
  di.registerFactory(() => UpdateProvinciaBloc(di()));

  di.registerFactory(() => LoadLocalidadBloc(di()));
  di.registerFactory(() => DeleteLocalidadBloc(di()));
  di.registerFactory(() => ListLocalidadBloc(di()));
  di.registerFactory(() => SaveLocalidadBloc(di()));
  di.registerFactory(() => UpdateLocalidadBloc(di()));
}
