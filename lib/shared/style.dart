

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class Style {
  final BuildContext context;

  Style(this.context);

  Color getTextColor() {
    return ThemeProvider.themeOf(context).id == 'dark'
        ? Theme.of(context).canvasColor :
    Theme.of(context).primaryColorDark;
  }
}