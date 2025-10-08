
import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';

abstract class LocalidadRepository {
  Future<Either<Failure, bool>> save(Localidad localidad);
  Future<Either<Failure, Localidad>> load(int id);
  Future<Either<Failure, bool>> delete(int id);
  Future<Either<Failure, List<Localidad>>> list(
      int? id,
      String? nombre,
      int? codPostal,
      String? provinciaId,
      );  
  Future<Either<Failure, bool>> update(Localidad localidad);

      
}