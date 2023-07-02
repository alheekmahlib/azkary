import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_provider/theme_provider.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../l10n/app_localizations.dart';
import '../shared/lists.dart';
import '../shared/local_notifications.dart';
import '../shared/reminder_model.dart';
import '../shared/style.dart';
import '../shared/widgets/svg_picture.dart';
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
    QuranCubit.get(context).loadReminders();
    super.initState();
  }

  void initializeTextFields() {
    QuranCubit cubit = QuranCubit.get(context);
    for (int i = 0; i < cubit.reminders.length; i++) {
      GlobalKey textFieldKey = GlobalKey();
      textFieldKeys.add(textFieldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuranCubit, QuranState>(
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
          child: SafeArea(
              child: Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                // padding: EdgeInsets.all(16.0),
                child: orientation(context,
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: .02,
                            child: azkary_icon(
                                context,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height),
                          ),
                        ),
                        ListView(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                                  width: MediaQuery.of(context).size.width,
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: greeting(context)),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: hijriDate(context),
                              ),
                            ),
                            zkrWidget(context),
                            reminderWidget(),
                          ],
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Opacity(
                              opacity: .02,
                              child: azkary_icon(
                                  context,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: greeting(context)),
                                  hijriDate(context),
                                  reminderWidget(),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: zkrWidget(context),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          )),
        );
      },
    );
  }

  Widget reminderWidget() {
    QuranCubit cubit = QuranCubit.get(context);
    initializeTextFields();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: cubit.addReminder,
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1)),
                  child: Text(
                    AppLocalizations.of(context)!.addReminder,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 14,
                        fontFamily: 'kufi'),
                  )),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 2
              )
            ),
            padding: EdgeInsets.all(2),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(.7),
                borderRadius: const BorderRadius.all(Radius.circular(7)),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                    return Dismissible(
                      background: Container(
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: delete(context),
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) async {
                        await cubit.deleteReminder(context, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 200,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: TextField(
                                  key: textFieldKeys[index],
                                  controller: controller,
                                  // focusNode: _textFocusNode,
                                  autofocus: false,
                                  cursorHeight: 18,
                                  cursorWidth: 3,
                                  cursorColor: Theme.of(context).dividerColor,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontFamily: 'kufi',
                                      fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'اكتب اسم التذكير',
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'kufi',
                                      color: Theme.of(context).canvasColor,
                                    ),
                                    icon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          reminder.name = controller.text;
                                        });
                                        ReminderStorage.saveReminders(
                                            cubit.reminders);
                                      },
                                      icon: Icon(
                                        Icons.done,
                                        size: 14,
                                        color:
                                        Theme.of(context).canvasColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${reminder.time.hour}:${reminder.time.minute}',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'kufi',
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: AnimatedToggleSwitch<int>.rolling(
                                current: reminder.isEnabled ? 1 : 0,
                                values: const [0, 1],
                                onChanged: (i) async {
                                  bool value = i == 1;
                                  setState(() {
                                    reminder.isEnabled = value;
                                  });
                                  ReminderStorage.saveReminders(cubit.reminders);
                                  if (reminder.isEnabled) {
                                    // Show the TimePicker to set the reminder time
                                    bool isConfirmed = await cubit.showTimePicker(
                                        context, reminder);
                                    if (!isConfirmed) {
                                      setState(() {
                                        reminder.isEnabled = false;
                                      });
                                    }
                                  } else {
                                    // Cancel the scheduled notification
                                    NotifyHelper()
                                        .cancelScheduledNotification(reminder.id);
                                  }
                                },
                                iconBuilder: rollingIconBuilder,
                                borderWidth: 1,
                                indicatorColor:
                                    Theme.of(context).colorScheme.surface,
                                innerColor: Theme.of(context).canvasColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                height: 25,
                                dif: 2.0,
                                borderColor: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget zkrWidget(BuildContext context) {
    Style style = Style(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
      child: container(
        context,
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )),
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  "أذكار اليوم :",
                  style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize:
                      platformView(orientation(context, 16.0, 18.0), 18.0),
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
                    top: 32.0, bottom: 16.0, left: 16.0, right: 16.0),
                child: Text(
                  element,
                  style: TextStyle(
                      color: style.getTextColor(),
                      fontSize: 22.0,
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
        height: 250.0,
        width: orientation(
            context,
            MediaQuery.of(context).size.width,
            platformView(MediaQuery.of(context).size.width / 1 / 2 * .8,
                MediaQuery.of(context).size.width / 1 / 2 * .8)),
      ),
    );
    // return Container(
    //   height: 250.0,
    //   width: orientation(
    //       context,
    //       MediaQuery.of(context).size.width,
    //       platformView(MediaQuery.of(context).size.width / 1 / 2 * .8,
    //           MediaQuery.of(context).size.width / 1 / 2 * .8)),
    //   alignment: Alignment.center,
    //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    //   margin: const EdgeInsets.symmetric(vertical: 16.0),
    //   decoration: BoxDecoration(
    //       color: Theme.of(context).colorScheme.surface,
    //       borderRadius: BorderRadius.all(Radius.circular(8)),
    //       image: DecorationImage(
    //           image: ExactAssetImage('assets/images/view.jpg'),
    //           fit: BoxFit.cover,
    //           opacity: .4)),
    //   child: Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       Align(
    //         alignment: Alignment.topRight,
    //         child: Container(
    //           width: MediaQuery.of(context).size.width,
    //           decoration: BoxDecoration(
    //               color: Theme.of(context).primaryColorDark,
    //               borderRadius: BorderRadius.all(Radius.circular(8))),
    //           padding:
    //               const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    //           child: Text(
    //             "أذكار اليوم :",
    //             style: TextStyle(
    //                 color: Theme.of(context).canvasColor,
    //                 fontSize:
    //                     platformView(orientation(context, 16.0, 18.0), 18.0),
    //                 height: 1.7,
    //                 fontFamily: 'kufi',
    //                 fontWeight: FontWeight.w100),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(
    //             top: 42.0, bottom: 16.0,
    //             right: 16.0, left: 16.0),
    //         child: Text(
    //           element,
    //           style: TextStyle(
    //               color: Theme.of(context).canvasColor,
    //               fontSize:
    //                   platformView(orientation(context, 18.0, 20.0), 20.0),
    //               height: 1.7,
    //               fontFamily: 'kufi',
    //               fontWeight: FontWeight.w100),
    //           textAlign: TextAlign.justify,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
