import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../database/databaseHelper.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/widgets/widgets.dart';
import '../models/azkar.dart';

/// AzkarController - تحكم في الأذكار المفضلة
/// Controller for managing favorite Azkar
class AzkarController extends GetxController {
  // قائمة الأذكار - List of Azkar
  final RxList<Azkar> azkarList = <Azkar>[].obs;

  // حالة التحميل - Loading state
  final RxBool isLoading = false.obs;

  // رسالة الخطأ - Error message
  final RxString errorMessage = ''.obs;

  /// الحصول على الكنترولر - Get controller instance
  static AzkarController get instance => Get.isRegistered<AzkarController>()
      ? Get.find<AzkarController>()
      : Get.put(AzkarController());

  @override
  void onInit() {
    super.onInit();
    getAzkar();
  }

  /// إضافة ذكر إلى المفضلة - Add azkar to favorites
  Future<int?> addAzkar(Azkar azkar) async {
    try {
      print('Adding azkar: $azkar');
      final result = await DatabaseHelper.addAzkar(azkar);

      // تحديث القائمة بعد الإضافة - Update list after adding
      getAzkar();

      return result;
    } catch (e) {
      print('Error adding azkar: $e');
      errorMessage.value = 'خطأ في إضافة الذكر: $e';
      throw e;
    }
  }

  /// جلب الأذكار من قاعدة البيانات - Get azkar from database
  Future<void> getAzkar() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final List<Map<String, dynamic>> azkarData =
          await DatabaseHelper.queryC();
      print('Retrieved azkar: $azkarData');

      azkarList.value = azkarData.map((data) => Azkar.fromJson(data)).toList();
    } catch (e) {
      print('Error getting azkar: $e');
      errorMessage.value = 'خطأ في جلب الأذكار: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// حذف ذكر من المفضلة - Delete azkar from favorites
  Future<void> deleteAzkar(Azkar azkar, BuildContext context) async {
    try {
      print('Deleting azkar: $azkar');

      await DatabaseHelper.deleteAzkar(azkar).then((value) => customSnackBar(
          context, AppLocalizations.of(context)!.deletedZekrBookmark));

      // تحديث القائمة بعد الحذف - Update list after deletion
      getAzkar();
    } catch (e) {
      print('Error deleting azkar: $e');
      errorMessage.value = 'خطأ في حذف الذكر: $e';
    }
  }

  /// تحديث ذكر - Update azkar
  Future<void> updateAzkar(Azkar azkar) async {
    try {
      print('Updating azkar: $azkar');

      await DatabaseHelper.updateAzkar(azkar);

      // تحديث القائمة بعد التحديث - Update list after updating
      getAzkar();
    } catch (e) {
      print('Error updating azkar: $e');
      errorMessage.value = 'خطأ في تحديث الذكر: $e';
      throw e;
    }
  }
}
