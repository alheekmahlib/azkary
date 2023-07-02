import 'dart:io';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:husn_al_muslim/cubit/cubit.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../database/notificationDatabase.dart';
import '../../home_page.dart';
import '../../l10n/app_localizations.dart';
import '../postPage.dart';
import 'package:intl/intl.dart' as intlPackage;

double lowerValue = 18;
double upperValue = 40;
String? selectedValue;


Widget hijriDate(BuildContext context) {
  ArabicNumbers arabicNumber = ArabicNumbers();
  var _today = HijriCalendar.now();
  AppLocalizations.of(context)!.appLang == "لغة التطبيق"
  ? HijriCalendar.setLocal('ar')
  : HijriCalendar.setLocal('en');
  return Container(
    height: 150,
    width: orientation(
        context,
        MediaQuery.of(context).size.width,
        platformView(MediaQuery.of(context).size.width / 1 / 2 * .8,
            MediaQuery.of(context).size.width / 1 / 2 * .8)),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      image: DecorationImage(
          image: ExactAssetImage('assets/images/desert.jpg'),
          fit: BoxFit.cover,
          opacity: .5)
    ),
    margin: EdgeInsets.only(right: 16.0, left: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svg/hijri/${_today.hMonth}.svg',
          height: 70.0,
          colorFilter: ColorFilter.mode(
              Theme.of(context).canvasColor,
              BlendMode.srcIn)
        ),
        Text(
        arabicNumber.convert('${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}'),
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'kufi',
            color: Theme.of(context).canvasColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget topBar(BuildContext context) {
  return SizedBox(
    height: orientation(context, 130.0, platformView(40.0, 130.0)),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: .1,
          child: SvgPicture.asset('assets/svg/splash_icon.svg'),
        ),
        SvgPicture.asset(
          'assets/svg/Logo_line2.svg',
          height: 80,
          width: MediaQuery.of(context).size.width / 1 / 2,
        ),
        Align(
          alignment: Alignment.topRight,
          child: customClose(context),
        ),
      ],
    ),
  );
}

Widget delete(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18,
            ),
            Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18,
            ),
            Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
            )
          ],
        ),
      ],
    ),
  );
}

customSnackBar(BuildContext context, String text) async {
  var cancel = BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 45,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            )
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                'assets/svg/snackBar_zakh.svg',
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'kufi',
                    fontStyle: FontStyle.italic,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: RotatedBox(
                quarterTurns: 2,
                child: SvgPicture.asset(
                  'assets/svg/snackBar_zakh.svg',
                ),
              ),
            ),
          ],
        ),
      );
    },
    duration: const Duration(milliseconds: 3000),
  );
}

Route animatRoute(Widget myWidget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => myWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route animatNameRoute({required String pushName, required Widget myWidget}) {
  return PageRouteBuilder(
    settings: RouteSettings(name: pushName),
    pageBuilder: (context, animation, secondaryAnimation) => myWidget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget customContainer(BuildContext context, Widget myWidget) {
  return ClipPath(
      clipper: const ShapeBorderClipper(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.2),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).colorScheme.surface, width: 2))),
        child: myWidget,
      ));
}

Widget bookmarkContainer(BuildContext context, Widget myWidget) {
  return ClipPath(
      clipper: const ShapeBorderClipper(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.8),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: Theme.of(context).colorScheme.surface, width: 2))),
        child: myWidget,
      ));
}

orientation(BuildContext context, var n1, n2) {
  Orientation orientation = MediaQuery.of(context).orientation;
  return orientation == Orientation.portrait
      ? n1
      : n2;
}

platformView(var p1, p2) {
  return (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia)
      ? p1
      : p2;
}

