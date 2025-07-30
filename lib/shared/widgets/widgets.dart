import 'dart:io';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../azkar/screens/azkar_item.dart';
import '../../core/controllers/azkary_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/svg_picture.dart';

double lowerValue = 25.sp;
double upperValue = 40.sp;
String? selectedValue;

Widget hijriDate(BuildContext context) {
  ArabicNumbers arabicNumber = ArabicNumbers();
  var _today = HijriCalendar.now();
  AppLocalizations.of(context)!.appLang == "لغة التطبيق"
      ? HijriCalendar.setLocal('ar')
      : HijriCalendar.setLocal('en');
  return Container(
    height: 150.h,
    width: orientation(
        context,
        MediaQuery.sizeOf(context).width,
        platformView(MediaQuery.sizeOf(context).width / 1 / 2 * .8,
            MediaQuery.sizeOf(context).width / 1 / 2 * .8)),
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: platformView(
            const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            const BorderRadius.all(Radius.circular(8))),
        image: const DecorationImage(
            image: ExactAssetImage('assets/images/desert.jpg'),
            fit: BoxFit.cover,
            opacity: .5)),
    margin: const EdgeInsets.only(right: 16.0, left: 16.0).r,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/svg/hijri/${_today.hMonth}.svg',
            height: 70.0.h,
            colorFilter: ColorFilter.mode(
                Theme.of(context).canvasColor, BlendMode.srcIn)),
        Text(
          arabicNumber.convert(
              '${_today.hDay} / ${_today.hMonth} / ${_today.hYear} هـ \n ${_today.dayWeName}'),
          style: TextStyle(
            fontSize: 16.0.sp,
            fontFamily: 'kufi',
            color: Theme.of(context).canvasColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget delete(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18.h,
            ),
            Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(
                  color: Colors.white, fontSize: 14.sp, fontFamily: 'kufi'),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18.h,
            ),
            Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(
                  color: Colors.white, fontSize: 14.sp, fontFamily: 'kufi'),
            )
          ],
        ),
      ],
    ),
  );
}

customSnackBar(BuildContext context, String text) async {
  final colorSchemeSurface = Theme.of(context).colorScheme.surface;

  BotToast.showCustomNotification(
    enableSlideOff: false,
    toastBuilder: (cancelFunc) {
      return Container(
        height: 45.h,
        decoration: BoxDecoration(
            color: colorSchemeSurface,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            )),
        margin: const EdgeInsets.symmetric(horizontal: 16.0).r,
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
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'kufi',
                    fontStyle: FontStyle.italic,
                    fontSize: 16.sp),
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
      const begin = Offset(-1.0, 0.0);
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

orientation(BuildContext context, var n1, n2) {
  Orientation orientation = MediaQuery.orientationOf(context);
  return orientation == Orientation.portrait ? n1 : n2;
}

platformView(var p1, p2) {
  return (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) ? p1 : p2;
}

allModalBottomSheet(BuildContext context, Widget child) {
  double hei = MediaQuery.sizeOf(context).height;
  double wid = MediaQuery.sizeOf(context).width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth:
              platformView(orientation(context, wid, wid / 1 / 2), wid / 1 / 2),
          maxHeight: orientation(
              context, hei * 3 / 4, platformView(hei, hei * 3 / 4))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      });
}

screenModalBottomSheet(BuildContext context, Widget child) {
  double hei = MediaQuery.sizeOf(context).height;
  double wid = MediaQuery.sizeOf(context).width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth: platformView(
              orientation(context, wid, wid * .7), wid / 1 / 2 * 1.5),
          maxHeight:
              orientation(context, hei * .9, platformView(hei, hei * 3 / 4))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      });
}

