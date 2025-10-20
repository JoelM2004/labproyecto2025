import 'package:dio/dio.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';
import 'package:labproyecto2025/src/features/localidad/data/models/localidad_model.dart';
import 'package:labproyecto2025/src/app/dio_client.dart';

abstract class LocalidadRemoteDatasource {
  Future<bool> save(Localidad localidad);
  Future<Localidad> load(int id);
  Future<bool> delete(int id);
  Future<List<Localidad>> list({
    String? nombre,
    int? codPostal,
    String? provinciaId,
  });
  Future<bool> update(Localidad localidad);
}

class LocalidadRemoteDataSourceImpl implements LocalidadRemoteDatasource {
  Dio get dio => DioClient.dio;

  @override
  Future<bool> save(Localidad localidad) async {
    try {
      final model = LocalidadModel.fromEntity(localidad);
      final jsonData = model.toJson();
      
      // No enviar el ID en save (el backend lo genera)
      jsonData.remove('id');
      final response = await dio.post("/localidad", data: jsonData);
      
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {  
      String errorMessage = "Error al guardar localidad";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    } catch (e) {
      throw Exception("Error al guardar localidad: $e");
    }
  }

  @override
  Future<Localidad> load(int id) async {
    try {
      final response = await dio.get("/localidad/$id");
      if (response.statusCode == 200) {
        final data = response.data["result"];
        return LocalidadModel.fromJson(data);
      } else {
        throw Exception("Error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al cargar localidad: $e");
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final response = await dio.delete("/localidad/$id");
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      
      String errorMessage = "Error al eliminar localidad";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    } catch (e) {
      throw Exception("Error al eliminar localidad: $e");
    }
  }

  @override
  Future<List<Localidad>> list({
    String? nombre,
    int? codPostal,
    String? provinciaId,
  }) async {
    try {
      final queryParams = {
        if (nombre != null && nombre.isNotEmpty) 'nombre': nombre,
        if (codPostal != null) 'codPostal': codPostal,
        if (provinciaId != null && provinciaId.isNotEmpty) 'provinciaId': provinciaId,
      };

      final response = await dio.get("/localidad", queryParameters: queryParams);

      if (response.statusCode == 200) {
        final dynamic resultData = response.data["result"];

        if (resultData == null) {
          return [];
        }

        if (resultData is List) {
          if (resultData.isEmpty) {
            return [];
          }
            return _parseLocalidadesList(resultData);
        }

        // Caso 3: result es un Map que contiene la lista
        if (resultData is Map<String, dynamic>) {
          // ⭐ CASO ESPECÍFICO: Tu backend devuelve {$localidades: [...], ...}
          if (resultData.containsKey('\$localidades')) {
            final localidadesData = resultData['\$localidades'];
            
            if (localidadesData is List) {
              return _parseLocalidadesList(localidadesData);
            } else {
              throw Exception("'\$localidades' no es una lista: ${localidadesData.runtimeType}");
            }
          }
          
          // Intentar con 'localidades' (sin $)
          if (resultData.containsKey('localidades')) {
            final localidadesData = resultData['localidades'];
            
            if (localidadesData is List) {
              return _parseLocalidadesList(localidadesData);
            }
          }
          
          return [LocalidadModel.fromJson(resultData)];
        }

        // Caso 4: result es Map sin tipo genérico
        if (resultData is Map) {
          final typedMap = Map<String, dynamic>.from(resultData);
          
          // Verificar si tiene $localidades
          if (typedMap.containsKey('\$localidades')) {
            final localidadesData = typedMap['\$localidades'];
            if (localidadesData is List) {
              return _parseLocalidadesList(localidadesData);
            }
          }
          
          return [LocalidadModel.fromJson(typedMap)];
        }

        // Caso 5: tipo no reconocido
        throw Exception(
          "Tipo inesperado en 'result': ${resultData.runtimeType}\n"
          "Valor: $resultData"
        );
        
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.data}");
      }
    } catch (e, stackTrace) {

      throw Exception("Error al listar localidades: $e");
    }
  }

  @override
  Future<bool> update(Localidad localidad) async {
    try {
      final model = LocalidadModel.fromEntity(localidad);
      final jsonData = model.toJson();
      
      final response = await dio.put(
        "/localidad/${localidad.id}",
        data: jsonData,
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      // Extraer mensaje de error del backend si existe
      String errorMessage = "Error al actualizar localidad";
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          final errorData = e.response!.data;
          errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
        } else {
          errorMessage = e.response!.data.toString();
        }
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    } catch (e) {
      throw Exception("Error al actualizar localidad: $e");
    }
  }

  // ⭐ MÉTODO AUXILIAR PARA PARSEAR LA LISTA
  List<Localidad> _parseLocalidadesList(List<dynamic> list) {
    return list.map((item) {
      try {
        if (item is Map<String, dynamic>) {
          return LocalidadModel.fromJson(item);
        } else if (item is Map) {
          return LocalidadModel.fromJson(Map<String, dynamic>.from(item));
        } else {
          throw Exception("Item no es Map: ${item.runtimeType}");
        }
      } catch (e) {
        rethrow;
      }
    }).toList();
  }
}