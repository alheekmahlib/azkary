import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:husn_al_muslim/screens/splash_screen.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import '../database/notificationDatabase.dart';
import '../home_page.dart';
import '../shared/postPage.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0, bottom: 16.0, right: 16.0, left: 16.0),
        child: Column(
          children: [
            Text('الإشعارات',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'kufi',
                color: Theme.of(context).canvasColor,
              ),
            ),
            SvgPicture.asset(
              'assets/svg/space_line.svg',
              height: 30,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>> notifications = snapshot.data!;
                      return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(.2),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(notification['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'kufi',
                                  color: ThemeProvider.themeOf(context).id == 'dark'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              subtitle: Text(DateFormat('HH:mm').format(notification['timestamp']),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'kufi',
                                  color: ThemeProvider.themeOf(context).id == 'dark'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              trailing: Icon(
                                Icons.notifications_active,
                                size: 28,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              onTap: () {
                                screenModalBottomSheet(context, PostPage(postId: notification['id']));
                                  //   Navigator.of(navigatorKey.currentContext!).push(
                                  // animatNameRoute(
                                  //   pushName: '/post',
                                  //   myWidget: PostPage(postId: notification['id']),
                                  // ),
                                // );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
