import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../azkar/models/all_azkar.dart';
import '../../azkar/screens/azkar_item.dart';
import '../../core/controllers/azkary_controller.dart';
import '../style.dart';
import 'widgets.dart';

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
