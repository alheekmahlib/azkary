class OurAppInfo {
  final int id;
  final String appTitle;
  final String body;
  final String appLogo;
  final String urlAppStore;
  final String urlPlayStore;
  final String urlAppGallery;
  final String urlMacAppStore;

  OurAppInfo({
    required this.id,
    required this.appTitle,
    required this.body,
    required this.appLogo,
    required this.urlAppStore,
    required this.urlPlayStore,
    required this.urlAppGallery,
    required this.urlMacAppStore,
  });

  factory OurAppInfo.fromJson(Map<String, dynamic> json) {
    return OurAppInfo(
      id: json['id'],
      appTitle: json['appTitle'],
      body: json['body'],
      appLogo: json['appLogo'],
      urlAppStore: json['urlAppStore'],
      urlPlayStore: json['urlPlayStore'],
      urlAppGallery: json['urlAppGallery'],
      urlMacAppStore: json['urlMacAppStore'],
    );
  }
}
