import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static AdaptiveThemeManager? _themeManager;

  /// Initialize the theme manager
  static void init(AdaptiveThemeManager themeManager) {
    _themeManager = themeManager;
  }

  /// Get current theme mode
  static AdaptiveThemeMode get currentThemeMode {
    return _themeManager?.mode ?? AdaptiveThemeMode.system;
  }

  /// Check if current theme is dark
  static bool get isDarkMode {
    return _themeManager?.mode == AdaptiveThemeMode.dark ||
        (_themeManager?.mode == AdaptiveThemeMode.system &&
            _themeManager?.darkTheme != null);
  }

  /// Check if current theme is light
  static bool get isLightMode {
    return _themeManager?.mode == AdaptiveThemeMode.light ||
        (_themeManager?.mode == AdaptiveThemeMode.system &&
            _themeManager?.theme != null);
  }

  /// Check if using system theme
  static bool get isSystemMode {
    return _themeManager?.mode == AdaptiveThemeMode.system;
  }

  /// Switch to light theme
  static void setLightMode() {
    _themeManager?.setLight();
  }

  /// Switch to dark theme
  static void setDarkMode() {
    _themeManager?.setDark();
  }

  /// Switch to system theme
  static void setSystemMode() {
    _themeManager?.setSystem();
  }

  /// Toggle between light and dark theme
  static void toggleTheme() {
    if (isDarkMode) {
      setLightMode();
    } else {
      setDarkMode();
    }
  }

  /// Reset theme to system default
  static void resetToSystem() {
    _themeManager?.reset();
  }

  /// Get theme mode as string
  static String get themeModeString {
    switch (currentThemeMode) {
      case AdaptiveThemeMode.light:
        return 'Light';
      case AdaptiveThemeMode.dark:
        return 'Dark';
      case AdaptiveThemeMode.system:
        return 'System';
    }
  }

  /// Get theme icon
  static IconData get themeIcon {
    switch (currentThemeMode) {
      case AdaptiveThemeMode.light:
        return Icons.light_mode;
      case AdaptiveThemeMode.dark:
        return Icons.dark_mode;
      case AdaptiveThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
