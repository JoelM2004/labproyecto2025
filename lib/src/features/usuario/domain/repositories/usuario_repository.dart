import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/usuario/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Either<Failure, Usuario>> login(String cuenta, String contrasena);
  Future<Either<Failure, bool>> logout();
}
