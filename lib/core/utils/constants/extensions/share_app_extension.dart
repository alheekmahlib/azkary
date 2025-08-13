import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

extension ShareAppExtension on void {
  Future<void> shareApp() async {
    final box = Get.context!.findRenderObject() as RenderBox?;
    final ByteData bytes =
        await rootBundle.load('assets/images/Azkary_banner.jpg');
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/Azkary_banner.jpg').create();
    file.writeAsBytesSync(list);
    await Share.shareXFiles(
      [XFile((file.path))],
      text:
          'تطبيق "أذكاري من الكتاب والسنة" التطبيق الأمثل لقراءة الأذكار المستمدة من القرآن الكريم والسنة النبوية.\n\nللتحميل:\nalheekmahlib.com/#/download/app/0',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
