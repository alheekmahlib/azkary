import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../books/screen/books_page.dart';
import '../widgets/lists.dart';
import '../widgets/widgets/books_widget.dart';
import '../widgets/widgets/hisn_list_widget.dart';
import '../widgets/widgets/quran_azkar_widget.dart';
import '../widgets/widgets/svg_picture.dart';
import '../widgets/widgets/widgets.dart';

class AzkarList extends StatelessWidget {
  const AzkarList({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0).r,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: booksList(context),
          ),
        ),
      ),
    );
  }
}

Widget booksList(BuildContext context) {
  bool screenWidth = MediaQuery.sizeOf(context).width < 700;
  return SingleChildScrollView(
    child: orientation(
        context,
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: bookBanner(context),
            ),
            book(
              context,
              booksDetails[0].title,
              BooksPage(
                title: booksDetails[0].title,
                details: booksDetails[0].details,
                myWidget: const QuranAzkarWidget(),
              ),
            ),
            book(
              context,
              booksDetails[1].title,
              BooksPage(
                title: booksDetails[1].title,
                details: booksDetails[1].details,
                myWidget: const HisnListWidget(),
              ),
            ),
            book(
              context,
              booksDetails[2].title,
              BooksPage(
                title: booksDetails[2].title,
                details: booksDetails[2].details,
                myWidget: const BooksWidget(),
              ),
            ),
          ],
        ),
        screenWidth
            ? Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: bookBanner(context),
                  ),
                  book(
                    context,
                    booksDetails[0].title,
                    BooksPage(
                      title: booksDetails[0].title,
                      details: booksDetails[0].details,
                      myWidget: const QuranAzkarWidget(),
                    ),
                  ),
                  book(
                    context,
                    booksDetails[1].title,
                    BooksPage(
                      title: booksDetails[1].title,
                      details: booksDetails[1].details,
                      myWidget: const HisnListWidget(),
                    ),
                  ),
                  book(
                    context,
                    booksDetails[2].title,
                    BooksPage(
                      title: booksDetails[2].title,
                      details: booksDetails[2].details,
                      myWidget: const BooksWidget(),
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: bookBanner(context),
                  ),
                  Expanded(
                    // alignment: platformView(Alignment.centerLeft, Alignment.center),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        book(
                          context,
                          booksDetails[0].title,
                          BooksPage(
                            title: booksDetails[0].title,
                            details: booksDetails[0].details,
                            myWidget: const QuranAzkarWidget(),
                          ),
                        ),
                        book(
                          context,
                          booksDetails[1].title,
                          BooksPage(
                            title: booksDetails[1].title,
                            details: booksDetails[1].details,
                            myWidget: const HisnListWidget(),
                          ),
                        ),
                        book(
                          context,
                          booksDetails[2].title,
                          BooksPage(
                            title: booksDetails[2].title,
                            details: booksDetails[2].details,
                            myWidget: const BooksWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
  );
}

Widget book(BuildContext context, String title, var widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: GestureDetector(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 80.h,
            width: 100.h,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(8)).r),
          ),
          Container(
            height: 100.h,
            width: 60.h,
            margin: const EdgeInsets.all(16.0).r,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color:
                      Theme.of(context).primaryColorDark.withValues(alpha: .5),
                  offset: const Offset(0, 10),
                  blurRadius: 10)
            ]),
            child: Stack(
              alignment: Alignment.center,
              children: [
                book_cover(),
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0).r,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 11.sp,
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
        ],
      ),
      onTap: () {
        screenModalBottomSheet(context, widget);
      },
    ),
  );
}

Widget bookBanner(BuildContext context) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 150.0.h,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 7),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enlargeFactor: 0.3,
      scrollDirection: Axis.horizontal,
    ),
    items: booksDetails.map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: container(context, Container(), false,
                    height: 100.0.h,
                    width: MediaQuery.sizeOf(context).width,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Container(
                          height: 180.w,
                          width: orientation(context, 150.w, 90.w),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(16.0),
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Text(
                            i.details,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'naskh',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )),
                    Container(
                      height: 110.h,
                      width: 70.h,
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withValues(alpha: .5),
                            offset: const Offset(0, 10),
                            blurRadius: 10)
                      ]),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          book_cover(),
                          Transform.translate(
                            offset: const Offset(0, 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                i.title,
                                style: TextStyle(
                                  fontSize: 12.sp,
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
                  ],
                ),
              ),
            ],
          );
        },
      );
    }).toList(),
  );
}
