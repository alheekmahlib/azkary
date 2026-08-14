part of '../our_apps.dart';

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
                      children:
                          app.tags!.map((t) => _tagChip(context, t)).toList(),
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
                      icon: Icon(Icons.download_outlined,
                          color: context.theme.colorScheme.inversePrimary),
                      label: Text(
                        'download'.tr,
                        style: TextStyle(
                            fontFamily: 'kufi',
                            color: context.theme.colorScheme.inversePrimary),
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
