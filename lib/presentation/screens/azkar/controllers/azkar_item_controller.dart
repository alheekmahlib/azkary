part of '../azkar.dart';

/// AzkarItemController - تحكم في شاشة فئة الأذكار (البيانات + موضع التمرير)
/// Controller for an azkar category screen (data + scroll position)
///
/// يُسجَّل بمتصف (tag) = اسم الفئة لتفادي التعارض عند فتح فئات متعددة.
/// Registered with tag = category name to avoid clashes across categories.
class AzkarItemController extends GetxController {
  AzkarItemController(this.category);

  final String category;

  /// نموذج فئة الأذكار / The azkar-by-category model
  final AzkarByCategory azkarByCategory = AzkarByCategory();

  /// متحكم التمرير لحفظ/استعادة موضع القراءة / Scroll controller for resume position
  final ScrollController scrollController = ScrollController();

  final GetStorage _box = GetStorage();
  Timer? _saveDebounce;

  /// مفتاح حفظ موضع القراءة حسب الفئة / Storage key per category
  String get scrollOffsetKey => 'azkar_scroll_offset_$category';

  @override
  void onInit() {
    super.onInit();
    azkarByCategory.getAzkarByCategory(category);
    scrollController.addListener(_onScrollChanged);
    // استعادة موضع القراءة بعد بناء الإطار الأول
    // Restore saved scroll position after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreScrollOffset());
  }

  void _onScrollChanged() {
    if (!scrollController.hasClients) return;
    final offset = scrollController.offset;
    // debounce: لا يُكتب إلا بعد توقّف التمرير 500ms
    // Debounce: only write after scrolling stops for 500ms
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
      _box.write(scrollOffsetKey, offset);
    });
  }

  Future<void> _restoreScrollOffset() async {
    if (!scrollController.hasClients) return;
    try {
      final savedOffset = _box.read<double>(scrollOffsetKey) ?? 0;
      if (savedOffset > 0 &&
          savedOffset <= scrollController.position.maxScrollExtent) {
        scrollController.jumpTo(savedOffset);
      }
    } catch (_) {
      // تجاهل أخطاء استعادة الموضع / Ignore scroll restore errors
    }
  }

  @override
  void onClose() {
    _saveDebounce?.cancel();
    scrollController.removeListener(_onScrollChanged);
    scrollController.dispose();
    super.onClose();
  }
}

/// ربط متحكم فئة الأذكار / Azkar item controller binding (per-category tag)
class AzkarItemBinding extends Bindings {
  AzkarItemBinding({required this.category});

  final String category;

  @override
  void dependencies() {
    Get.lazyPut<AzkarItemController>(
      () => AzkarItemController(category),
      tag: category,
    );
  }
}
