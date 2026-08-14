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
  final String dynamicLink;

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
    required this.dynamicLink,
  });

  /// القاعدة التي تُسبق بها روابط الصور النسبية القادمة من Vexaltech.
  static const String imageBaseUrl = 'https://dash.vexaltech.dev';

  /// قاعدة روابط التنزيل المشتقة من slug لدى Vexaltech.
  static const String downloadBaseUrl = 'https://alhikmah.vexaltech.dev';

  /// يُرجع رابط الصورة كاملاً: إذا كان مطلقاً (http/https) يُرجَع كما هو،
  /// وإذا كان نسبياً (يبدأ بـ /) تُسبق إليه قاعدة Vexaltech.
  static String resolveImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return '$imageBaseUrl$url';
  }

  factory OurAppInfo.fromJson(Map<String, dynamic> json, {String? langCode}) {
    final lang = langCode ?? Get.locale?.languageCode ?? 'ar';
    final name = _localized(json['appName'], 'name', lang);
    final title = json['appTitle'] as String? ?? '';
    return OurAppInfo(
      id: json['id'] as int,
      appName: name,
      // الواجهة لا ترسل appTitle؛ نعوضه باسم التطبيق المترجم
      appTitle: title.isNotEmpty ? title : name,
      companyName: json['companyName'] as String? ?? '',
      body: _localized(json['body'], 'value', lang),
      appLogo: json['appLogo'] as String? ?? '',
      appBanner: json['appBanner'] as String? ?? '',
      banners: (json['banners'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      dynamicLink: resolveDynamicLink(json),
    );
  }

  /// يُرجع رابط تنزيل التطبيق: dynamicLink الصريح من الواجهة، وإلا
  /// يُشتق من slug وفق نمط download/{slug}، وسلسلة فارغة إن غاب كلاهما.
  static String resolveDynamicLink(Map<String, dynamic> json) {
    final link = json['dynamicLink'] as String? ?? '';
    if (link.isNotEmpty) return link;
    final slug = json['slug'] as String? ?? '';
    return slug.isNotEmpty ? '$downloadBaseUrl/download/$slug' : '';
  }

  /// يستخرج النص المطابق للغة المطلوبة من قائمة ترجمات Vexaltech
  /// بصيغة [{lang, name|value}]، ويقبل النص الصريح أيضًا (توافقًا مع
  /// الأشكال القديمة). ترتيب الاحتياط: اللغة المطلوبة ثم 'ar' ثم 'en'
  /// ثم أول مدخل، وسلسلة فارغة إن غاب كل شيء.
  static String _localized(dynamic entries, String valueKey, String lang) {
    if (entries is String) return entries;
    if (entries is! List || entries.isEmpty) return '';
    for (final code in [lang, 'ar', 'en']) {
      for (final entry in entries) {
        if (entry is Map &&
            entry['lang'] == code &&
            entry[valueKey] is String) {
          return entry[valueKey] as String;
        }
      }
    }
    final first = entries.first;
    return first is Map && first[valueKey] is String
        ? first[valueKey] as String
        : '';
  }
}
