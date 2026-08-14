import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/themes/app_themes.dart';
import 'core/translations/app_translations.dart';
import 'presentation/controllers/azkary_controller.dart';
import 'presentation/controllers/theme_controller.dart';

/// مفتاح التنقّل العام لـ GetMaterialApp / Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          final themeController = ThemeController.instance;
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Azkary',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'AE'),
              Locale('en'),
              Locale('es'),
            ],
            // locale يُدار بالكامل عبر Get.updateLocale في AzkaryController.changeLocale
            // locale is fully managed via Get.updateLocale in changeLocale
            locale: AzkaryController.instance.initialLang.value,
            // مصدر الترجمات لـ '.tr' و '.trParams' — مهاجَر من ARB/gen-l10n
            translations: AppTranslations(),
            // اللغة الاحتياطية إذا لم توجد ترجمة لمفتاح في اللغة الحالية
            fallbackLocale: const Locale('ar', 'AE'),
            theme: AppThemes.getThemeById(themeController.currentThemeId.value)
                .data,
            darkTheme: AppThemes.darkTheme.data,
            themeMode: themeController.currentThemeId.value == 'dark'
                ? ThemeMode.dark
                : ThemeMode.light,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          );
        });
      },
    );
  }
}
