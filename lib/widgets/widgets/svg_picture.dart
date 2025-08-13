import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/themes/app_themes.dart';

spaceLine(double height, double? width) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SvgPicture.asset(
      'assets/svg/space_line.svg',
      height: height,
      width: width,
    ),
  );
}

fav_azkar(BuildContext context, double? width, double? height) {
  return SvgPicture.asset('assets/svg/fav_azkar.svg',
      // colorFilter: ColorFilter.mode(
      //     Theme.of(context).colorScheme.surface, BlendMode.srcIn),
      width: width,
      height: height);
}

azkary_icon(BuildContext context, {double? width, double? height}) {
  return SvgPicture.asset('assets/svg/azkary.svg',
      width: width, height: height);
}

azkary_logo(BuildContext context, {double? width, double? height}) {
  return SvgPicture.asset('assets/svg/azkary_logo.svg',
      width: width, height: height);
}

alheekmah_logo(BuildContext context, {double? width, double? height}) {
  return SvgPicture.asset('assets/svg/alheekmah_logo.svg',
      colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.surface, BlendMode.srcIn),
      width: width,
      height: height);
}

book_cover() {
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(4)),
    child: SvgPicture.asset(
      'assets/svg/azkary_book.svg',
      fit: BoxFit.cover,
    ),
  );
}

surah_name(BuildContext context, int? index) {
  return Container(
    height: 80,
    width: 150,
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(8))),
    child: SvgPicture.asset(
      "assets/svg/surah_name/00$index.svg",
      colorFilter: ColorFilter.mode(
          ThemeController.instance.currentThemeId.value == 'dark'
              ? Theme.of(context).canvasColor
              : Theme.of(context).primaryColorDark,
          BlendMode.srcIn),
    ),
  );
}
