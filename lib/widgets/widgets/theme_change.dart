import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_themes.dart';
import '../../l10n/app_localizations.dart';
import '../lists.dart';

class ThemeChange extends StatelessWidget {
  const ThemeChange({Key? key}) : super(key: key);

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
      child: GetBuilder<ThemeController>(
          init: ThemeController.instance,
          builder: (controller) => ListView.builder(
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
                                  color: ThemeController
                                              .instance.currentThemeId.value ==
                                          themeName[index]
                                      ? const Color(0xff91a57d)
                                      : Theme.of(context).secondaryHeaderColor,
                                  width: 1.5.w),
                              color: const Color(0xff39412a),
                            ),
                            child:
                                ThemeController.instance.currentThemeId.value ==
                                        themeName[index]
                                    ? Icon(Icons.done,
                                        size: 10.h,
                                        color: const Color(0xffF27127))
                                    : null,
                          ),
                          SizedBox(
                            width: 16.0.w,
                          ),
                          Text(
                            '${themeTitle[index]}',
                            style: TextStyle(
                              color: ThemeController
                                          .instance.currentThemeId.value ==
                                      themeName[index]
                                  ? const Color(0xffF27127)
                                  : Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha: .5),
                              fontSize: 12.sp,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      ThemeController.instance.changeTheme(themeName[index]);
                    },
                  ))),
    );
  }
}
