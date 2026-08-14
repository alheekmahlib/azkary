part of '../../our_apps.dart';

class OurAppInfo {
  final int id;
  final String appName;
  final String appTitle;
  final String companyName;
  final String body;
  final String appLogo;
  final String appBanner;
  final List<String>? banners;
  final List<String>? tags;
  final String urlAppStore;
  final String urlPlayStore;
  final String urlAppGallery;
  final String urlMacAppStore;

  OurAppInfo({
    required this.id,
    required this.appName,
    required this.appTitle,
    required this.companyName,
    required this.body,
    required this.appLogo,
    required this.appBanner,
    this.banners,
    this.tags,
    required this.urlAppStore,
    required this.urlPlayStore,
    required this.urlAppGallery,
    required this.urlMacAppStore,
  });

  /// القاعدة التي تُسبق بها روابط الصور النسبية القادمة من Vexaltech.
  static const String imageBaseUrl = 'https://dash.vexaltech.dev';

  /// يُرجع رابط الصورة كاملاً: إذا كان مطلقاً (http/https) يُرجَع كما هو،
  /// وإذا كان نسبياً (يبدأ بـ /) تُسبق إليه قاعدة Vexaltech.
  static String resolveImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return '$imageBaseUrl$url';
  }

  factory OurAppInfo.fromJson(Map<String, dynamic> json) {
    return OurAppInfo(
      id: json['id'] as int,
      appName: json['appName'] as String? ?? '',
      appTitle: json['appTitle'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      body: json['body'] as String? ?? '',
      appLogo: json['appLogo'] as String? ?? '',
      appBanner: json['appBanner'] as String? ?? '',
      banners: (json['banners'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      urlAppStore: json['urlAppStore'] as String? ?? '',
      urlPlayStore: json['urlPlayStore'] as String? ?? '',
      urlAppGallery: json['urlAppGallery'] as String? ?? '',
      urlMacAppStore: json['urlMacAppStore'] as String? ?? '',
    );
  }
}
