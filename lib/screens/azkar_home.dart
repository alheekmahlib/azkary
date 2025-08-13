import '/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../widgets/local_notification/notification_screen.dart';
import '../widgets/widgets/azkar_fav.dart';
import '../widgets/widgets/settings_list.dart';
import '../widgets/widgets/svg_picture.dart';
import '../widgets/widgets/widgets.dart';
import 'azkar_list.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class AzkarHome extends StatefulWidget {
  const AzkarHome({super.key});

  @override
  State<AzkarHome> createState() => _AzkarHomeState();
}

class _AzkarHomeState extends State<AzkarHome> {
  int selected = 0;
  var heart = false;
  PageController controller = PageController();
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();

  @override
  void initState() {
    onboarding();
    super.initState();
  }

  void onboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('is_first_time ${prefs.getBool("is_first_time")}');
    if (prefs.getBool("is_first_time") == null) {
      await Future.delayed(const Duration(seconds: 2));
      screenModalBottomSheet(
        context,
        OnboardingScreen(),
      );
      prefs.setBool("is_first_time", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    bool isNeedSafeArea = MediaQuery.viewPaddingOf(context).bottom > 0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        extendBody: false,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Padding(
          padding: orientation(
              context,
              isNeedSafeArea
                  ? const EdgeInsets.only(top: 64.0)
                  : const EdgeInsets.only(top: 16.0),
              const EdgeInsets.symmetric(horizontal: 32.0)),
          child: SliderDrawer(
            key: _key,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            slideDirection: orientation(context, SlideDirection.topToBottom,
                SlideDirection.leftToRight),
            sliderOpenSize: platformView(
                orientation(
                    context, height / 1 / 2 * 1.1, height / 1 / 2 * 1.7),
                height / 1 / 2 * 1.1),
            isDraggable: true,
            appBar: SliderAppBar(
              config: SliderAppBarConfig(
                title: azkary_icon(
                  context,
                  width: 60.0,
                ),
                splashColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
                drawerIconColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              // trailing: Container(
              //     alignment: Alignment.centerRight,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)
              //             .r,
              //     // width: MediaQuery.sizeOf(context).width,
              //     decoration: BoxDecoration(
              //         color: Theme.of(context).colorScheme.secondary,
              //         borderRadius: const BorderRadius.only(
              //           topLeft: Radius.circular(8),
              //           topRight: Radius.circular(8),
              //         )),
              //     child: greeting(context)),
            ),
            slider: const SettingsList(),
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  selected = index;
                });
                print('selected $selected');
              },
              children: [
                const MainScreen(),
                const AzkarList(),
                NotificationsScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: StylishBottomBar(
          items: [
            BottomBarItem(
              icon: iconsAsset('home'),
              selectedIcon: iconsAsset('home'),
              // selectedColor: Colors.teal,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                AppLocalizations.of(context)!.home,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'kufi',
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
            BottomBarItem(
              icon: iconsAsset('bookList'),
              selectedIcon: iconsAsset('bookList'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                AppLocalizations.of(context)!.athkar,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'kufi',
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
            BottomBarItem(
                icon: iconsAsset('notification'),
                selectedIcon: iconsAsset('notification'),
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text(
                  AppLocalizations.of(context)!.notification,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'kufi',
                    color: Theme.of(context).canvasColor,
                  ),
                )),
          ],
          hasNotch: true,
          fabLocation: StylishBarFabLocation.end,
          currentIndex: selected,
          onTap: (index) {
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });
          },
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.liquid,
            iconStyle: IconStyle.animated,
          ),
          backgroundColor:
              Theme.of(context).colorScheme.surface.withValues(alpha: .6),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          elevation: 80,
        ),
        floatingActionButton: SizedBox(
          height: 40.h,
          width: 40.h,
          child: FloatingActionButton(
            onPressed: () {
              screenModalBottomSheet(context, AzkarFav());
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              CupertinoIcons.heart,
              color: Colors.red,
              size: 24.h,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