Widget sentNotification(BuildContext context, List<Map<String, dynamic>> notifications, Function updateStatus) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    updateStatus();
  });
  Future<List<Map<String, dynamic>>> loadNotifications() async {
    final dbHelper = NotificationDatabaseHelper.instance;
    final notifications = await dbHelper.queryAllRows();

    return notifications.map((notification) {
      return {
        'id': notification['id'],
        'title': notification['title'],
        'timestamp': notification['timestamp'] != null
            ? DateTime.parse(notification['timestamp'])
            : DateTime.now(), // Set to the current time if null
      };
    }).toList();
  }
  return Scaffold(
    backgroundColor: Theme.of(context).primaryColorLight,
    body: Padding(
      padding: const EdgeInsets.only(top: 70.0, bottom: 16.0, right: 16.0, left: 16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    border: Border.all(
                        width: 2, color: Theme.of(context).dividerColor)),
                child: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
          Text('الإشعارات',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'kufi',
              color: Theme.of(context).canvasColor,
            ),
          ),
          SvgPicture.asset(
            'assets/svg/space_line.svg',
            height: 30,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: loadNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> notifications = snapshot.data!;
                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(notification['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'kufi',
                                color: ThemeProvider.themeOf(context).id == 'dark'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(intlPackage.DateFormat('HH:mm').format(notification['timestamp']),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'kufi',
                                color: ThemeProvider.themeOf(context).id == 'dark'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            trailing: Icon(
                              Icons.notifications_active,
                              size: 28,
                              color: Theme.of(context).dividerColor,
                            ),
                            onTap: () {
                              Navigator.of(navigatorNotificationKey.currentContext!).push(
                                animatNameRoute(
                                  pushName: '/post',
                                  myWidget: PostPage(postId: notification['id']),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

dropDownModalBottomSheet(BuildContext context, double height, width, Widget child) {
  QuranCubit cubit = QuranCubit.get(context);
  double hei = MediaQuery.of(context).size.height;
  double wid = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxWidth:  platformView(orientation(context,
            width, wid / 1/2),
            wid / 1/2),
        maxHeight: orientation(context, hei / 1/2,
            platformView(hei, hei / 1/2))
      ),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
  ),
  backgroundColor: Theme.of(context).colorScheme.background,
  isScrollControlled: true,
  builder: (BuildContext context) {
        return child;
  }
  );
  //     .whenComplete(() {
  //   if (cubit.screenController != null) {
  //     cubit.screenController!.reverse();
  //   }
  // });
  // if (cubit.screenController != null) {
  //   cubit.screenController!.forward();
  // }

}

allModalBottomSheet(BuildContext context, Widget child) {
  QuranCubit cubit = QuranCubit.get(context);
  double hei = MediaQuery.of(context).size.height;
  double wid = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,

      constraints: BoxConstraints(
        maxWidth:  platformView(orientation(context,
            wid, wid / 1/2),
            wid / 1/2),
        maxHeight: orientation(context, hei * 3/4,
            platformView(hei, hei *
                3/4))
      ),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
  ),
  backgroundColor: Theme.of(context).colorScheme.background,
  isScrollControlled: true,
  builder: (BuildContext context) {
        return child;
  }
  );
  //     .whenComplete(() {
  //   cubit.screenController!.reverse();
  // });
  // cubit.screenController!.forward();
}

screenModalBottomSheet(BuildContext context, Widget child) {
  double hei = MediaQuery.of(context).size.height;
  double wid = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxWidth:  platformView(orientation(context,
            wid, wid * .7),
            wid / 1/2),
        maxHeight: orientation(context, hei * .9,
            platformView(hei, hei *
                3/4))
      ),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
  ),
  backgroundColor: Theme.of(context).colorScheme.background,
  isScrollControlled: true,
  builder: (BuildContext context) {
        return child;
  }
  );
  //     .whenComplete(() {
  //   cubit.screenController!.reverse();
  // });
  // cubit.screenController!.forward();
}

Widget customClose(BuildContext context) {
  return GestureDetector(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.close_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.surface.withOpacity(.5)),
        Icon(Icons.close_outlined,
            size: 24,
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Theme.of(context).canvasColor
                : Theme.of(context).primaryColorDark),
      ],
    ),
    onTap: () {
      Navigator.of(context).pop();
    },
  );
}

