part of '../quran_azkar.dart';

class QuranAzkarView extends StatelessWidget {
  final Surah surah;

  const QuranAzkarView({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final arabicNumbers = ArabicNumbers();
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ).r),
      child: orientation(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 32.0).r,
                  child: SizedBox(
                    height: 70.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        greenContainer(
                            context,
                            30.0,
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: fontSizeDropDown(context,
                                      Theme.of(context).canvasColor),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: customClose(context,
                                      firstColor: Theme.of(context).canvasColor,
                                      secondColor:
                                          Theme.of(context).canvasColor),
                                ),
                              ],
                            ),
                            width: MediaQuery.sizeOf(context).width),
                        Align(
                          alignment: Alignment.topCenter,
                          child: surah_name(context, surah.surah),
                        ),
                      ],
                    ),
                  )),
              Flexible(
                child: _azkarBuild(context, arabicNumbers),
              ),
            ],
          ),
          Stack(
            children: [
              Align(alignment: Alignment.topRight, child: customClose(context)),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.only(top: 50.0).r,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        fontSizeDropDown(context,
                            Theme.of(context).colorScheme.surface),
                        surah_name(context, surah.surah),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 1 / 2 * .9,
                  child: _azkarBuild(context, arabicNumbers),
                ),
              ),
            ],
          )),
    );
  }

  Widget _azkarBuild(BuildContext context, ArabicNumbers arabicNumbers) {
    ColorStyle colorStyle = ColorStyle(context);
    return Obx(() {
      // قراءة القيمة التفاعلية هنا لتسجيل الاعتماد لدى Obx (itemBuilder كسول)
      // Read the reactive value here to register the dependency with Obx (itemBuilder is lazy)
      final fontSize = AzkarItem.fontSizeAzkar;
      return ListView.separated(
        shrinkWrap: true,
        itemCount: surah.ayahs.length,
        separatorBuilder: (c, i) => Divider(
              color: Theme.of(context).colorScheme.surface,
            ),
        itemBuilder: (context, index) {
          final ayah = surah.ayahs[index];
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
                        child: SelectableText(
                          ayah.ayah,
                          style: TextStyle(
                              color: colorStyle.greenTextColor(),
                              height: 1.4,
                              fontFamily: 'uthmanic2',
                              fontSize: fontSize),
                          showCursor: true,
                          cursorWidth: 3,
                          cursorColor: Theme.of(context).dividerColor,
                          cursorRadius: const Radius.circular(5),
                          scrollPhysics: const ClampingScrollPhysics(),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.justify,
                        ),
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
                          "${'ayah'.tr} | ${arabicNumbers.convert(ayah.ayahNumber)}",
                          style: TextStyle(
                              color: colorStyle.greenTextColor(),
                              fontSize: 14,
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
                            IconButton(
                              onPressed: () {
                                showVerseOptionsBottomSheet(context, ayah.ayah,
                                    surah.name, '', "", ayah.ayahNumber);
                              },
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(context).canvasColor,
                                size: 18.h,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                FlutterClipboard.copy('${surah.name}\n\n'
                                        '${ayah.ayah}\n\n'
                                        '| ${ayah.ayahNumber} |')
                                    .then((value) => customSnackBar(
                                        context,
                                        'copyAzkarText'.tr));
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
                                    .addAzkar(Azkar(null, surah.name,
                                        '1', '', ayah.ayahNumber, ayah.ayah))
                                    .then((value) => customSnackBar(
                                        context,
                                        'addZekrBookmark'.tr));
                              },
                              icon: Icon(
                                Icons.bookmark_add,
                                color: Theme.of(context).canvasColor,
                                size: 18.h,
                              ),
                            ),
                          ],
                        ),
                        width: MediaQuery.sizeOf(context).width),
                  ),
                ],
              ),
            ),
          );
        });
    });
  }
}
