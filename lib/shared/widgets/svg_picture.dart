
import 'package:husn_al_muslim/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:theme_provider/theme_provider.dart';


spaceLine(double height, width) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: SvgPicture.asset(
      'assets/svg/space_line.svg',
      height: height,
      width: width,
    ),
  );
}

fav_azkar(BuildContext context, double? width, height) {
  return SvgPicture.asset('assets/svg/fav_azkar.svg',
      // colorFilter: ColorFilter.mode(
      //     Theme.of(context).colorScheme.surface, BlendMode.srcIn),
      width: width, height: height);
}

azkary_icon(BuildContext context, {double? width, height}) {
  return SvgPicture.asset('assets/svg/azkary.svg',
      width: width, height: height);
}

azkary_logo(BuildContext context, {double? width, height}) {
  return SvgPicture.asset('assets/svg/azkary_logo.svg',
      width: width, height: height);
}

book_cover() {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    child: SvgPicture.asset(
      'assets/svg/azkary_book.svg',
      fit: BoxFit.cover,
    ),
  );
}

surah_name(BuildContext context, String? index, double? width, double? height) {
  return SvgPicture.asset(
    "assets/svg/surah_name/00$index.svg",
    height: height,
    width: width,
    colorFilter: ColorFilter.mode(
        Theme.of(context)
            .canvasColor,
        BlendMode.srcIn),
  );
}