Widget customClose2(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .background,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
            border: Border.all(
                width: 2,
                color: Theme.of(context).dividerColor)),
        child: Icon(
          Icons.close_outlined,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    ),
  );
}

Widget customClose3(BuildContext context) {
  return GestureDetector(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.close_outlined,
            size: 40,
            color: Theme.of(context).canvasColor.withOpacity(.2)),
        Icon(Icons.close_outlined,
            size: 24,
            color: Theme.of(context).canvasColor),
      ],
    ),
    onTap: () {
      Navigator.of(context).pop();
    },
  );
}

Widget greeting(BuildContext context) {
  return Text(
    '| ${QuranCubit.get(context).greeting} |',
    style: TextStyle(
      fontSize: 16.0,
      fontFamily: 'kufi',
      color: Theme.of(context).colorScheme.surface,
    ),
    textAlign: TextAlign.center,
  );
}

// Widget reminderWidget(BuildContext context, var setState) {
//   QuranCubit cubit = QuranCubit.get(context);
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Container(
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           color: Theme.of(context)
//               .colorScheme.surface
//               .withOpacity(.2),
//           borderRadius: const BorderRadius.all(Radius.circular(8)),
//         ),
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: List<Widget>.generate(
//             cubit.reminders.length,
//                 (int index) {
//               final reminder = cubit.reminders[index];
//               TextEditingController controller = TextEditingController(text: reminder.name);
//               // Create a new GlobalKey for the TextField and add it to the list
//               GlobalKey textFieldKey = GlobalKey();
//               textFieldKeys.add(textFieldKey);
//               return Dismissible(
//                 background: Container(
//                   decoration: const BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.all(
//                           Radius.circular(8))),
//                   child: delete(context),
//                 ),
//                 key: UniqueKey(),
//                 onDismissed: (DismissDirection direction) async {
//                   await cubit.deleteReminder(context, index);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         width: 200,
//                         child: Directionality(
//                           textDirection: TextDirection.ltr,
//                           child: TextField(
//                             key: textFieldKeys[index],
//                             controller: controller,
//                             // focusNode: _textFocusNode,
//                             autofocus: false,
//                             cursorHeight: 18,
//                             cursorWidth: 3,
//                             cursorColor: Theme.of(context).dividerColor,
//                             textDirection: TextDirection.rtl,
//                             style: TextStyle(
//                                 color: ThemeProvider.themeOf(context).id ==
//                                     'dark'
//                                     ? Colors.white
//                                     : Theme.of(context).primaryColor,
//                                 fontFamily: 'kufi',
//                                 fontSize: 14),
//                             decoration: InputDecoration(
//
//                               hintText: 'اكتب اسم التذكير',
//                               hintStyle: TextStyle(
//                                 fontSize: 12,
//                                 fontFamily: 'kufi',
//                                 color: ThemeProvider.themeOf(context).id ==
//                                     'dark'
//                                     ? Colors.white.withOpacity(.5)
//                                     : Theme.of(context).primaryColor.withOpacity(.5),
//                               ),
//                               icon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     reminder.name = controller.text;
//                                   });
//                                   ReminderStorage.saveReminders(cubit.reminders);
//                                 },
//                                 icon: Icon(
//                                   Icons.done,
//                                   size: 14,
//                                   color: Theme.of(context).colorScheme.surface,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       Text(
//                         '${reminder.time.hour}:${reminder.time.minute}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontFamily: 'kufi',
//                           color: ThemeProvider.themeOf(context).id ==
//                               'dark'
//                               ? Colors.white
//                               : Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 70,
//                         child: AnimatedToggleSwitch<int>.rolling(
//                           current: reminder.isEnabled ? 1 : 0,
//                           values: const [0, 1],
//                           onChanged: (i) async {
//                             bool value = i == 1;
//                             setState(() {
//                               reminder.isEnabled = value;
//                             });
//                             ReminderStorage.saveReminders(cubit.reminders);
//                             if (reminder.isEnabled) {
//                               // Show the TimePicker to set the reminder time
//                               bool isConfirmed = await cubit.showTimePicker(context, reminder);
//                               if (!isConfirmed) {
//                                 setState(() {
//                                   reminder.isEnabled = false;
//                                 });
//                               }
//                             } else {
//                               // Cancel the scheduled notification
//                               NotifyHelper().cancelScheduledNotification(reminder.id);
//                             }
//                           },
//                           iconBuilder: rollingIconBuilder,
//                           borderWidth: 1,
//                           indicatorColor: Theme.of(context).colorScheme.surface,
//                           innerColor: Theme.of(context).canvasColor,
//                           borderRadius: const BorderRadius.all(Radius.circular(8)),
//                           height: 25,
//                           dif: 2.0,
//                           borderColor: Theme.of(context).colorScheme.surface,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       Align(
//         alignment: Alignment.center,
//         child: GestureDetector(
//           onTap: cubit.addReminder,
//           child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 4),
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.all(
//                       Radius.circular(8)),
//                   border: Border.all(
//                       color: Theme.of(context).colorScheme.surface,
//                       width: 1
//                   )
//               ),
//               child: Text(AppLocalizations.of(context)!.addReminder,
//                 style: TextStyle(
//                     color: Theme.of(context).colorScheme.surface,
//                     fontSize: 14,
//                     fontFamily: 'kufi'
//                 ),)),
//         ),
//       ),
//     ],
//   );
// }

Widget rollingIconBuilder(int value, Size iconSize, bool foreground) {
  IconData data = Icons.done;
  if (value.isEven) data = Icons.close;
  return Icon(
    data,
    size: 18,
  );
}

Widget fontSizeDropDown(BuildContext context, var setState) {
  QuranCubit cubit = QuranCubit.get(context);
  return DropdownButton2(
    isExpanded: true,
    items: [
      DropdownMenuItem<String>(
        child: FlutterSlider(
          values: [AzkarItem.fontSizeAzkar],
          max: 40,
          min: 18,
          rtl: true,
          trackBar: FlutterSliderTrackBar(
            inactiveTrackBarHeight: 5,
            activeTrackBarHeight: 5,
            inactiveTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
            activeTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.background),
          ),
          handlerAnimation: const FlutterSliderHandlerAnimation(
              curve: Curves.elasticOut,
              reverseCurve: null,
              duration: Duration(milliseconds: 700),
              scale: 1.4),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            lowerValue = lowerValue;
            upperValue = upperValue;
            AzkarItem.fontSizeAzkar = lowerValue;
            cubit.saveAzkarFontSize(AzkarItem.fontSizeAzkar);
            setState(() {});
          },
          handler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Material(
              type: MaterialType.circle,
              color: Colors.transparent,
              elevation: 3,
              child: SvgPicture.asset('assets/svg/slider_ic.svg'),
            ),
          ),
        ),
      )
    ],
    value: selectedValue,
    onChanged: (value) {
      setState(() {
        selectedValue = value as String;
      });
    },
    customButton: Icon(
      Icons.format_size,
      size: 28,
      color: Theme.of(context).colorScheme.surface,
    ),
    iconStyleData: const IconStyleData(
      iconSize: 40,
    ),
    buttonStyleData: const ButtonStyleData(
      height: 60,
      width: 60,
      elevation: 0,
    ),
    dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.9),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.only(left: 1, right: 1),
        maxHeight: 230,
        width: 230,
        elevation: 0,
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(8),
          thickness: MaterialStateProperty.all(6),
        )
    ),
    menuItemStyleData: const MenuItemStyleData(
      height: 45,
    ),
  );
}

Widget container(BuildContext context, Widget myWidget, bool show, {double? height, width}) {
  return ClipRRect(
    child: Container(
      height: height,
      width: width,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Stack(
        children: [
          show == true ? Transform.translate(
            offset: Offset(0, -10),
            child: Opacity(
              opacity: .05,
              child: SvgPicture.asset(
                'assets/svg/azkary.svg',
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ) : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 15,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: myWidget,
          )
        ],
      ),
    ),
  );
}