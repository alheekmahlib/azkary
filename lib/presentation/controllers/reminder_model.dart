import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:get_storage/get_storage.dart';

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

/// ReminderStorage — تخزين التذكيرات فوق GetStorage
/// Reminders storage backed by GetStorage
///
/// استُبدلت shared_preferences بـ GetStorage. يخزّن قائمة Map مباشرة
/// (بدل StringList + jsonEncode لكل عنصر).
/// Replaced shared_preferences with GetStorage. Stores a list of Map directly
/// (instead of StringList + per-element jsonEncode).
class ReminderStorage {
  static final GetStorage _box = GetStorage();
  static const String _storageKey = 'reminders';

  static Future<void> saveReminders(List<Reminder> reminders) async {
    await _box.write(
        _storageKey, reminders.map((r) => r.toJson()).toList());
  }

  static Future<List<Reminder>> loadReminders() async {
    final List<dynamic> raw =
        _box.read<List<dynamic>>(_storageKey) ?? [];
    return raw
        .cast<Map<String, dynamic>>()
        .map((r) => Reminder.fromJson(r))
        .toList();
  }

  static Future<void> deleteReminder(int id) async {
    List<Reminder> reminders = await loadReminders();
    reminders.removeWhere((r) => r.id == id);
    await saveReminders(reminders);
  }
}
