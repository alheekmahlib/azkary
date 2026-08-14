import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/error_handling_system.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/widgets/lottie.dart';
import '../../../core/widgets/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../../../presentation/controllers/theme_controller.dart';

part 'controllers/our_apps_controller.dart';
part 'data/models/our_app_model.dart';
part 'screens/our_apps_screen.dart';
part 'widgets/app_card.dart';
