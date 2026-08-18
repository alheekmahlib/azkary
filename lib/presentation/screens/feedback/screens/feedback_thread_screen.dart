part of '../feedback.dart';

/// شاشة "ملاحظاتي": قائمة بطاقات الملاحظات السابقة + زر لإرسال ملاحظة جديدة
/// عبر bottom sheet.
///
/// كل اللوجيك في [FeedbackController] — هذه الشاشة مجرد واجهة (GetView).
class FeedbackThreadScreen extends GetView<FeedbackController> {
  const FeedbackThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تأكد من تحميل القائمة عند الفتح (يشمل بعد hot restart).
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.ensureLoaded());
    return Obx(() {
      final isDark = ThemeController.instance.currentThemeId.value == 'dark';
      return Scaffold(
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).canvasColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openSendSheet(context),
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: isDark
              ? Theme.of(context).canvasColor
              : Theme.of(context).colorScheme.primaryContainer,
          icon: const Icon(Icons.add),
          label: Text(
            'send_feedback'.tr,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'kufi',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: const Offset(300, -10),
                child: Opacity(
                  opacity: .05,
                  child: azkary_icon(
                    context,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: container(
                  context,
                  _body(context),
                  false,
                  height: orientation(context, 450.0.h, 300.0.h),
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: orientation(
                      context, Offset(0, -220.h), Offset(0, -130.h)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      azkary_logo(
                        context,
                        width: 80.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)).r),
                        padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0)
                            .r,
                        margin: const EdgeInsets.symmetric(vertical: 8.0).r,
                        child: Text(
                          'من الكتاب والسُّنة',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: orientation(
                      context,
                      const EdgeInsets.symmetric(vertical: 64.0).r,
                      const EdgeInsets.symmetric(vertical: 32.0).r),
                  child: alheekmah_logo(
                    context,
                    width: 60.w,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 48.0, right: 16.0).r,
                  child: customArrowBack(context),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// جسم الشاشة: يتفرّع على حالة المتحكم (تحميل/فارغ/بيانات)
  Widget _body(BuildContext context) {
    if (controller.isLoadingList.value && controller.threads.isEmpty) {
      return Center(child: bookLoading(150.0.w, 150.0.h));
    }
    if (!controller.hasFeedback || controller.threads.isEmpty) {
      return _emptyState(context);
    }
    return _list(context);
  }

  Widget _list(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 90.0).r,
      child: Column(
        children: [
          Text(
            'my_feedback'.tr,
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 20,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold),
          ),
          hDivider(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.loadAllThreads,
              child: ListView.separated(
                shrinkWrap: false,
                padding: EdgeInsets.zero,
                itemCount: controller.threads.length,
                separatorBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0).r,
                  child: hDivider(context, width: 200.0.w),
                ),
                itemBuilder: (context, index) => _FeedbackCard(
                  thread: controller.threads[index],
                  onTap: () =>
                      _openConversation(context, controller.threads[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// يفتح شاشة المحادثة للبطاقة المضغوطة.
  void _openConversation(BuildContext context, FeedbackThread thread) {
    Get.to(
      () => const FeedbackConversationScreen(),
      transition: Transition.downToUp,
    )?.then((_) {
      // أعد تحميل القائمة عند العودة (قد تكون أضفت رداً).
      controller.loadAllThreads();
    });
    controller.openConversation(thread.feedback.token);
  }

  /// يفتح الـ bottom sheet للإرسال.
  void _openSendSheet(BuildContext context) {
    allModalBottomSheet(context, const FeedbackSendSheet());
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconsAsset(
              'email',
              height: 56.h,
              width: 56.w,
            ),
            SizedBox(height: 16.0.h),
            Text(
              'no_feedback_yet'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.surface.withValues(alpha: .8),
                fontSize: 15,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0.h),
            FilledButton.icon(
              onPressed: () => _openSendSheet(context),
              icon: Icon(
                Icons.add,
                color: context.theme.colorScheme.inversePrimary,
              ),
              label: Text(
                'send_feedback'.tr,
                style: TextStyle(
                    fontFamily: 'kufi',
                    color: context.theme.colorScheme.inversePrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة ملاحظة واحدة في القائمة.
class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.thread, required this.onTap});

  final FeedbackThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final f = thread.feedback;
    final (label, color) = _statusStyle(f.status);
    final adminCount = thread.replies.where((r) => r.isAdmin).length;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)).r,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 32.0).r,
        padding: const EdgeInsets.all(12.0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0)
                          .r,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(8)).r,
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (adminCount > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: .6),
                      ),
                      SizedBox(width: 4.0.w),
                      Text(
                        '$adminCount',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: .6),
                          fontSize: 12,
                          fontFamily: 'kufi',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 8.0.h),
            Text(
              f.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 14,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.0.h),
            Text(
              f.createdAt,
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.surface.withValues(alpha: .5),
                fontSize: 11,
                fontFamily: 'kufi',
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color) _statusStyle(String status) {
    switch (status) {
      case 'in_progress':
        return ('feedback_status_in_progress'.tr, Colors.amber.shade700);
      case 'complete':
        return ('feedback_status_complete'.tr, Colors.green.shade700);
      case 'planned':
      default:
        return ('feedback_status_planned'.tr, Colors.blue.shade700);
    }
  }
}
