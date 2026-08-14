part of '../books.dart';

class BooksView extends StatelessWidget {
  const BooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          margin: orientation(
              context, const EdgeInsets.only(top: 64), EdgeInsets.zero),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)).r),
          child: orientation(
              context,
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0).r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customClose(context),
                        fontSizeDropDown(
                            context, Theme.of(context).colorScheme.surface),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _booksView(context),
                  ),
                ],
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 48.0).r,
                      child: _booksView(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).r,
                      child: Column(
                        children: [
                          customClose(context),
                          fontSizeDropDown(
                              context, Theme.of(context).colorScheme.surface),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget _booksView(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);

    return GetBuilder<BooksController>(
      id: 'booksViewWidget',
      init: BooksController.instance,
      builder: (controller) {
        return Obx(() {
          // التحقق من وجود فئة مختارة - Check if class is selected
          if (controller.selectedClass.value != null) {
            final selectedClass = controller.selectedClass.value!;

            return Padding(
              padding: orientation(
                  context, EdgeInsets.zero, const EdgeInsets.only(top: 16.0).r),
              child: PageView.builder(
                  itemCount: selectedClass.pages.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: (index % 2 == 0
                          ? rightPage(
                              context,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0)
                                    .r,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(children: [
                                        WidgetSpan(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            selectedClass.pages[index].title ==
                                                    ''
                                                ? Container()
                                                : greenContainer(
                                                    context,
                                                    80.0,
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: 270,
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 32.0)
                                                          .r,
                                                      child: Text(
                                                        selectedClass
                                                            .pages[index].title,
                                                        style: TextStyle(
                                                            color: colorStyle
                                                                .whiteTextColor(),
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'naskh',
                                                            height: 1.5),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                  ),
                                            const Divider(),
                                          ],
                                        )),
                                        TextSpan(
                                          text: selectedClass.pages[index].text,
                                          style: TextStyle(
                                            color: colorStyle.greenTextColor(),
                                            fontSize: AzkarItem.fontSizeAzkar,
                                            fontFamily: 'naskh',
                                          ),
                                        ),
                                        WidgetSpan(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            selectedClass.pages[index]
                                                        .footnote ==
                                                    ''
                                                ? Container()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Divider(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    32.0),
                                                        child: Text(
                                                          selectedClass
                                                              .pages[index]
                                                              .footnote,
                                                          style: TextStyle(
                                                            color: colorStyle
                                                                .greenTextColor()
                                                                .withValues(
                                                                    alpha: .7),
                                                            fontSize: 20,
                                                            fontFamily: 'naskh',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            const Divider(),
                                          ],
                                        ))
                                      ]),
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.visible,
                                      // showCursor: true,
                                      // cursorWidth: 3,
                                      // cursorColor: Theme.of(context).dividerColor,
                                      // cursorRadius: const Radius.circular(5),
                                      // scrollPhysics: const ClampingScrollPhysics(),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32.0),
                                        child: Text(
                                          selectedClass.pages[index].pageNumber,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            fontSize: 18,
                                            fontFamily: 'kufi',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : leftPage(
                              context,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0)
                                    .r,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text.rich(
                                      TextSpan(children: [
                                        WidgetSpan(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            selectedClass.pages[index].title ==
                                                    ''
                                                ? Container()
                                                : greenContainer(
                                                    context,
                                                    80.0,
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: 270,
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 32.0)
                                                          .r,
                                                      child: Text(
                                                        selectedClass
                                                            .pages[index].title,
                                                        style: TextStyle(
                                                            color: colorStyle
                                                                .whiteTextColor(),
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'naskh',
                                                            height: 1.5),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                  ),
                                            const Divider(),
                                          ],
                                        )),
                                        TextSpan(
                                          text: selectedClass.pages[index].text,
                                          style: TextStyle(
                                              color:
                                                  colorStyle.greenTextColor(),
                                              fontSize: AzkarItem.fontSizeAzkar,
                                              fontFamily: 'naskh',
                                              fontStyle: FontStyle.italic),
                                        ),
                                        WidgetSpan(
                                            child: Column(
                                          children: [
                                            selectedClass.pages[index]
                                                        .footnote ==
                                                    ''
                                                ? Container()
                                                : Column(
                                                    children: [
                                                      const Divider(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    32.0),
                                                        child: Text(
                                                          selectedClass
                                                              .pages[index]
                                                              .footnote,
                                                          style: TextStyle(
                                                              color: colorStyle
                                                                  .greenTextColor()
                                                                  .withValues(
                                                                      alpha:
                                                                          .7),
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'naskh',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            const Divider(),
                                          ],
                                        ))
                                      ]),
                                      textAlign: TextAlign.justify,
                                      // showCursor: true,
                                      // cursorWidth: 3,
                                      // cursorColor: Theme.of(context).dividerColor,
                                      // cursorRadius: const Radius.circular(5),
                                      // scrollPhysics: const ClampingScrollPhysics(),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32.0),
                                        child: Text(
                                          selectedClass.pages[index].pageNumber,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            fontSize: 18,
                                            fontFamily: 'kufi',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    );
                  }),
            );
          } else {
            // حالة عدم وجود فئة مختارة - No class selected state
            return Center(child: bookLoading(200.0.r, 200.0.r));
          }
        });
      },
    );
  }
}
