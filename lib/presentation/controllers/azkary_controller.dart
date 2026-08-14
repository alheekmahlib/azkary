import 'dart:async';
import 'dart:developer';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'reminder_model.dart';
import 'reminder_controller.dart';

/// AzkaryController - تحكم في الإعدادات العامة (اللغة، الخط، التحية)
/// Controller for general settings (language, font, greeting)
///
/// منطق التذكيرات منقول إلى ReminderController لفصل المسؤوليات.
/// يحتفظ بواجهات تفويض (delegates) للتذكيرات للحفاظ على التوافق الخلفي
/// مع الشاشات التي تستخدم AzkaryController.instance للتذكيرات.
/// Reminders logic moved to ReminderController for separation of concerns.
/// Keeps delegate accessors for backwards compatibility with screens using
/// AzkaryController.instance for reminders.
class AzkaryController extends GetxController {
  // إنشاء مثيل من الكنترولر مع التحقق من التسجيل
  // Create controller instance with registration check
  static AzkaryController get instance => Get.isRegistered<AzkaryController>()
      ? Get.find<AzkaryController>()
      : Get.put(AzkaryController());

  // طبقة التخزين الموحّدة / Unified storage layer
  final GetStorage _box = GetStorage();

  // المتغيرات التفاعلية العامة / General reactive variables
  final RxString greeting = ''.obs;
  final RxBool selected = false.obs;
  final arabicNumber = ArabicNumbers();
  final RxnInt shareTafseerValue = RxnInt();
  final RxBool isShowSettings = false.obs;
  final Rxn<Locale> initialLang = Rxn<Locale>();
  final controller = ScrollController();

  /// حجم خط الأذكار كمصدر تفاعلي وحيد للحقيقة / Reactive single source of truth for azkar font size
  final RxDouble fontSizeAzkar = 18.0.obs;

  /// اختصار للوصول إلى التذكيرات عبر ReminderController
  /// Shortcut to access reminders via ReminderController (backwards compat)
  ReminderController get _reminderCtrl => ReminderController.instance;

  // مفاتيح تفويض للتذكيرات (توافق خلفي) / Reminder delegate accessors
  RxList<Reminder> get reminders => _reminderCtrl.reminders;
  RxBool get isReminderEnabled => _reminderCtrl.isReminderEnabled;
  Rx<Time> get time => _reminderCtrl.time;
  RxBool get iosStyle => _reminderCtrl.iosStyle;

  @override
  void onInit() {
    super.onInit();
    // تحديث التحية عند بدء تشغيل الكنترولر
    // Update greeting when controller starts
    updateGreeting();
    loadLang();
    loadAzkarFontSize();
    log('AzkaryController initialized', name: 'AzkaryController');
  }

  /// إدارة التخزين / Storage Management

  // حفظ وتحميل حجم خط الأذكار (المصدر التفاعلي الموحّد)
  // Save & Load Azkar Text Font Size (single reactive source)
  Future<void> saveAzkarFontSize(double fontSizeAzkar) async {
    try {
      this.fontSizeAzkar.value = fontSizeAzkar;
      await _box.write('font_azkar_size', fontSizeAzkar);
      log('Font size saved: $fontSizeAzkar', name: 'AzkaryController');
    } catch (e) {
      log('Error saving font size: $e', name: 'AzkaryController');
    }
  }

  Future<void> loadAzkarFontSize() async {
    try {
      fontSizeAzkar.value = _box.read<double>('font_azkar_size') ?? 18;
      log('Font size loaded: ${fontSizeAzkar.value}',
          name: 'AzkaryController');
    } catch (e) {
      log('Error loading font size: $e', name: 'AzkaryController');
    }
  }

  // حفظ وتحميل اللغة
  // Save & Load Language
  Future<void> saveLang(String lan) async {
    try {
      await _box.write('lang', lan);
      log('Language saved: $lan', name: 'AzkaryController');
    } catch (e) {
      log('Error saving language: $e', name: 'AzkaryController');
    }
  }

