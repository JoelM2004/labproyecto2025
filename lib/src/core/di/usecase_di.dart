import 'package:get_it/get_it.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/delete.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/list.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/load.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/save.dart';
import 'package:labproyecto2025/src/features/localidad/domain/use_cases/update.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/delete.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/list.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/load.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/save.dart';
import 'package:labproyecto2025/src/features/provincia/domain/use_cases/update.dart';
import 'package:labproyecto2025/src/features/usuario/domain/use_cases/login.dart';
import 'package:labproyecto2025/src/features/usuario/domain/use_cases/logout.dart';

final di = GetIt.instance;

void initUseCases() {
  di.registerLazySingleton(() => LoadProvinciaUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteProvinciaUseCase(repository: di()));
  di.registerLazySingleton(() => SaveProvinciaUseCase(repository: di()));
  di.registerLazySingleton(() => UpdateProvinciaUseCase(repository: di()));
  di.registerLazySingleton(() => ListProvinciaUseCase(repository: di()));

  di.registerLazySingleton(() => LoadLocalidadUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteLocalidadUseCase(repository: di()));
  di.registerLazySingleton(() => SaveLocalidadUseCase(repository: di()));
  di.registerLazySingleton(() => UpdateLocalidadUseCase(repository: di()));
  di.registerLazySingleton(() => ListLocalidadUseCase(repository: di()));

  di.registerLazySingleton(() => LogoutUsuarioUseCase(repository: di()));
  di.registerLazySingleton(() => LoginUsuarioUseCase(repository: di()));
}
