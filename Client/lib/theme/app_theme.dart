import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0B1F3B); // Deep Navy Blue
  static const Color accent = Color(0xFF1FB6AA); // Teal accent
  static const Color surface = Color(0xFFFFFFFF);
  static const Color backgroundStart = Color(0xFFF7F9FB);
  static const Color backgroundEnd = Color(0xFFFFFFFF);

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: accent,
      onSecondary: Colors.white,
      error: Colors.red.shade700,
      onError: Colors.white,
      surface: surface,
      onSurface: Colors.black87,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundStart,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      textTheme: Typography.blackMountainView.copyWith(
        bodyMedium: const TextStyle(fontSize: 14, color: Colors.black87),
        titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
