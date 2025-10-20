import 'dart:ffi';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/features/usuario/data/datasource/usuario_remote_datasource.dart';
import 'package:labproyecto2025/src/features/usuario/domain/entities/usuario.dart';
import 'package:labproyecto2025/src/features/usuario/domain/repositories/usuario_repository.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  //final UsuarioLocalDataSource UsuarioLocalDataSource;
  final UsuarioRemoteDatasource usuarioRemoteDatasource;

  UsuarioRepositoryImpl({
    //required this.usuarioLocalDataSource,
    required this.usuarioRemoteDatasource,
  });

  @override
  Future<Either<Failure, Usuario>> login(String cuenta, String contrasena) async {
    try {
      final usuario = await usuarioRemoteDatasource.login(cuenta, contrasena);
      return Right(usuario);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure());
    }
  }


  @override
  Future<Either<Failure, bool>>logout() async {
    try {
      final bool resp = await usuarioRemoteDatasource.logout();
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

}