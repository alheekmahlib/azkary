import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../quran_azkar/controllers/quran_azkar_controller.dart';
import '../../quran_azkar/screen/quran_azkar_view.dart';

/// أذكار القرآن - Quran Azkar Widget Class
class QuranAzkarWidget extends StatelessWidget {
  const QuranAzkarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranAzkarController>(
      id: 'quranAzkarWidget',
      init: QuranAzkarController.instance,
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading.value) {
            // حالة التحميل - Loading state
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            // حالة الخطأ - Error state
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // عرض البيانات - Display data
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0).r,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.3,
            ),
            itemCount: controller.surahs.length,
            itemBuilder: (context, index) {
              final surah = controller.surahs[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 300),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: InkWell(
                      onTap: () => Get.bottomSheet(
                        QuranAzkarView(surah: surah),
                        isScrollControlled: true,
                      ),
                      child: Container(
                        height: 80.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: .2),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(10),
                            Text(
                              surah.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontFamily: 'noto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              'عدد الآيات: ${surah.ayahs.length}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontFamily: 'noto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}
