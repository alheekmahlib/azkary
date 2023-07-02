
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:husn_al_muslim/shared/widgets/svg_picture.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/share/ayah_to_images.dart';
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
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
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
                padding: const EdgeInsets.only(top: 50.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      padding: EdgeInsets.all(4),
                      child: surah_name(context, widget.surah.surah,
                          100,
                          30
                      ),
                    ),
                    fontSizeDropDown(context),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: azkarBuild(context),
            ),
          ),
        ],
      ),
          Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: customClose(context)),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    fontSizeDropDown(context),
                    Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      padding: EdgeInsets.all(4),
                      child: surah_name(context, widget.surah.surah,
                          100,
                          30
                      ),
                    ),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1 /2 *.9,
              child: azkarBuild(context),
            ),
          ),
        ],
      )),
    );
  }

  Widget azkarBuild(BuildContext context) {
    return ListView.builder(
        itemCount: widget.surah.ayahs.length,
        itemBuilder: (context, index) {
          final ayah = widget.surah.ayahs[index];
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
                    child: SelectableText(
                      ayah.ayah,
                      style: TextStyle(
                          color:
                          ThemeProvider.themeOf(context).id ==
                              'dark'
                              ? Colors.white
                              : Colors.black,
                          height: 1.4,
                          fontFamily: 'uthmanic2',
                          fontSize: AzkarItem.fontSizeAzkar),
                      showCursor: true,
                      cursorWidth: 3,
                      cursorColor: Theme.of(context).dividerColor,
                      cursorRadius: const Radius.circular(5),
                      scrollPhysics:
                      const ClampingScrollPhysics(),
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
                              .colorScheme.surface
                              .withOpacity(.2),
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme.surface,
                                  width: 2))),
                      child: Text(
                        "${AppLocalizations.of(context)!.ayah} | ${arabicNumbers.convert(ayah.ayahNumber)}",
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          showVerseOptionsBottomSheet(context,
                              ayah.ayah, widget.surah.name,
                              '', "", ayah.ayahNumber);
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
                              '${widget.surah.name}\n\n'
                                  '${ayah.ayah}\n\n'
                                  '| ${ayah.ayahNumber} |')
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
                          // await _azkarController
                          //     .addAzkar(Azkar(
                          //     azkar.id,
                          //     azkar.category,
                          //     azkar.count,
                          //     azkar.description,
                          //     azkar.reference,
                          //     azkar.zekr))
                          //     .then((value) => customSnackBar(
                          //     context,
                          //     AppLocalizations.of(context)!.addZekrBookmark));
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
                ),
              ),
            ],
          ),
        );
      }
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
