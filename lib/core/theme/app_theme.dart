import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Font Family - use null to use default system font
  static const String? fontFamily = null;

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

  // Dark theme colors - Premium enhanced for superior appearance
  static const Color darkBackground = Color(0xFF0A0E1A); // Deep space blue
  static const Color darkSurface = Color(0xFF1A1F2E); // Rich navy surface
  static const Color darkSurfaceVariant = Color(0xFF242938); // Elevated surface
  static const Color darkSurfaceContainer =
      Color(0xFF2A2F3E); // Container surface
  static const Color darkSurfaceContainerHigh =
      Color(0xFF343947); // High elevation
  static const Color darkOnBackground = Color(0xFFE8EAED); // Pure white text
  static const Color darkOnSurface = Color(0xFFBDC1C6); // Soft white text
  static const Color darkOnSurfaceVariant = Color(0xFF9AA0A6); // Muted text

  // Enhanced primary colors for dark theme with gradient support
  static const Color darkPrimary = Color(0xFF60A5FA); // Bright blue
  static const Color darkPrimaryLight =
      Color(0xFF93C5FD); // Lighter blue variant
  static const Color darkPrimaryDark = Color(0xFF3B82F6); // Darker blue variant
  static const Color darkPrimaryContainer =
      Color(0xFF1E3A8A); // Deep blue container
  static const Color darkSecondary = Color(0xFFFF8A65); // Warm orange
  static const Color darkSecondaryContainer = Color(0xFFBF360C); // Deep orange

  // Accent colors for enhanced visual hierarchy
  static const Color darkAccent = Color(0xFF10B981); // Emerald green
  static const Color darkAccentSecondary = Color(0xFF8B5CF6); // Purple accent
  static const Color darkWarning = Color(0xFFFBBF24); // Amber warning
  static const Color darkInfo = Color(0xFF06B6D4); // Cyan info

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
      // Ensure a consistent font family across the whole app
      fontFamily: fontFamily,
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
          fontFamily: fontFamily,
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
            fontFamily: fontFamily,
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
            fontFamily: fontFamily,
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
          fontFamily: fontFamily,
          inherit: true,
        ),
        displayMedium: TextStyle(
          color: lightOnBackground,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
          inherit: true,
        ),
        displaySmall: TextStyle(
          color: lightOnBackground,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
          inherit: true,
        ),
        headlineLarge: TextStyle(
          color: lightOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
          inherit: true,
        ),
        headlineMedium: TextStyle(
          color: lightOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
          inherit: true,
        ),
        headlineSmall: TextStyle(
          color: lightOnBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          inherit: true,
        ),
        titleLarge: TextStyle(
          color: lightOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          inherit: true,
        ),
        titleMedium: TextStyle(
          color: lightOnBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          inherit: true,
        ),
        titleSmall: TextStyle(
          color: lightOnBackground,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          inherit: true,
        ),
        bodyLarge: TextStyle(
          color: lightOnBackground,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
          inherit: true,
        ),
        bodyMedium: TextStyle(
          color: lightOnSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
          inherit: true,
        ),
        bodySmall: TextStyle(
          color: lightOnSurface,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
          inherit: true,
        ),
        labelLarge: TextStyle(
          color: lightOnSurface,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          inherit: true,
        ),
        labelMedium: TextStyle(
          color: lightOnSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          inherit: true,
        ),
        labelSmall: TextStyle(
          color: lightOnSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
          inherit: true,
        ),
      ),
    );
  }

  // Dark Theme - Premium enhanced for superior visual experience
  static ThemeData get darkTheme {
    return ThemeData(
      // Ensure a consistent font family across the whole app
      fontFamily: fontFamily,
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        primaryContainer: darkPrimaryContainer,
        secondary: darkSecondary,
        secondaryContainer: darkSecondaryContainer,
        tertiary: darkAccent,
        tertiaryContainer: Color(0xFF065F46),
        surface: darkSurface,
        surfaceVariant: darkSurfaceVariant,
        surfaceContainerHighest: darkSurfaceContainerHigh,
        background: darkBackground,
        error: errorDark,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurfaceVariant,
        onBackground: darkOnBackground,
        onError: Colors.black,
        outline: Color(0xFF5F6368),
        outlineVariant: Color(0xFF3C4043),
        shadow: Colors.black,
        scrim: Colors.black54,
      ),

      // Premium AppBar Theme for Dark Mode
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
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
          fontFamily: fontFamily,
        ),
        iconTheme: IconThemeData(
          color: darkPrimary,
          size: 26,
        ),
        actionsIconTheme: IconThemeData(
          color: darkOnBackground,
          size: 24,
        ),
        toolbarHeight: 70,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      // Premium Card Theme with enhanced depth
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),

      // Premium Elevated Button with gradient support
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: darkPrimary.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontFamily: fontFamily,
            inherit: true,
          ),
        ),
      ),

      // Enhanced Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontFamily: fontFamily,
            inherit: true,
          ),
        ),
      ),

      // Premium Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: BorderSide(color: darkPrimary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontFamily: fontFamily,
            inherit: true,
          ),
        ),
      ),

      // Premium Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.12),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.12),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkPrimary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorDark, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
        labelStyle: TextStyle(
          color: darkOnSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
      ),

      // Premium Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
          fontFamily: fontFamily,
        ),
      ),

      // Premium Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 12,
        focusElevation: 16,
        hoverElevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Enhanced Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.1),
        thickness: 1.5,
        space: 2,
      ),

      // Premium List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: darkPrimary.withOpacity(0.15),
        textColor: darkOnSurface,
        iconColor: darkOnSurface,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
          fontFamily: fontFamily,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          fontFamily: fontFamily,
        ),
      ),

      // Premium Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        selectedColor: darkPrimary.withOpacity(0.25),
        disabledColor: darkSurfaceVariant.withOpacity(0.5),
        labelStyle: const TextStyle(
          color: darkOnSurface,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
          fontFamily: fontFamily,
        ),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),

      // Premium Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkPrimary;
          }
          return Colors.grey[400];
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkPrimary.withOpacity(0.4);
          }
          return Colors.grey[700];
        }),
      ),

      // Premium Text Theme with enhanced typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 36,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.0,
          height: 1.2,
          fontFamily: fontFamily,
          inherit: true,
        ),
        displayMedium: TextStyle(
          color: darkOnBackground,
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
          height: 1.3,
          fontFamily: fontFamily,
          inherit: true,
        ),
        displaySmall: TextStyle(
          color: darkOnBackground,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.3,
          fontFamily: fontFamily,
          inherit: true,
        ),
        headlineLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.4,
          fontFamily: fontFamily,
          inherit: true,
        ),
        headlineMedium: TextStyle(
          color: darkOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
          height: 1.4,
          fontFamily: fontFamily,
          inherit: true,
        ),
        headlineSmall: TextStyle(
          color: darkOnBackground,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.25,
          height: 1.4,
          fontFamily: fontFamily,
          inherit: true,
        ),
        titleLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.4,
          fontFamily: fontFamily,
          inherit: true,
        ),
        titleMedium: TextStyle(
          color: darkOnBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.4,
          fontFamily: fontFamily,
          inherit: true,
        ),
        titleSmall: TextStyle(
          color: darkOnBackground,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.4,
          fontFamily: fontFamily,
          inherit: true,
        ),
        bodyLarge: TextStyle(
          color: darkOnBackground,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.5,
          fontFamily: fontFamily,
          inherit: true,
        ),
        bodyMedium: TextStyle(
          color: darkOnSurface,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.5,
          fontFamily: fontFamily,
          inherit: true,
        ),
        bodySmall: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.4,
          fontFamily: fontFamily,
          inherit: true,
        ),
        labelLarge: TextStyle(
          color: darkOnSurface,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.3,
          fontFamily: fontFamily,
          inherit: true,
        ),
        labelMedium: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.3,
          fontFamily: fontFamily,
          inherit: true,
        ),
        labelSmall: TextStyle(
          color: darkOnSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.2,
          fontFamily: fontFamily,
          inherit: true,
        ),
      ),

      // Enhanced Scaffold Background Color
      scaffoldBackgroundColor: darkBackground,

      // Premium Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 24,
        shadowColor: Colors.black.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: const TextStyle(
          color: darkOnBackground,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.25,
        ),
        contentTextStyle: const TextStyle(
          color: darkOnSurface,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.5,
        ),
      ),

      // Premium Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceContainerHigh,
        contentTextStyle: const TextStyle(
          color: darkOnSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 12,
      ),

      // Premium Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: darkPrimary,
        linearTrackColor: darkSurfaceVariant,
        circularTrackColor: darkSurfaceVariant,
      ),

      // Premium Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: darkPrimary,
        unselectedLabelColor: darkOnSurfaceVariant,
        indicatorColor: darkPrimary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
      ),
    );
  }
}
