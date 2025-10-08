import 'package:labproyecto2025/src/features/provincia/domain/entities/provincia.dart';

class ProvinciaModel extends Provincia {
  ProvinciaModel({
    required super.id,
    required super.nombre,
    required super.codPostal,
  });

  // Crear desde la entidad
  factory ProvinciaModel.fromEntity(Provincia provincia) {
    return ProvinciaModel(
      id: provincia.id,
      nombre: provincia.nombre,
      codPostal: provincia.codPostal,
    );
  }

  // Crear desde JSON (del backend)
  factory ProvinciaModel.fromJson(Map<String, dynamic> json) {
    try {
      final id = _parseId(json['id']);
      final nombre = _parseNombre(json['nombre']);
      final codPostal = _parseCodPostal(json['codPostal']);
      
      print("✅ Parseando: id=$id, nombre='$nombre', codPostal='$codPostal'");
      
      return ProvinciaModel(
        id: id,
        nombre: nombre,
        codPostal: codPostal,
      );
    } catch (e, stackTrace) {
      print("❌ Error parseando provincia: $e");
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



  // Convertir a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codPostal': codPostal,
    };
  }

  // Para crear una copia con modificaciones
  ProvinciaModel copyWith({
    int? id,
    String? nombre,
    int? codPostal,
  }) {
    return ProvinciaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codPostal: codPostal ?? this.codPostal,
    );
  }

  @override
  String toString() {
    return 'ProvinciaModel(id: $id, nombre: $nombre, codPostal: $codPostal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProvinciaModel &&
        other.id == id &&
        other.nombre == nombre &&
        other.codPostal == codPostal;
  }

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode ^ codPostal.hashCode;
}