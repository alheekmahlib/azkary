import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../books/controllers/books_controller.dart';
import '../../books/screen/books_view.dart';
import '../style.dart';
import 'lottie.dart';
import 'widgets.dart';

/// بناء الكتب - Books Widget Class
class BooksWidget extends StatelessWidget {
  const BooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // بناء الكتب - Books Build Widget
    ColorStyle style = ColorStyle(context);

    return GetBuilder<BooksController>(
      id: 'booksWidget',
      init: BooksController.instance,
      builder: (controller) {
        return Container(
          padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0).r,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8)).r,
                      color: (index % 2 == 0
                          ? Theme.of(context).canvasColor.withValues(alpha: .6)
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
                                color: index % 2 == 0
                                    ? style.greenTextColor()
                                    : Theme.of(context).canvasColor,
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
}
