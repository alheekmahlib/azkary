import 'dart:async';
import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/widgets/share/ayah_to_images.dart';
import '../../../core/widgets/style.dart';
import '../../../core/widgets/widgets.dart';
import '../../../database/database_helper.dart';
import '../../../presentation/controllers/azkary_controller.dart';

part 'controllers/azkar_controller.dart';
part 'controllers/azkar_item_controller.dart';
part 'models/all_azkar.dart';
part 'models/azkar.dart';
part 'models/azkar_by_category.dart';
part 'models/azkar_list.dart';
part 'screens/azkar_item.dart';
