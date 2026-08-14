import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../fetchBooks.dart';
import '../model/books_model.dart';

/// BooksController - تحكم في الكتب والفئات
/// Controller for managing books and classes
class BooksController extends GetxController {
  // حالة التحميل - Loading state
  final RxBool isLoading = false.obs;

  // قائمة الفئات - List of classes
  final RxList<Class> classes = <Class>[].obs;

  // الفئة المختارة - Selected class
  final Rx<Class?> selectedClass = Rx<Class?>(null);

  // رسالة الخطأ - Error message
  final RxString errorMessage = ''.obs;

  PageController? pageController;
  final int numPages = 3; // عدد الصفحات - The number of pages
  final RxInt currentPage = 0.obs;

  /// الحصول على الكنترولر - Get controller instance
  static BooksController get instance => Get.isRegistered<BooksController>()
      ? Get.find<BooksController>()
      : Get.put(BooksController());

  @override
  void onInit() {
    super.onInit();
    getClasses();
  }

  /// الحصول على الفئات - Get classes
  Future<List<Class>> getClasses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // جلب الفئات - Fetch classes
      final fetchedClasses = await fetchClasses();

      classes.value = fetchedClasses;

      return fetchedClasses;
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
      errorMessage.value = 'خطأ في تحميل الفئات: $e';

      // في حالة الخطأ، ارمي الاستثناء - In case of error, throw the exception
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  /// اختيار فئة - Select class
  void selectClass(Class selectedClassItem) {
    selectedClass.value = selectedClassItem;
  }
}
