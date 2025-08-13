import 'dart:async';
import 'dart:developer';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../azkar/screens/azkar_item.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/reminder_model.dart';
import '../../widgets/widgets/widgets.dart';
import '../services/notifications_helper.dart';

// تحكم رئيسي لإدارة الأذكار والتذكيرات والإعدادات
// Main controller for managing azkar, reminders and settings
class AzkaryController extends GetxController {
  // إنشاء مثيل من الكنترولر مع التحقق من التسجيل
  // Create controller instance with registration check
  static AzkaryController get instance => Get.isRegistered<AzkaryController>()
      ? Get.find<AzkaryController>()
      : Get.put(AzkaryController());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // المتغيرات التفاعلية / Reactive variables
  final RxString greeting = ''.obs;
  final Rx<TimeOfDay?> changedTimeOfDay = Rx<TimeOfDay?>(null);
  final RxBool isReminderEnabled = false.obs;
  final Rx<Time> time = Time(hour: 11, minute: 30, second: 20).obs;
  final RxBool iosStyle = true.obs;
  final RxList<Reminder> reminders = <Reminder>[].obs;
  final RxBool selected = false.obs;
  final arabicNumber = ArabicNumbers();
  final RxnInt shareTafseerValue = RxnInt();
  final RxBool isShowSettings = false.obs;
  final Rxn<Locale> initialLang = Rxn<Locale>();
  final controller = ScrollController();

  @override
  void onInit() {
    super.onInit();
    // تحديث التحية عند بدء تشغيل الكنترولر
    // Update greeting when controller starts
    updateGreeting();
    loadLang();
    loadAzkarFontSize();
    loadReminders();
    log('AzkaryController initialized', name: 'AzkaryController');
  }

  /// إدارة التفضيلات المشتركة / Shared Preferences Management

  // حفظ وتحميل حجم خط الأذكار
  // Save & Load Azkar Text Font Size
  Future<void> saveAzkarFontSize(double fontSizeAzkar) async {
    try {
      SharedPreferences prefs = await _prefs;
      await prefs.setDouble("font_azkar_size", fontSizeAzkar);
      log('Font size saved: $fontSizeAzkar', name: 'AzkaryController');
    } catch (e) {
      log('Error saving font size: $e', name: 'AzkaryController');
    }
  }

  Future<void> loadAzkarFontSize() async {
    try {
      SharedPreferences prefs = await _prefs;
      AzkarItem.fontSizeAzkar = prefs.getDouble('font_azkar_size') ?? 18;
      log('Font size loaded: ${AzkarItem.fontSizeAzkar}',
          name: 'AzkaryController');
    } catch (e) {
      log('Error loading font size: $e', name: 'AzkaryController');
    }
  }

  // حفظ وتحميل اللغة
  // Save & Load Language
  Future<void> saveLang(String lan) async {
    try {
      SharedPreferences prefs = await _prefs;
      await prefs.setString("lang", lan);
      log('Language saved: $lan', name: 'AzkaryController');
    } catch (e) {
      log('Error saving language: $e', name: 'AzkaryController');
    }
  }

  Future<void> loadLang() async {
    try {
      SharedPreferences prefs = await _prefs;
      initialLang.value = prefs.getString("lang") == null
          ? const Locale('ar', 'AE')
          : Locale(prefs.getString("lang")!);
      log('Language loaded: ${initialLang.value}', name: 'AzkaryController');
    } catch (e) {
      log('Error loading language: $e', name: 'AzkaryController');
    }
  }

