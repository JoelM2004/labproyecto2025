// provincia_remote_datasource.dart - CORREGIDO CON DIO

import 'package:dio/dio.dart';
import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';
import 'package:labproyecto2025/src/features/provincia/data/models/provincia_model.dart';

abstract class ProvinciaRemoteDatasource {
  Future<bool> save(Provincia provincia);
  Future<Provincia> load(int id);
  Future<bool> delete(int id);
  Future<List<Provincia>> list({
    String? nombre,
    int? codPostal,
    int? id,
  });
  Future<bool> update(Provincia provincia);
}

class ProvinciaRemoteDataSourceImpl implements ProvinciaRemoteDatasource {
  final Dio dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2/provincias/public",
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {"Content-Type": "application/json"},
  ));

  @override
  Future<bool> save(Provincia provincia) async {
    try {
      final model = ProvinciaModel.fromEntity(provincia);
      final jsonData = model.toJson();
      
      // No enviar el ID en save (el backend lo genera)
      jsonData.remove('id');
      
      print("📤 Save request: POST /provincia");
      print("📤 Save data: $jsonData");
      
      final response = await dio.post("/provincia", data: jsonData);
      
      print("📥 Save response status: ${response.statusCode}");
      print("📥 Save data: ${response.data}");
      
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      print("❌ DioException al guardar provincia:");
      print("   Status code: ${e.response?.statusCode}");
      print("   Response data: ${e.response?.data}");
      print("   Request data: ${e.requestOptions.data}");
      
      String errorMessage = "Error al guardar provincia";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    } catch (e) {
      print("❌ Error inesperado al guardar provincia: $e");
      throw Exception("Error al guardar provincia: $e");
    }
  }

  @override
  Future<Provincia> load(int id) async {
    try {
      final response = await dio.get("/provincia/$id");

      print("📥 Load response: ${response.statusCode}");
      print("📥 Load data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data["result"];
        return ProvinciaModel.fromJson(data);
      } else {
        throw Exception("Error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al cargar provincia: $e");
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      print("🗑️ Delete request: DELETE /provincia/$id");
      
      final response = await dio.delete("/provincia/$id");
      
      print("📥 Delete response status: ${response.statusCode}");
      print("📥 Delete response data: ${response.data}");
      
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      print("❌ DioException al eliminar provincia:");
      print("   Status code: ${e.response?.statusCode}");
      print("   Response data: ${e.response?.data}");
      
      String errorMessage = "Error al eliminar provincia";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    } catch (e) {
      print("❌ Error inesperado al eliminar provincia: $e");
      throw Exception("Error al eliminar provincia: $e");
    }
  }

  @override
  Future<List<Provincia>> list({
    String? nombre,
    int? codPostal,
    int? id,
  }) async {
    try {
      final queryParams = {
        if (nombre != null && nombre.isNotEmpty) 'nombre': nombre,
        if (codPostal != null) 'codPostal': codPostal,
        if (id != null) 'id': id,
      };

      print("🌐 List request: GET /provincia");
      print("🔍 Query params: $queryParams");

      final response = await dio.get("/provincia", queryParameters: queryParams);

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
          return _parseProvinciasList(resultData);
        }

        // Caso 3: result es un Map que contiene la lista
        if (resultData is Map<String, dynamic>) {
          // ⭐ CASO ESPECÍFICO: Tu backend devuelve {$provincias: [...], totalLocalidades: 6}
          if (resultData.containsKey('\$provincias')) {
            print("✅ Encontrado key '\$provincias'");
            final provinciasData = resultData['\$provincias'];
            
            if (provinciasData is List) {
              print("✅ \$provincias es lista con ${provinciasData.length} elementos");
              return _parseProvinciasList(provinciasData);
            } else {
              throw Exception("'\$provincias' no es una lista: ${provinciasData.runtimeType}");
            }
          }
          
          // Intentar con 'provincias' (sin $)
          if (resultData.containsKey('provincias')) {
            print("✅ Encontrado key 'provincias'");
            final provinciasData = resultData['provincias'];
            
            if (provinciasData is List) {
              print("✅ provincias es lista con ${provinciasData.length} elementos");
              return _parseProvinciasList(provinciasData);
            }
          }
          
          // Si no tiene ninguna key conocida, es un objeto único
          print("⚠️ Result es objeto único → convirtiéndolo a lista");
          return [ProvinciaModel.fromJson(resultData)];
        }

        // Caso 4: result es Map sin tipo genérico
        if (resultData is Map) {
          print("⚠️ Result es Map genérico");
          final typedMap = Map<String, dynamic>.from(resultData);
          
          // Verificar si tiene $provincias
          if (typedMap.containsKey('\$provincias')) {
            final provinciasData = typedMap['\$provincias'];
            if (provinciasData is List) {
              return _parseProvinciasList(provinciasData);
            }
          }
          
          return [ProvinciaModel.fromJson(typedMap)];
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
      print("❌ Error al listar provincias: $e");
      print("📋 Stack: $stackTrace");
      throw Exception("Error al listar provincias: $e");
    }
  }

  @override
  Future<bool> update(Provincia provincia) async {
    try {
      final model = ProvinciaModel.fromEntity(provincia);
      final jsonData = model.toJson();
      
      print("🔄 Update request: PUT /provincia/${provincia.id}");
      print("📤 Update data: $jsonData");
      
      final response = await dio.put(
        "/provincia/${provincia.id}",
        data: jsonData,
      );
      
      print("📥 Update response status: ${response.statusCode}");
      print("📥 Update response data: ${response.data}");
      
      return response.statusCode == 200;
    } on DioException catch (e) {
      print("❌ DioException al actualizar provincia:");
      print("   Status code: ${e.response?.statusCode}");
      print("   Response data: ${e.response?.data}");
      print("   Request data: ${e.requestOptions.data}");
      print("   URL: ${e.requestOptions.uri}");
      
      // Extraer mensaje de error del backend si existe
      String errorMessage = "Error al actualizar provincia";
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
      print("❌ Error inesperado al actualizar provincia: $e");
      throw Exception("Error al actualizar provincia: $e");
    }
  }

  // ⭐ MÉTODO AUXILIAR PARA PARSEAR LA LISTA
  List<Provincia> _parseProvinciasList(List<dynamic> list) {
    return list.map((item) {
      try {
        if (item is Map<String, dynamic>) {
          return ProvinciaModel.fromJson(item);
        } else if (item is Map) {
          return ProvinciaModel.fromJson(Map<String, dynamic>.from(item));
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