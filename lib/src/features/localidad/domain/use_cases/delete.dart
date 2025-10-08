import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/repositories/localidad_repository.dart';

class DeleteLocalidadUseCase{
    final LocalidadRepository repository;

    DeleteLocalidadUseCase({required this.repository});
    
    Future<Either<Failure,bool>> call(int id) {
        return repository.delete(id);
      }


}