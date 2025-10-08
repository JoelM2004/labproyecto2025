import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';
import 'package:labproyecto2025/src/features/localidad/domain/repositories/localidad_repository.dart';

class ListLocalidadUseCase{
    final LocalidadRepository repository;

    ListLocalidadUseCase({required this.repository});
    Future<Either<Failure, List<Localidad>>> call(
      int ?id,
      String ?nombre,
      int ?codPostal,
      String ?provinciaId,
      ) {
        return repository.list(id,nombre, codPostal, provinciaId);
      }


}