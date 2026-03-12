import 'package:flutter/material.dart';

ThemeData buildAdminTheme() {
  const brandBackground = Color(0xFF0B0B0B);
  const brandSurface = Color(0xFF141414);
  const brandAccent = Color(0xFFF4B400);
  const brandHover = Color(0xFFD89A00);
  const brandText = Color(0xFFF5F5F5);
  const brandMuted = Color(0xFFBDBDBD);
  const brandBorder = Color(0xFF2A2A2A);

  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: brandBackground,
    colorScheme: const ColorScheme.dark(
      primary: brandAccent,
      secondary: brandHover,
      surface: brandSurface,
      error: Color(0xFFEF4444),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: brandText,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: brandText,
      displayColor: brandText,
    ),
    dividerColor: brandBorder,
    cardTheme: const CardThemeData(
      color: brandSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(color: brandBorder),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black,
      hintStyle: const TextStyle(color: brandMuted),
      labelStyle: const TextStyle(color: brandMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: brandBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: brandBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: brandAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: brandSurface,
      contentTextStyle: TextStyle(color: brandText),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
