import 'dart:convert';
import 'dart:developer';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/widgets/share/ayah_to_images.dart';
import '../../../core/widgets/style.dart';
import '../../../core/widgets/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../azkar/azkar.dart';

part 'controllers/quran_azkar_controller.dart';
part 'data/models/quran_azkar_model.dart';
part 'screens/quran_azkar_view.dart';
