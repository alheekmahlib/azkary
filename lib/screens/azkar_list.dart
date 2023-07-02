import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:husn_al_muslim/azkar/screens/alzkar_view.dart';
import 'package:husn_al_muslim/books/screen/books_page.dart';
import '../books/cubit/books_cubit.dart';
import '../quran_azkar/screen/quran_azkar_list.dart';
import '../shared/lists.dart';
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

  void _pageListener() {
    BooksCubit booksCubit = BooksCubit.get(context);
    if (booksCubit.pageController!.page == booksCubit.numPages - 1) {
      booksCubit.pageController!.jumpToPage(0);
    }
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
    // BooksCubit booksCubit = BooksCubit.get(context);

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
              child: platformView(
                orientation(
                  context,
                  booksList(context, booksCubit!),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1 / 2 * .90,
                      child: booksList(context, booksCubit!),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1 / 2,
                    child: booksList(context, booksCubit!),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget booksList(BuildContext context, BooksCubit booksCubit) {
    void onPageChanged(int index) {
      if (index == booksCubit.currentPage) {
        // Avoid recursive call when the same page is selected
        return;
      }

      setState(() {
        booksCubit.currentPage = index;
      });

      if (booksCubit.currentPage == booksCubit.numPages - 1) {
        // Reached the last page, jump back to the first page
        booksCubit.pageController!.jumpToPage(0);
      } else if (booksCubit.currentPage == 0) {
        // Reached the first page, jump to the last page
        booksCubit.pageController!.jumpToPage(booksCubit.numPages - 1);
      }
    }


    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )
              ),
                child: greeting(context)),
          ),
          CarouselSlider(
            options: CarouselOptions(
                height: 170.0,
              aspectRatio: 16/9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 7),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
            items: booksDetails.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return bookBanner(
                    context,
                    i.title,
                    i.details,
                  );
                },
              );
            }).toList(),
          ),
          book(
            context,
            'الأذكار من القرآن',
            QuranAzkarList(title: 'الأذكار من القرآن'),
          ),
          book(
            context,
            'حصن المسلم',
            AzkarView(title: 'حصن المسلم'),
          ),
          book(
            context,
            'الطب النبوي',
            BooksPage(title: 'الطب النبوي'),
          ),
        ],
      ),
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
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
          ),
          Container(
            height: 150,
            width: 95,
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColorDark.withOpacity(.5),
                      offset: Offset(0, 10),
                      blurRadius: 10
                  )
                ]
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                book_cover(),
                Transform.translate(
                  offset: Offset(0, 10),
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

Widget bookBanner(BuildContext context, String title, details) {
  return Stack(
    // alignment: Alignment.bottomCenter,
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
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColorDark.withOpacity(.5),
                    offset: Offset(0, 10),
                    blurRadius: 10
                )
              ]
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              book_cover(),
              Transform.translate(
                offset: Offset(0, 10),
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
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Transform.translate(
          offset: Offset(0, 10),
          child: Container(
            width: 170,
            margin: EdgeInsets.all(16.0),
            child: Text(
              details,
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
}
