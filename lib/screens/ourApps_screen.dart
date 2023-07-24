import 'dart:convert';

import 'package:Azkary/l10n/app_localizations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/ourApp_model.dart';
import '../shared/widgets/lottie.dart';
import '../shared/widgets/svg_picture.dart';
import '../shared/widgets/widgets.dart';

class OurApps extends StatelessWidget {
  OurApps({super.key});

  Future<List<OurAppInfo>> fetchApps() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/ourApps.json'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => OurAppInfo.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  _launchURL(BuildContext context, int index, OurAppInfo ourAppInfo) async {
    // const urlAppStore = 'https://itunes.apple.com/app/idYOUR_APP_ID';
    // const urlPlayStore =
    //     'https://play.google.com/store/apps/details?id=YOUR_APP_PACKAGE';
    // const urlAppGallery = 'https://appgallery.huawei.com/#/YOUR_APP_ID';
    // const urlMacStore = 'https://itunes.apple.com/app/idYOUR_APP_ID';

    if (!kIsWeb) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppStore))) {
          await launchUrl(Uri.parse(ourAppInfo.urlAppStore));
        } else {
          throw 'Could not launch ${ourAppInfo.urlAppStore}';
        }
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        // Determine the device manufacturer using DeviceInfoPlugin
        // Note that this plugin does not support web
        final deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.manufacturer.toLowerCase() != 'huawei') {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlPlayStore))) {
            await launchUrl(Uri.parse(ourAppInfo.urlPlayStore));
          } else {
            throw 'Could not launch ${ourAppInfo.urlPlayStore}';
          }
        } else {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppGallery))) {
            await launchUrl(Uri.parse(ourAppInfo.urlAppGallery));
          } else {
            throw 'Could not launch ${ourAppInfo.urlAppGallery}';
          }
        }
      }
    } else {
      // If the platform is web, just redirect to the appropriate store based on user agent
      // For now, we'll just use the Google Play Store link as an example
      if (await canLaunchUrl(Uri.parse(ourAppInfo.urlMacAppStore))) {
        await launchUrl(Uri.parse(ourAppInfo.urlMacAppStore));
      } else {
        throw 'Could not launch ${ourAppInfo.urlMacAppStore}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.themeOf(context).id == 'dark'
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).canvasColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(300, -10),
              child: Opacity(
                opacity: .05,
                child: azkary_icon(
                  context,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: container(
                context,
                OurAppBuild(context),
                false,
                height: orientation(context, 450.0.h, 300.0.h),
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Transform.translate(
                    offset: orientation(
                        context, Offset(0, -220.h), Offset(0, -130.h)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        azkary_logo(
                          context,
                          width: 80.0.w,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)).r),
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0)
                              .r,
                          margin: const EdgeInsets.symmetric(vertical: 8.0).r,
                          child: Text(
                            'من الكتاب والسُّنة',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        ),
                      ],
                    ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: orientation(
                    context,
                    const EdgeInsets.symmetric(vertical: 64.0).r,
                    const EdgeInsets.symmetric(vertical: 32.0).r),
                child: alheekmah_logo(
                  context,
                  width: 60.w,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 48.0, right: 16.0).r,
                child: customArrowBack(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget OurAppBuild(BuildContext context) {
    return FutureBuilder<List<OurAppInfo>>(
      future: fetchApps(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OurAppInfo>? apps = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(top: 90.0).r,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.ourApps,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 20.sp,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold),
                ),
                hDivider(context),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: false,
                    padding: EdgeInsets.zero,
                    itemCount: apps!.length - 1,
                    separatorBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0).r,
                      child: hDivider(
                        context,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      if (index >= 1) {
                        index++;
                      }
                      return InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)).r),
                          padding: const EdgeInsets.all(8.0).r,
                          margin:
                              const EdgeInsets.symmetric(horizontal: 16.0).r,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.network(
                                "${apps[index].appLogo}",
                                height: 50.h,
                                width: 50.h,
                              ),
                              vDivider(context, height: 40.0.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      apps[index].appTitle,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontSize: 13.sp,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 8.0.h,
                                    ),
                                    Text(
                                      apps[index].body,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.7),
                                          fontSize: 10.sp,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _launchURL(context, index, apps[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return bookLoading(200.0.w, 200.0.h);
      },
    );
  }
}
