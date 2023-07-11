
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import '../../cubit/cubit.dart';
import '../../shared/widgets/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../azkar/models/all_azkar.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../books/cubit/books_cubit.dart';
import '../../books/model/books_model.dart';
import '../../books/screen/books_view.dart';
import '../../quran_azkar/cubit/quran_azkar_cubit.dart';
import '../../quran_azkar/quran_azkar_model.dart';
import '../../quran_azkar/screen/quran_azkar_view.dart';
import '../style.dart';

Widget quranAzkarBuild(BuildContext context) {
  return BlocBuilder<QuranAzkarCubit, List<Surah>>(
    builder: (context, surahs) {
      return AnimationLimiter(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            borderRadius: const BorderRadius.all(Radius.circular(8))
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
  );
}

Widget hisnListBuild(BuildContext context) {
  return AnimationLimiter(
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        controller: QuranCubit.get(context).controller,
        itemCount: azkarDataList.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => const Divider(),
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
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
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

Widget booksBuild(BuildContext context) {
  ColorStyle style = ColorStyle(context);
  Future<List<Class>> classesFuture = context.read<BooksCubit>().getClasses();
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    decoration: const BoxDecoration(
      // color: Theme.of(context).colorScheme.surface,
    ),
    child: FutureBuilder<List<Class>>(
      future: classesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Class>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        } else {
          var classes = snapshot.data;

          return AnimationLimiter(
            child: ListView.separated(
              itemCount: classes!.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: (index % 2 == 0
                        ? Theme.of(context).canvasColor
                        .withOpacity(.6)
                        : Theme.of(context)
                        .colorScheme.background),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    columnCount: 3,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Text(
                          classes[index].title,
                          style: TextStyle(
                              color: style.greenTextColor(),
                              fontFamily: 'naskh',
                              fontSize: 24,
                              height: 1.5
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  context
                      .read<BooksCubit>()
                      .selectClass(classes[index]);
                  screenModalBottomSheet(context, BooksView());
                },
              ),
            ),
          );
        }
      },
    ),
  );
}
