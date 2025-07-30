import 'package:get/get.dart';

import '../controllers/azkary_controller.dart';

// ربط الكنترولر مع النظام لإدارة التبعيات
// Binding controller with system for dependency management
class AzkaryBinding extends Bindings {
  @override
  void dependencies() {
    // تسجيل الكنترولر مع GetX
    // Register controller with GetX
    Get.lazyPut<AzkaryController>(() => AzkaryController());
  }
}
