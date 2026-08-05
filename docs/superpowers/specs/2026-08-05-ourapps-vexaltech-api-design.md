# OurApps — Vexaltech API Migration & Rich Cards

**Date:** 2026-08-05
**Status:** Approved (pre-implementation)
**Scope:** Replace the hardcoded GitHub-raw data source of the `OurApps` screen with the Vexaltech API (`https://dash.vexaltech.dev/api/apps`), consume it through the existing `ApiClient`, filter to `companyName == "Alheekmah Library"`, and render rich cards using the newly available fields (`appBanner`, `banners`, `tags`).

---

## 1. Goal & Motivation

The `OurApps` screen (`lib/screens/ourApps_screen.dart`) currently fetches its app list via a direct `http.get` to a hardcoded `raw.githubusercontent.com` URL, bypassing the project's `ApiClient` singleton. This migration:

- Centralizes network access through `ApiClient` (consistent error handling via `Either<Failure, dynamic>`).
- Moves to the canonical API at `https://dash.vexaltech.dev/api/apps`, which is richer and authoritative.
- Filters the list server-side-by-field to only the apps published under `companyName == "Alheekmah Library"` (excludes the third-party `musnad` app owned by `helal`).
- Leverages new fields (`appBanner`, `banners`, `tags`) for a richer visual experience.

## 2. Data Source

### Endpoint
- **New constant** in `ApiConstants`: `ourAppsApiUrl = "https://dash.vexaltech.dev/api/apps"` (absolute URL).
- Dio ignores `baseUrl` when an absolute URL is passed to `request()` (this is the same behavior relied upon by `downloadFile`). The call therefore hits Vexaltech directly.

### Response shape
The API returns a wrapper object, **not** a bare array:

```json
{ "apps": [ { ...app }, { ...app } ] }
```

Decode must read `json['apps']` (a `List<dynamic>`), then map each element through `OurAppInfo.fromJson`.

### Filtering
After decode, keep only entries where `companyName == "Alheekmah Library"`. This is a pure client-side filter over the decoded list (the API has no query parameter for it). It removes the `musnad` entry (owned by `helal`) automatically.

## 3. Model Changes — `OurAppInfo`

**File:** `lib/widgets/ourApp_model.dart`

Add the new fields returned by the API. Make collection fields nullable so the UI degrades gracefully if the API omits them:

| Field | Type | Source | Notes |
|---|---|---|---|
| `id` | `int` | existing | unchanged |
| `appName` | `String` | **new** | e.g. `"quran"`, `"azkary"` |
| `appTitle` | `String` | existing | unchanged |
| `companyName` | `String` | **new** | filter key |
| `body` | `String` | existing | unchanged |
| `appLogo` | `String` | existing | now used as raw image URL (resolve via `resolveImageUrl`) |
| `appBanner` | `String` | **new** | wide banner image |
| `banners` | `List<String>?` | **new** | nullable gallery |
| `tags` | `List<String>?` | **new** | nullable tag chips |
| `urlAppStore` | `String` | existing | unchanged |
| `urlPlayStore` | `String` | existing | unchanged |
| `urlAppGallery` | `String` | existing | unchanged |
| `urlMacAppStore` | `String` | existing | unchanged |

### Image URL resolution
API returns a **mix of relative** (e.g. `/media/2026/07/xesesrbr-quran_logo.png`) and **absolute** (e.g. `https://raw.githubusercontent.com/...`) image URLs. Resolution rule:

```dart
static const String _imageBaseUrl = 'https://dash.vexaltech.dev';

String resolveImageUrl(String url) {
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  return '$_imageBaseUrl$url'; // relative path → prepend base
}
```

`resolveImageUrl` is applied wherever an image URL is consumed in the UI (`appLogo`, `appBanner`, each entry in `banners`).

### fromJson resilience
`fromJson` casts collections defensively:

```dart
banners: (json['banners'] as List<dynamic>?)?.cast<String>(),
tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
```

This prevents a crash if the API ever returns `null` or omits a collection field.

## 4. Data Fetching — `OurApps.fetchApps()`

**File:** `lib/screens/ourApps_screen.dart`

Rewrite `fetchApps()` to use `ApiClient`:

```dart
Future<Either<Failure, List<OurAppInfo>>> fetchApps() async {
  final response = await ApiClient().request(
    endpoint: ApiConstants.ourAppsApiUrl,
    method: HttpMethod.get,
  );
  if (response.isRight) {
    final body = response.right;
    final List<dynamic> raw =
        body is String ? jsonDecode(body)['apps'] : body['apps'];
    final all = raw.map((e) => OurAppInfo.fromJson(e as Map<String, dynamic>)).toList();
    final filtered = all
        .where((a) => a.companyName == 'Alheekmah Library')
        .toList();
    return Right(filtered);
  }
  return Left(response.left);
}
```

