part of '../azkar.dart';

/// AzkarItem - شاشة فئة أذكار (Stateless عبر GetView مع tag لكل فئة)
/// Azkar category screen (stateless via GetView with per-category tag)
class AzkarItem extends GetView<AzkarItemController> {
  const AzkarItem({Key? key, required this.azkar})
      : tag = azkar,
        super(key: key);

  final String azkar;

  /// حجم خط الأذكار — يُفوّض إلى AzkaryController لجعله تفاعلياً
  /// Azkar font size — delegated to AzkaryController to make it reactive
  static double get fontSizeAzkar =>
      AzkaryController.instance.fontSizeAzkar.value;
  static set fontSizeAzkar(double value) =>
      AzkaryController.instance.fontSizeAzkar.value = value;

  /// وسْم المتحكم حسب اسم الفئة / Controller tag by category name
  @override
  final String? tag;

  @override
  Widget build(BuildContext context) {
    final azkarByCategory = controller.azkarByCategory;
    ColorStyle colorStyle = ColorStyle(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: orientation(
            context, const EdgeInsets.only(top: 64), EdgeInsets.zero),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ).r),
        child: orientation(
            context,
            Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: customClose(context)),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0).r,
                    child: greenContainer(
                      context,
                      32.0,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fontSizeDropDown(
                              context, Theme.of(context).canvasColor),
                          Container(
                            width: 250.w,
                            alignment: Alignment.center,
                            child: Text(
                              azkarByCategory.azkarList.first.category!,
                              style: TextStyle(
                                color: colorStyle.whiteTextColor(),
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'vexa',
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ),
                ),
                Padding(
                  padding: orientation(
                      context,
                      const EdgeInsets.only(top: 116).r,
                      const EdgeInsets.only(top: 55).r),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: azkarBuild(context)),
                ),
              ],
            ),
            Stack(
              children: [
                Align(
                    alignment: Alignment.topRight, child: customClose(context)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0).r,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            fontSizeDropDown(
                                context, Theme.of(context).colorScheme.surface),
                            greenContainer(
                              context,
                              60.0,
                              width: MediaQuery.sizeOf(context).width,
                              Container(
                                child: Text(
                                  azkarByCategory.azkarList.first.category!,
                                  style: TextStyle(
                                    color: colorStyle.whiteTextColor(),
                                    fontSize: 19.0,
                                    fontFamily: 'vexa',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * .5,
                          child: azkarBuild(context)),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget azkarBuild(BuildContext context) {
    final azkarList = controller.azkarByCategory.azkarList;
    ColorStyle colorStyle = ColorStyle(context);
    return SingleChildScrollView(
      controller: controller.scrollController,
      child: Column(
        children: azkarList.map((azkar) {
          return ClipRRect(
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ).r,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8).r,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: Theme.of(context).colorScheme.surface,
                            width: 5.w,
                          ),
                        ),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8).r,
                        child: Obx(() => Text(
                              azkar.zekr!,
                              style: TextStyle(
                                  color: colorStyle.greenTextColor(),
                                  height: 1.4,
                                  fontFamily: 'naskh',
                                  fontSize: AzkarItem.fontSizeAzkar),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.justify,
                            )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8).r,
                        margin: const EdgeInsets.symmetric(horizontal: 8).r,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 5.w))),
                        child: Text(
                          azkar.reference!,
                          style: TextStyle(
                              color: colorStyle.greenTextColor(),
                              fontSize: 12,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic),
                        )),
                  ),
                  azkar.description! == ''
                      ? Container()
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8).r,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8).r,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  border: Border.symmetric(
                                      vertical: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          width: 5.w))),
                              child: Text(
                                azkar.description!,
                                style: TextStyle(
                                    color: colorStyle.greenTextColor(),
                                    fontSize: 16,
                                    fontFamily: 'kufi',
                                    fontStyle: FontStyle.italic),
                              )),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                    child: greenContainer(
                        context,
                        30.0,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showVerseOptionsBottomSheet(
                                        context,
                                        azkar.zekr!,
                                        azkar.category!,
                                        azkar.description,
                                        ' التكرار:  ${azkar.count} ',
                                        azkar.reference);
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: Theme.of(context).canvasColor,
                                    size: 18.h,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy(
                                            '${azkar.category}\n\n'
                                            '${azkar.zekr}\n\n'
                                            '| ${azkar.description}. | (التكرار: ${azkar.count})')
                                        .then((value) => customSnackBar(
                                            context, 'copyAzkarText'.tr));
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: Theme.of(context).canvasColor,
                                    size: 18.h,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final azkarController =
                                        AzkarController.instance;
                                    await azkarController
                                        .addAzkar(Azkar(
                                            azkar.id,
                                            azkar.category,
                                            azkar.count,
                                            azkar.description,
                                            azkar.reference,
                                            azkar.zekr))
                                        .then((value) => customSnackBar(
                                            context, 'addZekrBookmark'.tr));
                                  },
                                  icon: Icon(
                                    Icons.bookmark_add,
                                    color: Theme.of(context).canvasColor,
                                    size: 18.h,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4)
                                  .r,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ).r,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    azkar.count!,
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor,
                                        fontSize: 14,
                                        fontFamily: 'kufi',
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.repeat,
                                    color: Theme.of(context).canvasColor,
                                    size: 18.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        width: MediaQuery.sizeOf(context).width),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
