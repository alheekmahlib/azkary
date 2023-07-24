import 'package:Azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../database/notificationDatabase.dart';
import '../home_page.dart';
import '../shared/postPage.dart';
import '../shared/style.dart';
import '../shared/widgets/lottie.dart';
import '../shared/widgets/widgets.dart';

class SentNotification extends StatefulWidget {
  const SentNotification({super.key});

  @override
  State<SentNotification> createState() => _SentNotificationState();
}

class _SentNotificationState extends State<SentNotification> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var homePage = HomePage.of(context);
    //   if(homePage != null) {
    //     homePage.updateNotificationStatus();
    //   } else {
    //     print("HomePage context not found"); // Log error or handle accordingly
    //   }
    // });
    updateNotificationStatus();
    loadNotifications();
    super.initState();
  }

  updateNotificationStatus() {
    setState(() {
      for (var notification in sentNotifications) {
        notification['opened'] = true;
      }
    });
  }

  Future<List<Map<String, dynamic>>> loadNotifications() async {
    final dbHelper = NotificationDatabaseHelper.instance;
    final notifications = await dbHelper.queryAllRows();

    return notifications.map((notification) {
      return {
        'id': notification['id'],
        'title': notification['title'],
        'timestamp': notification['timestamp'] != null
            ? DateTime.parse(notification['timestamp'])
            : DateTime.now(), // Set to the current time if null
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ColorStyle colorStyle = ColorStyle(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0).r,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ).r,
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0).r,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.notification,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              SvgPicture.asset(
                'assets/svg/space_line.svg',
                height: 30.h,
              ),
              SizedBox(
                height: 16.0.h,
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return bookLoading(200.0.w, 200.0.h);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>> notifications = snapshot.data!;
                      return ListView.builder(
                        itemCount: notifications.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return Container(
                            height: 60.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  notification['title'],
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'kufi',
                                    color: colorStyle.greenTextColor(),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('HH:mm')
                                    .format(notification['timestamp']),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'kufi',
                                  color: colorStyle.greenTextColor(),
                                ),
                              ),
                              trailing: Icon(
                                Icons.notifications_active,
                                size: 24.h,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              onTap: () {
                                screenModalBottomSheet(context,
                                    PostPage(postId: notification['id']));
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
