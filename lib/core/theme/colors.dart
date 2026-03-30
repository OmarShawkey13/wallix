import 'package:flutter/material.dart';
import 'package:wallix/core/utils/cubit/theme/theme_cubit.dart';

class ColorsManager {
  static bool get isDark => themeCubit.isDarkMode;

  // -------- MATERIAL 3 BRAND COLORS (Modern & Balanced) -------- //
  // تم اختيار تدرجات البنفسجي والنيلي لتعطي إحساساً بالفخامة والحداثة
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF625B71);
  static const Color tertiary = Color(0xFF7D5260);

  // -------- LIGHT THEME (Material 3 Surface Tones) -------- //
  static const Color lightBackground = Color(0xFFFEF7FF);
  static const Color lightSurface = Color(
    0xFFF7F2FA,
  ); // للبطاقات والعناصر العائمة
  static const Color lightTextPrimary = Color(0xFF1D1B20);
  static const Color lightTextSecondary = Color(0xFF49454F);
  static const Color lightOutline = Color(0xFF79747E); // للحدود الرفيعة

  // -------- DARK THEME (Immersive & Deep) -------- //
  // استخدام الرمادي العميق بدلاً من الأسود المطلق لتقليل إجهاد العين وإبراز ألوان الخلفيات
  static const Color darkBackground = Color(0xFF141218);
  static const Color darkSurface = Color(0xFF1D1B20);
  static const Color darkTextPrimary = Color(0xFFE6E1E5);
  static const Color darkTextSecondary = Color(0xFFCAC4D0);
  static const Color darkOutline = Color(0xFF938F99);

  // -------- SEMANTIC COLORS -------- //
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFB3261E);
  static const Color warning = Color(0xFFED9121);

  // -------- DYNAMIC GETTERS (UI/UX Logic) -------- //

  // الخلفية الأساسية للتطبيق
  static Color get backgroundColor => isDark ? darkBackground : lightBackground;

  // ألوان البطاقات (Cards) لتبدو بارزة بشكل نظيف
  static Color get cardColor => isDark ? darkSurface : lightSurface;

  // النصوص الأساسية (العناوين)
  static Color get textColor => isDark ? darkTextPrimary : lightTextPrimary;

  // النصوص الثانوية (الوصف أو التفاصيل)
  static Color get textSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;

  // الأيقونات الأساسية
  static Color get iconColor => isDark ? darkTextPrimary : lightTextPrimary;

  // الأيقونات الثانوية أو الحدود
  static Color get iconSecondaryColor =>
      isDark ? darkTextSecondary : lightTextSecondary;

  // لون الحدود (Divider / Borders)
  static Color get outlineColor => isDark ? darkOutline : lightOutline;
}
