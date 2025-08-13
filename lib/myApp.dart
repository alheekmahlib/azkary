import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home_page.dart' as pages;
import '../../screens/splash_screen.dart';
import 'core/core.dart';
import 'l10n/app_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeData theme;

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  void setLocale(Locale value) {
    setState(() {
      AzkaryController.instance.initialLang.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetBuilder<ThemeController>(
            init: ThemeController.instance,
            builder: (themeController) => GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Azkary',
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ar', 'AE'),
                Locale('en', ''),
                Locale('es', ''),
              ],
              locale: AzkaryController.instance.initialLang.value,
              theme:
                  AppThemes.getThemeById(themeController.currentThemeId.value)
                      .data,
              darkTheme: AppThemes.darkTheme.data,
              themeMode: themeController.currentThemeId.value == 'dark'
                  ? ThemeMode.dark
                  : ThemeMode.light,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              home: const Directionality(
                textDirection: TextDirection.rtl,
                child: pages.HomePage(),
              ),
            ),
          );
        });
  }
}
