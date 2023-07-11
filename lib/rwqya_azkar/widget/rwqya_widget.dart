import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../azkar/cubit/azkar_cubit.dart';
import '../../azkar/models/azkar.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/share/ayah_to_images.dart';
import '../../shared/widgets/widgets.dart';
import '../cubit/rwqya_cubit.dart';
import '../model/rwqya_model.dart';


class RwqyaList extends StatefulWidget {
  @override
  State<RwqyaList> createState() => _RwqyaListState();
}

class _RwqyaListState extends State<RwqyaList> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: orientation(
            context,
            Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter, child: customClose(context)),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 50.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fontSizeDropDown(context, setState),
                          Container(
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.5),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            // child: surah_name(
                            //     context, widget.surah.surah),
                          ),
                        ],
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: rwqyaBuild(context),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Align(alignment: Alignment.topRight, child: customClose(context)),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          fontSizeDropDown(context, setState),
                          Container(
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.5),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            // child: surah_name(
                            //     context, widget.surah.surah),
                          ),
                        ],
                      )),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1 / 2 * .9,
                    child: rwqyaBuild(context),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget rwqyaBuild(BuildContext context) {
    return BlocBuilder<RwqyaCubit, List<Rwqya>>(
        builder: (context, rwqyaList) {
      return ListView.builder(
        itemCount: rwqyaList.length,
        itemBuilder: (context, index) {
          final rwqya = rwqyaList[index];
          return Container(
            width: orientation(
                context,
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.width * .48),
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme.surface
                    .withOpacity(.2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color:
                          Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        rwqya.zekr,
                        style: TextStyle(
                            color:
                            ThemeProvider.themeOf(context).id ==
                                'dark'
                                ? Colors.white
                                : Colors.black,
                            height: 1.4,
                            fontFamily: 'naskh',
                            fontSize: AzkarItem.fontSizeAzkar),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme.surface
                                  .withOpacity(.2),
                              border: Border.symmetric(
                                  vertical: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme.surface,
                                      width: 2))),
                          child: Text(
                            rwqya.reference,
                            style: TextStyle(
                                color:
                                ThemeProvider.themeOf(context)
                                    .id ==
                                    'dark'
                                    ? Colors.white
                                    : Theme.of(context)
                                    .primaryColorDark,
                                fontSize: 12,
                                fontFamily: 'kufi',
                                fontStyle: FontStyle.italic),
                          ))),
                ),
                rwqya.description == ''
                    ? Container()
                    : Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme.surface
                                .withOpacity(.2),
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme.surface,
                                    width: 2))),
                        child: Text(
                          rwqya.description,
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context)
                                  .id ==
                                  'dark'
                                  ? Colors.white
                                  : Theme.of(context)
                                  .primaryColorDark,
                              fontSize: 16,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic),
                        ))),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme.surface
                            .withOpacity(.2),
                        border: Border.symmetric(
                            vertical: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme.surface,
                                width: 2))),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showVerseOptionsBottomSheet(context,
                                    rwqya.zekr, rwqya.category,
                                    rwqya.description, ' التكرار:  ${rwqya.count} ', rwqya.reference);
                                // Share.share('${azkar.category}\n\n'
                                //     '${azkar.zekr}\n\n'
                                //     '| ${azkar.description}. | (التكرار: ${azkar.count})');
                              },
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(context)
                                    .colorScheme.surface,
                                size: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                FlutterClipboard.copy(
                                    '${rwqya.category}\n\n'
                                        '${rwqya.zekr}\n\n'
                                        '| ${rwqya.description}. | (التكرار: ${rwqya.count})')
                                    .then((value) => customSnackBar(
                                    context,
                                    AppLocalizations.of(context)!.copyAzkarText));
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Theme.of(context)
                                    .colorScheme.surface,
                                size: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final rwqyaCubit = context.read<AzkarCubit>();
                                await rwqyaCubit.addAzkar(Azkar(
                                    rwqya.id,
                                    rwqya.category,
                                    rwqya.count,
                                    rwqya.description,
                                    rwqya.reference,
                                    rwqya.zekr
                                )).then((value) => customSnackBar(
                                    context,
                                    AppLocalizations.of(context)!.addZekrBookmark));
                              },
                              icon: Icon(
                                Icons.bookmark_add,
                                color: Theme.of(context)
                                    .colorScheme.surface,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color:
                            Theme.of(context).colorScheme.surface,
                          ),
                          child: Row(
                            children: [
                              Text(
                                rwqya.count,
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 14,
                                    fontFamily: 'kufi',
                                    fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.repeat,
                                color: Theme.of(context).canvasColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
