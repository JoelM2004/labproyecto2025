
import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';

abstract class ProvinciaRepository {
  Future<Either<Failure, bool>> save(Provincia provincia);
  Future<Either<Failure, Provincia>> load(int id);
  Future<Either<Failure, bool>> delete(int id);
  Future<Either<Failure, List<Provincia>>> list(
      String? nombre,
      int? codPostal,
      int? id,
      );  
  Future<Either<Failure, bool>> update(Provincia provincia);

      
}