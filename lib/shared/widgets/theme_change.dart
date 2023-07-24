import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      height: 65.h,
      margin: const EdgeInsets.all(4.0).r,
      child: ListView.builder(
          itemCount: 3,
          shrinkWrap: false,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => InkWell(
                child: SizedBox(
                  height: 20.h,
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    children: [
                      Container(
                        height: 15.h,
                        width: 15.h,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2.0)),
                          border: Border.all(
                              color: ThemeProvider.themeOf(context).id ==
                                      themeName[index]
                                  ? const Color(0xff91a57d)
                                  : Theme.of(context).secondaryHeaderColor,
                              width: 1.5.w),
                          color: const Color(0xff39412a),
                        ),
                        child: ThemeProvider.themeOf(context).id ==
                                themeName[index]
                            ? Icon(Icons.done,
                                size: 10.h, color: const Color(0xffF27127))
                            : null,
                      ),
                      SizedBox(
                        width: 16.0.w,
                      ),
                      Text(
                        '${themeTitle[index]}',
                        style: TextStyle(
                          color: ThemeProvider.themeOf(context).id ==
                                  themeName[index]
                              ? const Color(0xffF27127)
                              : Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.5),
                          fontSize: 12.sp,
                          fontFamily: 'kufi',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  ThemeProvider.controllerOf(context)
                      .setTheme(themeName[index]);
                },
              )),
    );
  }
}
