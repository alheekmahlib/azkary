import '../../shared/widgets/svg_picture.dart';
import '../../shared/widgets/theme_change.dart';
import '../../shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../myApp.dart';


class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      // direction: Axis.vertical,
      children: [
        Center(
          child: spaceLine(30, MediaQuery.of(context).size.width * 3 / 4,),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: contentContainer(
            context,
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/line.svg',
                        height: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .langChange,
                        style: TextStyle(
                            color: Theme.of(context)
                                .canvasColor,
                            fontFamily: 'kufi',
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      ),
                      SvgPicture.asset(
                        'assets/svg/line2.svg',
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        child: SizedBox(
                          height: 30,
                          width:
                          MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(2.0)),
                                  border: Border.all(
                                      color: AppLocalizations.of(
                                          context)!
                                          .appLang ==
                                          "لغة التطبيق"
                                          ? const Color(0xff91a57d) : Theme.of(context)
                                          .secondaryHeaderColor,
                                      width: 2),
                                  color:
                                  const Color(0xff39412a),
                                ),
                                child: AppLocalizations.of(
                                    context)!
                                    .appLang ==
                                    "لغة التطبيق"
                                    ? const Icon(Icons.done,
                                    size: 14,
                                    color: Color(0xffF27127))
                                    : null,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                'العربية',
                                style: TextStyle(
                                  color: AppLocalizations.of(
                                      context)!
                                      .appLang ==
                                      "لغة التطبيق"
                                      ? const Color(0xffF27127)
                                      : Theme.of(context)
                                      .colorScheme.surface
                                      .withOpacity(.5),
                                  fontSize: 14,
                                  fontFamily: 'kufi',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          MyApp.of(context)!.setLocale(
                              const Locale.fromSubtags(
                                  languageCode: "ar"));
                        },
                      ),
                      InkWell(
                        child: SizedBox(
                          height: 30,
                          width:
                          MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(2.0)),
                                  border: Border.all(
                                      color: AppLocalizations.of(
                                          context)!
                                          .appLang ==
                                          "App Language"
                                          ? Theme.of(context)
                                          .secondaryHeaderColor
                                          : Theme.of(context)
                                          .colorScheme.surface
                                          .withOpacity(.5),
                                      width: 2),
                                  color:
                                  const Color(0xff39412a),
                                ),
                                child: AppLocalizations.of(
                                    context)!
                                    .appLang ==
                                    "App Language"
                                    ? Icon(Icons.done,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme.surface)
                                    : null,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                'English',
                                style: TextStyle(
                                  color: AppLocalizations.of(
                                      context)!
                                      .appLang ==
                                      "App Language"
                                      ? Theme.of(context)
                                      .secondaryHeaderColor
                                      : Theme.of(context)
                                      .colorScheme.surface
                                      .withOpacity(.5),
                                  fontSize: 14,
                                  fontFamily: 'kufi',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          MyApp.of(context)!.setLocale(
                              const Locale.fromSubtags(
                                  languageCode: "en"));
                        },
                      ),
                      InkWell(
                        child: SizedBox(
                          height: 30,
                          width:
                          MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(2.0)),
                                  border: Border.all(
                                      color: AppLocalizations.of(
                                          context)!
                                          .appLang ==
                                          "Idioma de la aplicación"
                                          ? Theme.of(context)
                                          .secondaryHeaderColor
                                          : Theme.of(context)
                                          .colorScheme.surface
                                          .withOpacity(.5),
                                      width: 2),
                                  color:
                                  const Color(0xff39412a),
                                ),
                                child: AppLocalizations.of(
                                    context)!
                                    .appLang ==
                                    "Idioma de la aplicación"
                                    ? Icon(Icons.done,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme.surface)
                                    : null,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                'Español',
                                style: TextStyle(
                                  color: AppLocalizations.of(
                                      context)!
                                      .appLang ==
                                      "Idioma de la aplicación"
                                      ? Theme.of(context)
                                      .secondaryHeaderColor
                                      : Theme.of(context)
                                      .colorScheme.surface
                                      .withOpacity(.5),
                                  fontSize: 14,
                                  fontFamily: 'kufi',
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          MyApp.of(context)!.setLocale(
                              const Locale.fromSubtags(
                                  languageCode: "es"));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: contentContainer(
            context,
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/line.svg',
                        height: 15,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .themeTitle,
                        style: TextStyle(
                            color: Theme.of(context)
                                .canvasColor,
                            fontFamily: 'kufi',
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      ),
                      SvgPicture.asset(
                        'assets/svg/line2.svg',
                        height: 15,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ThemeChange(),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: spaceLine(30, MediaQuery.of(context).size.width * 3 / 4,),
        ),
      ],
    );
  }
}
