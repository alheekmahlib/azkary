import 'dart:async';
import 'package:husn_al_muslim/cubit/cubit.dart';
import 'package:husn_al_muslim/screens/splash_screen.dart';
import 'package:husn_al_muslim/shared/local_notifications.dart';
import 'package:husn_al_muslim/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:io';
import 'database/notificationDatabase.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:husn_al_muslim/shared/postPage.dart';

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
  late NotifyHelper notifyHelper;
  DateTime now = DateTime.now();


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;

  Future<void> initializeLocalNotifications(BuildContext context) async {
    print('Initializing local notifications...');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) async {
        if (response != null && response.payload != null) {
          debugPrint('notification payload: ' + response.payload!);
        }
        // selectNotificationSubject.add(payload!);
      },
    );
  }

  void selectNotification(String payload) async {
    print('Notification tapped, payload: $payload');
    Navigator.of(navigatorNotificationKey.currentContext!).push(
      animatNameRoute(
        pushName: '/post',
        myWidget: PostPage(postId: int.parse(payload)),
      ),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text(body!));
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute + 1);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduledNotification(
      int reminderId, int hour, int minutes, String reminderName) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        reminderId,
        'حصن المسلم - مكتبة الحكمة',
        reminderName,
        _nextInstanceOfTenAM(hour, minutes),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'notificationIdChannel', 'notificationChannel',
              icon: '@drawable/ic_launcher'),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: reminderId.toString(),
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }

    // Add the notification to the sentNotifications list
    setState(() {
      sentNotifications.add({
        'id': reminderId,
        'title': reminderName,
        'hour': hour,
        'minutes': minutes,
        'opened': false, // Add this line
        'timestamp': now, // Add this line
      });
    });
  }

  void startPeriodicTask() async {
    print('Task triggered on app start');
    final latestPosts = await fetchLatestPosts();
    print('Latest posts: ${latestPosts.toString()}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    int lastSeenPostId = prefs.getInt('lastSeenPostId') ?? 0;

    int newLastSeenPostId = lastSeenPostId;

    for (var post in latestPosts) {
      print('Checking post with id: ${post['id']} and title: ${post['title']}');
      print('Post ID: ${post['id']}, lastSeenPostId: $lastSeenPostId');
      if (post['id'] > lastSeenPostId) {
        int reminderId = post['id'];
        int hour = 10;
        int minutes = 0;
        String reminderName = post['title'];

        print(
            'Scheduling notification for post id: $reminderId, title: $reminderName');
        await scheduledNotification(
            reminderId, hour, minutes, reminderName); // pass context here
        print(
            'Notification scheduled for post id: $reminderId, title: $reminderName');

        // Save the notification data to the SQLite database
        await NotificationDatabaseHelper.instance.insertNotification({
          'id': reminderId,
          'title': reminderName,
          // Add other relevant columns if needed
        });

        if (post['id'] > newLastSeenPostId) {
          newLastSeenPostId = post['id'];
        }
      }
    }

    await prefs.setInt('lastSeenPostId', newLastSeenPostId);
  }

  displayNotification({
    required String title,
    required String body,
    required int postId,
  }) async {
    print('doing test');
    sentNotifications.add({'title': title, 'body': body, 'postId': postId});
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'notificationIdChannel',
      'notificationChannel',
      importance: Importance.max,
      icon: '@drawable/ic_launcher',
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: postId.toString(),
    );

    // Add sent notification to the sentNotifications list
    sentNotifications.add({
      'title': title,
      'body': body,
      'postId': postId,
    });
  }

  Future<List<Map<String, dynamic>>> fetchLatestPosts() async {
    final response = await http.get(Uri.parse(
        'https://github.com/alheekmahlib/thegarlanded/blob/master/azkar_noti.json?raw=true'));

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        // Return an empty list if the response body is empty
        return [];
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> posts = jsonResponse
          .map((post) => {
                'id': post['id'],
                'title': post['title'],
                'body': post['body'],
                'isLottie': post['isLottie'],
                'lottie': post['lottie'],
                'isImage': post['isImage'],
                'image': post['image'],
              })
          .toList();

      return posts;
    } else {
      print('Status code: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load posts');
    }
  }

  Future<void> _initializeApp(BuildContext context) async {
    await initializeLocalNotifications(context);
    startPeriodicTask();
  }

  @override
  void initState() {
    if (Platform.isIOS || Platform.isAndroid) {
      _initializeApp(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initializeLocalNotifications(context);
      });
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
    QuranCubit.get(context).loadLang();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.requestMACPermissions();
    QuranCubit.get(context).updateGreeting();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   PostPage.of(context)?.initializeLocalNotifications();
    //   // PostPage.of(context)?.startPeriodicTask(timesADay: 4);
    //   PostPage.of(context)?.startPeriodicTask(minutesInterval: 15);
    // });
    // initialization();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    googlePlayIdentifier: 'com.alheekmah.alquranalkareem.alquranalkareem',
    appStoreIdentifier: '1500153222',
  );

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => SplashScreen(),
      desktop: (BuildContext context) => SplashScreen(),
      breakpoints:
      const ScreenBreakpoints(desktop: 650, tablet: 450, watch: 300),
    );
  }
}
