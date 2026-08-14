import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../quran_azkar_model.dart';

/// QuranAzkarController - تحكم في أذكار القرآن
/// Controller for managing Quran Azkar data
class QuranAzkarController extends GetxController {
  // قائمة السور - List of Surahs
  final RxList<Surah> surahs = <Surah>[].obs;

  // حالة التحميل - Loading state
  final RxBool isLoading = false.obs;

  // رسالة الخطأ - Error message
  final RxString errorMessage = ''.obs;

  /// الحصول على الكنترولر - Get controller instance
  static QuranAzkarController get instance =>
      Get.isRegistered<QuranAzkarController>()
          ? Get.find<QuranAzkarController>()
          : Get.put(QuranAzkarController());

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// تحميل البيانات من الملف - Load data from file
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
          await rootBundle.loadString('assets/books/quran_azkar.json');
      final data = await json.decode(response);
      final surahsList =
          (data['surahs'] as List).map((i) => Surah.fromJson(i)).toList();

      surahs.value = surahsList;
    } catch (e) {
      errorMessage.value = 'خطأ في تحميل البيانات: $e';
      print('Error loading Quran Azkar data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
