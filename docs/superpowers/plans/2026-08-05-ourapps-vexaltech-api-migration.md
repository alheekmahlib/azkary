# OurApps Vexaltech API Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Switch the `OurApps` screen from a hardcoded GitHub-raw JSON to the Vexaltech API (`https://dash.vexaltech.dev/api/apps`) via the existing `ApiClient`, filter to `companyName == "Alheekmah Library"`, and render rich cards using the new `appBanner`, `banners`, and `tags` fields.

**Architecture:** A new absolute-URL constant feeds `ApiClient().request(...)`, which returns `Either<Failure, dynamic>`. The screen decodes `body['apps']`, maps to an extended `OurAppInfo` model, filters by `companyName`, and renders rich cards with `Image.network` (with placeholder + error builders). The screen converts to `StatefulWidget` to support a retry button on the error state.

**Tech Stack:** Flutter, Dio, either_dart, flutter_screenutil, url_launcher, flutter_test.

## Global Constraints

- API endpoint (absolute, verbatim): `https://dash.vexaltech.dev/api/apps`
- Image base URL for relative paths: `https://dash.vexaltech.dev`
- Filter value (verbatim): `companyName == 'Alheekmah Library'`
- The API returns a wrapper: `{ "apps": [ ... ] }` — decode from `body['apps']`, not the root.
- New logos/banners are PNG/JPG — use `Image.network`, never `SvgPicture.network`, for them.
- `ApiClient` is a singleton: `ApiClient()`; `request()` signature is `request({required String endpoint, required HttpMethod method, ...})` returning `Future<Either<Failure, dynamic>>`. Use `response.isRight`, `response.right`, `response.left`.
- `Failure` has a `.message` (`String`) and `.code` (`int`) field.
- Keep `_launchURL` platform-routing logic unchanged.
- Follow existing import style (relative imports with `/` for package-root files where the codebase already does so; relative `../` otherwise).

---

## File Structure

| File | Responsibility |
|---|---|
| `lib/core/utils/constants/api_constants.dart` | Add the new endpoint constant |
| `lib/widgets/ourApp_model.dart` | Extended model: new fields, resilient `fromJson`, `resolveImageUrl` static helper |
| `lib/screens/ourApps_screen.dart` | Network via `ApiClient`, `StatefulWidget` conversion, rich cards, error/retry/empty states, `Image.network` |
| `test/our_app_model_test.dart` (new) | Unit tests for the model (image resolution + resilient decode) |

---

### Task 1: Add the Vexaltech API endpoint constant

**Files:**
- Modify: `lib/core/utils/constants/api_constants.dart`

**Interfaces:**
- Produces: `ApiConstants.ourAppsApiUrl` (a `String` constant equal to `https://dash.vexaltech.dev/api/apps`) — consumed by Task 4.

- [ ] **Step 1: Add the constant**

Open `lib/core/utils/constants/api_constants.dart` and replace the entire file contents with:

```dart
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
}
```

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/core/utils/constants/api_constants.dart`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/core/utils/constants/api_constants.dart
git commit -m "feat(api): add ourAppsApiUrl constant for Vexaltech endpoint"
```

---

### Task 2: Extend `OurAppInfo` model with new fields + URL resolver

**Files:**
- Modify: `lib/widgets/ourApp_model.dart`

**Interfaces:**
- Consumes: the new fields from the Vexaltech API JSON (see Task 3 tests for exact expected JSON shape).
- Produces: `OurAppInfo` with fields `appName`, `companyName`, `appBanner`, nullable `banners`, nullable `tags`; and a `static String resolveImageUrl(String url)` method used by Task 4.

- [ ] **Step 1: Write the failing test**

Create `test/our_app_model_test.dart`:

