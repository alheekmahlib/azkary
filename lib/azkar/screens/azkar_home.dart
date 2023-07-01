import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:husn_al_muslim/azkar/screens/azkar_fav.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../home_page.dart';
import '../../screens/azkar_list.dart';
import '../../screens/main_screen.dart';
import '../../screens/sentNotification.dart';
import '../../shared/custom_rect_tween.dart';
import '../../shared/hero_dialog_route.dart';
import '../../shared/widgets/settings_list.dart';
import '../../shared/widgets/settings_popUp.dart';
import '../../shared/widgets/widgets.dart';
import 'alzkar_view.dart';

class AzkarHome extends StatefulWidget {
  const AzkarHome({super.key});

  @override
  State<AzkarHome> createState() => _AzkarHomeState();
}

class _AzkarHomeState extends State<AzkarHome> {
  dynamic selected;
  var heart = false;
  PageController controller = PageController();


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        // body: _selectedWidget,
        body: Stack(
          children: [
            PageView(
              controller: controller,
              children: [
                MainScreen(),
                AzkarList(),
                SentNotification(),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: orientation(context,
                    const EdgeInsets.symmetric(vertical: 75.0, horizontal: 16.0),
                    const EdgeInsets.all(8.0)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        HeroDialogRoute(
                            builder: (context) {
                              return settingsPopupCard(
                                child: const SettingsList(),
                                height: orientation(context,
                                    400.0,
                                    MediaQuery.of(context).size.height * 1/2 * 1.6),
                                alignment: Alignment.topCenter,
                                padding: orientation(context,
                                    EdgeInsets.only(right: 16.0, left: 16.0),
                                    EdgeInsets.only(top: 70.0, right: width * .5, left: 16.0)),
                              );
                            }));

                  },
                  child: Hero(
                    tag: heroAddTodo,
                    createRectTween: (begin, end) {
                      return CustomRectTween(begin: begin!, end: end!);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(8)
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 1.0,
                            spreadRadius: 0.0,
                            offset: Offset(0.0, 0.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.settings,
                        size: 28,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: StylishBottomBar(
          items: [
            BottomBarItem(
              icon: const Icon(
                Icons.house_outlined,
              ),
              selectedIcon: const Icon(Icons.house_rounded),
              // selectedColor: Colors.teal,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text('الرئيسية',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            BottomBarItem(
              icon: const Icon(Icons.format_list_bulleted),
              selectedIcon: const Icon(Icons.list),
              backgroundColor: Theme.of(context).colorScheme.surface,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title: Text('الأذكار',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.surface,
                ),),
            ),
            BottomBarItem(
                icon: const Icon(
                  Icons.notifications_active_outlined,
                ),
                selectedIcon: const Icon(
                  Icons.notifications,
                ),
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text('الإشعارات',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'kufi',
                    color: Theme.of(context).colorScheme.surface,
                  ),
                )),
          ],
          hasNotch: true,
          fabLocation: StylishBarFabLocation.end,
          currentIndex: selected ?? 0,
          onTap: (index) {
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });
          },
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.animated,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          elevation: 80,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            screenModalBottomSheet(context, AzkarFav());
          },
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Icon(
            CupertinoIcons.heart,
            color: Colors.red,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}