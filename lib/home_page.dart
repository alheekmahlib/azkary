import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../screens/splash_screen.dart';
import 'core/core.dart';

final GlobalKey<NavigatorState> navigatorNotificationKey =
    GlobalKey<NavigatorState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  static _HomePageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>();
}

List<Map<String, dynamic>> sentNotifications = [];

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (Platform.isIOS || Platform.isAndroid) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   initializeLocalNotifications(context);
      // });
      rateMyApp.init().then((_) {
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showRateDialog(
            context,
            title: 'Rate this app',
            // The dialog title.
            message:
                'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
            // The dialog message.
            rateButton: 'RATE',
            // The dialog "rate" button text.
            noButton: 'NO THANKS',
            // The dialog "no" button text.
            laterButton: 'MAYBE LATER',
            // The dialog "later" button text.
            listener: (button) {
              // The button click listener (useful if you want to cancel the click event).
              switch (button) {
                case RateMyAppDialogButton.rate:
                  print('Clicked on "Rate".');
                  break;
                case RateMyAppDialogButton.later:
                  print('Clicked on "Later".');
                  break;
                case RateMyAppDialogButton.no:
                  print('Clicked on "No".');
                  break;
              }

              return true; // Return false if you want to cancel the click event.
            },
            ignoreNativeDialog: Platform.isAndroid,
            // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
            dialogStyle: const DialogStyle(),
            // Custom dialog styles.

            onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
                .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
            // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
            // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
          );
        }
      });
    }
    AzkaryController.instance.loadLang();
    // notifyHelper = notifications.NotifyHelper();
    // notifyHelper.requestIOSPermissions();
    // notifyHelper.requestMACPermissions();
    AzkaryController.instance.updateGreeting();
    AzkaryController.instance.loadAzkarFontSize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 5,
    minLaunches: 7,
    remindDays: 15,
    remindLaunches: 20,
    googlePlayIdentifier: 'com.alheekmah.azkaryapp',
    appStoreIdentifier: '6451125110',
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => SplashScreen(),
        desktop: (BuildContext context) => SplashScreen(),
        breakpoints:
            const ScreenBreakpoints(desktop: 650, tablet: 450, watch: 300),
      ),
    );
  }
}
