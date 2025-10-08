// localidad_remote_datasource.dart - CORREGIDO CON DIO

import 'package:dio/dio.dart';
import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';
import 'package:labproyecto2025/src/features/localidad/data/models/localidad_model.dart';

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
  final Dio dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2/provincias/public",
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {"Content-Type": "application/json"},
  ));

  @override
  Future<bool> save(Localidad localidad) async {
    try {
      final model = LocalidadModel.fromEntity(localidad);
      final jsonData = model.toJson();
      
      // No enviar el ID en save (el backend lo genera)
      jsonData.remove('id');
      
      print("📤 Save request: POST /localidad");
      print("📤 Save data: $jsonData");
      
      final response = await dio.post("/localidad", data: jsonData);
      
      print("📥 Save response status: ${response.statusCode}");
      print("📥 Save data: ${response.data}");
      
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      print("❌ DioException al guardar localidad:");
      print("   Status code: ${e.response?.statusCode}");
      print("   Response data: ${e.response?.data}");
      print("   Request data: ${e.requestOptions.data}");
      
      String errorMessage = "Error al guardar localidad";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    } catch (e) {
      print("❌ Error inesperado al guardar localidad: $e");
      throw Exception("Error al guardar localidad: $e");
    }
  }

  @override
  Future<Localidad> load(int id) async {
    try {
      final response = await dio.get("/localidad/$id");

      print("📥 Load response: ${response.statusCode}");
      print("📥 Load data: ${response.data}");

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
      print("🗑️ Delete request: DELETE /localidad/$id");
      
      final response = await dio.delete("/localidad/$id");
      
      print("📥 Delete response status: ${response.statusCode}");
      print("📥 Delete response data: ${response.data}");
      
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      print("❌ DioException al eliminar localidad:");
      print("   Status code: ${e.response?.statusCode}");
      print("   Response data: ${e.response?.data}");
      
      String errorMessage = "Error al eliminar localidad";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    } catch (e) {
      print("❌ Error inesperado al eliminar localidad: $e");
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

      print("🌐 List request: GET /localidad");
      print("🔍 Query params: $queryParams");

      final response = await dio.get("/localidad", queryParameters: queryParams);

      print("📥 List response status: ${response.statusCode}");
      print("📥 List response data: ${response.data}");

      if (response.statusCode == 200) {
        final dynamic resultData = response.data["result"];
        
        print("📦 Result type: ${resultData.runtimeType}");
        print("📦 Result content: $resultData");

        // Caso 1: result es null
        if (resultData == null) {
          print("⚠️ Result es null → lista vacía");
          return [];
        }

        // Caso 2: result es directamente una lista
        if (resultData is List) {
          if (resultData.isEmpty) {
            print("⚠️ Result es lista vacía");
            return [];
          }
          
          print("✅ Result es lista con ${resultData.length} elementos");
          return _parseLocalidadesList(resultData);
        }

        // Caso 3: result es un Map que contiene la lista
        if (resultData is Map<String, dynamic>) {
          // ⭐ CASO ESPECÍFICO: Tu backend devuelve {$localidads: [...], totalLocalidades: 6}
          if (resultData.containsKey('\$localidades')) {
            print("✅ Encontrado key '\$localidades'");
            final localidadesData = resultData['\$localidades'];
            
            if (localidadesData is List) {
              print("✅ \$localidades es lista con ${localidadesData.length} elementos");
              return _parseLocalidadesList(localidadesData);
            } else {
              throw Exception("'\$localidades' no es una lista: ${localidadesData.runtimeType}");
            }
          }
          
          // Intentar con 'localidads' (sin $)
          if (resultData.containsKey('localidades')) {
            print("✅ Encontrado key 'localidades'");
            final localidadesData = resultData['localidades'];
            
            if (localidadesData is List) {
              print("✅ localidads es lista con ${localidadesData.length} elementos");
              return _parseLocalidadesList(localidadesData);
            }
          }
          
          // Si no tiene ninguna key conocida, es un objeto único
          print("⚠️ Result es objeto único → convirtiéndolo a lista");
          return [LocalidadModel.fromJson(resultData)];
        }

        // Caso 4: result es Map sin tipo genérico
        if (resultData is Map) {
          print("⚠️ Result es Map genérico");
          final typedMap = Map<String, dynamic>.from(resultData);
          
          // Verificar si tiene $localidads
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
      print("❌ Error al listar localidads: $e");
      print("📋 Stack: $stackTrace");
      throw Exception("Error al listar localidads: $e");
    }
  }

  @override
  Future<bool> update(Localidad localidad) async {
    try {
      final model = LocalidadModel.fromEntity(localidad);
      final jsonData = model.toJson();
      
      print("🔄 Update request: PUT /localidad/${localidad.id}");
      print("📤 Update data: $jsonData");
      
      final response = await dio.put(
        "/localidad/${localidad.id}",
        data: jsonData,
      );
      
      print("📥 Update response status: ${response.statusCode}");
      print("📥 Update response data: ${response.data}");
      
      return response.statusCode == 200;
    } on DioException catch (e) {
      print("❌ DioException al actualizar localidad:");
      print("   Status code: ${e.response?.statusCode}");
      print("   Response data: ${e.response?.data}");
      print("   Request data: ${e.requestOptions.data}");
      print("   URL: ${e.requestOptions.uri}");
      
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
      print("❌ Error inesperado al actualizar localidad: $e");
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
        print("❌ Error parseando item: $item");
        print("❌ Error: $e");
        rethrow;
      }
    }).toList();
  }
}