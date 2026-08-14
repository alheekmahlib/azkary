import 'dart:async';
import 'dart:developer';

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reminder_model.dart';
import '../../core/widgets/widgets.dart';
import '../../core/services/notifications_helper.dart';

/// ReminderController - تحكم في التذكيرات والإشعارات المجدولة
/// Controller for managing reminders and scheduled notifications
///
/// منطق التذكيرات المستخرج من AzkaryController لفصل المسؤوليات.
/// Reminders logic extracted from AzkaryController for separation of concerns.
class ReminderController extends GetxController {
  static ReminderController get instance =>
      Get.isRegistered<ReminderController>()
          ? Get.find<ReminderController>()
          : Get.put(ReminderController());

  // المتغيرات التفاعلية للتذكيرات / Reactive reminder variables
  final Rx<TimeOfDay?> changedTimeOfDay = Rx<TimeOfDay?>(null);
  final RxBool isReminderEnabled = false.obs;
  final Rx<Time> time = Time(hour: 11, minute: 30, second: 20).obs;
  final RxBool iosStyle = true.obs;
  final RxList<Reminder> reminders = <Reminder>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
    log('ReminderController initialized', name: 'ReminderController');
  }

  /// تحميل التذكيرات / Load reminders
  void loadReminders() async {
    try {
      List<Reminder> loadedReminders = await ReminderStorage.loadReminders();
      reminders.value = loadedReminders;
      log('Reminders loaded: ${reminders.length}', name: 'ReminderController');
    } catch (e) {
      log('Error loading reminders: $e', name: 'ReminderController');
    }
  }

  /// عرض منتقي الوقت / Show time picker
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
                name: 'ReminderController');
          },
          accentColor: Theme.of(context).colorScheme.surface,
          okText: 'ok'.tr,
          okStyle: TextStyle(
            fontFamily: 'kufi',
            fontSize: 14,
            color: Theme.of(context).colorScheme.surface,
          ),
          cancelText: 'cancel'.tr,
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

        log('Reminder time updated: $hour:$minute', name: 'ReminderController');
      }
    } catch (e) {
      log('Error showing time picker: $e', name: 'ReminderController');
    }

    return isConfirmed;
  }

  /// إضافة تذكير جديد / Add new reminder
  Future<void> addReminder() async {
    try {
      String reminderName = '';
      DateTime now = DateTime.now();
      Time currentTime = Time(hour: now.hour, minute: now.minute);

      reminders.add(Reminder(
          id: reminders.length,
          isEnabled: false,
          time: currentTime,
          name: reminderName));

      await ReminderStorage.saveReminders(reminders);
      log('Reminder added, total: ${reminders.length}',
          name: 'ReminderController');
    } catch (e) {
      log('Error adding reminder: $e', name: 'ReminderController');
    }
  }

  /// حذف تذكير / Delete reminder
  Future<void> deleteReminder(BuildContext context, int index) async {
    try {
      // إلغاء الإشعار المجدول
      // Cancel scheduled notification
      await _cancelReminderNotification(reminders[index].id);

      // حذف التذكير
      // Delete reminder
      await ReminderStorage.deleteReminder(index).then((value) =>
          customSnackBar(
              context, 'deletedReminder'.tr));

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
      log('Reminder deleted at index: $index', name: 'ReminderController');
    } catch (e) {
      log('Error deleting reminder: $e', name: 'ReminderController');
    }
  }

  /// تغيير الوقت / Change time
  void onTimeChanged(Time newTime) {
    time.value = newTime;
    log('Time changed to: ${newTime.hour}:${newTime.minute}',
        name: 'ReminderController');
  }

  /// تحديث اسم تذكير وحفظه ثم تحديث الواجهة
  /// Update a reminder's name, persist, then refresh the UI
  Future<void> updateReminderName(int index, String name) async {
    if (index < 0 || index >= reminders.length) return;
    reminders[index].name = name;
    await ReminderStorage.saveReminders(reminders);
    update(['main_screen']);
  }

  /// تبديل تفعيل تذكير وحفظه ثم تحديث الواجهة
  /// Toggle a reminder's enabled flag, persist, then refresh the UI
  Future<void> toggleReminder(int index, bool value) async {
    if (index < 0 || index >= reminders.length) return;
    reminders[index].isEnabled = value;
    await ReminderStorage.saveReminders(reminders);
    update(['main_screen']);
  }

  /// جدولة إشعار التذكير / Schedule reminder notification
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
          name: 'ReminderController');
    } catch (e) {
      log('Error scheduling reminder notification: $e',
          name: 'ReminderController');
    }
  }

  /// إلغاء إشعار التذكير / Cancel reminder notification
  Future<void> _cancelReminderNotification(int reminderId) async {
    try {
      final notifyHelper = NotifyHelper();
      await notifyHelper.cancelNotification(reminderId);
      log('Notification cancelled for reminder $reminderId',
          name: 'ReminderController');
    } catch (e) {
      log('Error cancelling reminder notification: $e',
          name: 'ReminderController');
    }
  }
}
