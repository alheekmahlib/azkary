part of '../onboarding.dart';

/// OnboardingController - تحكم في شاشة الترحيب (رقم الصفحة + مؤشر التقدّم)
/// Controller for the onboarding screen (page number + progress indicator)
class OnboardingController extends GetxController {
  static OnboardingController get instance =>
      Get.isRegistered<OnboardingController>()
          ? Get.find<OnboardingController>()
          : Get.put(OnboardingController());

  /// رقم الصفحة الحالية / Current page number
  final RxInt pageNumber = 1.obs;

  /// تقدّم المؤشر / Indicator progress
  final RxDouble indicatorProgress = 0.0.obs;

  /// متحكم الصفحات / Page controller
  final PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// تحديث المؤشر حسب رقم الصفحة / Update indicator based on page number
  void _indicator(int pageNumber) {
    const map = {0: 0.0, 1: 0.33, 2: 0.66, 3: 1.0};
    indicatorProgress.value = map[pageNumber] ?? 0.0;
  }

  /// عند تغيير الصفحة / On page change
  void onPageChanged(int page) {
    pageNumber.value = page + 1;
    _indicator(page);
  }

  /// الانتقال للصفحة التالية / Go to next page
  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }
}

/// ربط متحكم شاشة الترحيب / Onboarding screen controller binding
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OnboardingController>(OnboardingController());
  }
}
