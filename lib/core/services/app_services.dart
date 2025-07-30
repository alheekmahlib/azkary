import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// كلاس مساعد للإشعارات المجدولة
// Helper class for scheduled notifications
class NotifyHelper {
  // تهيئة الإشعارات / Initialize notifications
  void initializeNotification() {
    log('Notification initialized', name: 'NotifyHelper');
  }

  // جدولة إشعار / Schedule notification
  Future<void> scheduledNotification(
    BuildContext context,
    int id,
    int hour,
    int minute,
    String title,
  ) async {
    try {
      log('Notification scheduled - ID: $id, Time: $hour:$minute, Title: $title',
          name: 'NotifyHelper');
    } catch (e) {
      log('Error scheduling notification: $e', name: 'NotifyHelper');
    }
  }

  // إلغاء إشعار مجدول / Cancel scheduled notification
  Future<void> cancelScheduledNotification(int id) async {
    try {
      log('Notification cancelled - ID: $id', name: 'NotifyHelper');
    } catch (e) {
      log('Error cancelling notification: $e', name: 'NotifyHelper');
    }
  }
}

// كلاس لفحص الاتصال بالإنترنت
// Connectivity service class
class ConnectivityService extends GetxService {
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
  }

  void _initConnectivity() {
    // تهيئة فحص الاتصال / Initialize connectivity check
    log('Connectivity service initialized', name: 'ConnectivityService');
  }

  Future<bool> checkConnectivity() async {
    // فحص الاتصال / Check connectivity
    return isConnected.value;
  }
}

// كلاس لطلبات API مع Dio
// API client class with Dio
class ApiClient extends GetxService {
  // مثيل من ApiClient / ApiClient instance
  static ApiClient get instance => Get.isRegistered<ApiClient>()
      ? Get.find<ApiClient>()
      : Get.put(ApiClient());

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    // تهيئة Dio / Initialize Dio
    log('ApiClient initialized', name: 'ApiClient');
  }

  Future<dynamic> get(String url) async {
    try {
      log('GET request to: $url', name: 'ApiClient');
      // تنفيذ طلب GET / Execute GET request
      return {};
    } catch (e) {
      log('Error in GET request: $e', name: 'ApiClient');
      throw e;
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> data) async {
    try {
      log('POST request to: $url', name: 'ApiClient');
      // تنفيذ طلب POST / Execute POST request
      return {};
    } catch (e) {
      log('Error in POST request: $e', name: 'ApiClient');
      throw e;
    }
  }

  Future<void> downloadFile(String url, String savePath) async {
    try {
      log('Downloading file from: $url to: $savePath', name: 'ApiClient');
      // تحميل الملف / Download file
    } catch (e) {
      log('Error downloading file: $e', name: 'ApiClient');
      throw e;
    }
  }
}
