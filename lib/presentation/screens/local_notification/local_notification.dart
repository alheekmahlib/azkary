import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/notifications_helper.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/widgets/style.dart';

part 'controllers/local_notifications_controller.dart';
part 'data/models/post_model.dart';
part 'screens/notification_screen.dart';
part 'widgets/notification_icon_widget.dart';
part 'widgets/notification_widget.dart';
