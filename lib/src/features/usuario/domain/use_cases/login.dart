import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/usuario/domain/entities/usuario.dart';
import 'package:labproyecto2025/src/features/usuario/domain/repositories/usuario_repository.dart';

class LoginUsuarioUseCase {
  final UsuarioRepository repository;

  LoginUsuarioUseCase({required this.repository});

  Future<Either<Failure, Usuario>> call(String cuenta, String contrasena) {
    return repository.login(cuenta, contrasena);
  }
}
