import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/myApp.dart';
import 'core/services/notifications_helper.dart' as notify;
import 'presentation/controllers/azkary_controller.dart';
import 'presentation/controllers/reminder_controller.dart';
import 'presentation/screens/azkar/azkar.dart';
import 'presentation/screens/books/books.dart';
import 'presentation/screens/quran_azkar/quran_azkar.dart';

// دالة التشغيل الرئيسية / Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تعيين حجم النافذة للأنظمة المكتبية / Set window size for desktop platforms
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    windowSize();
  }

  // تهيئة GetStorage (طبقة التخزين الموحّدة) / Initialize GetStorage (unified storage)
  await GetStorage.init();

  // تهيئة الإشعارات / Initialize notifications
  await init();

  // تسجيل المتحكمات العامة (تُستخدم قبل أي مسار وأثناء دورة حياة التطبيق)
  // Register global controllers (used before any route and across app lifecycle)
  Get.put(AzkaryController());
  Get.put(ReminderController());
  Get.put(AzkarController());
  Get.put(BooksController());
  Get.put(QuranAzkarController());

  runApp(MyApp(
    theme: ThemeData.light(),
  ));

  // تهيئة تقييم التطبيق بعد بناء الإطار الأول / Init app rating after first frame
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => AzkaryController.instance.initAppRating(),
  );
}

// تعيين حجم النافذة / Set window size
Future<void> windowSize() async {
  await DesktopWindow.setMinWindowSize(const Size(860, 640));
}

// تهيئة الإشعارات / Initialize notifications
Future<void> init() async {
  // تهيئة Awesome Notifications / Initialize Awesome Notifications
  notify.NotifyHelper.initAwesomeNotifications();

  // تهيئة المستمعين والأذونات / Initialize listeners and permissions
  final notifyHelper = notify.NotifyHelper();
  notifyHelper.setNotificationsListeners();
  await notifyHelper.requistPermissions();
}
