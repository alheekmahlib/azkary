part of '../about.dart';

/// AboutApp - شاشة "حول التطبيق" (Stateless عبر GetView)
/// About screen (stateless via GetView)
class AboutApp extends GetView<AboutController> {
  AboutApp({Key? key}) : super(key: key);

  final InAppReview inAppReview = InAppReview.instance;

  _launchUrl() async {
    // ios specification
    String uri = 'https://www.facebook.com/alheekmahlib';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      log("No url client found", name: 'AboutApp');
    }
  }

  Future<void> share() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/Azkary_banner.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/Azkary_banner.jpg').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          '"أذكاري من الكتاب والسنة" هو تطبيق متميز يقدم للمستخدمين مجموعة واسعة من الأذكار المستمدة من القرآن الكريم والسنة النبوية.\n\nرابط التحميل:\nhttps://shorturl.at/tW235',
    );
  }

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
                  Container(),
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
                                    const BorderRadius.all(Radius.circular(4))
                                        .r),
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
                      ))),
              Align(
                alignment: Alignment.center,
                child: orientation(
                    context,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 64.0.h,
                        ),
                        buildVersion(context, isDark),
                        SizedBox(
                          height: 16.0.h,
                        ),
                        appDetails(context),
                        shareRateApp(context),
                        SizedBox(
                          height: 16.0.h,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: socialMedia(context)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: socialMedia(context)),
                        buildVersion(context, isDark),
                        SizedBox(
                          height: 32.0.h,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 64.0).r,
                          child: Row(
                            children: [
                              Expanded(child: appDetails(context)),
                              Expanded(child: shareRateApp(context)),
                            ],
                          ),
                        )
                      ],
                    )),
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
              )
            ],
          ),
        ),
      );
    });
  }

  Widget buildVersion(BuildContext context, bool isDark) {
    return borderRadiusGreenContainer(
        context,
        15.0,
        width: 120.0,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${'version'.tr}: ${controller.packageInfo.value.version}',
            style: TextStyle(
              color: isDark ? Colors.white : Theme.of(context).canvasColor,
              fontSize: 12,
              fontFamily: 'kufi',
            ),
          ),
        ));
  }

  Widget appDetails(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)).r),
      padding: const EdgeInsets.all(8.0).r,
      margin: const EdgeInsets.all(16.0).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          azkary_logo(
            context,
            width: 40.0,
          ),
          vDivider(context, height: 40.h),
          Expanded(
            child: Text.rich(
                textAlign: TextAlign.justify,
                TextSpan(children: [
                  TextSpan(
                    text: 'أذكاري من الكتاب والسنة | ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 13,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        'التطبيق يحتوي على مجموعة من الأذكار التي وردت في القرآن والسنة.',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 13,
                      fontFamily: 'kufi',
                    ),
                  ),
                ])),
          ),
        ],
      ),
    );
  }

  Widget shareRateApp(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)).r),
      padding: const EdgeInsets.all(8.0).r,
      margin: const EdgeInsets.all(16.0).r,
      child: Column(
        children: [
          InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconsAsset(
                  'share',
                  height: 20.h,
                  width: 20.h,
                ),
                vDivider(context),
                Expanded(
                  child: Text(
                    'share'.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 13,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            onTap: () => shareApp(),
          ),
          hDivider(
            context,
          ),
          InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconsAsset(
                  'rating',
                  height: 20.h,
                  width: 20.h,
                ),
                vDivider(
                  context,
                ),
                Expanded(
                  child: Text(
                    'rating'.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 13,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            onTap: () {
              inAppReview.openStoreListing(appStoreId: '6451125110');
            },
          ),
        ],
      ),
    );
  }

  Widget socialMedia(BuildContext context) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ).r),
      padding: const EdgeInsets.all(8.0).r,
      child: Column(
        children: [
          InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconsAsset(
                  'email',
                  height: 20.h,
                  width: 20.h,
                ),
                vDivider(
                  context,
                ),
                Expanded(
                  child: Text(
                    'feedback'.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 13,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            onTap: () => Get.toNamed(AppRoutes.feedback),
          ),
          hDivider(
            context,
          ),
          InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconsAsset(
                  'facebook',
                  height: 20.h,
                  width: 20.h,
                ),
                vDivider(
                  context,
                ),
                Expanded(
                  child: Text(
                    'facebook'.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 13,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            onTap: () {
              _launchUrl();
            },
          ),
        ],
      ),
    );
  }
}