  /// تبديل اللغة فورياً عبر GetX وتخزينها / Switch language via GetX + persist
  ///
  /// يستخدم Get.updateLocale لتحديث locale لدى GetMaterialApp مباشرةً
  /// (الطريقة الرسمية من GetX لتغيير اللغة في وقت التشغيل).
  /// Uses Get.updateLocale to update GetMaterialApp's locale directly
  /// (the official GetX way to change language at runtime).
  void changeLocale(String langCode) {
    final locale = Locale(langCode);
    initialLang.value = locale;
    Get.updateLocale(locale);
    saveLang(langCode);
  }

  Future<void> loadLang() async {
    try {
      final langCode = _box.read<String>('lang');
      final locale =
          langCode == null ? const Locale('ar', 'AE') : Locale(langCode);
      initialLang.value = locale;
      // مزامنة Get.locale مع اللغة المحفوظة عند بدء التشغيل
      // Sync Get.locale with the persisted language at startup
      Get.locale = locale;
      log('Language loaded: $locale', name: 'AzkaryController');
    } catch (e) {
      log('Error loading language: $e', name: 'AzkaryController');
    }
  }

  // مسح قيمة من التخزين
  // Clear a stored value
  Future<void> clearPreference(String value) async {
    try {
      await _box.remove(value);
      log('Preference cleared: $value', name: 'AzkaryController');
    } catch (e) {
      log('Error clearing preference: $e', name: 'AzkaryController');
    }
  }

  // تحديث التحية حسب الوقت
  // Update greeting based on time
  void updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
    log('Greeting updated: ${greeting.value}', name: 'AzkaryController');
  }

  /// تقييم التطبيق (rateMyApp) — يُستدعى بعد بناء الإطار الأول
  /// App rating (rateMyApp) — invoked after the first frame
  late final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 5,
    minLaunches: 7,
    remindDays: 15,
    remindLaunches: 20,
    googlePlayIdentifier: 'com.alheekmah.azkaryapp',
    appStoreIdentifier: '6451125110',
  );

  /// تهيئة وعرض حوار تقييم التطبيق عند الاستحقاق
  /// Initialize and show the rate dialog when eligible
  Future<void> initAppRating() async {
    try {
      await rateMyApp.init();
      if (rateMyApp.shouldOpenDialog && Get.context != null) {
        rateMyApp.showRateDialog(
          Get.context!,
          title: 'Rate this app',
          message:
              'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
          rateButton: 'RATE',
          noButton: 'NO THANKS',
          laterButton: 'MAYBE LATER',
          listener: (button) {
            switch (button) {
              case RateMyAppDialogButton.rate:
                log('Clicked on "Rate".', name: 'AzkaryController');
                break;
              case RateMyAppDialogButton.later:
                log('Clicked on "Later".', name: 'AzkaryController');
                break;
              case RateMyAppDialogButton.no:
                log('Clicked on "No".', name: 'AzkaryController');
                break;
            }
            return true;
          },
          ignoreNativeDialog: false,
          dialogStyle: const DialogStyle(),
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    } catch (e) {
      log('Error initializing rate app: $e', name: 'AzkaryController');
    }
  }

  /// إدارة الوقت / Time Management
  String get lastRead =>
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';

  /// تفويض عمليات التذكيرات إلى ReminderController (توافق خلفي)
  /// Delegate reminder operations to ReminderController (backwards compat)
  void loadReminders() => _reminderCtrl.loadReminders();

  Future<bool> showTimePicker(BuildContext context, Reminder reminder) =>
      _reminderCtrl.showTimePicker(context, reminder);

  Future<void> addReminder() => _reminderCtrl.addReminder();

  Future<void> deleteReminder(BuildContext context, int index) =>
      _reminderCtrl.deleteReminder(context, index);

  Future<void> updateReminderName(int index, String name) =>
      _reminderCtrl.updateReminderName(index, name);

  Future<void> toggleReminder(int index, bool value) =>
      _reminderCtrl.toggleReminder(index, value);

  void onTimeChanged(dynamic newTime) => _reminderCtrl.onTimeChanged(newTime);

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
    log('AzkaryController disposed', name: 'AzkaryController');
  }
}
