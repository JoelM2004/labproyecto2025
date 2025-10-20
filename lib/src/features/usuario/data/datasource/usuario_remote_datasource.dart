// usuario_remote_datasource.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:labproyecto2025/src/app/dio_client.dart';
import 'package:labproyecto2025/src/core/error/failures.dart';
import 'package:labproyecto2025/src/features/usuario/domain/entities/usuario.dart';
import 'package:labproyecto2025/src/features/usuario/data/models/usuario_model.dart';
import 'package:labproyecto2025/src/core/session.dart';

abstract class UsuarioRemoteDatasource {
  Future<Usuario> login(String cuenta, String contrasena);
  Future<bool> logout();
  Future<bool> restoreSession();
}

class UsuarioRemoteDataSourceImpl implements UsuarioRemoteDatasource {
  Dio get dio => DioClient.dio;

  @override
  Future<UsuarioModel> login(String cuenta, String contrasena) async {
    try {
      final response = await dio.post('/authentication',
          data: {'account': cuenta, 'password': contrasena});

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final respData = data['data'];
          final token = respData['token'];
          final userData = respData['user'];

          final usuario = UsuarioModel(
            id: userData['id'] is int
                ? userData['id']
                : int.tryParse(userData['id'].toString()) ?? 0,
            nombres: userData['nombres'] ?? '',
            apellido: userData['apellido'] ?? '',
            cuenta: userData['cuenta'] ?? '',
            token: token ?? '',
          );

          await DioClient.saveToken(token);
          Session.currentUser = usuario;
          return usuario;
        } else {
          throw ServerFailure();
        }
      }

      throw ServerFailure();
    } on DioException catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<bool> logout() async {
    try {
      
      if (Session.currentUser == null) {
        return false;
      }
      
      // El token se agrega automáticamente por el interceptor
      final response = await dio.delete(
        '/authentication/${Session.currentUser?.id}',
      );
      
      if (response.statusCode == 200) {
        await DioClient.clearToken();
        Session.currentUser = null;
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      // Limpiar la sesión local incluso si falla el servidor
      await DioClient.clearToken();
      Session.currentUser = null;
      return false;
    }
  }

  @override
  Future<bool> restoreSession() async {
    try {
      if (!await DioClient.hasToken()) {
        print("ℹ️ No hay token guardado");
        return false;
      }

      print("🔄 Restaurando sesión...");

      // El token se agrega automáticamente por el interceptor
      final response = await dio.get('/authentication');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final userData = response.data['data'];

        final usuario = UsuarioModel(
          id: userData['id'] is int 
              ? userData['id'] 
              : int.tryParse(userData['id'].toString()) ?? 0,
          nombres: userData['nombres'] ?? '',
          apellido: userData['apellido'] ?? '',
          cuenta: userData['cuenta'] ?? '',
          token: '', // El token ya está en el cliente
        );

        Session.currentUser = usuario;
        print("✅ Sesión restaurada: ${usuario.nombres}");
        return true;
      }

      print("⚠️ Token inválido o expirado, limpiando sesión...");
      await DioClient.clearToken();
      Session.currentUser = null;
      return false;

    } catch (e) {
      print("❌ Error restaurando sesión: $e");
      await DioClient.clearToken();
      Session.currentUser = null;
      return false;
    }
  }
}