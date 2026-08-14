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
          'appName': [
            {'lang': 'ar', 'name': 'القرآن الكريم - مكتبة الحكمة'},
            {'lang': 'en', 'name': 'Al Quran Al Kareem'},
          ],
          'companyName': 'Alheekmah Library',
          'appLogo': '/media/q.png',
          'appBanner': '/media/banner.png',
          'body': [
            {'lang': 'ar', 'value': 'وصف عربي'},
            {'lang': 'en', 'value': 'English description'},
          ],
          'slug': 'quran',
          'dynamicLink': 'https://alhikmah.vexaltech.dev/download/quran',
          'banners': ['/media/1.jpg', '/media/2.jpg'],
          'tags': ['Flutter', 'Quran'],
        };

    test('parses localized appName/body for the requested language', () {
      final app = OurAppInfo.fromJson(baseApp(), langCode: 'en');
      expect(app.appName, 'Al Quran Al Kareem');
      expect(app.body, 'English description');
      expect(app.companyName, 'Alheekmah Library');
      expect(app.appBanner, '/media/banner.png');
      expect(app.banners, ['/media/1.jpg', '/media/2.jpg']);
      expect(app.tags, ['Flutter', 'Quran']);
    });

    test('appTitle falls back to the localized appName when absent', () {
      final app = OurAppInfo.fromJson(baseApp(), langCode: 'ar');
      expect(app.appTitle, 'القرآن الكريم - مكتبة الحكمة');
    });

    test('prefers an explicit appTitle over the appName fallback', () {
      final json = baseApp()..['appTitle'] = 'عنوان مخصص';
      final app = OurAppInfo.fromJson(json, langCode: 'ar');
      expect(app.appTitle, 'عنوان مخصص');
    });

    test('falls back to Arabic when the requested language is missing', () {
      final app = OurAppInfo.fromJson(baseApp(), langCode: 'tr');
      expect(app.appName, 'القرآن الكريم - مكتبة الحكمة');
      expect(app.body, 'وصف عربي');
    });

    test('falls back to the first entry when no ar/en translation exists', () {
      final json = baseApp()
        ..['appName'] = [
          {'lang': 'ku', 'name': 'ناوی کوردی'}
        ];
      final app = OurAppInfo.fromJson(json, langCode: 'fr');
      expect(app.appName, 'ناوی کوردی');
    });

    test('tolerates plain-string appName/body (legacy shape)', () {
      final json = baseApp()
        ..['appName'] = 'quran'
        ..['body'] = 'desc';
      final app = OurAppInfo.fromJson(json, langCode: 'ar');
      expect(app.appName, 'quran');
      expect(app.body, 'desc');
    });

    test('returns empty strings when localized lists are empty', () {
      final json = baseApp()
        ..['appName'] = <dynamic>[]
        ..['body'] = <dynamic>[];
      final app = OurAppInfo.fromJson(json, langCode: 'ar');
      expect(app.appName, '');
      expect(app.body, '');
      expect(app.appTitle, '');
    });

    test('does not crash when banners and tags are omitted', () {
      final json = baseApp()
        ..remove('banners')
        ..remove('tags');
      final app = OurAppInfo.fromJson(json, langCode: 'ar');
      expect(app.banners, isNull);
      expect(app.tags, isNull);
    });

    test('does not crash when banners and tags are null', () {
      final json = baseApp()
        ..['banners'] = null
        ..['tags'] = null;
      final app = OurAppInfo.fromJson(json, langCode: 'ar');
      expect(app.banners, isNull);
      expect(app.tags, isNull);
    });
  });

  group('OurAppInfo dynamicLink', () {
    Map<String, dynamic> baseApp() => <String, dynamic>{
          'id': 1,
          'slug': 'zad',
          'dynamicLink': 'https://alhikmah.vexaltech.dev/download/zad',
        };

    test('uses the explicit dynamicLink from the API', () {
      final app = OurAppInfo.fromJson(baseApp(), langCode: 'ar');
      expect(app.dynamicLink, 'https://alhikmah.vexaltech.dev/download/zad');
    });

    test('derives the link from slug when dynamicLink is absent', () {
      final json = baseApp()..remove('dynamicLink');
      final app = OurAppInfo.fromJson(json, langCode: 'ar');
      expect(app.dynamicLink, 'https://alhikmah.vexaltech.dev/download/zad');
    });

    test('returns empty string when both dynamicLink and slug are absent', () {
      final json = baseApp()
        ..remove('dynamicLink')
        ..remove('slug');
      final app = OurAppInfo.fromJson(json, langCode: 'ar');
      expect(app.dynamicLink, '');
    });
  });
}
