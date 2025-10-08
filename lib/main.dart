import 'package:labproyecto2025/src/app/di.dart';
import 'package:labproyecto2025/src/app/app.dart';
import 'package:flutter/material.dart';
import 'package:labproyecto2025/src/app/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    AppBlocProviders.createProviders(
      child: const MyApp(),
    ),
  );
}