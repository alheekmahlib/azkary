import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:husn_al_muslim/quran_azkar/cubit/quran_azkar_cubit.dart';
import 'package:husn_al_muslim/rwqya_azkar/cubit/rwqya_cubit.dart';
import 'package:husn_al_muslim/shared/bloc_observer.dart';
import 'package:husn_al_muslim/shared/local_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wakelock/wakelock.dart';
import 'azkar/cubit/azkar_cubit.dart';
import 'books/cubit/books_cubit.dart';
import 'cubit/cubit.dart';
import 'database/databaseHelper.dart';
import 'database/notificationDatabase.dart';
import 'myApp.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    windowSize();
  }
  Wakelock.enable();

  init();
  tz.initializeTimeZones();
  Bloc.observer = MyBlocObserver();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<QuranCubit>(
          create: (BuildContext context) => QuranCubit(),
        ),
        BlocProvider<QuranAzkarCubit>(
          create: (BuildContext context) => QuranAzkarCubit()..loadData(),
        ),
        BlocProvider<AzkarCubit>(
          create: (BuildContext context) => AzkarCubit(),
        ),
        BlocProvider<RwqyaCubit>(
          create: (BuildContext context) => RwqyaCubit()..loadData(),
        ),
        BlocProvider<BooksCubit>(
          create: (BuildContext context) => BooksCubit(),
        ),
      ],
      child: MyApp(theme: ThemeData.light())));
}



Future windowSize() async {
  await DesktopWindow.setMinWindowSize(const Size(900, 840));
}

init() async {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  databaseHelper.database;
  NotificationDatabaseHelper notificationdatabaseHelper = NotificationDatabaseHelper.instance;
  notificationdatabaseHelper.database;
  NotifyHelper().initializeNotification();
}
