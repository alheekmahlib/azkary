import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../presentation/screens/azkar/azkar.dart';
import '../../presentation/controllers/azkary_controller.dart';
import 'style.dart';

/// قائمة الحصن - Hisn List Widget Class
class HisnListWidget extends StatelessWidget {
  const HisnListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return AnimationLimiter(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(16.0).r,
        child: ListView.separated(
          controller: AzkaryController.instance.controller,
          itemCount: azkarDataList.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 450),
                child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                        child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: (index % 2 == 0
                            ? Theme.of(context)
                                .canvasColor
                                .withValues(alpha: .6)
                            : Theme.of(context).colorScheme.surface),
                      ),
                      child: InkWell(
                        onTap: () {
                          final categoryName =
                              azkarDataList[index].toString().trim();
                          // تسجيل المتحكم بعلامة الفئة وإنشاؤه فوراً لتشغيل onInit
                          // Register + create immediately with the category tag to run onInit
                          if (!Get.isRegistered<AzkarItemController>(
                              tag: categoryName)) {
                            Get.put<AzkarItemController>(
                              AzkarItemController(categoryName),
                              tag: categoryName,
                            );
                          }
                          Get.bottomSheet(
                            AzkarItem(azkar: categoryName),
                            isScrollControlled: true,
                            backgroundColor: Get.theme.colorScheme.surface,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ).r,
                                child: Text(
                                  azkarDataList[index].toString(),
                                  style: TextStyle(
                                    color: index % 2 == 0
                                        ? colorStyle.greenTextColor()
                                        : Theme.of(context).canvasColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'vexa',
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))));
          },
        ),
      ),
    );
  }
}
