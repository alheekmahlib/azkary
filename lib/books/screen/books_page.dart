import 'package:flutter/material.dart';
import '../../shared/widgets/widgets.dart';

class BooksPage extends StatelessWidget {
  final String title;
  final String details;
  final Widget myWidget;
  const BooksPage(
      {super.key,
      required this.title,
      required this.details,
      required this.myWidget});

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
                    alignment: Alignment.topCenter,
                    child: bookCard(context),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: customClose(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 240.0),
                      child: myWidget,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customClose(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1 / 2 * .6,
                        child: bookCard(context)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1 / 2 * .8,
                        child: myWidget),
                  ),
                ],
              ))),
    );
  }

  Widget bookCard(BuildContext context) {
    return borderRadiusContainer(
      context,
      true,
      title,
      details,
      height: orientation(context, 240.0, 350.0),
      width: MediaQuery.of(context).size.width,
    );
  }
}
