// dio_client.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  // ⭐ Singleton verdadero con instancia estática
  static DioClient? _instance;
  static Dio? _dio;
  
  static const String _tokenKey = 'auth_token';

  // Constructor privado
  DioClient._();

  // Getter estático que garantiza una sola instancia
  static Dio get dio {
    if (_dio == null) {
      _instance = DioClient._();
      _instance!._initializeDio();
    }
    return _dio!;
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2/provincias/public",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ));

    // Interceptor global para agregar token a TODAS las peticiones
    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        
        // Obtener el token y agregarlo a los headers
        final token = await getToken();
        
        if (token != null && token.isNotEmpty) {
          options.headers.remove('authorization');
          options.headers.remove('Authorization');
          
          options.headers['Authorization'] = 'Bearer $token';
        } 

          options.headers.forEach((key, value) {
          // Ocultar el token completo en logs
          if (key.toLowerCase() == 'authorization' && value.toString().startsWith('Bearer ')) {
          } 
        });
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  // Método estático para obtener el token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token;
  }

  // Método para guardar el token (usado después del login)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Método para limpiar el token (usado después del logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Método para verificar si hay token
  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Método para forzar reinicio (útil para testing)
  static void reset() {
    _dio = null;
    _instance = null;
  }
}