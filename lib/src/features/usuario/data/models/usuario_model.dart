import 'package:labproyecto2025/src/features/usuario/domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  UsuarioModel({
    required super.id,
    required super.nombres,
    required super.apellido,
    required super.token,
    required super.cuenta,
  });

  // Crear desde la entidad
  factory UsuarioModel.fromEntity(Usuario usuario) {
    return UsuarioModel(
      id: usuario.id,
      nombres: usuario.nombres,
      apellido: usuario.apellido,
      token: usuario.token,
      cuenta: usuario.cuenta,
    );
  }

  // Crear desde JSON (del backend)
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    try {
      final id = _parseId(json['id']);
      final nombres = _parseNombre(json['nombre']);
      final apellido = _parseApellido(json['apellido']);
      final token = _parseToken(json['token']);
      final cuenta = _parseNombre(json['cuenta']);

      return UsuarioModel(
        id: id,
        nombres: nombres,
        apellido: apellido,
        token: token,
        cuenta: cuenta,

      );
    } catch (e, stackTrace) {
      print("❌ Error parseando usuario: $e");
      print("📦 JSON recibido: $json");
      print("📋 Stack: $stackTrace");
      rethrow;
    }
  }

  // Método auxiliar para parsear el ID
  static int _parseId(dynamic id) {
    if (id == null) {
      print("⚠️ ID es null, usando 0");
      return 0;
    }
    if (id is int) return id;
    if (id is String) {
      final parsed = int.tryParse(id);
      if (parsed == null) {
        print("⚠️ No se pudo parsear ID '$id', usando 0");
        return 0;
      }
      return parsed;
    }
    print("⚠️ ID tipo desconocido: ${id.runtimeType}, usando 0");
    return 0;
  }

  // Método auxiliar para parsear nombre
  static String _parseNombre(dynamic nombre) {
    if (nombre == null) return '';
    if (nombre is String) return nombre;
    return nombre.toString();
  }

  static String _parseApellido(dynamic apellido) {
    if (apellido == null) return '';
    if (apellido is String) return apellido;
    return apellido.toString();
  }

  static String _parseToken(dynamic token) {
    if (token == null) return '';
    if (token is String) return token;
    return token.toString();
  }

  static String _parseCuenta(dynamic cuenta) {
    if (cuenta == null) return '';
    if (cuenta is String) return cuenta;
    return cuenta.toString();
  }


 



  // Convertir a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellido': apellido,
      'token': token,
      'cuenta': cuenta,
    };
  }

  // Para crear una copia con modificaciones
  UsuarioModel copyWith({
    int? id,
    String? nombres,
    String? apellido,
    String? token,
    String? cuenta,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nombres: nombres ?? this.nombres,
      apellido: apellido ?? this.apellido,
      token: token ?? this.token,
      cuenta: cuenta ?? this.cuenta,
    );
  }

}