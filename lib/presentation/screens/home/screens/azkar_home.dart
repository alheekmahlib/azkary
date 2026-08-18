part of '../home.dart';

/// AzkarHome - الشاشة الرئيسية مع التبويب السفلي (Stateless عبر GetView)
/// Home screen with bottom navigation (stateless via GetView)
class AzkarHome extends GetView<NavigationController> {
  const AzkarHome({super.key});

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
            key: controller.drawerKey,
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
            ),
            slider: const SettingsList(),
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.changePage,
              children: [
                MainScreen(),
                const AzkarList(),
                NotificationsScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => StylishBottomBar(
            items: [
              BottomBarItem(
                icon: iconsAsset('home'),
                selectedIcon: iconsAsset('home'),
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text(
                  'home'.tr,
                  style: TextStyle(
                    fontSize: 12,
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
                  'athkar'.tr,
                  style: TextStyle(
                    fontSize: 12,
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
                    'notification'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'kufi',
                      color: Theme.of(context).canvasColor,
                    ),
                  )),
            ],
            hasNotch: true,
            fabLocation: StylishBarFabLocation.end,
            currentIndex: controller.selected.value,
            onTap: controller.jumpToPage,
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
