part of '../home.dart';

/// NavigationController - تحكم في التبويب السفلي والتنقّل داخل الشاشة الرئيسية
/// Controller for bottom navigation and in-home navigation
class NavigationController extends GetxController {
  static NavigationController get instance =>
      Get.isRegistered<NavigationController>()
          ? Get.find<NavigationController>()
          : Get.put(NavigationController());

  /// فهرس التبويب المختار / Selected tab index
  final RxInt selected = 0.obs;

  /// متحكم الصفحات / Page controller for the PageView
  final PageController pageController = PageController();

  /// مفتاح درج الإعداقات / Settings drawer key
  final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  @override
  void onInit() {
    super.onInit();
    _showOnboardingIfFirstTime();
  }

  /// إظهار شاشة الترحيب عند أول تشغيل / Show onboarding on first launch
  void _showOnboardingIfFirstTime() async {
    final box = GetStorage();
    final isFirstTime = !box.hasData('is_first_time');
    log('is_first_time $isFirstTime', name: 'NavigationController');
    if (isFirstTime) {
      await Future.delayed(const Duration(seconds: 2));
      Get.bottomSheet(
        const OnboardingScreen(),
        isScrollControlled: true,
        backgroundColor: Get.theme.colorScheme.primaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      );
      await box.write('is_first_time', false);
    }
  }

  /// تغيير التبويب المختار / Change selected tab
  void changePage(int index) {
    selected.value = index;
    log('selected ${selected.value}', name: 'NavigationController');
  }

  /// القفز إلى تبويب عبر الـ PageController / Jump to a tab via PageController
  void jumpToPage(int index) {
    pageController.jumpToPage(index);
    changePage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

/// ربط متحكم الشاشة الرئيسية / Home screen controller binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put لضمان الإنشاء الفوري وتشغيل onInit (الترحيب الأول + التنقّل)
    // Get.put to ensure immediate creation and run onInit (first-run onboarding)
    Get.put<NavigationController>(NavigationController());
  }
}
