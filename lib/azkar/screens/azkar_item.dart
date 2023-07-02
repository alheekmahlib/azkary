import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:husn_al_muslim/azkar/models/azkar.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../azkar/models/azkar_by_category.dart';
import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/svg_picture.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: .02,
                child: azkary_icon(
                context,
                width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height
              ),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: customClose(context)),
            orientation(
                context,
                Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                orientation(context,
                    const EdgeInsets.only(right: 16.0, left: 16.0, top: 50.0),
                    const EdgeInsets.only(right: 16.0, left: 16.0, top: 40.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    fontSizeDropDown(context),
                    Container(
                      width: orientation(context, 250.0, 350.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme.surface
                              .withOpacity(.2),
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 2))),
                      child: Text(
                        azkarByCategory.azkarList.first.category!,
                        style: TextStyle(
                          color: ThemeProvider.themeOf(context).id == 'dark'
                              ? Colors.white
                              : Theme.of(context).primaryColorDark,
                          fontSize: orientation(context, 19.0, 22.0),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'vexa',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 64),
                  child: Column(
                    children: [
                      fontSizeDropDown(context),
                      Container(
                        width: orientation(context, 250.0, 170.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme.surface
                                .withOpacity(.2),
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color: Theme.of(context).colorScheme.surface,
                                    width: 2))),
                        child: Text(
                          azkarByCategory.azkarList.first.category!,
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColorDark,
                            fontSize: orientation(context, 19.0, 22.0),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'vexa',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            Padding(
              padding: orientation(context,
                  const EdgeInsets.only(top: 116),
                  const EdgeInsets.only(top: 55)),
              child: Align(
                alignment: orientation(
                    context, Alignment.topCenter, Alignment.centerLeft),
                  child: azkarBuild(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget azkarBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: azkarByCategory.azkarList.map((azkar) {
          return Container(
            width: orientation(
                context,
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.width * .48),
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme.surface
                    .withOpacity(.2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color:
                          Theme.of(context).colorScheme.surface,
                          width: 2,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme.surface
                                  .withOpacity(.2),
                              border: Border.symmetric(
                                  vertical: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme.surface,
                                      width: 2))),
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
                          ))),
                ),
                azkar.description! == ''
                    ? Container()
                    : Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme.surface
                                .withOpacity(.2),
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme.surface,
                                    width: 2))),
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
                        ))),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
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
                                    .colorScheme.surface,
                                size: 20,
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
                                    .colorScheme.surface,
                                size: 20,
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
                                    .colorScheme.surface,
                                size: 20,
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
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget fontSizeDropDown(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: FlutterSlider(
            values: [AzkarItem.fontSizeAzkar],
            max: 40,
            min: 18,
            rtl: true,
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBarHeight: 5,
              activeTrackBarHeight: 5,
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.background),
            ),
            handlerAnimation: const FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: null,
                duration: Duration(milliseconds: 700),
                scale: 1.4),
            onDragging: (handlerIndex, lowerValue, upperValue) {
              lowerValue = lowerValue;
              upperValue = upperValue;
              AzkarItem.fontSizeAzkar = lowerValue;
              cubit.saveAzkarFontSize(AzkarItem.fontSizeAzkar);
              setState(() {});
            },
            handler: FlutterSliderHandler(
              decoration: const BoxDecoration(),
              child: Material(
                type: MaterialType.circle,
                color: Colors.transparent,
                elevation: 3,
                child: SvgPicture.asset('assets/svg/slider_ic.svg'),
              ),
            ),
          ),
        )
      ],
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value as String;
        });
      },
      customButton: Icon(
        Icons.format_size,
        size: 28,
        color: Theme.of(context).colorScheme.surface,
      ),
      iconStyleData: const IconStyleData(
        iconSize: 40,
      ),
      buttonStyleData: const ButtonStyleData(
        height: 60,
        width: 60,
        elevation: 0,
      ),
      dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(.9),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          padding: const EdgeInsets.only(left: 1, right: 1),
          maxHeight: 230,
          width: 230,
          elevation: 0,
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(8),
            thickness: MaterialStateProperty.all(6),
          )
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 45,
      ),
    );
  }
}
