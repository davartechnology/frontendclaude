import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs
  static const Color primary = Color(0xFFFF0050); // TikTok pink
  static const Color secondary = Color(0xFF00F2EA); // TikTok cyan
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF8E8E93);
  static const Color lightGrey = Color(0xFFAEAEB2);

  // Dégradés
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFE1306C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Thème Sombre (par défaut)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      background: background,
      onBackground: onBackground,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: onBackground),
      titleTextStyle: TextStyle(
        color: onBackground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: background,
      selectedItemColor: onBackground,
      unselectedItemColor: grey,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: onBackground,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onBackground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: onBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: onBackground,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: grey,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: grey),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(16),
      ),
    ),

    

    dividerTheme: const DividerThemeData(
      color: grey,
      thickness: 0.5,
    ),
  );
}