Widget customClose(BuildContext context) {
  return GestureDetector(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.close_outlined,
            size: 35.h,
            color: Theme.of(context).colorScheme.surface.withOpacity(.5)),
        Icon(Icons.close_outlined,
            size: 20.h,
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
        height: 30.h,
        width: 30.w,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
            border:
                Border.all(width: 2, color: Theme.of(context).dividerColor)),
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
            size: 40.h, color: Theme.of(context).canvasColor.withOpacity(.2)),
        Icon(Icons.close_outlined,
            size: 24.h, color: Theme.of(context).canvasColor),
      ],
    ),
    onTap: () {
      Navigator.of(context).pop();
    },
  );
}

Widget greeting(BuildContext context) {
  return Text(
    '| ${AzkaryController.instance.greeting} |',
    style: TextStyle(
      fontSize: 14.0.sp,
      fontFamily: 'kufi',
      color: Theme.of(context).colorScheme.surface,
    ),
    textAlign: TextAlign.center,
  );
}

Widget rollingIconBuilder(int value, bool foreground) {
  IconData data = Icons.done;
  if (value.isEven) data = Icons.close;
  return Icon(
    data,
    size: 18.h,
  );
}

Widget fontSizeDropDown(BuildContext context, var setState, Color color) {
  final ctrl = AzkaryController.instance;
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
                color: Theme.of(context).colorScheme.surface),
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
            ctrl.saveAzkarFontSize(AzkarItem.fontSizeAzkar);
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
      size: 22.h,
      color: color,
    ),
    iconStyleData: IconStyleData(
      iconSize: 40.h,
    ),
    buttonStyleData: ButtonStyleData(
      height: 60.w,
      width: 60.w,
      elevation: 0,
    ),
    dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.9),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.only(left: 1, right: 1),
        maxHeight: 230,
        width: 280,
        elevation: 0,
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(8),
          thickness: WidgetStateProperty.all(6),
        )),
    menuItemStyleData: MenuItemStyleData(
      height: 45.h,
    ),
  );
}

