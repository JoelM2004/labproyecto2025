import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';
import 'package:labproyecto2025/src/features/localidad/domain/repositories/localidad_repository.dart';

class LoadLocalidadUseCase{
    final LocalidadRepository repository;

    LoadLocalidadUseCase({required this.repository});
    
    Future<Either<Failure, Localidad>> call(int id) {
        return repository.load(id);
      }


}