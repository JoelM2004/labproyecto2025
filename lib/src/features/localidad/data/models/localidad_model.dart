import 'package:labproyecto2025/src/features/localidad/domain/entities/localidad.dart';

class LocalidadModel extends Localidad {
  LocalidadModel({
    required super.id,
    required super.nombre,
    required super.codPostal,
    required super.provinciaId
  });

  // Crear desde la entidad
  factory LocalidadModel.fromEntity(Localidad localidad) {
    return LocalidadModel(
      id: localidad.id,
      nombre: localidad.nombre,
      codPostal: localidad.codPostal,
      provinciaId: localidad.provinciaId
    );
  }

  // Crear desde JSON (del backend)
  factory LocalidadModel.fromJson(Map<String, dynamic> json) {
    try {
      final id = _parseId(json['id']);
      final nombre = _parseNombre(json['nombre']);
      final codPostal = _parseCodPostal(json['codPostal']);
      final provinciaId= _parseProvinciaId(json['provinciaId']);

      print("✅ Parseando: id=$id, nombre='$nombre', codPostal='$codPostal', provinciaId: $provinciaId");
      
      return LocalidadModel(
        id: id,
        nombre: nombre,
        codPostal: codPostal,
        provinciaId: provinciaId
      );
    } catch (e, stackTrace) {
      print("❌ Error parseando localidad: $e");
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

 static int _parseCodPostal(dynamic codPostal) {
  // Si es null → 0
  if (codPostal == null) {
    print("⚠️ codPostal es null → 0");
    return 0;
  }

  // Si ya es int
  if (codPostal is int) {
    return codPostal;
  }

  // Si es double → convertir a int
  if (codPostal is double) {
    return codPostal.toInt();
  }

  // Si es String → intentar parsear a int
  if (codPostal is String) {
    if (codPostal.isEmpty) return 0;
    final parsed = int.tryParse(codPostal);
    if (parsed == null) {
      return 0;
    }
    return parsed;
  }
  return 0;
}

  static String _parseProvinciaId(dynamic provinciaId) {
    if (provinciaId == null) return '';
    if (provinciaId == null) return '';
    if (provinciaId is String) return provinciaId;
    return provinciaId.toString();
  }


  // Convertir a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codPostal': codPostal,
      'provinciaId': provinciaId
    };
  }

  // Para crear una copia con modificaciones
  LocalidadModel copyWith({
    int? id,
    String? nombre,
    int? codPostal,
    String? provinciaId
  }) {
    return LocalidadModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codPostal: codPostal ?? this.codPostal,
      provinciaId: provinciaId ?? this.provinciaId
    );
  }

  @override
  String toString() {
    return 'LocalidadModel(id: $id, nombre: $nombre, codPostal: $codPostal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalidadModel &&
        other.id == id &&
        other.nombre == nombre &&
        other.codPostal == codPostal &&
        other.provinciaId == provinciaId ;
  }

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode ^ codPostal.hashCode ^ provinciaId.hashCode;
}