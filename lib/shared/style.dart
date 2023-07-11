

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ColorStyle {
  final BuildContext context;

  ColorStyle(this.context);

  Color greenTextColor() {
    return ThemeProvider.themeOf(context).id == 'dark'
        ? Theme.of(context).canvasColor :
    Theme.of(context).primaryColorDark;
  }

  Color whiteTextColor() {
    return ThemeProvider.themeOf(context).id == 'dark'
        ? Theme.of(context).canvasColor :
    Theme.of(context).colorScheme.secondary;
  }
}