import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/error_handling_system.dart';
import '../../../core/services/notifications_helper.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/widgets/lottie.dart';
import '../../../core/widgets/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../../controllers/theme_controller.dart';

part 'controllers/feedback_controller.dart';
part 'data/models/feedback_model.dart';
part 'data/models/feedback_reply_model.dart';
part 'data/models/feedback_thread.dart';
part 'screens/feedback_conversation_screen.dart';
part 'screens/feedback_thread_screen.dart';
part 'screens/widgets/feedback_media_gallery.dart';
part 'screens/widgets/feedback_send_sheet.dart';
