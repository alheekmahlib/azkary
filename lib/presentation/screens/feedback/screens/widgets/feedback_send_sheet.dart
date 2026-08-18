part of '../../feedback.dart';

/// Bottom sheet لإرسال ملاحظة جديدة.
///
/// كل اللوجيك في [FeedbackController] — الـ widget يدير TextEditingControllers
/// المحلية فقط (تنظيف عند الإغلاق). يستخدم نفس ستايل شاشات التطبيق.
class FeedbackSendSheet extends StatefulWidget {
  const FeedbackSendSheet({super.key});

  @override
  State<FeedbackSendSheet> createState() => _FeedbackSendSheetState();
}

class _FeedbackSendSheetState extends State<FeedbackSendSheet> {
  final FeedbackController _c = FeedbackController.instance;
  final TextEditingController _messageCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final ValueNotifier<int> _charCount = ValueNotifier<int>(0);

  static const int _maxChars = 8000;

  @override
  void initState() {
    super.initState();
    _messageCtrl.addListener(() => _charCount.value = _messageCtrl.text.length);
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _emailCtrl.dispose();
    _charCount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final result = await _c.submitFeedback(
      _messageCtrl.text,
      email: _emailCtrl.text,
    );
    if (!mounted) return;
    result.fold(
      (failure) => customSnackBar(context, 'feedback_sent_error'.tr),
      (_) {
        _messageCtrl.clear();
        _emailCtrl.clear();
        customSnackBar(context, 'feedback_sent_success'.tr);
        // أغلق الـ sheet ثم أعد تحميل القائمة.
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
        _c.loadAllThreads();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ارفع المحتوى فوق الكيبورد عند ظهوره.
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'feedback_subtitle'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: 16,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.0.h),
              _messageField(context),
              ValueListenableBuilder<int>(
                valueListenable: _charCount,
                builder: (context, used, _) {
                  final remaining = _maxChars - used;
                  return Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '$remaining ${'characters_remaining'.tr}',
                      style: TextStyle(
                        color:
                            Theme.of(context).canvasColor.withValues(alpha: .7),
                        fontSize: 11,
                        fontFamily: 'kufi',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.0.h),
              _emailField(context),
              SizedBox(height: 12.0.h),
              _mediaSection(context),
              SizedBox(height: 16.0.h),
              _submitButton(context),
              SizedBox(height: 16.0.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _charCount,
      builder: (context, used, _) {
        final hasText = used > 0;
        return Obx(() {
          final busy = _c.isSubmitting.value;
          final uploading = _c.isUploading.value;
          final hasFiles = _c.selectedFiles.isNotEmpty;
          // مفعّل إن وُجد نص أو ملفات، ولسنا مشغولين.
          final enabled = (hasText || hasFiles) && !busy && !uploading;
          return Opacity(
            opacity: enabled ? 1.0 : 0.5,
            child: InkWell(
              onTap: enabled ? _submit : null,
              borderRadius: const BorderRadius.all(Radius.circular(8)).r,
              child: Container(
                height: 46.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)).r,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (busy) ...[
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0.w),
                    ],
                    Text(
                      'send_feedback'.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 15,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _mediaSection(BuildContext context) {
    return Obx(() {
      final files = _c.selectedFiles;
      final uploading = _c.isUploading.value;
      final progress = _c.uploadProgress.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صف الأزرار: + صور + فيديو + عدّاد.
          Row(
            children: [
              _pickerButton(
                context: context,
                icon: Icons.add_photo_alternate_outlined,
                label: 'feedback_pick_images',
                onPressed: uploading ? null : () => _pickImages(context),
              ),
              SizedBox(width: 8.0.w),
              _pickerButton(
                context: context,
                icon: Icons.videocam_outlined,
                label: 'feedback_pick_video',
                onPressed: uploading ? null : () => _pickVideo(context),
              ),
              const Spacer(),
              Text(
                '${files.length}/${FeedbackController.maxFiles}',
                style: TextStyle(
                  color: Theme.of(context).canvasColor.withValues(alpha: .7),
                  fontSize: 12,
                  fontFamily: 'kufi',
                ),
              ),
            ],
          ),
          // شريط تقدّم الرفع.
          if (uploading) ...[
            SizedBox(height: 8.0.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor:
                    Theme.of(context).canvasColor.withValues(alpha: .15),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).canvasColor,
                ),
              ),
            ),
            SizedBox(height: 4.0.h),
            Text(
              '${'feedback_uploading'.tr} ${(progress * 100).toInt()}%',
              style: TextStyle(
                color: Theme.of(context).canvasColor.withValues(alpha: .7),
                fontSize: 11,
                fontFamily: 'kufi',
              ),
            ),
          ],
          // شبكة المصغّرات.
          if (files.isNotEmpty) ...[
            SizedBox(height: 8.0.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(files.length, (i) {
                return _thumb(context, files[i], i);
              }),
            ),
          ],
        ],
      );
    });
  }

  Widget _pickerButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(8)).r,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0).r,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor.withValues(alpha: .12),
            borderRadius: const BorderRadius.all(Radius.circular(8)).r,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Theme.of(context).canvasColor),
              SizedBox(width: 4.0.w),
              Text(
                label.tr,
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: 12,
                  fontFamily: 'kufi',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// مصغّرة ملف واحد مع زر إزالة وشارة نوع.
  Widget _thumb(BuildContext context, File file, int index) {
    final isVideo = _c.isVideoFile(file);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)).r,
          child: SizedBox(
            width: 72.w,
            height: 72.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(file, fit: BoxFit.cover),
                if (isVideo)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _c.removeFileAt(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 14.sp),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages(BuildContext context) async {
    final err = await _c.pickImages();
    if (err != null && context.mounted) {
      customSnackBar(context, err.tr);
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final err = await _c.pickVideo();
    if (err != null && context.mounted) {
      customSnackBar(context, err.tr);
    }
  }

  Widget _messageField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0).r,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.withValues(alpha: .12),
        borderRadius: const BorderRadius.all(Radius.circular(12)).r,
      ),
      child: TextField(
        controller: _messageCtrl,
        maxLines: 8,
        minLines: 5,
        maxLength: _maxChars,
        cursorColor: Theme.of(context).canvasColor,
        // أخفِ الكيبورد عند الضغط خارج الحقل.
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: TextStyle(
          color: Theme.of(context).canvasColor,
          fontSize: 15,
          fontFamily: 'kufi',
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: 'feedback_message_hint'.tr,
          hintStyle: TextStyle(
            color: Theme.of(context).canvasColor.withValues(alpha: .5),
            fontSize: 15,
            fontFamily: 'kufi',
          ),
        ),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0).r,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.withValues(alpha: .12),
        borderRadius: const BorderRadius.all(Radius.circular(12)).r,
      ),
      child: Row(
        children: [
          iconsAsset(
            'email',
            height: 20.h,
            width: 20.w,
          ),
          SizedBox(width: 8.0.w),
          Expanded(
            child: TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Theme.of(context).canvasColor,
              // أخفِ الكيبورد عند الضغط خارج الحقل.
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: TextStyle(
                color: Theme.of(context).canvasColor,
                fontSize: 15,
                fontFamily: 'kufi',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'feedback_contact_optional'.tr,
                hintStyle: TextStyle(
                  color: Theme.of(context).canvasColor.withValues(alpha: .5),
                  fontSize: 15,
                  fontFamily: 'kufi',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