- Handles both a String body (Dio may return a String when content-type isn't JSON) and a pre-decoded Map.
- Removes the `http` import and the inline GitHub URL.

## 5. UI — Rich Cards

Each list item becomes a rich vertical card:

```
┌───────────────────────────────────────┐
│        appBanner (wide image)         │  ← Image.network, fixed height, cover fit
├───────────────────────────────────────┤
│  ┌─────┐  appTitle                    │  ← logo (50px) + title
│  │logo │                              │
│  └─────┘                              │
│                                       │
│  body (max 3 lines, ellipsis)         │  ← description
│                                       │
│  [tag] [tag] [tag]   (if present)     │  ← horizontal Wrap of chips
│                                       │
│  ┌───────────────────────────────┐    │
│  │ banners gallery (horizontal)  │    │  ← SizedBox/PageView, only if non-empty
│  └───────────────────────────────┘    │
│                                       │
│            [   تنزيل   ]              │  ← FilledButton → _launchURL
└───────────────────────────────────────┘
```

### Image handling
- `SvgPicture.network` is **replaced** with `Image.network` because the new logos/banners are PNG/JPG, not SVG.
- Every `Image.network` gets both `loadingBuilder` (spinner placeholder) and `errorBuilder` (broken-image icon placeholder) to avoid layout crashes on failed loads.

### Removal of legacy index hack
The previous render logic used `itemCount: apps!.length - 1` together with `if (index >= 1) index++;` to hide the first JSON entry. **This hack is removed.** After the `companyName` filter, every remaining entry should render. `itemCount` becomes `apps.length`, and `itemBuilder` uses `index` directly.

### Click behavior
Preserved unchanged: tapping the card (or the new "تنزيل" button) calls `_launchURL`, which routes by platform (iOS → App Store, Android non-Huawei → Play Store, Huawei → AppGallery, Web → Mac App Store).

## 6. Error & Loading States

| State | Rendering |
|---|---|
| Loading | `bookLoading(200.0.w, 200.0.h)` — unchanged |
| Error (`Left(Failure)`) | Centered message with the localized failure text + a "retry" button that re-runs `fetchApps()` (sets state via a `StatefulWidget` conversion, see §7) |
| Empty list | Centered message "لا توجد تطبيقات" (or localized equivalent) |

Because a retry button requires `setState`, the screen must change from `StatelessWidget` to `StatefulWidget` (minimal change: add `State` class, hold nothing inmutable in the widget).

## 7. Screen Lifecycle

`OurApps` converts from `StatelessWidget` to `StatefulWidget`. The `State` holds the current `Future` so the retry button can reassign it and trigger rebuild:

```dart
class OurApps extends StatefulWidget { ... }
class _OurAppsState extends State<OurApps> {
  late Future<Either<Failure, List<OurAppInfo>>> _future;
  @override
  void initState() { super.initState(); _future = fetchApps(); }
  void _retry() => setState(() => _future = fetchApps());
  ...
}
```

## 8. Out of Scope

- The `_launchURL` platform-routing logic is intentionally left unchanged.
- `ApiConstants.ourAppsUrl` (the old GitHub-raw constant) is left in place; only the new `ourAppsApiUrl` is consumed. (The old constant can be removed in a later cleanup, but removing it now would be unrelated churn.)
- No changes to localization keys beyond reusing the existing `ourApps` key.
- No new tests required by this spec (the project has no existing widget-test coverage for this screen); the change is verified by building and visually confirming.

## 9. Files Touched

| File | Change |
|---|---|
| `lib/core/utils/constants/api_constants.dart` | Add `ourAppsApiUrl` constant |
| `lib/widgets/ourApp_model.dart` | Add fields + `resolveImageUrl` helper + resilient `fromJson` |
| `lib/screens/ourApps_screen.dart` | Rewrite `fetchApps()` to use `ApiClient`; convert to `StatefulWidget`; rich-card `itemBuilder`; remove index hack; error/retry/empty states; swap `SvgPicture.network` → `Image.network` |

## 10. Risks & Mitigations

- **Relative vs absolute image URLs** → mitigated by `resolveImageUrl` applied at every image site.
- **Image format changed (SVG → PNG/JPG)** → mitigated by swapping to `Image.network` with `errorBuilder`.
- **Network failure on the new API** → mitigated by the `Either<Failure, _>` retry UI. (No automatic fallback URL is configured for the first cut; the API is authoritative. A fallback can be added later by passing `fallbackUrl:` to `ApiClient().request` if a mirror becomes available.)
- **API returns wrapper `{ "apps": [...] }`** → mitigated by decoding from `body['apps']`.
