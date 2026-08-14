import 'package:azkary/presentation/screens/our_apps/our_apps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OurAppInfo.resolveImageUrl', () {
    test('prepends Vexaltech base to relative URLs starting with /', () {
      expect(
        OurAppInfo.resolveImageUrl('/media/2026/07/logo.png'),
        'https://dash.vexaltech.dev/media/2026/07/logo.png',
      );
    });

    test('returns absolute https URLs unchanged', () {
      const url =
          'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/x.png';
      expect(OurAppInfo.resolveImageUrl(url), url);
    });

    test('returns absolute http URLs unchanged', () {
      const url = 'http://example.com/x.png';
      expect(OurAppInfo.resolveImageUrl(url), url);
    });
  });

  group('OurAppInfo.fromJson', () {
    Map<String, dynamic> baseApp() => <String, dynamic>{
          'id': 1,
          'appName': 'quran',
          'appTitle': 'القرآن الكريم',
          'companyName': 'Alheekmah Library',
          'appLogo': '/media/q.png',
          'appBanner': '/media/banner.png',
          'body': 'desc',
          'urlAppStore': 'https://apps.apple.com/x',
          'urlPlayStore': 'https://play.google.com/x',
          'urlAppGallery': 'https://appgallery.huawei.com/x',
          'urlMacAppStore': 'https://apps.apple.com/x',
          'banners': ['/media/1.jpg', '/media/2.jpg'],
          'tags': ['Flutter', 'Quran'],
        };

    test('parses all fields including collections', () {
      final app = OurAppInfo.fromJson(baseApp());
      expect(app.appName, 'quran');
      expect(app.companyName, 'Alheekmah Library');
      expect(app.appBanner, '/media/banner.png');
      expect(app.banners, ['/media/1.jpg', '/media/2.jpg']);
      expect(app.tags, ['Flutter', 'Quran']);
    });

    test('does not crash when banners and tags are omitted', () {
      final json = baseApp()..remove('banners')..remove('tags');
      final app = OurAppInfo.fromJson(json);
      expect(app.banners, isNull);
      expect(app.tags, isNull);
    });

    test('does not crash when banners and tags are null', () {
      final json = baseApp()
        ..['banners'] = null
        ..['tags'] = null;
      final app = OurAppInfo.fromJson(json);
      expect(app.banners, isNull);
      expect(app.tags, isNull);
    });
  });
}
