import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/repositories/provincia_repository.dart';

class DeleteProvinciaUseCase{
    final ProvinciaRepository repository;

    DeleteProvinciaUseCase({required this.repository});
    
    Future<Either<Failure,bool>> call(int id) {
        return repository.delete(id);
      }


}