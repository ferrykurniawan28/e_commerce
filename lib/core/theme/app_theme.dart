import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Primary color scheme
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryVariant = Color(0xFF1976D2);
  static const Color secondary = Color(0xFFFF5722);
  static const Color secondaryVariant = Color(0xFFE64A19);

  // Light theme colors - Enhanced for consistency
  static const Color lightBackground = Color(0xFFFAFBFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF8F9FA);
  static const Color lightOnBackground = Color(0xFF1A1C1E);
  static const Color lightOnSurface = Color(0xFF44474F);
  static const Color lightOnSurfaceVariant = Color(0xFF5F6368);

  // Dark theme colors - Enhanced for better appearance
  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF1A1F2E);
  static const Color darkSurfaceVariant = Color(0xFF242938);
  static const Color darkOnBackground = Color(0xFFE8EAED);
  static const Color darkOnSurface = Color(0xFFBDC1C6);
  static const Color darkOnSurfaceVariant = Color(0xFF9AA0A6);

  // Enhanced primary colors for dark theme
  static const Color darkPrimary = Color(0xFF60A5FA);
  static const Color darkPrimaryContainer = Color(0xFF1E3A8A);
  static const Color darkSecondary = Color(0xFFFF8A65);
  static const Color darkSecondaryContainer = Color(0xFFBF360C);

  // Error colors
  static const Color errorLight = Color(0xFFD32F2F);
  static const Color errorDark = Color(0xFFCF6679);

  // Success colors
  static const Color success = Color(0xFF4CAF50);

  // Warning colors
  static const Color warning = Color(0xFFFF9800);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: Color(0xFFE3F2FD),
        secondary: secondary,
        secondaryContainer: Color(0xFFFFE0B2),
        surface: lightSurface,
        background: lightBackground,
        error: errorLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightOnSurface,
        onBackground: lightOnBackground,
        onError: Colors.white,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightOnBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            inherit: true,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            inherit: true,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorLight, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightBackground,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightOnSurface,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: lightOnBackground,
          fontSize: 32,
          fontWeight: FontWeight.w300,
        ),
        displayMedium: TextStyle(
          color: lightOnBackground,
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: lightOnBackground,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: lightOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          color: lightOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
          color: lightOnBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: lightOnBackground,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: lightOnSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: lightOnSurface,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // Dark Theme - Enhanced for better visual appeal
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        primaryContainer: darkPrimaryContainer,
        secondary: darkSecondary,
        secondaryContainer: darkSecondaryContainer,
        surface: darkSurface,
        surfaceVariant: darkSurfaceVariant,
        background: darkBackground,
        error: errorDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurfaceVariant,
        onBackground: darkOnBackground,
        onError: Colors.black,
        outline: Color(0xFF5F6368),
        outlineVariant: Color(0xFF3C4043),
      ),

      // Enhanced AppBar Theme for Dark Mode
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: darkOnBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: darkOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontFamily: 'System',
        ),
        iconTheme: IconThemeData(
          color: darkPrimary,
          size: 26,
        ),
        actionsIconTheme: IconThemeData(
          color: darkOnBackground,
          size: 24,
        ),
        toolbarHeight: 64,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        // Add subtle shadow for depth
        shadowColor: Colors.black.withOpacity(0.3),
      ),

      // Enhanced Card Theme
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),

      // Enhanced Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: darkPrimary.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            inherit: true,
          ),
        ),
      ),

      // Enhanced Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            inherit: true,
          ),
        ),
      ),

      // Enhanced Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: BorderSide(color: darkPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            inherit: true,
          ),
        ),
      ),

      // Enhanced Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorDark, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 16,
        ),
        labelStyle: TextStyle(
          color: darkOnSurface,
          fontSize: 16,
        ),
      ),

      // Enhanced Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Enhanced Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Enhanced Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.08),
        thickness: 1,
        space: 1,
      ),

      // Enhanced List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: darkPrimary.withOpacity(0.1),
        textColor: darkOnSurface,
        iconColor: darkOnSurface,
      ),

      // Enhanced Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        selectedColor: darkPrimary.withOpacity(0.2),
        disabledColor: darkSurfaceVariant.withOpacity(0.5),
        labelStyle: const TextStyle(color: darkOnSurface),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Enhanced Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkPrimary;
          }
          return Colors.grey[600];
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkPrimary.withOpacity(0.3);
          }
          return Colors.grey[800];
        }),
      ),

      // Enhanced Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 32,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: darkOnBackground,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          color: darkOnBackground,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          color: darkOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
        headlineSmall: TextStyle(
          color: darkOnBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        ),
        titleLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          color: darkOnBackground,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          color: darkOnBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: darkOnSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          color: darkOnSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),

      // Enhanced Scaffold Background Color
      scaffoldBackgroundColor: darkBackground,

      // Enhanced Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: darkOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: darkOnSurface,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Enhanced Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceVariant,
        contentTextStyle: const TextStyle(
          color: darkOnSurface,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
