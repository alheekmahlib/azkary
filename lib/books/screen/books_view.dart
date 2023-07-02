import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../azkar/screens/azkar_item.dart';
import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/books_cubit.dart';

class BooksView extends StatefulWidget {
  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: orientation(
              context,
              Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: booksView(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: customClose(context),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: fontSizeDropDown(context, setState),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: booksView(context),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customClose(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: fontSizeDropDown(context, setState),
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget booksView(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(
      builder: (context, state) {
        if (state is ClassSelected) {
          return ListView.builder(
            itemCount: state.selectedClass.pages.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SelectableText.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(child: Column(
                                children: [
                                  state.selectedClass.pages[index].title == ''
                                      ? Container()
                                      : Container(
                                    width: 350,
                                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                      state.selectedClass.pages[index].title,
                                      style: TextStyle(
                                        color: ThemeProvider.themeOf(context)
                                            .id ==
                                            'dark'
                                            ? Theme.of(context)
                                            .canvasColor
                                            : Theme.of(context)
                                            .primaryColorDark,
                                        fontSize: 20,
                                        fontFamily: 'naskh',
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Divider(),
                                ],
                              )),
                              TextSpan(
                                text: state.selectedClass.pages[index].text,
                                style: TextStyle(
                                    color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Colors.white
                                        : Theme.of(context).primaryColorDark,
                                    fontSize: AzkarItem.fontSizeAzkar,
                                    fontFamily: 'naskh',
                                    fontStyle: FontStyle.italic),
                              ),
                              WidgetSpan(child: Column(
                                children: [
                                  state.selectedClass.pages[index].footnote == ''
                                      ? Container()
                                      : Column(
                                    children: [
                                      Divider(),
                                      Text(
                                        state.selectedClass.pages[index].footnote,
                                        style: TextStyle(
                                            color:
                                            ThemeProvider.themeOf(context).id ==
                                                'dark'
                                                ? Colors.white
                                                : Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: AzkarItem.fontSizeAzkar,
                                            fontFamily: 'naskh',
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ))
                            ]
                          ),
                          textAlign: TextAlign.justify,
                          showCursor: true,
                          cursorWidth: 3,
                          cursorColor: Theme.of(context).dividerColor,
                          cursorRadius: const Radius.circular(5),
                          scrollPhysics: const ClampingScrollPhysics(),
                          textDirection: TextDirection.rtl,
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.selectedClass.pages[index].pageNumber,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 16,
                              fontFamily: 'kufi',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('No class selected!'));
        }
      },
    );
  }
}
