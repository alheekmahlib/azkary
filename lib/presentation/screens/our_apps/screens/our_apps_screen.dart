part of '../our_apps.dart';

/// OurApps - شاشة "تطبيقاتنا" (Stateless عبر GetView)
/// تعرض التطبيقات المفلترة من واجهة Vexaltech كبطاقات غنية.
class OurApps extends GetView<OurAppsController> {
  const OurApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = ThemeController.instance.currentThemeId.value == 'dark';
      return Scaffold(
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).canvasColor,
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
                            width: 80.0.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))
                                        .r),
                            padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0)
                                .r,
                            margin: const EdgeInsets.symmetric(vertical: 8.0).r,
                            child: Text(
                              'من الكتاب والسُّنة',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),
                        ],
                      ))),
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

  /// جسم الشاشة: يتفرّع على حالة المتحكم (تحميل/خطأ/فارغ/بيانات)
  Widget _body(BuildContext context) {
    if (controller.isLoading.value) {
      return bookLoading(200.0.w, 200.0.h);
    }
    if (controller.errorMessage.value.isNotEmpty) {
      return _errorView(context, controller.errorMessage.value);
    }
    if (controller.apps.isEmpty) {
      return _emptyView(context);
    }
    return _list(context, controller.apps);
  }

  Widget _list(BuildContext context, List<OurAppInfo> apps) {
    return Padding(
      padding: const EdgeInsets.only(top: 90.0).r,
      child: Column(
        children: [
          Text(
            'ourApps'.tr,
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 20.sp,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold),
          ),
          hDivider(context),
          Expanded(
            child: ListView.separated(
              shrinkWrap: false,
              padding: EdgeInsets.zero,
              itemCount: apps.length,
              separatorBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0).r,
                child: hDivider(context),
              ),
              itemBuilder: (context, index) => _AppCard(
                app: apps[index],
                onLaunch: controller.launchApp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 13.sp,
                fontFamily: 'kufi',
              ),
            ),
            SizedBox(height: 16.0.h),
            FilledButton.icon(
              onPressed: controller.fetchApps,
              icon: const Icon(Icons.refresh),
              label: Text(
                'ourApps'.tr,
                style: const TextStyle(fontFamily: 'kufi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد تطبيقات',
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontSize: 14.sp,
          fontFamily: 'kufi',
        ),
      ),
    );
  }
}
