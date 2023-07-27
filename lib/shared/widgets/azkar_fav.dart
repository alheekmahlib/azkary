import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../azkar/cubit/azkar_cubit.dart';
import '../../azkar/models/azkar.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../l10n/app_localizations.dart';
import '../share/ayah_to_images.dart';
import '../style.dart';
import 'lottie.dart';
import 'svg_picture.dart';
import 'widgets.dart';

class AzkarFav extends StatelessWidget {
  AzkarFav({Key? key}) : super(key: key);

  static double fontSizeAzkar = 20;

  var controller = ScrollController();
  final double lowerValue = 18;
  final double upperValue = 40;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    context.read<AzkarCubit>().getAzkar();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              )),
          child: orientation(
              context,
              Column(
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
        ));
  }

  Widget fav_build(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        if (state is AzkarInitial) {
          return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: bookLoading(250.0, 250.0));
        } else if (state is AzkarError) {
          // Handle the error state here
          return const Text('Error occurred');
        } else if (state is AzkarLoaded) {
          if (state.azkarList.isEmpty) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: bookLoading(250.0.h, 250.0.h),
            );
          } else {
            return AnimationLimiter(
              child: SizedBox(
                width: orientation(context, MediaQuery.sizeOf(context).width,
                    MediaQuery.sizeOf(context).width * .48),
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
                                      horizontal: 16.0, vertical: 8.0)
                                  .r,
                              child: Dismissible(
                                background: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              border: Border.symmetric(
                                                vertical: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  width: 5.w,
                                                ),
                                              ),
                                            ),
                                            width: double.infinity,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8).r,
                                              child: Text(
                                                azkar.zekr!,
                                                style: TextStyle(
                                                    color: colorStyle
                                                        .greenTextColor(),
                                                    height: 1.4,
                                                    fontFamily: 'naskh',
                                                    fontSize: AzkarItem
                                                        .fontSizeAzkar),
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                          horizontal: 8)
                                                      .r,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                          horizontal: 8)
                                                      .r,
                                              decoration: BoxDecoration(
                                                  color:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                  border: Border.symmetric(
                                                      vertical: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          width: 5.w))),
                                              child: Text(
                                                azkar.reference!,
                                                style: TextStyle(
                                                    color: ThemeProvider
                                                                    .themeOf(
                                                                        context)
                                                                .id ==
                                                            'dark'
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColorDark,
                                                    fontSize: 12.sp,
                                                    fontFamily: 'kufi',
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )),
                                        ),
                                        azkar.description! == ''
                                            ? Container()
                                            : Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                            horizontal: 8)
                                                        .r,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                                horizontal: 8)
                                                            .r,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                        border: Border.symmetric(
                                                            vertical: BorderSide(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                width: 5.w))),
                                                    child: Text(
                                                      azkar.description!,
                                                      style: TextStyle(
                                                          color: ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Colors.white
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColorDark,
                                                          fontSize: 16.sp,
                                                          fontFamily: 'kufi',
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    )),
                                              ),
                                        Container(
                                          height: 30.h,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          margin: const EdgeInsets.symmetric(
                                                  horizontal: 8.0)
                                              .r,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          child: ClipRRect(
                                            child: Stack(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/svg/azkary.svg',
                                                  colorFilter: ColorFilter.mode(
                                                      Theme.of(context)
                                                          .canvasColor
                                                          .withOpacity(.05),
                                                      BlendMode.srcIn),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface
                                                          .withOpacity(.2),
                                                      border: Border.symmetric(
                                                          vertical: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .surface,
                                                              width: 2.w))),
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              showVerseOptionsBottomSheet(
                                                                  context,
                                                                  azkar.zekr!,
                                                                  azkar
                                                                      .category!,
                                                                  azkar
                                                                      .description,
                                                                  ' التكرار:  ${azkar.count} ',
                                                                  azkar
                                                                      .reference);
                                                              // Share.share('${azkar.category}\n\n'
                                                              //     '${azkar.zekr}\n\n'
                                                              //     '| ${azkar.description}. | (التكرار: ${azkar.count})');
                                                            },
                                                            icon: Icon(
                                                              Icons.share,
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
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
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .copyAzkarText));
                                                            },
                                                            icon: Icon(
                                                              Icons.copy,
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                              size: 18.h,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              final azkarCubit =
                                                                  context.read<
                                                                      AzkarCubit>();
                                                              await azkarCubit
                                                                  .addAzkar(Azkar(
                                                                      azkar.id,
                                                                      azkar
                                                                          .category,
                                                                      azkar.count ==
                                                                              ''
                                                                          ? ''
                                                                          : azkar
                                                                              .count,
                                                                      azkar.description ==
                                                                              ''
                                                                          ? ''
                                                                          : azkar
                                                                              .description,
                                                                      azkar
                                                                          .reference,
                                                                      azkar
                                                                          .zekr))
                                                                  .then((value) => customSnackBar(
                                                                      context,
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .addZekrBookmark));
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .bookmark_add,
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                              size: 18.h,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8,
                                                                vertical: 4)
                                                            .r,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8),
                                                          ).r,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              azkar.count!,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontFamily:
                                                                      'kufi',
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Icon(
                                                              Icons.repeat,
                                                              color: Theme.of(
                                                                      context)
                                                                  .canvasColor,
                                                              size: 18.h,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
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
        return Container();
      },
    );
  }
}
