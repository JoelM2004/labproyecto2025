import 'package:get_it/get_it.dart';
import 'package:labproyecto2025/src/features/localidad/data/datasource/localidad_remote_datasource.dart';
import 'package:labproyecto2025/src/features/provincia/data/datasource/provincia_remote_datasource.dart';

final di = GetIt.instance;

void initDatasource() {
  di.registerLazySingleton<ProvinciaRemoteDatasource>(
    () => ProvinciaRemoteDataSourceImpl(),
  );

  di.registerLazySingleton<LocalidadRemoteDatasource>(
    () => LocalidadRemoteDataSourceImpl(),
  );
}
