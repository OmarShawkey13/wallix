import 'package:flutter/material.dart';
import 'package:wallix/core/utils/cubit/home_cubit.dart';

class ColorsManager {
  static bool get isDark => homeCubit.isDarkMode;

  // -------- BRAND COLORS (Modern & Vibrant) -------- //
  static const Color primary = Color(0xFF6C63FF); // Deep Periwinkle / Indigo
  static const Color secondary = Color(0xFFFF4081); // Pink Accent
  static const Color accent = Color(0xFF00E5FF); // Cyan Highlight

  // -------- LIGHT THEME -------- //
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF3F4F6); // Very light gray
  static const Color lightTextPrimary = Color(0xFF1F2937); // Dark gray
  static const Color lightTextSecondary = Color(0xFF6B7280); // Medium gray

  // -------- DARK THEME (Immersive) -------- //
  static const Color darkBackground = Color(0xFF121212); // Material Dark
  static const Color darkCard = Color(0xFF1E1E1E); // Elevated Dark Surface
  static const Color darkTextPrimary = Color(0xFFF9FAFB); // Off-white
  static const Color darkTextSecondary = Color(0xFF9CA3AF); // Light gray

  // -------- SHARED -------- //
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB74D);

  // -------- DYNAMIC GETTERS -------- //
  static Color get textColor => isDark ? darkTextPrimary : lightTextPrimary;

  static Color get backgroundColor => isDark ? darkBackground : lightBackground;

  static Color get cardColor => isDark ? darkCard : lightCard;

  static Color get textSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;

  static Color get iconColor => isDark ? darkTextPrimary : lightTextPrimary;

  static Color get iconSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;
}
