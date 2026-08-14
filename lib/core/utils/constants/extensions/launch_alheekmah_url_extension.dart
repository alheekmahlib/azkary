import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

extension LaunchAlheekmahUrlExtension on void {
  Future<void> launchAlheekmahUrl() async {
    String uri = 'https://www.facebook.com/alheekmahlib';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      log("No url client found", name: 'LaunchAlheekmahUrl');
    }
  }
}
