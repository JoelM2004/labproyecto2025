import 'package:labproyecto2025/src/core/di/bloc_di.dart';
import 'package:labproyecto2025/src/core/di/data_source_di.dart';
import 'package:labproyecto2025/src/core/di/repository_di.dart';
import 'package:labproyecto2025/src/core/di/usecase_di.dart';

Future<void> init() async {
  initDatasource();
  initRepository();
  initUseCases();
  initBlocs();
}
