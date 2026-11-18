import 'package:flutter/material.dart';

class C {
  static const noche = Color(0xFF0E2238);
  static const panel = Color(0xFF173456);
  static const sol = Color(0xFFFFC31F);
  static const verde = Color(0xFF2DBE60);
  static const madera = Color(0xFF8B5A2B);
  static const hoja = Color(0xFF58B368);
  static const cielo = Color(0xFF4FB3E8);
  static const tinta = Color(0xFF12304A); 
}

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      fontFamily: 'Fredoka',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: C.cielo, brightness: Brightness.dark),
      scaffoldBackgroundColor: C.noche,
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: C.panel, height: 72),
    );
