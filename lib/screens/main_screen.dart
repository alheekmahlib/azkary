import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../l10n/app_localizations.dart';
import '../shared/lists.dart';
import '../shared/local_notifications.dart';
import '../shared/reminder_model.dart';
import '../shared/style.dart';
import '../shared/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

List<GlobalKey> textFieldKeys = [];

class _MainScreenState extends State<MainScreen> {
  var element;
  Random rnd = Random();

  @override
  void initState() {
    element = zikr[rnd.nextInt(zikr.length)];
    AzkaryCubit.get(context).loadReminders();
    super.initState();
  }

  void initializeTextFields() {
    AzkaryCubit cubit = AzkaryCubit.get(context);
    for (int i = 0; i < cubit.reminders.length; i++) {
      GlobalKey textFieldKey = GlobalKey();
      textFieldKeys.add(textFieldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AzkaryCubit, QuranState>(
      listener: (context, state) {
        LoadRemindersState();
        ShowTimePickerState();
        AddReminderState();
        DeleteReminderState();
        OnTimeChangedState();
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0)
                      .r,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )),
                padding: const EdgeInsets.only(top: 16.0),
                child: orientation(
                    context,
                    ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        hijriDate(context),
                        zkrWidget(context),
                        reminderWidget(),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: platformView(
                                  orientation(
                                      context,
                                      MediaQuery.sizeOf(context).width * .4,
                                      MediaQuery.sizeOf(context).width * .45),
                                  MediaQuery.sizeOf(context).width * .5),
                              height: MediaQuery.sizeOf(context).height,
                              child: Column(
                                children: [
                                  hijriDate(context),
                                  Padding(
                                    padding: platformView(
                                        const EdgeInsets.all(0.0),
                                        const EdgeInsets.only(top: 80.0)),
                                    child: reminderWidget(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * .4,
                              child: zkrWidget(context),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget reminderWidget() {
    AzkaryCubit cubit = AzkaryCubit.get(context);
    initializeTextFields();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
                color: Theme.of(context).colorScheme.surface, width: 2)),
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            GestureDetector(
              onTap: cubit.addReminder,
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.sizeOf(context).width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  child: Text(
                    AppLocalizations.of(context)!.addReminder,
                    style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 14.sp,
                        fontFamily: 'kufi'),
                  )),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(
                cubit.reminders.length,
                (int index) {
                  final reminder = cubit.reminders[index];
                  TextEditingController controller =
                      TextEditingController(text: reminder.name);
                  // Create a new GlobalKey for the TextField and add it to the list
                  GlobalKey textFieldKey = GlobalKey();
                  textFieldKeys.add(textFieldKey);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: orientation(
                                  context,
                                  MediaQuery.sizeOf(context).width /
                                      1 /
                                      2 *
                                      1.1,
                                  MediaQuery.sizeOf(context).width /
                                      1 /
                                      2 *
                                      .4),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: TextField(
                                  key: textFieldKeys[index],
                                  controller: controller,
                                  // focusNode: _textFocusNode,
                                  autofocus: false,
                                  cursorHeight: 18.h,
                                  cursorWidth: 3.w,
                                  cursorColor: Theme.of(context).dividerColor,

                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      fontFamily: 'kufi',
                                      fontSize: 14.sp),
                                  decoration: InputDecoration(
                                    hintText: 'اكتب اسم التذكير',
                                    hintStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: 'kufi',
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    icon: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                reminder.name = controller.text;
                                              });
                                              ReminderStorage.saveReminders(
                                                  cubit.reminders);
                                            },
                                            child: Icon(
                                              Icons.done,
                                              size: 18.h,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await cubit.deleteReminder(
                                                context, index);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            size: 18.h,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
                                        ),
                                      ],
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.2),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60.w,
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      )),
                                  child: Text.rich(
                                    TextSpan(children: [
                                      WidgetSpan(
                                          child: Container(
                                        height: 20.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          '${reminder.time.hour}\n',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontFamily: 'kufi',
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                      TextSpan(
                                        text: '${reminder.time.minute}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'kufi',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                  width: 60.w,
                                  child: AnimatedToggleSwitch<int>.rolling(
                                    current: reminder.isEnabled ? 1 : 0,
                                    values: const [0, 1],
                                    onChanged: (i) async {
                                      bool value = i == 1;
                                      setState(() {
                                        reminder.isEnabled = value;
                                      });
                                      ReminderStorage.saveReminders(
                                          cubit.reminders);
                                      if (reminder.isEnabled) {
                                        // Show the TimePicker to set the reminder time
                                        bool isConfirmed = await cubit
                                            .showTimePicker(context, reminder);
                                        if (!isConfirmed) {
                                          setState(() {
                                            reminder.isEnabled = false;
                                          });
                                        }
                                      } else {
                                        // Cancel the scheduled notification
                                        NotifyHelper()
                                            .cancelScheduledNotification(
                                                reminder.id);
                                      }
                                    },
                                    iconBuilder: rollingIconBuilder,
                                    borderWidth: 1,
                                    indicatorColor:
                                        Theme.of(context).colorScheme.surface,
                                    innerColor: Theme.of(context).canvasColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    height: 25.h,
                                    dif: 2.0,
                                    borderColor:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget zkrWidget(BuildContext context) {
    ColorStyle style = ColorStyle(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0).r,
      child: container(
          context,
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      )),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    "أذكار اليوم :",
                    style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 16.sp,
                        height: 1.7,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.w100),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                          top: 48.0, bottom: 16.0, left: 16.0, right: 16.0)
                      .r,
                  child: Text(
                    element,
                    style: TextStyle(
                        color: style.greenTextColor(),
                        fontSize: 22.0.sp,
                        height: 1.7,
                        fontFamily: 'naskh',
                        fontWeight: FontWeight.w100),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
          false,
          width: orientation(
              context,
              MediaQuery.sizeOf(context).width,
              platformView(MediaQuery.sizeOf(context).width / 1 / 2 * .8,
                  MediaQuery.sizeOf(context).width / 1 / 2 * .8)),
          color: Theme.of(context).colorScheme.background),
    );
  }
}
