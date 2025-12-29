import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';

/// Theme state
class ThemeState {
  final ThemeMode themeMode;
  final bool isDarkMode;

  const ThemeState({
    required this.themeMode,
    required this.isDarkMode,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

/// Theme notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState(themeMode: ThemeMode.dark, isDarkMode: true)) {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? true;
    final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    state = ThemeState(
      themeMode: themeMode,
      isDarkMode: isDarkMode,
    );
  }

  Future<void> toggleTheme() async {
    final newIsDarkMode = !state.isDarkMode;
    final newThemeMode = newIsDarkMode ? ThemeMode.dark : ThemeMode.light;

    state = ThemeState(
      themeMode: newThemeMode,
      isDarkMode: newIsDarkMode,
    );

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newIsDarkMode);
  }

  ThemeData get currentTheme => state.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});