import 'dart:developer' show log;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart' show Colors;

import '../../widgets/local_notification/controller/local_notifications_controller.dart';

class NotifyHelper {
  // دالة مُحسنة لجدولة تذكيرات الأذكار
  // Enhanced function for scheduling dhikr reminders
  Future<void> scheduleReminderNotification({
    required int reminderId,
    required String reminderName,
    required DateTime scheduledTime,
    bool isRepeating = true,
  }) async {
    await scheduledNotification(
      reminderId: reminderId,
      title: 'أذكاري - مكتبة الحكمة',
      summary: 'تذكير بالأذكار',
      body: reminderName.isEmpty ? 'حان وقت الذكر والدعاء' : reminderName,
      isRepeats: isRepeating,
      time: scheduledTime,
      payload: {
        'type': 'reminder',
        'reminder_id': reminderId.toString(),
        'reminder_name': reminderName,
      },
    );
  }

  Future<void> scheduledNotification({
    required int reminderId,
    required String title,
    required String summary,
    required String body,
    required bool isRepeats,
    DateTime? time,
    Map<String, String?>? payload,
  }) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    log('reminderId: $reminderId');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: reminderId,
        groupKey: 'notifications_channel_ak_notification_group',
        channelKey: 'notifications_channel_ak_notification',
        actionType: ActionType.Default,
        title: title,
        summary: summary,
        body: body,
        payload: payload,
        customSound: 'resource://raw/notification',
        wakeUpScreen: true,
        badge: LocalNotificationsController.instance.unreadCount,
      ),
      schedule: time != null
          ? NotificationCalendar.fromDate(date: time, repeats: isRepeats)
          : NotificationInterval(
              interval: const Duration(minutes: 2),
              timeZone: localTimeZone,
              repeats: false,
            ),
    );
    log('Scheduled Notification: $title', name: 'NotifyHelper');
  }

  static void initAwesomeNotifications() {
    AwesomeNotifications().initialize(
      'resource://drawable/icon',
      [
        NotificationChannel(
          channelGroupKey: 'notifications_channel_ak_notification_group',
          channelKey: 'notifications_channel_ak_notification',
          channelName: 'Reminder Notifications',
          channelDescription: 'Notification channel for Reminder',
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          playSound: true,
          // Ensure the audio file exists in res/raw and is correctly named
          soundSource: 'resource://raw/notification',
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'notifications_channel_ak_notification_group',
          channelGroupName: 'Reminder Notifications',
        ),
      ],
      debug: false,
    );
    log('Awesome Notifications Initialized', name: 'NotifyHelper');
  }

  Future<void> notificationBadgeListener() async {
    await AwesomeNotifications().getGlobalBadgeCounter().then((_) async {
      await AwesomeNotifications().setGlobalBadgeCounter(
        LocalNotificationsController.instance.unreadCount,
      );
    });
  }

  Future<void> cancelNotification(int notificationId) {
    log('Notification ID $notificationId was cancelled', name: 'NotifyHelper');
    return AwesomeNotifications().cancelSchedule(notificationId);
  }

  Future<void> requistPermissions() async {
    await AwesomeNotifications().isNotificationAllowed().then((
      isAllowed,
    ) async {
      if (!isAllowed) {
        // Get.dialog(
        //     const Text('please allow us to send you helpfull notifications'));
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void setNotificationsListeners() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log(
      'Notification Created: ${receivedNotification.title}',
      name: 'NotifyHelper',
    );
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log(
      'notificationDisplayed 2: ${receivedNotification.body}',
      name: 'NotifyHelper',
    );
    // log('audioPlayer.allowsExternalPlayback : ${PrayersNotificationsCtrl.instance.state.adhanPlayer.allowsExternalPlayback}',
    //     name: 'NotifyHelper');
    // if (prayerList.contains(receivedNotification.title!) ||
    //     receivedNotification.payload?['sound_type'] == 'sound') {
    //   await PrayersNotificationsCtrl.instance
    //       .fullAthanForIos(receivedNotification);
    // }
    if (receivedNotification.payload?['sound_type'] == 'sound') {
      // playAudio(receivedNotification.id, receivedNotification.title,
      //     receivedNotification.body);
    }
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log('Notification Dismessed: ${receivedAction.body}', name: 'NotifyHelper');
    // notiCtrl.state.adhanPlayer.stop();
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log(
      'Received Action: ${receivedAction.body} Received Action ID: ${receivedAction.id}',
      name: 'NotifyHelper',
    );
  }
}
