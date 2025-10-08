import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';
import 'package:labproyecto2025/src/features/provincia/domain/repositories/provincia_repository.dart';

class LoadProvinciaUseCase{
    final ProvinciaRepository repository;

    LoadProvinciaUseCase({required this.repository});
    
    Future<Either<Failure, Provincia>> call(int id) {
        return repository.load(id);
      }


}