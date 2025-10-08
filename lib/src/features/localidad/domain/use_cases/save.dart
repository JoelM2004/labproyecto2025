import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';
import 'package:labproyecto2025/src/features/localidad/domain/repositories/localidad_repository.dart';

class SaveLocalidadUseCase{
    final LocalidadRepository repository;

    SaveLocalidadUseCase({required this.repository});
    
    Future<Either<Failure, bool>> call(Localidad localidad) {
        return repository.save(localidad);
      }


}