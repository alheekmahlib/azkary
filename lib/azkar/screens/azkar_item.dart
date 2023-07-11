import 'package:flutter_bloc/flutter_bloc.dart';
import '../../azkar/models/azkar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../shared/style.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../azkar/models/azkar_by_category.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/azkar_cubit.dart';

class AzkarItem extends StatefulWidget {
  const AzkarItem({Key? key, required this.azkar}) : super(key: key);
  final String azkar;

  static double fontSizeAzkar = 18;

  @override
  State<AzkarItem> createState() => _AzkarItemState();
}

class _AzkarItemState extends State<AzkarItem> {
  AzkarByCategory azkarByCategory = AzkarByCategory();
  double lowerValue = 18;
  double upperValue = 40;
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
          )
        ),
        child: orientation(context,
            Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: customClose(context)),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: greenContainer(context,
                  60.0,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fontSizeDropDown(context, setState),
                      Container(
                        width: 250,
                        alignment: Alignment.center,
                        child: Text(
                          azkarByCategory.azkarList.first.category!,
                          style: TextStyle(
                            color: colorStyle.whiteTextColor(),
                            fontSize: orientation(context, 19.0, 22.0),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'vexa',
                          ),
                        ),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Padding(
              padding: orientation(context,
                  const EdgeInsets.only(top: 116),
                  const EdgeInsets.only(top: 55)),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: azkarBuild(context)),
            ),
          ],
        ),
            Stack(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: customClose(context)),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fontSizeDropDown(context, setState),
                    greenContainer(context,
                      100.0,
                      Container(
                        // width: 250,
                        // alignment: Alignment.center,
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
                      width: MediaQuery.of(context).size.width /1/2 *.5
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1/2 *.9,
                    child: azkarBuild(context))),
          ],
        )),
      ),
    );
  }

  Widget azkarBuild(BuildContext context) {
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
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color:
                            Theme.of(context).colorScheme.surface,
                            width: 5,
                          ),
                        ),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          azkar.zekr!,
                          style: TextStyle(
                              color:
                              ThemeProvider.themeOf(context).id ==
                                  'dark'
                                  ? Colors.white
                                  : Colors.black,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme.background,
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme.surface,
                                    width: 5))),
                        child: Text(
                          azkar.reference!,
                          style: TextStyle(
                              color:
                              ThemeProvider.themeOf(context)
                                  .id ==
                                  'dark'
                                  ? Colors.white
                                  : Theme.of(context)
                                  .primaryColorDark,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme.background,
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme.surface,
                                    width: 5))),
                        child: Text(
                          azkar.description!,
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context)
                                  .id ==
                                  'dark'
                                  ? Colors.white
                                  : Theme.of(context)
                                  .primaryColorDark,
                              fontSize: 16,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic),
                        )),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    color: Theme.of(context).colorScheme.surface,
                    child: ClipRRect(
                      child: Stack(
                        children: [
                          SvgPicture.asset('assets/svg/azkary.svg',
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).canvasColor.withOpacity(.05),
                                BlendMode.srcIn),
                            fit: BoxFit.fitWidth,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme.surface
                                    .withOpacity(.2),
                                border: Border.symmetric(
                                    vertical: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme.surface,
                                        width: 2))),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showVerseOptionsBottomSheet(context,
                                            azkar.zekr!, azkar.category!,
                                            azkar.description, ' التكرار:  ${azkar.count} ', azkar.reference);
                                        // Share.share('${azkar.category}\n\n'
                                        //     '${azkar.zekr}\n\n'
                                        //     '| ${azkar.description}. | (التكرار: ${azkar.count})');
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: Theme.of(context)
                                            .canvasColor,
                                        size: 23,
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
                                            AppLocalizations.of(context)!.copyAzkarText));
                                      },
                                      icon: Icon(
                                        Icons.copy,
                                        color: Theme.of(context)
                                            .canvasColor,
                                        size: 23,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final azkarCubit = context.read<AzkarCubit>();
                                        await azkarCubit.addAzkar(Azkar(
                                            azkar.id,
                                            azkar.category,
                                            azkar.count,
                                            azkar.description,
                                            azkar.reference,
                                            azkar.zekr
                                        )).then((value) => customSnackBar(
                                            context,
                                            AppLocalizations.of(context)!.addZekrBookmark));
                                      },
                                      icon: Icon(
                                        Icons.bookmark_add,
                                        color: Theme.of(context)
                                            .canvasColor,
                                        size: 23,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    color:
                                    Theme.of(context).colorScheme.surface,
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
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
