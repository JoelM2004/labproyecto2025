// session.dart
import 'package:labproyecto2025/src/features/usuario/data/models/usuario_model.dart';

class Session {
  // Usuario actual en sesión
  static UsuarioModel? currentUser;

  // Verificar si hay sesión activa
  static bool get isAuthenticated => currentUser != null;

  // Obtener el token del usuario actual
  static String? get currentToken => currentUser?.token;

  // Obtener el ID del usuario actual
  static int? get currentUserId => currentUser?.id;

  // Obtener nombre completo del usuario
  static String get fullName {
    if (currentUser == null) return 'Usuario';
    return '${currentUser!.nombres} ${currentUser!.apellido}'.trim();
  }

  // Limpiar sesión
  static void clear() {
    currentUser = null;
    print("🗑️ Session.currentUser limpiado");
  }

  // Establecer usuario en sesión
  static void setUser(UsuarioModel user) {
    currentUser = user;
    print("💾 Session.currentUser establecido: ${user.nombres}");
  }

  // Método para debug
  static void printSessionInfo() {
    if (isAuthenticated) {
      print("📊 Sesión Activa:");
      print("   👤 Usuario: $fullName");
      print("   🆔 ID: $currentUserId");
      print("   📧 Cuenta: ${currentUser?.cuenta}");
      print("   🎫 Token: ${currentToken?.substring(0, 20)}...");
    } else {
      print("📊 No hay sesión activa");
    }
  }
}