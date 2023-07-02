import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:husn_al_muslim/quran_azkar/screen/quran_azkar_view.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/quran_azkar_cubit.dart';
import '../quran_azkar_model.dart';

class QuranAzkarList extends StatelessWidget {
  final String title;
  const QuranAzkarList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.all(
              Radius.circular(8.0))
      ),
        child: orientation(context,
            Stack(
          children: [
            Opacity(
              opacity: .1,
              child: book_cover(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 180.0),
                child: BlocBuilder<QuranAzkarCubit, List<Surah>>(
                  builder: (context, surahs) {
                    return AnimationLimiter(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.all(
                                Radius.circular(8.0))
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 6.5,
                            crossAxisSpacing: 6.5,
                            childAspectRatio: 1.5,),
                          itemCount: surahs.length,
                          itemBuilder: (context, index) {
                            final surah = surahs[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 450),
                              columnCount: 3,
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    child: Container(
                                      height: 80,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/svg/surah_name/00${index + 1}.svg",
                                        colorFilter: ColorFilter.mode(
                                            ThemeProvider.themeOf(context).id ==
                                                'dark'
                                                ? Theme.of(context)
                                                .canvasColor
                                                : Theme.of(context).primaryColorDark,
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                    onTap: () => screenModalBottomSheet(
                                        context, QuranAzkarView(surah: surah)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: customClose(context),
            ),
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
                      offset: Offset(0, 15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(title,
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
              child: BlocBuilder<QuranAzkarCubit, List<Surah>>(
                builder: (context, surahs) {
                  return AnimationLimiter(
                    child: Container(
                      width: MediaQuery.of(context).size.width /1/2 *.9,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.all(
                              Radius.circular(8.0))
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 6.5,
                          crossAxisSpacing: 6.5,
                          childAspectRatio: 1.5,),
                        itemCount: surahs.length,
                        itemBuilder: (context, index) {
                          final surah = surahs[index];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 450),
                            columnCount: 3,
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  child: Container(
                                    height: 80,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/svg/surah_name/00${index + 1}.svg",
                                      colorFilter: ColorFilter.mode(
                                          ThemeProvider.themeOf(context).id ==
                                              'dark'
                                              ? Theme.of(context)
                                              .canvasColor
                                              : Theme.of(context).primaryColorDark,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                  onTap: () => screenModalBottomSheet(
                                      context, QuranAzkarView(surah: surah)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customClose(context),
              ),
            ),
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
                        child: Text(title,
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
        ))
      ),
    );
  }
}
