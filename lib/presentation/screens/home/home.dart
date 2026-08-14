import 'dart:developer';
import 'dart:math' hide log;

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../core/utils/constants/lists.dart';
import '../../../core/widgets/azkar_fav.dart';
import '../../../core/widgets/books_widget.dart';
import '../../../core/widgets/hisn_list_widget.dart';
import '../../../core/widgets/quran_azkar_widget.dart';
import '../../../core/widgets/settings_list.dart';
import '../../../core/widgets/style.dart';
import '../../../core/widgets/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../../../presentation/controllers/azkary_controller.dart';
import '../../../presentation/controllers/reminder_model.dart';
import '../../screens/books/books.dart';
import '../../screens/onboarding/onboarding.dart';
import '../../screens/local_notification/local_notification.dart';

part 'controllers/navigation_controller.dart';
part 'screens/azkar_home.dart';
part 'screens/azkar_list.dart';
part 'screens/main_screen.dart';
