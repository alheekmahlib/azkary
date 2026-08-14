part of '../splash.dart';

/// SplashController - تحكم في شاشة البداية (التأخير ثم التنقّل)
/// Controller for the splash screen (delay then navigation)
class SplashController extends GetxController {
  static SplashController get instance => Get.isRegistered<SplashController>()
      ? Get.find<SplashController>()
      : Get.put(SplashController());

  @override
  void onInit() {
    super.onInit();
    _startTime();
  }

  /// تأخير ثم التنقّل إلى الشاشة الرئيسية / Delay then navigate to home
  Future<void> _startTime() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(AppRoutes.home);
  }
}

/// ربط متحكم شاشة البداية / Splash screen controller binding
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put (وليس lazyPut) لضمان الإنشاء الفوري وتشغيل onInit الذي يحوي التنقّل
    // Get.put (not lazyPut) to ensure immediate creation and run onInit (navigation)
    Get.put<SplashController>(SplashController());
  }
}
