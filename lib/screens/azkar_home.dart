import 'package:Azkary/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../shared/widgets/azkar_fav.dart';
import '../shared/widgets/settings_list.dart';
import '../shared/widgets/widgets.dart';
import 'azkar_list.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';
import 'sentNotification.dart';

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
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: orientation(
              context,
              isNeedSafeArea
                  ? const EdgeInsets.only(top: 64.0)
                  : const EdgeInsets.only(top: 16.0),
              const EdgeInsets.symmetric(horizontal: 32.0)),
          child: SliderDrawer(
            key: _key,
            splashColor: Theme.of(context).colorScheme.background,
            slideDirection: orientation(context, SlideDirection.TOP_TO_BOTTOM,
                SlideDirection.LEFT_TO_RIGHT),
            sliderOpenSize: platformView(
                orientation(
                    context, height / 1 / 2 * 1.1, height / 1 / 2 * 1.7),
                height / 1 / 2 * 1.1),
            isCupertino: true,
            isDraggable: true,
            appBar: SliderAppBar(
              appBarColor: Theme.of(context).colorScheme.background,
              appBarPadding: const EdgeInsets.symmetric(horizontal: 16.0).r,
              drawerIconColor: Theme.of(context).colorScheme.secondary,
              drawerIcon: IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 24.h,
                  color: Theme.of(context).colorScheme.surface,
                ),
                onPressed: () => _key.currentState?.toggle(),
              ),
              appBarHeight: 40.h,
              title: Container(),
              trailing: Container(
                  alignment: Alignment.centerRight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)
                          .r,
                  // width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      )),
                  child: greeting(context)),
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
                const SentNotification(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: StylishBottomBar(
          items: [
            BottomBarItem(
              icon: Opacity(
                  opacity: selected == 0 ? 1 : .5, child: iconsAsset('home')),
              selectedIcon: iconsAsset('home'),
              // selectedColor: Colors.teal,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                AppLocalizations.of(context)!.home,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            BottomBarItem(
              icon: Opacity(
                  opacity: selected == 1 ? 1 : .5,
                  child: iconsAsset('bookList')),
              selectedIcon: iconsAsset('bookList'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                AppLocalizations.of(context)!.athkar,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            BottomBarItem(
                icon: Opacity(
                    opacity: selected == 2 ? 1 : .5,
                    child: iconsAsset('notification')),
                selectedIcon: iconsAsset('notification'),
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text(
                  AppLocalizations.of(context)!.notification,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'kufi',
                    color: Theme.of(context).colorScheme.surface,
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
          backgroundColor: Theme.of(context).colorScheme.background,
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
            backgroundColor: Theme.of(context).colorScheme.background,
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
