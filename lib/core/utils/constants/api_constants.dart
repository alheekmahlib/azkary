class ApiConstants {
  static const downloadAppUrl = "https://alheekmahlib.com/#/download/app/0";

  static const baseUrl = "https://github.com/";
  static const String notificationsUrl =
      'alheekmahlib/thegarlanded/blob/master/noti.json?raw=true';
  static const String ourAppsUrl =
      'alheekmahlib/thegarlanded/blob/master/ourApps.json?raw=true';

  /// واجهة برمجة تطبيقات تطبيقاتنا على منصّة Vexaltech.
  /// رابط مطلق — Dio يتجاهل baseUrl عند تمرير رابط مطلق.
  static const String ourAppsApiUrl = 'https://dash.vexaltech.dev/api/apps';

  /// واجهة ميزة الملاحظات (Feedback) على منصّة Vexaltech.
  /// POST + GET /feedback — إنشاء ملاحظة وجلبها بالـ token.
  static const String feedbackApiUrl = 'https://vexaltech.dev/api/feedback';
  static const String feedbackEndpoint = '/feedback';
  static const String feedbackReplySuffix =
      '/reply'; // POST /feedback/{token}/reply
  static const String feedbackUploadEndpoint = '/upload'; // POST رفع وسائط
}