```dart
import 'package:azkary/widgets/ourApp_model.dart';
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/our_app_model_test.dart`
Expected: FAIL — compile error (`resolveImageUrl` not defined, `appName`/`companyName`/`appBanner`/`banners`/`tags` getters don't exist).

- [ ] **Step 3: Implement the extended model**

Replace the entire contents of `lib/widgets/ourApp_model.dart` with:

```dart
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/our_app_model_test.dart`
Expected: PASS — all tests green.

- [ ] **Step 5: Run analyze to catch regressions across callers**

Run: `flutter analyze lib/widgets/ourApp_model.dart lib/screens/ourApps_screen.dart`
Expected: Errors will appear in `ourApps_screen.dart` because it still references the old `fetchApps`/shape — that's fine; it will be rewritten in Task 4. Confirm there are no OTHER errors (e.g. no other file depends on a removed field). If a file outside the plan breaks, STOP and report.

- [ ] **Step 6: Commit**

```bash
git add lib/widgets/ourApp_model.dart test/our_app_model_test.dart
git commit -m "feat(model): extend OurAppInfo with Vexaltech fields and resolveImageUrl"
```

---

### Task 3: Rewrite `OurApps` screen — network, stateful conversion, rich cards, error/retry/empty

**Files:**
- Modify: `lib/screens/ourApps_screen.dart` (full rewrite of the class body, keeping `_launchURL` logic intact)

**Interfaces:**
- Consumes: `ApiConstants.ourAppsApiUrl` (Task 1), `OurAppInfo` extended model + `resolveImageUrl` (Task 2), `ApiClient` (`request`), `HttpMethod`, `Failure`, `Either`.
- Produces: the `OurApps` widget (still pushed from `settings_list.dart:454` with the same constructor — no caller changes).

- [ ] **Step 1: Replace the entire file contents**

Replace the whole of `lib/screens/ourApps_screen.dart` with the following. (The `_launchURL` platform-routing logic is preserved verbatim; everything else is rewritten.)

```dart
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '/l10n/app_localizations.dart';
import '../../core/services/api_client.dart';
import '../../core/services/error_handling_system.dart';
import '../../core/themes/app_themes.dart';
import '../../core/utils/constants/api_constants.dart';
import '../widgets/ourApp_model.dart';
import '../widgets/widgets/lottie.dart';
import '../widgets/widgets/svg_picture.dart';
import '../widgets/widgets/widgets.dart';

class OurApps extends StatefulWidget {
  const OurApps({super.key});

  @override
  State<OurApps> createState() => _OurAppsState();
}

class _OurAppsState extends State<OurApps> {
  late Future<Either<Failure, List<OurAppInfo>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchApps();
  }

  void _retry() {
    setState(() {
      _future = _fetchApps();
    });
  }

  /// يجلب التطبيقات من واجهة Vexaltech عبر ApiClient، ثم يفلترها بحسب
  /// companyName == 'Alheekmah Library'.
  Future<Either<Failure, List<OurAppInfo>>> _fetchApps() async {
    final response = await ApiClient().request(
      endpoint: ApiConstants.ourAppsApiUrl,
      method: HttpMethod.get,
    );
    if (response.isRight) {
      try {
        final body = response.right;
        final decoded = body is String ? jsonDecode(body) : body;
        final List<dynamic> raw = decoded['apps'] as List<dynamic>;
        final all = raw
            .map((e) => OurAppInfo.fromJson(e as Map<String, dynamic>))
            .toList();
        final filtered = all
            .where((a) => a.companyName == 'Alheekmah Library')
            .toList();
        return Right(filtered);
      } catch (e) {
        return Left(DataSource.DEFAULT.getFailure());
      }
    }
    return Left(response.left);
  }

  _launchURL(BuildContext context, OurAppInfo ourAppInfo) async {
    if (!kIsWeb) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppStore))) {
          await launchUrl(Uri.parse(ourAppInfo.urlAppStore));
        } else {
          throw 'Could not launch ${ourAppInfo.urlAppStore}';
        }
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        final deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.manufacturer.toLowerCase() != 'huawei') {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlPlayStore))) {
            await launchUrl(Uri.parse(ourAppInfo.urlPlayStore));
          } else {
            throw 'Could not launch ${ourAppInfo.urlPlayStore}';
          }
        } else {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppGallery))) {
            await launchUrl(Uri.parse(ourAppInfo.urlAppGallery));
          } else {
            throw 'Could not launch ${ourAppInfo.urlAppGallery}';
          }
        }
      }
    } else {
      if (await canLaunchUrl(Uri.parse(ourAppInfo.urlMacAppStore))) {
        await launchUrl(Uri.parse(ourAppInfo.urlMacAppStore));
      } else {
        throw 'Could not launch ${ourAppInfo.urlMacAppStore}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.instance.currentThemeId.value == 'dark'
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).canvasColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(300, -10),
              child: Opacity(
                opacity: .05,
                child: azkary_icon(
                  context,
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: container(
                context,
                _OurAppBuild(
                  future: _future,
                  onRetry: _retry,
                  onLaunch: (app) => _launchURL(context, app),
                ),
                false,
                height: orientation(context, 450.0.h, 300.0.h),
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Transform.translate(
                    offset: orientation(
                        context, Offset(0, -220.h), Offset(0, -130.h)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        azkary_logo(
                          context,
                          width: 80.0.w,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)).r),
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0)
                              .r,
                          margin: const EdgeInsets.symmetric(vertical: 8.0).r,
                          child: Text(
                            'من الكتاب والسُّنة',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        ),
                      ],
                    ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: orientation(
                    context,
                    const EdgeInsets.symmetric(vertical: 64.0).r,
                    const EdgeInsets.symmetric(vertical: 32.0).r),
                child: alheekmah_logo(
                  context,
                  width: 60.w,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 48.0, right: 16.0).r,
                child: customArrowBack(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OurAppBuild extends StatelessWidget {
  final Future<Either<Failure, List<OurAppInfo>>> future;
  final VoidCallback onRetry;
  final ValueChanged<OurAppInfo> onLaunch;

  const _OurAppBuild({
    required this.future,
    required this.onRetry,
    required this.onLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either<Failure, List<OurAppInfo>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return bookLoading(200.0.w, 200.0.h);
        }

        if (snapshot.hasError) {
          return _errorView(context, snapshot.error.toString());
        }

        final result = snapshot.data;
        if (result == null) {
          return _errorView(context, 'null');
        }

        return result.fold(
          (failure) => _errorView(context, failure.message),
          (apps) {
            if (apps.isEmpty) {
              return _emptyView(context);
            }
            return _list(context, apps);
          },
        );
      },
    );
  }

  Widget _list(BuildContext context, List<OurAppInfo> apps) {
    return Padding(
      padding: const EdgeInsets.only(top: 90.0).r,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.ourApps,
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 20.sp,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold),
          ),
          hDivider(context),
          Expanded(
            child: ListView.separated(
              shrinkWrap: false,
              padding: EdgeInsets.zero,
              itemCount: apps.length,
              separatorBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0).r,
                child: hDivider(context),
              ),
              itemBuilder: (context, index) =>
                  _AppCard(app: apps[index], onLaunch: onLaunch),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 13.sp,
                fontFamily: 'kufi',
              ),
            ),
            SizedBox(height: 16.0.h),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(
                AppLocalizations.of(context)!.ourApps,
                style: const TextStyle(fontFamily: 'kufi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyView(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد تطبيقات',
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontSize: 14.sp,
          fontFamily: 'kufi',
        ),
      ),
    );
  }
}

/// بطاقة غنية لتطبيق واحد: بانر + شعار + عنوان + وصف + وسوم + معرض صور + زر تنزيل.
class _AppCard extends StatelessWidget {
  final OurAppInfo app;
  final ValueChanged<OurAppInfo> onLaunch;

  const _AppCard({required this.app, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onLaunch(app),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)).r,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0).r,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بانر علوي عريض
            _networkImage(
              OurAppInfo.resolveImageUrl(app.appBanner),
              height: 140.h,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _networkImage(
                        OurAppInfo.resolveImageUrl(app.appLogo),
                        height: 50.h,
                        width: 50.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 12.0.w),
                      Expanded(
                        child: Text(
                          app.appTitle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: 14.sp,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0.h),
                  Text(
                    app.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: .7),
                      fontSize: 10.sp,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (app.tags != null && app.tags!.isNotEmpty) ...[
                    SizedBox(height: 8.0.h),
                    Wrap(
                      spacing: 6.0.w,
                      runSpacing: 4.0.h,
                      children: app.tags!
                          .map((t) => _tagChip(context, t))
                          .toList(),
                    ),
                  ],
                  if (app.banners != null && app.banners!.isNotEmpty) ...[
                    SizedBox(height: 10.0.h),
                    SizedBox(
                      height: 150.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: app.banners!.length,
                        separatorBuilder: (_, __) => SizedBox(width: 8.0.w),
                        itemBuilder: (context, i) => ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)).r,
                          child: _networkImage(
                            OurAppInfo.resolveImageUrl(app.banners![i]),
                            height: 150.h,
                            width: 90.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 12.0.h),
                  Align(
                    alignment: Alignment.center,
                    child: FilledButton.icon(
                      onPressed: () => onLaunch(app),
                      icon: const Icon(Icons.download_outlined),
                      label: Text(
                        AppLocalizations.of(context)!.ourApps,
                        style: const TextStyle(fontFamily: 'kufi'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0).r,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .12),
        borderRadius: const BorderRadius.all(Radius.circular(20)).r,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontFamily: 'kufi',
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  /// صورة شبكة مع placeholder للتحميل وأيقونة عند الفشل لتفادي الكراش.
  Widget _networkImage(String url,
      {required double height, double? width, required BoxFit fit}) {
    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          height: height,
          width: width,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          height: height,
          width: width,
          child: Container(
            color: Colors.black12,
            child: const Icon(Icons.broken_image_outlined),
          ),
        );
      },
    );
  }
}
```

Notes embedded for the implementer:
- The legacy index hack (`itemCount: apps.length - 1` + `index++`) is **gone** — `itemCount: apps.length` and direct `index` use.
- `SvgPicture.network` is **gone** — replaced by `_networkImage` (which uses `Image.network`).
- `http` package import is **gone** — replaced by `ApiClient`.
- The `_launchURL` body is unchanged (only the unused `index` parameter was removed).
- A `_retry` button reassigns `_future` via `setState`.

- [ ] **Step 2: Run analyze on the whole package**

Run: `flutter analyze`
Expected: `No issues found!` (or only pre-existing warnings unrelated to this change). If new errors appear, fix imports/types before proceeding.

- [ ] **Step 3: Verify the model unit tests still pass**

Run: `flutter test test/our_app_model_test.dart`
Expected: PASS (the model wasn't changed by this task, but the screen rewrite must not have broken anything).

- [ ] **Step 4: Build a debug APK to confirm it compiles end-to-end**

Run: `flutter build apk --debug` (or, faster on this machine: `flutter build apk --debug --target-platform android-arm64`)
Expected: `✓ Built build/app/outputs/flutter-apk/app-debug.apk.`

If the build fails due to the `container`/`orientation`/`hDivider`/`bookLoading`/`customArrowBack` helpers, double-check imports from `widgets/widgets/widgets.dart` and `widgets/widgets/lottie.dart`, `widgets/widgets/svg_picture.dart` — they match the original imports verbatim.

- [ ] **Step 5: Manual visual check (if a device/emulator is available)**

Optional: launch on a device/emulator, open Settings → "تطبيقاتنا", and confirm:
- 5 Alheekmah apps render (not the `musnad` app).
- Each card shows banner + logo + title + body + tags + (where present) banner gallery + a "تنزيل" button.
- Tap a card → opens the correct store on the platform.
- No layout overflow.

- [ ] **Step 6: Commit**

```bash
git add lib/screens/ourApps_screen.dart
git commit -m "feat(ourapps): migrate to Vexaltech API via ApiClient with rich cards"
```

---

### Task 4: Final verification — full analyze + test + build

**Files:** None (verification only).

- [ ] **Step 1: Full analyze**

Run: `flutter analyze`
Expected: `No issues found!` (or only pre-existing warnings unrelated to this change).

- [ ] **Step 2: Full test suite**

Run: `flutter test`
Expected: The model tests PASS. The legacy `test/widget_test.dart` may still FAIL (it references an old counter UI unrelated to this work) — that is acceptable and pre-existing; do not modify it.

- [ ] **Step 3: Build**

Run: `flutter build apk --debug --target-platform android-arm64`
Expected: success.

- [ ] **Step 4: Final commit (if anything was amended) / otherwise done**

If all green and nothing left uncommitted, you're done. Report a summary of what changed.
