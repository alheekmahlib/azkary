import 'package:flutter/material.dart';
import 'package:get/get.dart';

// إدارة ثيمات وألوان التطبيق
// App themes and colors management
class AppThemes {
  // الألوان الأساسية / Primary colors
  static const Color primaryColor = Color(0xFF2E7D4E);
  static const Color primaryLightColor = Color(0xFF4CAF50);
  static const Color primaryDarkColor = Color(0xFF1B5E20);

  // الألوان الثانوية / Secondary colors
  static const Color secondaryColor = Color(0xFFFFB74D);
  static const Color secondaryLightColor = Color(0xFFFFE0B2);
  static const Color secondaryDarkColor = Color(0xFFF57C00);

  // ألوان النص / Text colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textOnPrimaryColor = Colors.white;

  // ألوان الخلفية / Background colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);

  // الثيم الفاتح / Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: textOnPrimaryColor,
      onSecondary: textPrimaryColor,
      onSurface: textPrimaryColor,
      onError: textOnPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textOnPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'kufi',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textOnPrimaryColor,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'kufi',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'kufi',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'kufi',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'kufi',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'kufi',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      titleLarge: TextStyle(
        fontFamily: 'kufi',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'kufi',
        fontSize: 16,
        color: textPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'kufi',
        fontSize: 14,
        color: textPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'kufi',
        fontSize: 12,
        color: textSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimaryColor,
        textStyle: const TextStyle(
          fontFamily: 'kufi',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'kufi',
        color: textSecondaryColor,
      ),
    ),
  );

  // الثيم الداكن / Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    primaryColor: primaryLightColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryLightColor,
      secondary: secondaryLightColor,
      surface: Color(0xFF1E1E1E),
      error: Color(0xFFCF6679),
      onPrimary: textPrimaryColor,
      onSecondary: textPrimaryColor,
      onSurface: Colors.white,
      onError: textPrimaryColor,
    ),
    // باقي إعدادات الثيم الداكن...
  );
}

// كنترولر إدارة الثيم / Theme controller
class ThemeController extends GetxController {
  static ThemeController get instance => Get.isRegistered<ThemeController>()
      ? Get.find<ThemeController>()
      : Get.put(ThemeController());

  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPrefs();
  }

  // تغيير الثيم / Change theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(
        isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme);
    saveThemeToPrefs();
  }

  // حفظ الثيم في التفضيلات / Save theme to preferences
  void saveThemeToPrefs() {
    // حفظ في SharedPreferences
    // Save to SharedPreferences
  }

  // تحميل الثيم من التفضيلات / Load theme from preferences
  void loadThemeFromPrefs() {
    // تحميل من SharedPreferences
    // Load from SharedPreferences
  }
}
