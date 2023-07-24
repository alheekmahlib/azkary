import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/widgets/svg_picture.dart';
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
              borderRadius: const BorderRadius.all(Radius.circular(8.0)).r),
          child: orientation(
              context,
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: bookCard(context),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 190.0).r,
                      child: myWidget,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: customClose(context),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).r,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.topRight,
                              child: customClose(context)),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0).r,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 140.h,
                                  width: 90.h,
                                  margin: const EdgeInsets.all(16.0).r,
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
                                              fontSize: 16.sp,
                                              fontFamily: 'kufi',
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(context).canvasColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 230.w,
                                  child: Text(
                                    details,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontFamily: 'naskh',
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: myWidget,
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
      height: 180.0,
      width: MediaQuery.sizeOf(context).width,
    );
  }

  Widget bookCardLand(BuildContext context) {
    return borderRadiusContainerLand(
      context,
      false,
      title,
      details,
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
    );
  }
}