Widget container(BuildContext context, Widget myWidget, bool show,
    {double? height, double? width, Color? color}) {
  return ClipRRect(
    child: Container(
      height: height,
      width: width!.w,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.secondary,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          show == true
              ? Transform.translate(
                  offset: const Offset(0, -10),
                  child: Opacity(
                    opacity: .05,
                    child: SvgPicture.asset(
                      'assets/svg/azkary.svg',
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 15.h,
              width: MediaQuery.sizeOf(context).width,
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

Widget borderRadiusContainer(
    BuildContext context, bool show, String title, String details,
    {double? height, double? width, Color? color}) {
  return ClipRRect(
    child: Container(
      height: height!.h,
      width: width!.w,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ).r,
      ),
      child: Stack(
        children: [
          show == true
              ? Transform.translate(
                  offset: const Offset(0, -10),
                  child: Opacity(
                    opacity: .05,
                    child: SvgPicture.asset(
                      'assets/svg/azkary.svg',
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 25.h,
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).colorScheme.surface,
              child: ClipRRect(
                child: SvgPicture.asset(
                  'assets/svg/azkary.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).canvasColor.withOpacity(.05),
                      BlendMode.srcIn),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          orientation(
              context,
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200.w,
                      margin: const EdgeInsets.only(right: 16.0).r,
                      child: Text(
                        details,
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontFamily: 'naskh',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Container(
                      height: 120.h,
                      width: 75.h,
                      margin: const EdgeInsets.all(16.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          book_cover(),
                          Transform.translate(
                            offset: const Offset(0, 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 140.h,
                      width: 90.h,
                      margin: const EdgeInsets.all(16.0).r,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          book_cover(),
                          Transform.translate(
                            offset: const Offset(0, 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0).r,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 230.w,
                      child: Text(
                        details,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'naskh',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    ),
  );
}

Widget borderRadiusContainerLand(
    BuildContext context, bool show, String title, String details,
    {double? height, double? width, Color? color}) {
  return ClipRRect(
    child: Container(
      height: height!,
      width: width!.w,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ).r,
      ),
      child: Stack(
        children: [
          show == true
              ? Transform.translate(
                  offset: const Offset(0, -10),
                  child: Opacity(
                    opacity: .05,
                    child: SvgPicture.asset(
                      'assets/svg/azkary.svg',
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 140.h,
                  width: 90.h,
                  margin: const EdgeInsets.all(16.0).r,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      book_cover(),
                      Transform.translate(
                        offset: const Offset(0, 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0).r,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 230.w,
                  child: Text(
                    details,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'naskh',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget contentContainer(BuildContext context, Widget myWidget,
    {double? height}) {
  return ClipRRect(
    child: Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ).r,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height ?? 25.h,
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).colorScheme.surface,
              child: ClipRRect(
                child: SvgPicture.asset(
                  'assets/svg/azkary.svg',
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).canvasColor.withOpacity(.05),
                      BlendMode.srcIn),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          myWidget,
        ],
      ),
    ),
  );
}

Widget greenContainer(BuildContext context, double height, Widget myWidget,
    {double? width}) {
  return Container(
    height: height.h,
    width: width!.w,
    // margin: EdgeInsets.symmetric(horizontal: 8.0),
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    color: Theme.of(context).colorScheme.surface,
    child: ClipRRect(
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          SvgPicture.asset(
            'assets/svg/azkary.svg',
            colorFilter: ColorFilter.mode(
                Theme.of(context).canvasColor.withOpacity(.05),
                BlendMode.srcIn),
            fit: BoxFit.fitWidth,
          ),
          myWidget
        ],
      ),
    ),
  );
}

Widget borderRadiusGreenContainer(
    BuildContext context, double height, Widget myWidget,
    {double? width}) {
  return Container(
    height: height.h,
    width: width!.w,
    // margin: EdgeInsets.symmetric(horizontal: 8.0),
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        )),
    child: ClipRRect(
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          SvgPicture.asset(
            'assets/svg/azkary.svg',
            colorFilter: ColorFilter.mode(
                Theme.of(context).canvasColor.withOpacity(.05),
                BlendMode.srcIn),
            fit: BoxFit.fitWidth,
          ),
          myWidget
        ],
      ),
    ),
  );
}

Widget iconsAsset(String name, {double? height, double? width}) {
  return Image.asset(
    'assets/icons/$name.png',
    height: height ?? 20.h,
    width: width ?? 20.w,
  );
}

Widget vDivider(BuildContext context, {double? height}) {
  return Container(
    height: height ?? 20.h,
    width: 2.w,
    margin: const EdgeInsets.symmetric(horizontal: 8.0).r,
    color: Theme.of(context).colorScheme.surface,
  );
}

Widget hDivider(BuildContext context, {double? width}) {
  return Container(
    height: 1.h,
    width: width ?? MediaQuery.sizeOf(context).width,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).r,
    color: Theme.of(context).colorScheme.surface,
  );
}

Widget customArrowBack(BuildContext context) {
  return GestureDetector(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.arrow_back_ios,
            size: 40.h,
            color: Theme.of(context).colorScheme.surface.withOpacity(.5)),
        Icon(Icons.arrow_back_ios,
            size: 24.h,
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

Widget rightPage(BuildContext context, Widget child) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 4.0, top: 16.0, bottom: 16.0).r,
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.5)
                  : Theme.of(context).dividerColor.withOpacity(.5),
              borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))
                  .r),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 16.0, bottom: 16.0).r,
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.7)
                  : Theme.of(context).dividerColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))
                  .r),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 12.0, top: 16.0, bottom: 16.0).r,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))
                  .r),
          child: child,
        ),
      ),
    ],
  );
}

Widget leftPage(BuildContext context, Widget child) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.5)
                  : Theme.of(context).dividerColor.withOpacity(.5),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Theme.of(context).primaryColorDark.withOpacity(.7)
                  : Theme.of(context).dividerColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: child,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 16.0, bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: child,
        ),
      ),
    ],
  );
}
