part of '../about.dart';

/// AboutController - تحكم في شاشة "حول التطبيق" (معلومات الحزمة)
/// Controller for the About screen (package info)
class AboutController extends GetxController {
  static AboutController get instance => Get.isRegistered<AboutController>()
      ? Get.find<AboutController>()
      : Get.put(AboutController());

  /// معلومات الحزمة (الإصدار/رقم البناء) / Package info (version/build)
  final Rx<PackageInfo> packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _initPackageInfo();
  }

  /// تحميل معلومات الحزمة من المنصة / Load package info from platform
  Future<void> _initPackageInfo() async {
    packageInfo.value = await PackageInfo.fromPlatform();
  }
}

/// ربط متحكم شاشة "حول التطبيق" / About screen controller binding
class AboutBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put لضمان تحميل معلومات الحزمة فوراً
    // Get.put to ensure package info loads immediately
    Get.put<AboutController>(AboutController());
  }
}
