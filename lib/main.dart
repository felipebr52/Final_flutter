import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter/foundation.dart'; // Para usar o kIsWeb
import 'package:sqflite/sqflite.dart'; // Faltava essa importação
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() {
  // Garante que os widgets estão inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Se não for Web e for Windows/Linux, usa o FFI
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
