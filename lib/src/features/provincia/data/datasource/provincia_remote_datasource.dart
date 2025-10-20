import 'package:dio/dio.dart';
import 'package:labproyecto2025/src/app/dio_client.dart';
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
  Dio get dio => DioClient.dio;

  @override
  Future<bool> save(Provincia provincia) async {
    try {
      final model = ProvinciaModel.fromEntity(provincia);
      final jsonData = model.toJson();
      jsonData.remove('id');
            
      final response = await dio.post("/provincia", data: jsonData);
      
      
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      
      String errorMessage = "Error al guardar provincia";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    }
  }

  @override
  Future<Provincia> load(int id) async {
    try {
      final response = await dio.get("/provincia/$id");

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
      final response = await dio.delete("/provincia/$id");
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      String errorMessage = "Error al eliminar provincia";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
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

      final response = await dio.get("/provincia", queryParameters: queryParams);

      if (response.statusCode == 200) {
        final dynamic resultData = response.data["result"];
        
        if (resultData == null) return [];
        if (resultData is List) return _parseProvinciasList(resultData);

        if (resultData is Map<String, dynamic>) {
          if (resultData.containsKey('\$provincias')) {
            final provinciasData = resultData['\$provincias'];
            if (provinciasData is List) {
              return _parseProvinciasList(provinciasData);
            }
          }
          
          if (resultData.containsKey('provincias')) {
            final provinciasData = resultData['provincias'];
            if (provinciasData is List) {
              return _parseProvinciasList(provinciasData);
            }
          }
          
          return [ProvinciaModel.fromJson(resultData)];
        }

        if (resultData is Map) {
          final typedMap = Map<String, dynamic>.from(resultData);
          if (typedMap.containsKey('\$provincias')) {
            final provinciasData = typedMap['\$provincias'];
            if (provinciasData is List) {
              return _parseProvinciasList(provinciasData);
            }
          }
          return [ProvinciaModel.fromJson(typedMap)];
        }

        throw Exception("Tipo inesperado en 'result': ${resultData.runtimeType}");
        
      } else {
        throw Exception("HTTP ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      throw Exception("Error al listar provincias: $e");
    }
  }

  @override
  Future<bool> update(Provincia provincia) async {
    try {
      final model = ProvinciaModel.fromEntity(provincia);
      final jsonData = model.toJson();
      
      final response = await dio.put(
        "/provincia/${provincia.id}",
        data: jsonData,
      );
      
      return response.statusCode == 200;
    } on DioException catch (e) {
      String errorMessage = "Error al actualizar provincia";
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data;
        errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
      }
      
      throw Exception("$errorMessage (HTTP ${e.response?.statusCode})");
    }
  }

  List<Provincia> _parseProvinciasList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return ProvinciaModel.fromJson(item);
      } else if (item is Map) {
        return ProvinciaModel.fromJson(Map<String, dynamic>.from(item));
      } else {
        throw Exception("Item no es Map: ${item.runtimeType}");
      }
    }).toList();
  }
}