  // مسح التفضيلات المشتركة
  // Clear SharedPreferences
  Future<void> clearPreference(String value) async {
    try {
      SharedPreferences prefs = await _prefs;
      await prefs.remove(value);
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

  /// إدارة الوقت / Time Management
  String get lastRead =>
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  /// إدارة التذكيرات / Reminder Management

  // تحميل التذكيرات
  // Load reminders
  void loadReminders() async {
    try {
      List<Reminder> loadedReminders = await ReminderStorage.loadReminders();
      reminders.value = loadedReminders;
      log('Reminders loaded: ${reminders.length}', name: 'AzkaryController');
    } catch (e) {
      log('Error loading reminders: $e', name: 'AzkaryController');
    }
  }

  // عرض منتقي الوقت
  // Show time picker
  Future<bool> showTimePicker(BuildContext context, Reminder reminder) async {
    bool isConfirmed = false;
    Time initialTime = time.value;
    TimeOfDay initialTimeOfDay =
        TimeOfDay(hour: initialTime.hour, minute: initialTime.minute);

    try {
      await Navigator.of(context).push(
        showPicker(
          context: context,
          value: time.value,
          onChange: (selectedTime) {
            changedTimeOfDay.value = selectedTime;
            log('Time changed: ${changedTimeOfDay.value}',
                name: 'AzkaryController');
          },
          accentColor: Theme.of(context).colorScheme.surface,
          okText: AppLocalizations.of(context)!.ok,
          okStyle: TextStyle(
            fontFamily: 'kufi',
            fontSize: 14,
            color: Theme.of(context).colorScheme.surface,
          ),
          cancelText: AppLocalizations.of(context)!.cancel,
          cancelStyle: TextStyle(
              fontFamily: 'kufi',
              fontSize: 14,
              color: Theme.of(context).colorScheme.surface),
          themeData: ThemeData(
            cardColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      );

      if (changedTimeOfDay.value != null &&
          changedTimeOfDay.value != initialTimeOfDay) {
        final int hour = changedTimeOfDay.value!.hour;
        final int minute = changedTimeOfDay.value!.minute;
        // تحديث وقت التذكير
        // Update reminder time
        reminder.time = Time(hour: hour, minute: minute);

        // جدولة الإشعار للتذكير
        // Schedule notification for reminder
        await _scheduleReminderNotification(reminder);

        // تأكيد تحديد الوقت
        // Confirm time selection
        isConfirmed = true;

        // تحديث واجهة المستخدم
        // Update UI
        update(['main_screen']);

        log('Reminder time updated: ${hour}:${minute}',
            name: 'AzkaryController');
      }
    } catch (e) {
      log('Error showing time picker: $e', name: 'AzkaryController');
    }

    return isConfirmed;
  }

  // إضافة تذكير جديد
  // Add new reminder
  Future<void> addReminder() async {
    try {
      String reminderName = "";
      DateTime now = DateTime.now();
      Time currentTime = Time(hour: now.hour, minute: now.minute);

      reminders.add(Reminder(
          id: reminders.length,
          isEnabled: false,
          time: currentTime,
          name: reminderName));

      await ReminderStorage.saveReminders(reminders);
      log('Reminder added, total: ${reminders.length}',
          name: 'AzkaryController');
    } catch (e) {
      log('Error adding reminder: $e', name: 'AzkaryController');
    }
  }

  // حذف تذكير
  // Delete reminder
  Future<void> deleteReminder(BuildContext context, int index) async {
    try {
      // إلغاء الإشعار المجدول
      // Cancel scheduled notification
      await _cancelReminderNotification(reminders[index].id);

      // حذف التذكير
      // Delete reminder
      await ReminderStorage.deleteReminder(index).then((value) =>
          customSnackBar(
              context, AppLocalizations.of(context)!.deletedReminder));

      // تحديث قائمة التذكيرات
      // Update reminders list
      reminders.removeAt(index);

      // تحديث معرفات التذكيرات
      // Update reminder IDs
      for (int i = index; i < reminders.length; i++) {
        reminders[i].id = i;
      }

      // حفظ قائمة التذكيرات المحدثة
      // Save updated reminders list
      await ReminderStorage.saveReminders(reminders);
      log('Reminder deleted at index: $index', name: 'AzkaryController');
    } catch (e) {
      log('Error deleting reminder: $e', name: 'AzkaryController');
    }
  }

  // تغيير الوقت
  // Change time
  void onTimeChanged(Time newTime) {
    time.value = newTime;
    log('Time changed to: ${newTime.hour}:${newTime.minute}',
        name: 'AzkaryController');
  }

  // جدولة إشعار التذكير
  // Schedule reminder notification
  Future<void> _scheduleReminderNotification(Reminder reminder) async {
    try {
      final notifyHelper = NotifyHelper();

      // إنشاء وقت الجدولة
      // Create scheduled time
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        reminder.time.hour,
        reminder.time.minute,
      );

      // إذا كان الوقت المحدد قد مضى اليوم، جدوله للغد
      // If the scheduled time has passed today, schedule for tomorrow
      final finalScheduledTime = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      await notifyHelper.scheduleReminderNotification(
        reminderId: reminder.id,
        reminderName: reminder.name,
        scheduledTime: finalScheduledTime,
        isRepeating: true, // تكرار يومي / Daily repeat
      );

      log('Notification scheduled for reminder ${reminder.id} at ${reminder.time.hour}:${reminder.time.minute}',
          name: 'AzkaryController');
    } catch (e) {
      log('Error scheduling reminder notification: $e',
          name: 'AzkaryController');
    }
  }

  // إلغاء إشعار التذكير
  // Cancel reminder notification
  Future<void> _cancelReminderNotification(int reminderId) async {
    try {
      final notifyHelper = NotifyHelper();
      await notifyHelper.cancelNotification(reminderId);
      log('Notification cancelled for reminder $reminderId',
          name: 'AzkaryController');
    } catch (e) {
      log('Error cancelling reminder notification: $e',
          name: 'AzkaryController');
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
    log('AzkaryController disposed', name: 'AzkaryController');
  }
}
