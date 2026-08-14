import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/themes/app_themes.dart';

/// كنترولر إدارة الثيم / Theme controller
class ThemeController extends GetxController {
  static ThemeController get instance => Get.isRegistered<ThemeController>()
      ? Get.find<ThemeController>()
      : Get.put(ThemeController());

  // استخدام نفس الافتراضي الموحّد / Use the unified default
  final RxString currentThemeId = AppThemes.defaultThemeId.obs;
  final RxBool isDarkMode = false.obs;
  final GetStorage _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // تحميل الثيم بشكل غير متزامن
    loadThemeFromPrefs();
  }

  // تغيير الثيم / Change theme
  void changeTheme(String themeId) {
    currentThemeId.value = themeId;
    AppTheme selectedTheme = AppThemes.getThemeById(themeId);
    Get.changeTheme(selectedTheme.data);
    update(); // تحديث جميع GetBuilder widgets
    saveThemeToPrefs();
  }

  // تبديل بين الفاتح والداكن / Toggle between light and dark
  void toggleDarkMode() {
    if (currentThemeId.value == 'dark') {
      changeTheme(AppThemes.defaultThemeId);
    } else {
      changeTheme('dark');
    }
  }

  // حفظ الثيم في التخزين / Save theme to storage
  Future<void> saveThemeToPrefs() async {
    try {
      await _box.write('selected_theme', currentThemeId.value);
      log('تم حفظ الثيم: ${currentThemeId.value}', name: 'ThemeController');
    } catch (e) {
      log('خطأ في حفظ الثيم: $e', name: 'ThemeController');
    }
  }

  // تحميل الثيم من التخزين / Load theme from storage
  Future<void> loadThemeFromPrefs() async {
    try {
      final savedThemeId =
          _box.read<String>('selected_theme') ?? AppThemes.defaultThemeId;
      log('تم تحميل الثيم المحفوظ: $savedThemeId', name: 'ThemeController');

      // تطبيق الثيم المحفوظ
      currentThemeId.value = savedThemeId;
      AppTheme selectedTheme = AppThemes.getThemeById(savedThemeId);
      Get.changeTheme(selectedTheme.data);
      update(); // تحديث UI
    } catch (e) {
      log('خطأ في تحميل الثيم، استخدام الافتراضي: $e', name: 'ThemeController');
      changeTheme(AppThemes.defaultThemeId); // الثيم الافتراضي في حالة الخطأ
    }
  }

  // تحميل الثيم بشكل متزامن للاستخدام في التهيئة / Load theme synchronously
  String loadThemeSync() {
    // محاولة الحصول على الثيم المحفوظ بشكل فوري
    // في حالة عدم التوفر، استخدام الافتراضي الموحّد
    return AppThemes.defaultThemeId;
  }
}
