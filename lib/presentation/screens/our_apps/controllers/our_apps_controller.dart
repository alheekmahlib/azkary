import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/error_handling_system.dart';
import '../../core/utils/constants/api_constants.dart';
import '../../widgets/ourApp_model.dart';

/// OurAppsController - تحكم في شاشة "تطبيقاتنا"
/// يجلب التطبيقات من واجهة Vexaltech عبر ApiClient ويفلترها حسب الشركة.
class OurAppsController extends GetxController {
  /// الحصول على الكنترولر (تسجيل ذاتي عند أول وصول)
  static OurAppsController get instance => Get.isRegistered<OurAppsController>()
      ? Get.find<OurAppsController>()
      : Get.put(OurAppsController());

  /// حالة التحميل - Loading state
  final RxBool isLoading = false.obs;

  /// قائمة التطبيقات المفلترة - Filtered apps list
  final RxList<OurAppInfo> apps = <OurAppInfo>[].obs;

  /// رسالة الخطأ - Error message
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApps();
  }

  /// جلب التطبيقات من Vexaltech ثم الفلترة بحسب
  /// companyName == 'Alheekmah Library'
  Future<void> fetchApps() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiClient().request(
        endpoint: ApiConstants.ourAppsApiUrl,
        method: HttpMethod.get,
      );

      if (response.isRight) {
        final body = response.right;
        final decoded = body is String ? jsonDecode(body) : body;
        final List<dynamic> raw = decoded['apps'] as List<dynamic>;
        final all = raw
            .map((e) => OurAppInfo.fromJson(e as Map<String, dynamic>))
            .toList();
        apps.value =
            all.where((a) => a.companyName == 'Alheekmah Library').toList();
      } else {
        errorMessage.value = response.left.message;
      }
    } catch (e, s) {
      log('Exception details:\n $e', name: 'OurAppsController');
      log('Stack trace:\n $s', name: 'OurAppsController');
      errorMessage.value = DataSource.DEFAULT.getFailure().message;
    } finally {
      isLoading.value = false;
    }
  }
}

/// ربط متحكم شاشة "تطبيقاتنا" / OurApps screen controller binding
class OurAppsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put (وليس lazyPut) لضمان إنشاء المتحكم وتشغيل onInit فوراً
    Get.put<OurAppsController>(OurAppsController());
  }
}
