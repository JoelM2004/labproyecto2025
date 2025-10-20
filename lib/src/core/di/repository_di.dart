import 'package:get_it/get_it.dart';
import 'package:labproyecto2025/src/features/localidad/data/repositories/localidad_repository_impl.dart';
import 'package:labproyecto2025/src/features/localidad/domain/repositories/localidad_repository.dart';
import 'package:labproyecto2025/src/features/provincia/data/repositories/provincia_repository_impl.dart';
import 'package:labproyecto2025/src/features/provincia/domain/repositories/provincia_repository.dart';
import 'package:labproyecto2025/src/features/usuario/data/repositories/usuario_repository_impl.dart';
import 'package:labproyecto2025/src/features/usuario/domain/repositories/usuario_repository.dart';

final di = GetIt.instance;

void initRepository() {
  di.registerLazySingleton<ProvinciaRepository>(
    () => ProvinciaRepositoryImpl(
      provinciaRemoteDatasource: di(), // obtiene datasource inyectado
    ),
    
  );

  di.registerLazySingleton<LocalidadRepository>(
    () => LocalidadRepositoryImpl(
      localidadRemoteDatasource: di(), // obtiene datasource inyectado
    ),
    
  );

  di.registerLazySingleton<UsuarioRepository>(
    () => UsuarioRepositoryImpl(
      usuarioRemoteDatasource: di(), // obtiene datasource inyectado
    ),
    
  );
}
