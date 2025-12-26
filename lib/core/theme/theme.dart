import 'package:flutter/material.dart';
import 'package:wallix/core/theme/colors.dart';
import 'package:wallix/core/theme/text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: ColorsManager.lightBackground,
    primaryColor: ColorsManager.primary,
    colorScheme: const ColorScheme.light(
      primary: ColorsManager.primary,
      secondary: ColorsManager.secondary,
      surface: ColorsManager.lightCard,
      error: ColorsManager.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.lightBackground,
      foregroundColor: ColorsManager.lightTextPrimary,
      titleTextStyle: TextStylesManager.bold22.copyWith(
        color: ColorsManager.lightTextPrimary,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorsManager.lightBackground,
      selectedItemColor: ColorsManager.primary,
      unselectedItemColor: ColorsManager.lightTextPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.primary,
        foregroundColor: ColorsManager.lightBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: ColorsManager.lightCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: ColorsManager.darkBackground,
    primaryColor: ColorsManager.primary,
    colorScheme: const ColorScheme.dark(
      primary: ColorsManager.primary,
      secondary: ColorsManager.secondary,
      surface: ColorsManager.darkCard,
      error: ColorsManager.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.darkBackground,
      foregroundColor: ColorsManager.darkTextPrimary,
      titleTextStyle: TextStylesManager.bold22.copyWith(
        color: ColorsManager.darkTextPrimary,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorsManager.darkBackground,
      selectedItemColor: ColorsManager.primary,
      unselectedItemColor: ColorsManager.darkTextPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.primary,
        foregroundColor: ColorsManager.darkTextPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: ColorsManager.darkCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
