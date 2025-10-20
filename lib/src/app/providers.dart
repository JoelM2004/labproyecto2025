import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labproyecto2025/src/features/localidad/presentation/bloc/localidades_bloc_provider.dart';
import 'package:labproyecto2025/src/features/provincia/presentation/bloc/provincias_bloc_provider.dart';
import 'package:labproyecto2025/src/features/usuario/presentation/bloc/usuarios_bloc_provider.dart';

class AppBlocProviders {
  static Widget createProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        // Aquí puedes agregar más grupos de providers de otras features
        ...ProvinciaBlocProviders.providers,
        ...LocalidadBlocProviders.providers,
        ...UsuarioBlocProviders.providers
        // ...OtraFeatureBlocProviders.providers,
      ],
      child: child,
    );
  }
}
