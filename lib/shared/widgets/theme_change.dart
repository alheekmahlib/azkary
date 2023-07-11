import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../lists.dart';

class ThemeChange extends StatefulWidget {
  const ThemeChange({Key? key}) : super(key: key);

  @override
  State<ThemeChange> createState() => _ThemeChangeState();
}

class _ThemeChangeState extends State<ThemeChange> {

  @override
  Widget build(BuildContext context) {
    List<String> themeTitle = <String>[
      '${AppLocalizations.of(context)!.green}',
      '${AppLocalizations.of(context)!.blue}',
      '${AppLocalizations.of(context)!.dark}',
    ];
    return Container(
      height: 90,
      child: ListView.builder(
        itemCount: 3,
          itemBuilder: (context, index) => InkWell(
            child: SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                      border:
                      Border.all(color: ThemeProvider.themeOf(context).id == themeName[index]
                          ? const Color(0xff91a57d) : Theme.of(context)
                          .secondaryHeaderColor, width: 2),
                      color: const Color(0xff39412a),
                    ),
                    child: ThemeProvider.themeOf(context).id == themeName[index]
                        ? const Icon(Icons.done,
                        size: 14, color: Color(0xffF27127))
                        : null,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    '${themeTitle[index]}',
                    style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == themeName[index]
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
              ThemeProvider.controllerOf(context).setTheme(themeName[index]);
            },
          )),
    );
  }
}
