import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '/screens/about_app.dart';
import '/screens/ourApps_screen.dart';
import '../../core/controllers/azkary_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../myApp.dart';
import 'svg_picture.dart';
import 'theme_change.dart';
import 'widgets.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0).r,
      child: SizedBox(
        height: orientation(context, height / 1 / 2 * 1.1, height),
        width: width,
        child: ListView(
          padding: EdgeInsets.zero,
          // direction: Axis.vertical,
          children: [
            Center(
              child: spaceLine(
                20.h,
                width * 3 / 4,
              ),
            ),
            langChange(context),
            const SizedBox(
              height: 16.0,
            ),
            themeChange(context),
            const SizedBox(
              height: 16.0,
            ),
            otherWidget(context),
            Center(
              child: spaceLine(
                20.h,
                width * 3 / 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget langChange(BuildContext context) {
    final ctrl = AzkaryController.instance;
    double width = MediaQuery.sizeOf(context).width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: contentContainer(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0).r,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/line.svg',
                    height: 12.h,
                  ),
                  Text(
                    AppLocalizations.of(context)!.langChange,
                    style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic,
                        fontSize: 14.sp),
                  ),
                  SvgPicture.asset(
                    'assets/svg/line2.svg',
                    height: 12.h,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).r,
              child: Column(
                children: [
                  InkWell(
                    child: SizedBox(
                      height: 20.h,
                      width: width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0)),
                              border: Border.all(
                                  color: AppLocalizations.of(context)!
                                              .appLang ==
                                          "لغة التطبيق"
                                      ? const Color(0xff91a57d)
                                      : Theme.of(context).secondaryHeaderColor,
                                  width: 1.5.w),
                              color: const Color(0xff39412a),
                            ),
                            child: AppLocalizations.of(context)!.appLang ==
                                    "لغة التطبيق"
                                ? Icon(Icons.done,
                                    size: 10.h, color: const Color(0xffF27127))
                                : null,
                          ),
                          SizedBox(
                            width: 16.0.w,
                          ),
                          Text(
                            'العربية',
                            style: TextStyle(
                              color: AppLocalizations.of(context)!.appLang ==
                                      "لغة التطبيق"
                                  ? const Color(0xffF27127)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha: .5),
                              fontSize: 13.sp,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      MyApp.of(context)!.setLocale(
                          const Locale.fromSubtags(languageCode: "ar"));
                      ctrl.saveLang("ar");
                    },
                  ),
                  InkWell(
                    child: SizedBox(
                      height: 20.h,
                      width: width.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0)),
                              border: Border.all(
                                  color:
                                      AppLocalizations.of(context)!.appLang ==
                                              "App Language"
                                          ? const Color(0xff91a57d)
                                          : Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withValues(alpha: .5),
                                  width: 1.5.w),
                              color: const Color(0xff39412a),
                            ),
                            child: AppLocalizations.of(context)!.appLang ==
                                    "App Language"
                                ? Icon(Icons.done,
                                    size: 10.h, color: const Color(0xffF27127))
                                : null,
                          ),
                          SizedBox(
                            width: 16.0.w,
                          ),
                          Text(
                            'English',
                            style: TextStyle(
                              color: AppLocalizations.of(context)!.appLang ==
                                      "App Language"
                                  ? const Color(0xffF27127)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha: .5),
                              fontSize: 13.h,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      MyApp.of(context)!.setLocale(
                          const Locale.fromSubtags(languageCode: "en"));
                      ctrl.saveLang("en");
                    },
                  ),
                  InkWell(
                    child: SizedBox(
                      height: 20.h,
                      width: width.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2.0)),
                              border: Border.all(
                                  color:
                                      AppLocalizations.of(context)!.appLang ==
                                              "Idioma de la aplicación"
                                          ? const Color(0xff91a57d)
                                          : Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withValues(alpha: .5),
                                  width: 1.5.w),
                              color: const Color(0xff39412a),
                            ),
                            child: AppLocalizations.of(context)!.appLang ==
                                    "Idioma de la aplicación"
                                ? Icon(Icons.done,
                                    size: 10.h, color: const Color(0xffF27127))
                                : null,
                          ),
                          SizedBox(
                            width: 16.0.w,
                          ),
                          Text(
                            'Español',
                            style: TextStyle(
                              color: AppLocalizations.of(context)!.appLang ==
                                      "Idioma de la aplicación"
                                  ? const Color(0xffF27127)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha: .5),
                              fontSize: 13.sp,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      MyApp.of(context)!.setLocale(
                          const Locale.fromSubtags(languageCode: "es"));
                      ctrl.saveLang("es");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget themeChange(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: contentContainer(
        context,
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0).r,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/svg/line.svg',
                    height: 12.h,
                  ),
                  Text(
                    AppLocalizations.of(context)!.themeTitle,
                    style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic,
                        fontSize: 14.sp),
                  ),
                  SvgPicture.asset(
                    'assets/svg/line2.svg',
                    height: 12.h,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: ThemeChange(),
            ),
          ],
        ),
      ),
    );
  }

  Widget otherWidget(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(8)).r),
        padding: const EdgeInsets.all(8.0).r,
        margin: const EdgeInsets.only(top: 16.0).r,
        child: Column(
          children: [
            InkWell(
              child: Container(
                height: 24.h,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: azkary_logo(
                        context,
                        width: 24.0.w,
                      ),
                    ),
                    vDivider(context),
                    Expanded(
                      flex: 8,
                      child: Text(
                        AppLocalizations.of(context)!.aboutApp,
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).colorScheme.surface,
                        size: 18.h,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(context, animatRoute(AboutApp()));
              },
            ),
            hDivider(context),
            InkWell(
              child: Container(
                height: 24.h,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1, child: alheekmah_logo(context, width: 24.0.w)),
                    vDivider(context),
                    Expanded(
                      flex: 8,
                      child: Text(
                        AppLocalizations.of(context)!.ourApps,
                        style: TextStyle(
                          fontFamily: 'kufi',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).colorScheme.surface,
                        size: 18.h,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(context, animatRoute(OurApps()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
