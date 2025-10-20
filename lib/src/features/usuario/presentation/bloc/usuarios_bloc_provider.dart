import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:labproyecto2025/src/features/usuario/presentation/bloc/login_usuario/login_usuario_bloc.dart';
import 'package:labproyecto2025/src/features/usuario/presentation/bloc/logout_usuario/logout_usuario_bloc.dart';

class UsuarioBlocProviders {
  static final providers = [
    BlocProvider<LoginUsuarioBloc>(
      create: (_) => GetIt.instance.get<LoginUsuarioBloc>(),
    ),
    BlocProvider<LogoutUsuarioBloc>(
      create: (_) => GetIt.instance.get<LogoutUsuarioBloc>(),
    ),
  ];
}