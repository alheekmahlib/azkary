import 'package:flutter/material.dart';

import '../core/themes/app_themes.dart';

class ColorStyle {
  final BuildContext context;

  ColorStyle(this.context);

  Color greenTextColor() {
    return ThemeController.instance.currentThemeId.value == 'dark'
        ? Theme.of(context).canvasColor
        : Theme.of(context).primaryColorDark;
  }

  Color whiteTextColor() {
    return ThemeController.instance.currentThemeId.value == 'dark'
        ? Theme.of(context).canvasColor
        : Theme.of(context).colorScheme.secondary;
  }
}
