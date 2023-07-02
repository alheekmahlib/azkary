import 'dart:convert';

import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reminder {
  int id;
  Time time;
  bool isEnabled;
  String name;

  Reminder({required this.id, required this.time, this.isEnabled = false, required this.name});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      time: Time(hour: json['hour'], minute: json['minute']),
      isEnabled: json['isEnabled'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': time.hour,
      'minute': time.minute,
      'isEnabled': isEnabled,
      'name': name,
    };
  }
}

class ReminderStorage {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const String _storageKey = 'reminders';

  static Future<void> saveReminders(List<Reminder> reminders) async {
    SharedPreferences prefs = await _prefs;
    List<String> remindersJson = reminders.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_storageKey, remindersJson);
  }

  static Future<List<Reminder>> loadReminders() async {
    SharedPreferences prefs = await _prefs;
    List<String> remindersJson = prefs.getStringList(_storageKey)?.cast<String>() ?? [];
    List<Reminder> reminders = remindersJson.map((r) => Reminder.fromJson(jsonDecode(r))).toList();
    return reminders;
  }

  static Future<void> deleteReminder(int id) async {
    List<Reminder> reminders = await loadReminders();
    reminders.removeWhere((r) => r.id == id);
    await saveReminders(reminders);
  }

}
