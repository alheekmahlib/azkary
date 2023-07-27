import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../screens/onboarding_screen.dart';
import '../../shared/widgets/widgets.dart';
import '../shared/widgets/lottie.dart';
import '../shared/widgets/svg_picture.dart';
import 'azkar_home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Future startTime() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      animate = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    // Get.off(() => OnboardingScreen());
    Get.off(() => const AzkarHome());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   navigationPage();
    // });
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('is_first_time ${prefs.getBool("is_first_time")}');
    if (prefs.getBool("is_first_time") == null) {
      Get.off(() => OnboardingScreen());
      // navigatorKey.currentState!.push(
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => OnboardingScreen(),
      //   ),
      // );
      prefs.setBool("is_first_time", false);
    } else {
      Get.off(() => const AzkarHome());
      // navigatorKey.currentState!.push(
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => const AzkarHome(),
      //   ),
      // );
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
          children: [
            Transform.translate(
              offset: const Offset(300, -10),
              child: Opacity(
                opacity: .05,
                child: SvgPicture.asset(
                  'assets/svg/azkary.svg',
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: container(
                context,
                Container(),
                false,
                height: 150.0,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Transform.translate(
                    offset: const Offset(0, -50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        azkary_logo(
                          context,
                          width: 120.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'من الكتاب والسُّنة',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        )
                      ],
                    ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Transform.translate(
                  offset: orientation(
                      context, const Offset(0, 20), const Offset(0, 50)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/alheekmah_logo.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.surface,
                            BlendMode.srcIn),
                        width: 90,
                      ),
                      Transform.translate(
                        offset: const Offset(0, 20),
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: loading(240.0, 170.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
