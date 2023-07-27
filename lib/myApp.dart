import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../home_page.dart';
import '../../screens/splash_screen.dart';
import '../../shared/postPage.dart';
import 'cubit/cubit.dart';
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
      AzkaryCubit.get(context).initialLang = value;
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
          return ThemeProvider(
            defaultThemeId: 'green',
            saveThemesOnChange: true,
            loadThemeOnInit: false,
            onInitCallback: (controller, previouslySavedThemeFuture) async {
              String? savedTheme = await previouslySavedThemeFuture;
              if (savedTheme != null) {
                controller.setTheme(savedTheme);
              } else {
                Brightness platformBrightness = SchedulerBinding
                        .instance.platformDispatcher.platformBrightness ??
                    Brightness.light;
                if (platformBrightness == Brightness.dark) {
                  controller.setTheme('dark');
                } else {
                  controller.setTheme('green');
                }
                controller.forgetSavedTheme();
              }
            },
            themes: <AppTheme>[
              AppTheme(
                id: 'blue',
                description: "My blue Theme",
                data: ThemeData(
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xff4F709C),
                    onPrimary: Color(0xff213555),
                    secondary: Color(0xffe7dfce),
                    onSecondary: Color(0xffD8C4B6),
                    error: Color(0xff213555),
                    onError: Color(0xff213555),
                    background: Color(0xffF5EFE7),
                    onBackground: Color(0xffF5EFE7),
                    surface: Color(0xff213555),
                    onSurface: Color(0xff213555),
                  ),
                  primaryColor: const Color(0xff4F709C),
                  primaryColorLight: const Color(0xffD8C4B6),
                  primaryColorDark: const Color(0xff213555),
                  dialogBackgroundColor: const Color(0xffF5EFE7),
                  dividerColor: const Color(0xffD8C4B6),
                  highlightColor: const Color(0xffD8C4B6).withOpacity(0.3),
                  indicatorColor: const Color(0xffD8C4B6),
                  scaffoldBackgroundColor: const Color(0xff213555),
                  canvasColor: const Color(0xffF2E5D5),
                  hoverColor: const Color(0xffF2E5D5).withOpacity(0.3),
                  disabledColor: const Color(0Xffffffff),
                  hintColor: const Color(0xff213555),
                  focusColor: const Color(0xff4F709C),
                  secondaryHeaderColor: const Color(0xff4F709C),
                  cardColor: const Color(0xff213555),
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor: const Color(0xff213555).withOpacity(0.3),
                      selectionHandleColor: const Color(0xff213555)),
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: Color(0xff213555),
                  ),
                ).copyWith(useMaterial3: true),
              ),
              AppTheme(
                id: 'green',
                description: "My green Theme",
                data: ThemeData(
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xffF7E6C4),
                    onPrimary: Color(0xffF7E6C4),
                    secondary: Color(0xffe7dfce),
                    onSecondary: Color(0xff263A29),
                    error: Color(0xff41644A),
                    onError: Color(0xff41644A),
                    background: Color(0xffF5EFE7),
                    onBackground: Color(0xffF5EFE7),
                    surface: Color(0xff41644A),
                    onSurface: Color(0xff41644A),
                  ),
                  primaryColor: const Color(0xffF7E6C4),
                  primaryColorLight: const Color(0xff263A29),
                  primaryColorDark: const Color(0xff263A29),
                  dialogBackgroundColor: const Color(0xff263A29),
                  dividerColor: const Color(0xffE86A33),
                  highlightColor: const Color(0xff41644A).withOpacity(0.3),
                  indicatorColor: const Color(0xffE86A33),
                  scaffoldBackgroundColor: const Color(0xffF7E6C4),
                  canvasColor: const Color(0xffF5EFE7),
                  hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
                  disabledColor: const Color(0Xffffffff),
                  hintColor: const Color(0xffF7E6C4),
                  focusColor: const Color(0xff41644A),
                  secondaryHeaderColor: const Color(0xff263A29),
                  cardColor: const Color(0xffF7E6C4),
                  dividerTheme: const DividerThemeData(
                    color: Color(0xffE86A33),
                  ),
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor: const Color(0xff41644A).withOpacity(0.3),
                      selectionHandleColor: const Color(0xff41644A)),
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: Color(0xff606c38),
                  ),
                ).copyWith(useMaterial3: true),
              ),
              AppTheme(
                id: 'dark',
                description: "My dark Theme",
                data: ThemeData(
                  colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xff3F3F3F),
                    onPrimary: Color(0xff252526),
                    secondary: Color(0xff19191a),
                    onSecondary: Color(0xff4d4d4d),
                    error: Color(0xff41644A),
                    onError: Color(0xff41644A),
                    background: Color(0xff19191a),
                    onBackground: Color(0xff3F3F3F),
                    surface: Color(0xff41644A),
                    onSurface: Color(0xff41644A),
                  ),
                  primaryColor: const Color(0xff3F3F3F),
                  primaryColorLight: const Color(0xff4d4d4d),
                  primaryColorDark: const Color(0xff010101),
                  dialogBackgroundColor: const Color(0xff3F3F3F),
                  dividerColor: const Color(0xff41644A),
                  highlightColor: const Color(0xff41644A).withOpacity(0.3),
                  indicatorColor: const Color(0xff41644A),
                  scaffoldBackgroundColor: const Color(0xff252526),
                  canvasColor: const Color(0xffF5EFE7),
                  hoverColor: const Color(0xfff2f1da).withOpacity(0.3),
                  disabledColor: const Color(0Xffffffff),
                  hintColor: const Color(0xff252526),
                  focusColor: const Color(0xff41644A),
                  secondaryHeaderColor: const Color(0xff41644A),
                  cardColor: const Color(0xffF5EFE7),
                  textSelectionTheme: TextSelectionThemeData(
                      selectionColor: const Color(0xff41644A).withOpacity(0.3),
                      selectionHandleColor: const Color(0xff41644A)),
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    primaryColor: Color(0xff213555),
                  ),
                ).copyWith(useMaterial3: true),
              ),
            ],
            child: ThemeConsumer(
              child: Builder(builder: (themeContext) {
                return GetMaterialApp(
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
                  locale: AzkaryCubit.get(context).initialLang,
                  theme: ThemeProvider.themeOf(themeContext).data,
                  builder: BotToastInit(),
                  navigatorObservers: [BotToastNavigatorObserver()],
                  routes: {
                    // Other routes...
                    '/post': (context) {
                      int postId =
                          ModalRoute.of(context)!.settings.arguments as int;
                      return PostPage(postId: postId);
                    },
                  },
                  home: const Directionality(
                    textDirection: TextDirection.rtl,
                    child: HomePage(),
                  ),
                );
              }),
            ),
          );
        });
  }
}
