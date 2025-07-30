import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../azkar/models/all_azkar.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../books/controllers/books_controller.dart';
import '../../books/screen/books_view.dart';
import '../../core/controllers/azkary_controller.dart';
import '../../quran_azkar/controllers/quran_azkar_controller.dart';
import '../../quran_azkar/screen/quran_azkar_view.dart';
import '../../shared/widgets/widgets.dart';
import '../style.dart';
import 'lottie.dart';

Widget quranAzkarWidget() {
  // أذكار القرآن - Quran Azkar Widget
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: .8,
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
                    onTap: () => Get.to(
                      () => QuranAzkarView(surah: surah),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeProvider.themeOf(context).data.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Gap(10),
                          SvgPicture.asset(
                            'assets/svg/quran.svg',
                            color: Theme.of(context).colorScheme.primary,
                            width: 50.w,
                            height: 50.h,
                          ),
                          const Gap(10),
                          Text(
                            surah.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ThemeProvider.themeOf(context)
                                  .data
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
                              color: Theme.of(context).colorScheme.primary,
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

Widget hisnListBuild(BuildContext context) {
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
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: (index % 2 == 0
                          ? Theme.of(context).canvasColor.withOpacity(.6)
                          : Theme.of(context).colorScheme.surface),
                    ),
                    child: InkWell(
                      onTap: () {
                        screenModalBottomSheet(
                            context,
                            AzkarItem(
                              azkar: azkarDataList[index].toString().trim(),
                            ));
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
                                  color: colorStyle.greenTextColor(),
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

Widget booksBuild(BuildContext context) {
  // بناء الكتب - Books Build Widget
  ColorStyle style = ColorStyle(context);

  return GetBuilder<BooksController>(
    id: 'booksWidget',
    init: BooksController.instance,
    builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0).r,
        child: Obx(() {
          if (controller.isLoading.value) {
            // حالة التحميل - Loading state
            return Center(child: bookLoading(150.0, 150.0));
          }

          if (controller.errorMessage.isNotEmpty) {
            // حالة الخطأ - Error state
            return Center(
              child: Text(
                'خطأ: ${controller.errorMessage.value}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // عرض البيانات - Display data
          final classes = controller.classes;

          return AnimationLimiter(
            child: ListView.separated(
              itemCount: classes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)).r,
                    color: (index % 2 == 0
                        ? Theme.of(context).canvasColor.withOpacity(.6)
                        : Theme.of(context).colorScheme.surface),
                  ),
                  padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0)
                      .r,
                  child: AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 450),
                    columnCount: 3,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Text(
                          classes[index].title,
                          style: TextStyle(
                              color: style.greenTextColor(),
                              fontFamily: 'naskh',
                              fontSize: 20.sp,
                              height: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  // اختيار الفئة - Select class
                  controller.selectClass(classes[index]);
                  screenModalBottomSheet(context, BooksView());
                },
              ),
            ),
          );
        }),
      );
    },
  );
}
