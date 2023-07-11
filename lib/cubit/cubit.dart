import 'dart:async';
import '../../azkar/screens/azkar_item.dart';
import '../../cubit/states.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../shared/local_notifications.dart';
import '../shared/reminder_model.dart';
import '../shared/widgets/widgets.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(QuranPageState());
  static QuranCubit get(context) => BlocProvider.of<QuranCubit>(context);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String greeting = '';
  TimeOfDay? changedTimeOfDay;
  bool isReminderEnabled = false;
  Time time = Time(hour: 11, minute: 30, second: 20);
  bool iosStyle = true;
  List<Reminder> reminders = [];
  bool selected = false;
  ArabicNumbers arabicNumber = ArabicNumbers();
  int? shareTafseerValue;
  bool isShowSettings = false;
  Locale? initialLang;
  var controller = ScrollController();


  /// Shared Preferences
  // Save & Load Azkar Text Font Size
  saveAzkarFontSize(double fontSizeAzkar) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setDouble("font_azkar_size", fontSizeAzkar);
    emit(SharedPreferencesState());
  }

  loadAzkarFontSize() async {
    SharedPreferences prefs = await _prefs;
    AzkarItem.fontSizeAzkar = prefs.getDouble('font_azkar_size') ?? 18;
    print('get font size ${prefs.getDouble('font_azkar_size')}');
    emit(SharedPreferencesState());
  }

  // Save & Load Last Page For Quran Page
  saveLang(String lan) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString("lang", lan);
    emit(SharedPreferencesState());
  }

  loadLang() async {
    SharedPreferences prefs = await _prefs;
    initialLang = prefs.getString("lang") == null
        ? const Locale('ar', 'AE')
        : Locale(prefs.getString("lang")!);
    print('get lang $initialLang');
    emit(SharedPreferencesState());
  }

  // Clear SharedPreferences
  clear(String Value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.remove(Value);
    emit(SharedPreferencesState());
  }

  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting = isMorning ? 'صبحكم الله بالخير' : 'مساكم الله بالخير';
    emit(greetingState());
  }

  void initState() {
    loadLang();
    emit(QuranPageState());
  }


  /// Time
  // var now = DateTime.now();
  String lastRead =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  /// Reminder
  void loadReminders() async {
    List<Reminder> loadedReminders = await ReminderStorage.loadReminders();
    reminders = loadedReminders;
    emit(LoadRemindersState());
  }

  Future<bool> showTimePicker(BuildContext context, Reminder reminder) async {
    QuranCubit cubit = QuranCubit.get(context);
    bool isConfirmed = false;
    Time initialTime = time;
    TimeOfDay initialTimeOfDay =
        TimeOfDay(hour: initialTime.hour, minute: initialTime.minute);

    await Navigator.of(context).push(
      showPicker(
        context: context,
        value: time,
        onChange: (time) {
          cubit.changedTimeOfDay = time;
          print(cubit.changedTimeOfDay);
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
          cardColor: Theme.of(context).colorScheme.background,
        ),
      ),
    );

    if (cubit.changedTimeOfDay != null &&
        cubit.changedTimeOfDay != initialTimeOfDay) {
      final int hour = cubit.changedTimeOfDay!.hour;
      final int minute = cubit.changedTimeOfDay!.minute;
      // Update the reminder's time
      reminder.time = Time(hour: hour, minute: minute);
      emit(ShowTimePickerState());
      // Schedule the notification with the reminder's ID
      await NotifyHelper().scheduledNotification(
          context, reminder.id, hour, minute, reminder.name);
      isConfirmed = true;
    }

    return isConfirmed;
  }

  Future<void> addReminder() async {
    String reminderName = "";

    DateTime now = DateTime.now();
    Time currentTime = Time(hour: now.hour, minute: now.minute);

    reminders.add(Reminder(
        id: reminders.length,
        isEnabled: false,
        time: currentTime,
        name: reminderName));
    emit(AddReminderState());
    ReminderStorage.saveReminders(reminders);
  }

  deleteReminder(BuildContext context, int index) async {
    // Cancel the scheduled notification
    await NotifyHelper().cancelScheduledNotification(reminders[index].id);

    // Delete the reminder
    await ReminderStorage.deleteReminder(index).then((value) =>
        customSnackBar(context, AppLocalizations.of(context)!.deletedReminder));

    // Update the reminders list
    reminders.removeAt(index);
    emit(DeleteReminderState());

    // Update the reminder IDs
    for (int i = index; i < reminders.length; i++) {
      reminders[i].id = i;
    }

    // Save the updated reminders list
    ReminderStorage.saveReminders(reminders);
  }

  void onTimeChanged(Time newTime) {
    time = newTime;
    emit(OnTimeChangedState());
  }
}
