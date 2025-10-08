import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';
import 'package:labproyecto2025/src/features/provincia/domain/repositories/provincia_repository.dart';

class SaveProvinciaUseCase{
    final ProvinciaRepository repository;

    SaveProvinciaUseCase({required this.repository});
    
    Future<Either<Failure, bool>> call(Provincia provincia) {
        return repository.save(provincia);
      }


}