import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import '../../home_page.dart';
import '../../screens/splash_screen.dart';
import '../../shared/lists.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:home_widget/home_widget.dart';
import '../../shared/postPage.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'cubit/cubit.dart';
import 'l10n/app_localizations.dart';


/// Used for Background Updates using Workmanager Plugin
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    print('Background task started: $taskName'); // Added print statement

    // Generate a random Zikr
    Set<int> usedIndices = {};
    int randomIndex;
    do {
      randomIndex = Random().nextInt(zikr.length);
    } while (usedIndices.contains(randomIndex));
    usedIndices.add(randomIndex);
    final randomZikr = zikr[randomIndex];


    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'zikr',
        randomZikr,
      ),
      HomeWidget.updateWidget(
        name: 'ZikerWidget',
        iOSName: 'ZikerWidget',
      ),
    ]).then((value) {
      print('Background task completed: $taskName'); // Added print statement
      return !value.contains(false);
    });
  });
}

/// Called when Doing Background Work initiated from Widget
@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
  print(data);

  if (data!.host == 'zikr') {
    Set<int> usedIndices = {};
    int randomIndex;
    do {
      randomIndex = Random().nextInt(zikr.length);
    } while (usedIndices.contains(randomIndex));
    usedIndices.add(randomIndex);
    final randomZikr = zikr[randomIndex];

    await HomeWidget.saveWidgetData<String>('zikr', randomZikr);
    await HomeWidget.updateWidget(
        name: 'ZikerWidget', iOSName: 'ZikerWidget');
  }
}



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
  Set<int> usedIndices = {};

  void setLocale(Locale value) {
    setState(() {
      QuranCubit.get(context).initialLang = value;
    });
  }
  Future<void> _saveRandomZikr() async {
    if (usedIndices.length == zikr.length) {
      usedIndices.clear();
    }

    int randomIndex;
    do {
      randomIndex = Random().nextInt(zikr.length);
    } while (usedIndices.contains(randomIndex));

    usedIndices.add(randomIndex);
    final randomZikr = zikr[randomIndex];

    try {
      await HomeWidget.saveWidgetData<String>('zikr', randomZikr);
    } on PlatformException catch (exception) {
      debugPrint('Error Saving Random Zikr. $exception');
    }
  }

  Future<void> saveHijriDate() async {
    ArabicNumbers arabicNumber = ArabicNumbers();
    // HijriCalendar.setLocal('en');
    var _today = HijriCalendar.now();
    String day = "${arabicNumber.convert(_today.hDay)}";
    String year = "${arabicNumber.convert(_today.hYear)}";
    await HomeWidget.saveWidgetData<String>('hijriDay', "$day");
    await HomeWidget.saveWidgetData<String>('hijriMonth', _today.hMonth.toString());
    await HomeWidget.saveWidgetData<String>('hijriYear', "$year");
  }

  @override
  void initState() {
    super.initState();
    if(Platform.isIOS || Platform.isAndroid) {
      // Initialize Workmanager
      final workManager = Workmanager();
      workManager.initialize(
        callbackDispatcher, // Your callbackDispatcher function
        isInDebugMode: false, // Set to false in production builds
      );
      HomeWidget.setAppGroupId('com.alheekmah.hisnulmuslim.widget');
      saveHijriDate();
      Timer.periodic(const Duration(minutes: 1), (timer) async {
        await _saveRandomZikr();
        await _updateWidget();
      });
      HomeWidget.registerBackgroundCallback(backgroundCallback);
      // _startBackgroundUpdate();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Future<void> _updateWidget() async {
    try {
      await HomeWidget.updateWidget(
          name: 'ZikerWidget', iOSName: 'ZikerWidget');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  // void _startBackgroundUpdate() {
  //   Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
  //       frequency: const Duration(minutes: 1));
  // }
  //
  // void _stopBackgroundUpdate() {
  //   Workmanager().cancelByUniqueName('1');
  // }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Theme.of(context).primaryColorDark
    // ));
    // page.QuranCubit cubit = page.QuranCubit.get(context);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return ThemeProvider(
      defaultThemeId: 'green',
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance.platformDispatcher.platformBrightness ??
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
              onSurface: Color(0xff213555),),
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
              onSurface: Color(0xff41644A),),
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
              onSurface: Color(0xff41644A),),
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
        child: Builder(
            builder: (themeContext) {
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
              locale: QuranCubit.get(context).initialLang,
              theme: ThemeProvider.themeOf(themeContext).data,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              routes: {
                // Other routes...
                '/post': (context) {
                  int postId = ModalRoute.of(context)!.settings.arguments as int;
                  return PostPage(postId: postId);
                },
              },
              home: const Directionality(
                textDirection: TextDirection.rtl,
                child: HomePage(),

              ),
            );
          }
        ),
      ),
    );
  }
}
