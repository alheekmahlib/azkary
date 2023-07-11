import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import '../../shared/style.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../cubit/cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/lottie.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/azkar_cubit.dart';
import '../models/azkar.dart';



class AzkarFav extends StatefulWidget {
  const AzkarFav({Key? key}) : super(key: key);

  static double fontSizeAzkar = 20;

  @override
  State<AzkarFav> createState() => _AzkarFavState();
}

class _AzkarFavState extends State<AzkarFav> {
  var controller = ScrollController();
  double lowerValue = 18;
  double upperValue = 40;
  String? selectedValue;

  @override
  void initState() {
    context.read<AzkarCubit>().getAzkar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          )
        ),
        child: orientation(
            context, Column(
          children: [
            customClose(context),
            fav_azkar(context, 100.0, 100.0),
            Flexible(child: fav_build(context)),
          ],
        ),
            Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: customClose(context)),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: fav_azkar(context, 130.0, 130.0))),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: fav_build(context),
                    )),
              ],
            )),
      )
    );
  }

  Widget fav_build(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        if (state is AzkarInitial) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: bookmarks(150.0, 150.0),
          );
        } else if (state is AzkarError) {
          // Handle the error state here
          return const Text('Error occurred');
        } else if (state is AzkarLoaded) {
          if (state.azkarList.isEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: bookmarks(150.0, 150.0),
            );
          } else {
            return AnimationLimiter(
              child: SizedBox(
                width: orientation(
                    context,
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.width * .48
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: controller,
                    padding: EdgeInsets.zero,
                    itemCount: state.azkarList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var azkar = state.azkarList[index];
                      print(azkar.zekr);
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 450),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Dismissible(
                                background: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8))),
                                  child: delete(context),
                                ),
                                key: ValueKey<int>(azkar.id!),
                                onDismissed: (DismissDirection direction) {
                                  final azkarCubit = context.read<AzkarCubit>();
                                  azkarCubit.deleteAzkar(azkar, context);
                                },
                                child: ClipRRect(
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
                                                    color: colorStyle.greenTextColor(),
                                                    height: 1.4,
                                                    fontFamily: 'naskh',
                                                    fontSize:
                                                    AzkarFav.fontSizeAzkar),
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
                                                    color: ThemeProvider.themeOf(
                                                        context)
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
                                                    color: ThemeProvider.themeOf(
                                                        context)
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
                                                                  azkar.count == '' ? '' : azkar.count,
                                                                  azkar.description == '' ? '' : azkar.description,
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
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
        }
        return Container(
          color: Colors.blue,
          height: 300,
          width: 300,
        );
      },
    );
  }
  Widget fontSizeDropDown(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    return DropdownButton2(
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          child: FlutterSlider(
            values: [AzkarFav.fontSizeAzkar],
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
              AzkarFav.fontSizeAzkar = lowerValue;
              cubit.saveAzkarFontSize(AzkarFav.fontSizeAzkar);
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
        color: Theme.of(context).colorScheme.surface,
      ),
      iconStyleData: const IconStyleData(
        iconSize: 24,
      ),
      buttonStyleData: const ButtonStyleData(
        height: 50,
        width: 50,
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
