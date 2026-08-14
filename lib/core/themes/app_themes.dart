import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// إدارة ثيمات وألوان التطبيق
// App themes and colors management
class AppTheme {
  final String id;
  final String description;
  final ThemeData data;

  AppTheme({
    required this.id,
    required this.description,
    required this.data,
  });
}

class AppThemes {
  // قائمة الثيمات المتاحة / Available themes list
  static List<AppTheme> get themes => [
        blueTheme,
        greenTheme,
        darkTheme,
      ];

  // معرّف الثيم الافتراضي الموحّد / Unified default theme id
  static const String defaultThemeId = 'green';

  // الثيم الأزرق / Blue theme
  static AppTheme blueTheme = AppTheme(
    id: 'blue',
    description: "الثيم الأزرق / Blue Theme",
    data: ThemeData(
      colorScheme: const ColorScheme(
        // الثيم الأزرق داكن فعلياً / Blue theme is effectively dark
        brightness: Brightness.dark,
        primary: Color(0xff4F709C),
        onPrimary: Color(0xff213555),
        secondary: Color(0xffe7dfce),
        onSecondary: Color(0xffD8C4B6),
        error: Color(0xff213555),
        onError: Color(0xff213555),
        surface: Color(0xff213555),
        onSurface: Color(0xff213555),
        primaryContainer: Color(0xffF5EFE7),
        inversePrimary: const Color(0xff213555),
      ),
      primaryColor: const Color(0xff4F709C),
      primaryColorLight: const Color(0xffD8C4B6),
      primaryColorDark: const Color(0xff213555),
      dialogBackgroundColor: const Color(0xffF5EFE7),
      dividerColor: const Color(0xffD8C4B6),
      highlightColor: const Color(0xffD8C4B6).withValues(alpha: .3),
      indicatorColor: const Color(0xffD8C4B6),
      scaffoldBackgroundColor: const Color(0xff213555),
      canvasColor: const Color(0xffF2E5D5),
      hoverColor: const Color(0xffF2E5D5).withValues(alpha: .3),
      disabledColor: const Color(0Xffffffff),
      hintColor: const Color(0xff213555),
      focusColor: const Color(0xff4F709C),
      secondaryHeaderColor: const Color(0xff4F709C),
      cardColor: const Color(0xff213555),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: const Color(0xff213555).withValues(alpha: .3),
        selectionHandleColor: const Color(0xff213555),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: Color(0xff213555),
      ),
    ).copyWith(),
  );

  // الثيم الأخضر / Green theme
  static AppTheme greenTheme = AppTheme(
    id: 'green',
    description: "الثيم الأخضر / Green Theme",
    data: ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xffF7E6C4),
        onPrimary: Color(0xffF7E6C4),
        secondary: Color(0xffe7dfce),
        onSecondary: Color(0xff263A29),
        error: Color(0xff41644A),
        onError: Color(0xff41644A),
        surface: Color(0xff41644A),
        onSurface: Color(0xff41644A),
        primaryContainer: Color(0xffF5EFE7),
        inversePrimary: const Color(0xff263A29),
      ),
      primaryColor: const Color(0xffF7E6C4),
      primaryColorLight: const Color(0xff263A29),
      primaryColorDark: const Color(0xff263A29),
      dialogBackgroundColor: const Color(0xff263A29),
      dividerColor: const Color(0xffE86A33),
      highlightColor: const Color(0xff41644A).withValues(alpha: .3),
      indicatorColor: const Color(0xffE86A33),
      scaffoldBackgroundColor: const Color(0xffF7E6C4),
      canvasColor: const Color(0xffF5EFE7),
      hoverColor: const Color(0xfff2f1da).withValues(alpha: .3),
      disabledColor: const Color(0Xffffffff),
      hintColor: const Color(0xffF7E6C4),
      focusColor: const Color(0xff41644A),
      secondaryHeaderColor: const Color(0xff263A29),
      cardColor: const Color(0xffF7E6C4),
      dividerTheme: const DividerThemeData(
        color: Color(0xffE86A33),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: const Color(0xff41644A).withValues(alpha: .3),
        selectionHandleColor: const Color(0xff41644A),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: Color(0xff606c38),
      ),
    ).copyWith(),
  );

  // الثيم الداكن / Dark theme
  static AppTheme darkTheme = AppTheme(
    id: 'dark',
    description: "الثيم الداكن / Dark Theme",
    data: ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xff3F3F3F),
        onPrimary: Color(0xff252526),
        secondary: Color(0xff19191a),
        onSecondary: Color(0xff4d4d4d),
        error: Color(0xff41644A),
        onError: Color(0xff41644A),
        surface: Color(0xff41644A),
        onSurface: Color(0xff41644A),
        primaryContainer: Color(0xff19191a),
        inversePrimary: const Color(0xffF5EFE7),
      ),
      primaryColor: const Color(0xff3F3F3F),
      primaryColorLight: const Color(0xff4d4d4d),
      primaryColorDark: const Color(0xff010101),
      dialogBackgroundColor: const Color(0xff3F3F3F),
      dividerColor: const Color(0xff41644A),
      highlightColor: const Color(0xff41644A).withValues(alpha: .3),
      indicatorColor: const Color(0xff41644A),
      scaffoldBackgroundColor: const Color(0xff252526),
      canvasColor: const Color(0xffF5EFE7),
      hoverColor: const Color(0xfff2f1da).withValues(alpha: .3),
      disabledColor: const Color(0Xffffffff),
      hintColor: const Color(0xff252526),
      focusColor: const Color(0xff41644A),
      secondaryHeaderColor: const Color(0xff41644A),
      cardColor: const Color(0xffF5EFE7),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: const Color(0xff41644A).withValues(alpha: .3),
        selectionHandleColor: const Color(0xff41644A),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: Color(0xff213555),
      ),
    ).copyWith(),
  );

  // طريقة للحصول على ثيم محدد / Get specific theme
  static AppTheme getThemeById(String id) {
    return themes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => greenTheme,
    );
  }
}
