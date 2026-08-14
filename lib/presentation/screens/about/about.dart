import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/utils/constants/extensions/contact_us_extension.dart';
import '/core/utils/constants/extensions/share_app_extension.dart';
import '../../../core/widgets/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../../../presentation/controllers/theme_controller.dart';

part 'controllers/about_controller.dart';
part 'screens/about_app.dart';
part 'screens/info_app.dart';
