import 'package:get/get.dart';

import '../../screens/about_app.dart';
import '../../screens/about/about_controller.dart';
import '../../screens/azkar_home.dart';
import '../../screens/controllers/navigation_controller.dart';
import '../../screens/ourApps/our_apps_controller.dart';
import '../../screens/ourApps_screen.dart';
import '../../screens/splash/splash_controller.dart';
import '../../screens/splash_screen.dart';

/// أسماء المسارات المُسمّاة / Named route paths
class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const about = '/about';
  static const ourApps = '/ourApps';

  /// قائمة صفحات GetX مع روابطها (Bindings)
  /// GetX pages list with their Bindings
  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: home,
      page: () => const AzkarHome(),
      binding: HomeBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: about,
      page: () => AboutApp(),
      binding: AboutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ourApps,
      page: () => const OurApps(),
      binding: OurAppsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
