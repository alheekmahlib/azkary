import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../cubit/cubit.dart';
import '../../shared/lists.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../models/all_azkar.dart';
import 'azkar_fav.dart';
import 'azkar_item.dart';



class AzkarView extends StatefulWidget {
  final String title;
  const AzkarView({Key? key, required this.title}) : super(key: key);

  @override
  State<AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<AzkarView> {
  var controller = ScrollController();

  @override
  void initState() {
    QuranCubit.get(context).loadAzkarFontSize();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: orientation(context,
            Stack(
              children: [
                Opacity(
                  opacity: .1,
                  child: book_cover(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 180.0),
                  child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: tabBar(context),
                        ),
                      )),
                Align(
                    alignment: Alignment.topRight,
                    child: customClose(context)),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 155,
                    width: 100,
                    margin: EdgeInsets.all(16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        book_cover(),
                        Transform.translate(
                          offset: Offset(0, 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).canvasColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Opacity(
                  opacity: .1,
                  child: book_cover(),
                ),
                Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1/2 * .9,
                        child: tabBar(context),
                      ),
                    ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customClose(context),
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 140,
                    width: 100,
                    margin: EdgeInsets.all(64.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        book_cover(),
                        Transform.translate(
                          offset: Offset(0, 25),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).canvasColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
        )
      ),
    );
  }
  Widget tabBar(BuildContext context) {
    return AnimationLimiter(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.all(
                Radius.circular(8.0))
        ),
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          controller: controller,
          itemCount: azkarDataList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 450),
                child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: index == 0
                                  ? const Radius.circular(8.0)
                                  : const Radius.circular(5.0),
                              topRight: index == 0
                                  ? const Radius.circular(8.0)
                                  : const Radius.circular(5.0),
                              bottomLeft: index == azkarDataList.length - 1
                                  ? const Radius.circular(8.0)
                                  : const Radius.circular(5.0),
                              bottomRight: index == azkarDataList.length - 1
                                  ? const Radius.circular(8.0)
                                  : const Radius.circular(5.0),
                            ),
                            color: (index % 2 == 0
                                ? Theme.of(context).canvasColor
                                .withOpacity(.6)
                                : Theme.of(context)
                                .colorScheme.background),
                          ),
                          child: InkWell(
                            onTap: () {
                              screenModalBottomSheet(context, AzkarItem(
                                azkar: azkarDataList[index].toString().trim(),
                              ));
                              // Navigator.of(context).push(
                              //     animatRoute(AzkarItem(
                              //       azkar: azkarDataList[index].toString().trim(),
                              //     ),
                              //     ));
                            },
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      azkarDataList[index].toString(),
                                      style: TextStyle(
                                        color: ThemeProvider.themeOf(context).id ==
                                            'dark'
                                            ? Theme.of(context)
                                            .canvasColor
                                            : Theme.of(context).primaryColorDark,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'vexa',
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))));
          },
        ),
      ),
    );
  }
}