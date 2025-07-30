import 'dart:async';
import 'dart:io';

import 'package:Azkary/myApp.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'azkar/controllers/azkar_controller.dart';
import 'books/controllers/books_controller.dart';
import 'core/core.dart';
import 'database/databaseHelper.dart';
import 'database/notificationDatabase.dart';
import 'quran_azkar/controllers/quran_azkar_controller.dart';

// دالة التشغيل الرئيسية / Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة المنطقة الزمنية / Initialize timezone
  // final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  // tz.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation(timeZoneName));

  // تهيئة قاعدة البيانات للأنظمة المكتبية / Initialize database for desktop platforms
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }

  // تعيين حجم النافذة للأنظمة المكتبية / Set window size for desktop platforms
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    windowSize();
  }

  // تهيئة قواعد البيانات والإشعارات / Initialize databases and notifications
  await init();
  // tz.initializeTimeZones();

  // تهيئة الخدمات / Initialize services
  await Get.putAsync(() async => ConnectivityService());
  await Get.putAsync(() async => ApiClient());

  // تهيئة Controllers / Initialize controllers
  Get.put(AzkaryController());
  Get.put(AzkarController());
  Get.put(BooksController());
  Get.put(QuranAzkarController()); // تشغيل التطبيق / Run app
  runApp(MyApp(
    theme: ThemeData.light(),
  ));
}

// تعيين حجم النافذة / Set window size
Future<void> windowSize() async {
  await DesktopWindow.setMinWindowSize(const Size(860, 640));
}

// تهيئة قواعد البيانات والإشعارات / Initialize databases and notifications
Future<void> init() async {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  databaseHelper.database;
  NotificationDatabaseHelper notificationdatabaseHelper =
      NotificationDatabaseHelper.instance;
  notificationdatabaseHelper.database;
  NotifyHelper().initializeNotification();
}
