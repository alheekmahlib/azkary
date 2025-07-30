import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../azkar/controllers/azkar_controller.dart';
import '../../azkar/models/azkar.dart';
import '../../azkar/models/azkar_by_category.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/style.dart';
import '../../shared/widgets/widgets.dart';

class AzkarItem extends StatefulWidget {
  const AzkarItem({Key? key, required this.azkar}) : super(key: key);
  final String azkar;

  static double fontSizeAzkar = 18;

  @override
  State<AzkarItem> createState() => _AzkarItemState();
}

class _AzkarItemState extends State<AzkarItem> {
  AzkarByCategory azkarByCategory = AzkarByCategory();
  double lowerValue = 18.sp;
  double upperValue = 40.sp;
  String? selectedValue;

  @override
  void initState() {
    azkarByCategory.getAzkarByCategory(widget.azkar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
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
                      32.0.h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fontSizeDropDown(
                              context, setState, Theme.of(context).canvasColor),
                          Container(
                            width: 250.w,
                            alignment: Alignment.center,
                            child: Text(
                              azkarByCategory.azkarList.first.category!,
                              style: TextStyle(
                                color: colorStyle.whiteTextColor(),
                                fontSize: 19.0.sp,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0).r,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fontSizeDropDown(context, setState,
                            Theme.of(context).colorScheme.surface),
                        greenContainer(
                            context,
                            100.0.h,
                            Container(
                              child: Text(
                                azkarByCategory.azkarList.first.category!,
                                style: TextStyle(
                                  color: colorStyle.whiteTextColor(),
                                  fontSize: 19.0.sp,
                                  fontFamily: 'vexa',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            width:
                                MediaQuery.sizeOf(context).width / 1 / 2 * .5),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                        width: MediaQuery.sizeOf(context).width / 1 / 2 * .9,
                        child: azkarBuild(context))),
              ],
            )),
      ),
    );
  }

  Widget azkarBuild(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return SingleChildScrollView(
      child: Column(
        children: azkarByCategory.azkarList.map((azkar) {
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
                        child: Text(
                          azkar.zekr!,
                          style: TextStyle(
                              color: colorStyle.greenTextColor(),
                              height: 1.4,
                              fontFamily: 'naskh',
                              fontSize: AzkarItem.fontSizeAzkar),
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
                          azkar.reference!,
                          style: TextStyle(
                              color: colorStyle.greenTextColor(),
                              fontSize: 12.sp,
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
                                  color: Theme.of(context).colorScheme.surface,
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
                                    fontSize: 16.sp,
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
                                    // Share.share('${azkar.category}\n\n'
                                    //     '${azkar.zekr}\n\n'
                                    //     '| ${azkar.description}. | (التكرار: ${azkar.count})');
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
                                        .addAzkar(Azkar(
                                            azkar.id,
                                            azkar.category,
                                            azkar.count,
                                            azkar.description,
                                            azkar.reference,
                                            azkar.zekr))
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
                                        fontSize: 14.sp,
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
