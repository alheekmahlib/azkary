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
