import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../books/screen/books_page.dart';
import '../books/cubit/books_cubit.dart';
import '../shared/lists.dart';
import '../shared/widgets/books_lists_widgets.dart';
import '../shared/widgets/svg_picture.dart';
import '../shared/widgets/widgets.dart';

class AzkarList extends StatefulWidget {
  const AzkarList({super.key});

  @override
  State<AzkarList> createState() => _AzkarListState();
}

class _AzkarListState extends State<AzkarList> {

  BooksCubit? booksCubit;

  @override
  void initState() {
    BooksCubit.get(context).pageController = PageController(initialPage: BooksCubit.get(context).currentPage);
    context.read<BooksCubit>().getClasses();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    booksCubit ??= BooksCubit.get(context);
  }

  @override
  void dispose() {
    booksCubit?.pageController?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: booksList(context, booksCubit!),
            ),
          ),
        ),
      ),
    );
  }

  Widget booksList(BuildContext context, BooksCubit booksCubit) {
    return SingleChildScrollView(
      child: orientation(context,
          Wrap(
        alignment: WrapAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                ),
                child: greeting(context)),
          ),
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
              myWidget: quranAzkarBuild(context),
            ),
          ),
          book(
            context,
            booksDetails[1].title,
            BooksPage(
              title: booksDetails[1].title,
              details: booksDetails[1].details,
              myWidget: hisnListBuild(context),
            ),
          ),
          book(
            context,
            booksDetails[2].title,
            BooksPage(
              title: booksDetails[2].title,
              details: booksDetails[2].details,
              myWidget: booksBuild(context),
            ),
          ),
        ],
      ),
          Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                ),
                child: greeting(context)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: platformView(MediaQuery.of(context).size.width / 1/2 * .8, MediaQuery.of(context).size.width),
              margin: const EdgeInsets.only(top: 64),
              child: bookBanner(context),
            ),
          ),
          Align(
            alignment: platformView(Alignment.centerLeft, Alignment.center),
            child: Container(
              width: platformView(MediaQuery.of(context).size.width / 1/2 * .8, MediaQuery.of(context).size.width),
              padding: platformView(const EdgeInsets.only(top: 64.0), const EdgeInsets.only(top: 250.0)),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  book(
                    context,
                    booksDetails[0].title,
                    BooksPage(
                      title: booksDetails[0].title,
                      details: booksDetails[0].details,
                      myWidget: quranAzkarBuild(context),
                    ),
                  ),
                  book(
                    context,
                    booksDetails[1].title,
                    BooksPage(
                      title: booksDetails[1].title,
                      details: booksDetails[1].details,
                      myWidget: hisnListBuild(context),
                    ),
                  ),
                  book(
                    context,
                    booksDetails[2].title,
                    BooksPage(
                      title: booksDetails[2].title,
                      details: booksDetails[2].details,
                      myWidget: booksBuild(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

Widget book(BuildContext context, String title, var widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: GestureDetector(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 130,
            width: 150,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(8))
            ),
          ),
          Container(
            height: 150,
            width: 95,
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColorDark.withOpacity(.5),
                      offset: const Offset(0, 10),
                      blurRadius: 10
                  )
                ]
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                book_cover(),
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
      height: 170.0,
      aspectRatio: 16/9,
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
                child: container(
                  context,
                  Container(),
                  false,
                  height: 130.0,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 150,
                  width: 95,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).primaryColorDark.withOpacity(.5),
                            offset: const Offset(0, 10),
                            blurRadius: 10
                        )
                      ]
                  ),
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
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Transform.translate(
                  offset: const Offset(0, 10),
                  child: Container(
                    width: 170,
                    margin: const EdgeInsets.all(16.0),
                    child: Text(
                      i.details,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'naskh',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              )
            ],
          );
          // return bookBanner(
          //   context,
          //   i.title,
          //   i.details,
          // );
        },
      );
    }).toList(),
  );
  // return Stack(
  //   // alignment: Alignment.bottomCenter,
  //   children: [
  //     Align(
  //       alignment: Alignment.bottomCenter,
  //       child: container(
  //         context,
  //         Container(),
  //         false,
  //         height: 130.0,
  //         width: MediaQuery.of(context).size.width,
  //       ),
  //     ),
  //     Align(
  //       alignment: Alignment.topLeft,
  //       child: Container(
  //         height: 150,
  //         width: 95,
  //         margin: EdgeInsets.all(16.0),
  //         decoration: BoxDecoration(
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Theme.of(context).primaryColorDark.withOpacity(.5),
  //                   offset: Offset(0, 10),
  //                   blurRadius: 10
  //               )
  //             ]
  //         ),
  //         child: Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             book_cover(),
  //             Transform.translate(
  //               offset: Offset(0, 10),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Text(title,
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontFamily: 'kufi',
  //                     fontWeight: FontWeight.bold,
  //                     color: Theme.of(context).canvasColor,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //     Align(
  //       alignment: Alignment.centerRight,
  //       child: Transform.translate(
  //         offset: Offset(0, 10),
  //         child: Container(
  //           width: 170,
  //           margin: EdgeInsets.all(16.0),
  //           child: Text(
  //             details,
  //             style: TextStyle(
  //               fontSize: 16,
  //               fontFamily: 'naskh',
  //               fontWeight: FontWeight.bold,
  //               color: Theme.of(context).colorScheme.surface,
  //             ),
  //             textAlign: TextAlign.right,
  //           ),
  //         ),
  //       ),
  //     )
  //   ],
  // );
}
