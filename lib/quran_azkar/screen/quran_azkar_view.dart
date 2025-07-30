import 'package:Azkary/shared/style.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../azkar/controllers/azkar_controller.dart';
import '../../azkar/models/azkar.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../quran_azkar_model.dart';

class QuranAzkarView extends StatefulWidget {
  final Surah surah;

  QuranAzkarView({required this.surah});

  @override
  State<QuranAzkarView> createState() => _QuranAzkarViewState();
}

class _QuranAzkarViewState extends State<QuranAzkarView> {
  double lowerValue = 18;
  double upperValue = 40;
  String? selectedValue;
  ArabicNumbers arabicNumbers = ArabicNumbers();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ).r),
      child: orientation(
          context,
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0).r,
                  child: azkarBuild(context),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
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
                                    child: fontSizeDropDown(context, setState,
                                        Theme.of(context).canvasColor),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: customClose(context),
                                  ),
                                ],
                              ),
                              width: MediaQuery.sizeOf(context).width),
                          Align(
                            alignment: Alignment.topCenter,
                            child: surah_name(context, widget.surah.surah),
                          ),
                        ],
                      ),
                    )),
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
                        fontSizeDropDown(context, setState,
                            Theme.of(context).colorScheme.surface),
                        surah_name(context, widget.surah.surah),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 1 / 2 * .9,
                  child: azkarBuild(context),
                ),
              ),
            ],
          )),
    );
  }

  Widget azkarBuild(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return ListView.separated(
        itemCount: widget.surah.ayahs.length,
        separatorBuilder: (c, i) => Divider(
              color: Theme.of(context).colorScheme.surface,
            ),
        itemBuilder: (context, index) {
          final ayah = widget.surah.ayahs[index];
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
                        color: Theme.of(context).colorScheme.surface,
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
                              fontSize: AzkarItem.fontSizeAzkar),
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
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 5.w))),
                        child: Text(
                          "${AppLocalizations.of(context)!.ayah} | ${arabicNumbers.convert(ayah.ayahNumber)}",
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
                                    widget.surah.name, '', "", ayah.ayahNumber);
                              },
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(context).canvasColor,
                                size: 18.h,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                FlutterClipboard.copy('${widget.surah.name}\n\n'
                                        '${ayah.ayah}\n\n'
                                        '| ${ayah.ayahNumber} |')
                                    .then((value) => customSnackBar(
                                        context,
                                        AppLocalizations.of(context)!
                                            .copyAzkarText));
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
                                    .addAzkar(Azkar(null, widget.surah.name,
                                        '1', '', ayah.ayahNumber, ayah.ayah))
                                    .then((value) => customSnackBar(
                                        context,
                                        AppLocalizations.of(context)!
                                            .addZekrBookmark));
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
  }
}
