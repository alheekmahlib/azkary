part of '../splash.dart';

/// SplashScreen - شاشة البداية (Stateless عبر GetView)
/// Splash screen (stateless via GetView)
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor:
              ThemeController.instance.currentThemeId.value == 'dark'
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).canvasColor,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: [
                Transform.translate(
                  offset: const Offset(300, -10),
                  child: Opacity(
                    opacity: .05,
                    child: SvgPicture.asset(
                      'assets/svg/azkary.svg',
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: container(
                    context,
                    Container(),
                    false,
                    height: 150.0,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                        offset: const Offset(0, -50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            azkary_logo(
                              context,
                              width: 120.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'من الكتاب والسُّنة',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                            )
                          ],
                        ))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Transform.translate(
                      offset: orientation(
                          context, const Offset(0, 20), const Offset(0, 50)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/alheekmah_logo.svg',
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.surface,
                                BlendMode.srcIn),
                            width: 90,
                          ),
                          Transform.translate(
                            offset: const Offset(0, 20),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: loading(240.0, 170.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
