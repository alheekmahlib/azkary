import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:husn_al_muslim/azkar/screens/azkar_home.dart';
import 'package:husn_al_muslim/cubit/cubit.dart';
import 'package:husn_al_muslim/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:husn_al_muslim/shared/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import '../shared/widgets/lottie.dart';
import '../shared/widgets/svg_picture.dart';


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
    QuranCubit.get(context).loadLang();
  }
  Future startTime() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      animate = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    // Get.off(() => OnboardingScreen());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationPage();
    });
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
            Align(
              alignment: Alignment.center,
              child: container(
                context,
                Align(
                  alignment: Alignment.center,
                  child: azkary_logo(
                context,
                width: 120.0,)),
                true,
                height: 250.0,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Transform.translate(
                  offset: orientation(context, Offset(0, 20), Offset(0, 50)),
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
                        offset: Offset(0, 20),
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
