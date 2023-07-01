import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../model/books_model.dart';
import '../cubit/books_cubit.dart';
import 'books_view.dart';

class BooksPage extends StatelessWidget {
  final String title;
  const BooksPage({super.key, required this.title});


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: orientation(
              context,
              Stack(
                children: [
                  Opacity(
                    opacity: .1,
                    child: book_cover(),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: bookCard(context),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: customClose3(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200.0),
                      child: booksBuild(context),
                    ),
                  ),
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
                    child: booksBuild(context),
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
                              child: Text(
                                title,
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
              ))),
    );
  }

  Widget bookCard(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 210,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(
          Radius.circular(8)
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              'مقتبس من كتاب الطب النبوي (جزء من كتاب زاد المعاد لابن القيم -رحمه الله-)',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'naskh',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).canvasColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
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
                    child: Text(
                      title,
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
    );
  }

  Widget booksBuild(BuildContext context) {
    Future<List<Class>> classesFuture = context.read<BooksCubit>().getClasses();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            color: Colors.grey,
            blurRadius: 5
          )
        ]
      ),
      child: FutureBuilder<List<Class>>(
        future: classesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Class>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else {
            var classes = snapshot.data;

            return AnimationLimiter(
              child: ListView.separated(
                itemCount: classes!.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => GestureDetector(
                  child: Container(
                    // decoration: BoxDecoration(
                    //     color: Theme.of(context).colorScheme.surface,
                    //     borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    // padding: EdgeInsets.all(8.0),
                    // margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
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
                                color: Theme.of(context).primaryColorDark,
                                fontFamily: 'naskh',
                                fontSize: 20,
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
}
