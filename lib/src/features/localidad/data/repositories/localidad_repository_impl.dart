import 'dart:ffi';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/features/localidad/data/datasource/localidad_remote_datasource.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';
import 'package:labproyecto2025/src/features/localidad/domain/repositories/localidad_repository.dart';

class LocalidadRepositoryImpl implements LocalidadRepository {
  //final LocalidadLocalDataSource localidadLocalDataSource;
  final LocalidadRemoteDatasource localidadRemoteDatasource;

  LocalidadRepositoryImpl({
    //required this.localidadLocalDataSource,
    required this.localidadRemoteDatasource,
  });

  @override
  Future<Either<Failure, bool>> save(Localidad localidad) async {
    try {
      final bool resp = await localidadRemoteDatasource.save(localidad);
      return Right(resp);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, Localidad>>load(int id) async {
    try {
      final Localidad localidad = await localidadRemoteDatasource.load(id);
      return Right(localidad);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>>delete(int id) async {
    try {
      final bool localidad = await localidadRemoteDatasource.delete(id);
      return Right(localidad);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Localidad>>> list(
    int ?id,
    String ?nombre,
    int ?codPostal,
    String ?provinciaId,
  ) async {
    try {
      final List<Localidad> resp = await localidadRemoteDatasource.list(
        nombre: nombre,
        codPostal: codPostal,
        provinciaId: provinciaId,
      );
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(
    Localidad localidad
  ) async {
    try {
      final bool resp = await localidadRemoteDatasource.update(localidad );
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

}