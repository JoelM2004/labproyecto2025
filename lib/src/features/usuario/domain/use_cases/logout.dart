import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/usuario/domain/repositories/usuario_repository.dart';

class LogoutUsuarioUseCase{
    final UsuarioRepository repository;

    LogoutUsuarioUseCase({required this.repository});
    
    Future<Either<Failure,bool>> call() {
        return repository.logout();
      }


}