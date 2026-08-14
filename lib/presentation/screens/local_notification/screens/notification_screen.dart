import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../l10n/app_localizations.dart';
import '../style.dart';
import 'controller/local_notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});
  final notiCtrl = LocalNotificationsController.instance;

  @override
  Widget build(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Container(
        padding: const EdgeInsets.only(top: 16.0),
        margin: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0).r,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.notification,
                style: TextStyle(
                  color: colorStyle.greenTextColor(),
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Gap(32),
              Flexible(
                child: GetBuilder<LocalNotificationsController>(
                  builder: (notiCtrl) => notiCtrl.postsList.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              const Gap(32),
                              Text(
                                'noNotifications'.tr,
                                style: TextStyle(
                                  color: colorStyle.greenTextColor(),
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Flexible(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0.w,
                                ),
                                itemCount: notiCtrl.postsList.length,
                                itemBuilder: (context, index) {
                                  var reversedList =
                                      notiCtrl.postsList.reversed.toList();
                                  var noti = reversedList[index];
                                  return noti.appName == 'azkary'
                                      ? ExpansionTile(
                                          backgroundColor: Colors.transparent,
                                          collapsedBackgroundColor:
                                              Colors.transparent,
                                          onExpansionChanged: (_) => notiCtrl
                                              .markNotificationAsRead(noti.id),
                                          title: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: noti.opened
                                                  ? Theme.of(context)
                                                      .primaryColorDark
                                                      .withValues(alpha: .1)
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withValues(alpha: .15),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8)),
                                              border: Border.all(
                                                width: 1,
                                                color: noti.opened
                                                    ? Colors.transparent
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  noti.title,
                                                  style: TextStyle(
                                                    color: colorStyle
                                                        .greenTextColor(),
                                                    fontFamily: 'kufi',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          children: <Widget>[
                                            Text(
                                              noti.title,
                                              style: TextStyle(
                                                color:
                                                    colorStyle.greenTextColor(),
                                                fontFamily: 'kufi',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                            const Divider(),
                                            const Gap(16),
                                            Text(
                                              noti.body,
                                              style: TextStyle(
                                                color:
                                                    colorStyle.greenTextColor(),
                                                fontFamily: 'kufi',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const Gap(32),
                                            noti.isLottie &&
                                                    noti.lottie.isNotEmpty
                                                ? Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor
                                                          .withValues(
                                                              alpha: .15),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8)),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                      ),
                                                    ),
                                                    child: Lottie.network(
                                                      noti.lottie,
                                                      width: Get.width * .5,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const CircularProgressIndicator
                                                              .adaptive(),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            const Gap(32),
                                            noti.isImage &&
                                                    noti.image.isNotEmpty
                                                ? Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor
                                                          .withValues(
                                                              alpha: .15),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8)),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                      ),
                                                    ),
                                                    child: Image.network(
                                                      noti.image,
                                                      width: Get.width * .5,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const CircularProgressIndicator
                                                              .adaptive(),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            const Gap(16),
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                },
                              ),
                            )
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
