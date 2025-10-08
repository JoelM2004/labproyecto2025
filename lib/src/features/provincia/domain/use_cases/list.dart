import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';
import 'package:labproyecto2025/src/features/provincia/domain/repositories/provincia_repository.dart';

class ListProvinciaUseCase{
    final ProvinciaRepository repository;

    ListProvinciaUseCase({required this.repository});
    Future<Either<Failure, List<Provincia>>> call(
      String ?nombre,
      int ?codPostal,
      int ?id,
      ) {
        return repository.list(nombre, codPostal, id);
      }


}