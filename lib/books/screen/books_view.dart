import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/style.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../azkar/screens/azkar_item.dart';
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
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
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
                ],
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: booksView(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          customClose(context),
                          fontSizeDropDown(context, setState),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget booksView(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return BlocBuilder<BooksCubit, BooksState>(
      builder: (context, state) {
        if (state is ClassSelected) {
          return ListView.builder(
            itemCount: state.selectedClass.pages.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SelectableText.rich(
                    TextSpan(children: [
                      WidgetSpan(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          state.selectedClass.pages[index].title == ''
                              ? Container()
                              : greenContainer(
                                  context,
                                  80.0,
                                  Container(
                                    alignment: Alignment.center,
                                    // width: 270,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                      state.selectedClass.pages[index].title,
                                      style: TextStyle(
                                        color: colorStyle.whiteTextColor(),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'naskh',
                                          height: 1.5
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            width: MediaQuery.of(context).size.width,
                          ),
                          const Divider(),
                        ],
                      )),
                      TextSpan(
                        text: state.selectedClass.pages[index].text,
                        style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == 'dark'
                                ? Colors.white
                                : Theme.of(context).primaryColorDark,
                            fontSize: AzkarItem.fontSizeAzkar,
                            fontFamily: 'naskh',
                            fontStyle: FontStyle.italic),
                      ),
                      WidgetSpan(
                          child: Column(
                        children: [
                          state.selectedClass.pages[index].footnote == ''
                              ? Container()
                              : Column(
                                  children: [
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                      child: Text(
                                        state.selectedClass.pages[index].footnote,
                                        style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context).id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColorDark,
                                            fontSize: 20,
                                            fontFamily: 'naskh',
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                ),
                          const Divider(),
                        ],
                      ))
                    ]),
                    textAlign: TextAlign.justify,
                    showCursor: true,
                    cursorWidth: 3,
                    cursorColor: Theme.of(context).dividerColor,
                    cursorRadius: const Radius.circular(5),
                    scrollPhysics: const ClampingScrollPhysics(),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      state.selectedClass.pages[index].pageNumber,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 18,
                        fontFamily: 'kufi',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No class selected!'));
        }
      },
    );
  }
}
