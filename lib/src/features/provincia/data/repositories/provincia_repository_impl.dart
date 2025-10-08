import 'dart:ffi';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:labproyecto2025/src/features/provincia/data/datasource/provincia_remote_datasource.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';
import 'package:labproyecto2025/src/features/provincia/domain/repositories/provincia_repository.dart';

class ProvinciaRepositoryImpl implements ProvinciaRepository {
  //final ProvinciaLocalDataSource provinciaLocalDataSource;
  final ProvinciaRemoteDatasource provinciaRemoteDatasource;

  ProvinciaRepositoryImpl({
    //required this.provinciaLocalDataSource,
    required this.provinciaRemoteDatasource,
  });

  @override
  Future<Either<Failure, bool>> save(Provincia provincia) async {
    try {
      final bool resp = await provinciaRemoteDatasource.save(provincia);
      return Right(resp);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, Provincia>>load(int id) async {
    try {
      final Provincia provincia = await provinciaRemoteDatasource.load(id);
      return Right(provincia);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>>delete(int id) async {
    try {
      final bool provincia = await provinciaRemoteDatasource.delete(id);
      return Right(provincia);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Provincia>>> list(
    String ?nombre,
    int ?codPostal,
    int ?id,
  ) async {
    try {
      final List<Provincia> resp = await provinciaRemoteDatasource.list(
        nombre: nombre,
        codPostal: codPostal,
        id: id,
      );
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(
    Provincia provincia
  ) async {
    try {
      final bool resp = await provinciaRemoteDatasource.update(provincia );
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

}