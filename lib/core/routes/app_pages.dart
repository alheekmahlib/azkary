import 'package:get/get.dart';

import '../../presentation/screens/about/about.dart';
import '../../presentation/screens/home/home.dart';
import '../../presentation/screens/our_apps/our_apps.dart';
import '../../presentation/screens/splash/splash.dart';
import 'app_routes.dart';

/// قائمة صفحات GetX مع روابطها (Bindings)
/// GetX pages list with their Bindings
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const AzkarHome(),
      binding: HomeBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => AboutApp(),
      binding: AboutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ourApps,
      page: () => const OurApps(),
      binding: OurAppsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
