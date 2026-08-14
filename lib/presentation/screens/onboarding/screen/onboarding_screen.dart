part of '../onboarding.dart';

/// OnboardingScreen - شاشة الترحيب (Stateless عبر GetView)
/// Onboarding screen (stateless via GetView)
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Obx(
                        () => HorizontalStepper(
                          totalStep: 4,
                          completedStep: controller.pageNumber.value,
                          selectedColor: Theme.of(context).colorScheme.surface,
                          backGroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            'تخطي',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: .4),
                              fontSize: 16.0,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0),
                          onPressed: () => Get.back(),
                        ),
                        Obx(() => controller.pageNumber.value == 4
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                  child: Text('أبدأ',
                                      style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface)),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0),
                                  onPressed: () {
                                    if (controller.pageNumber.value == 4) {
                                      Get.back();
                                    } else {
                                      controller.nextPage();
                                    }
                                  },
                                ),
                              )
                            : Align(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0),
                                  onPressed: controller.nextPage,
                                ),
                              )),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: orientation(
                      context,
                      const EdgeInsets.only(
                        top: 84.0,
                      ),
                      const EdgeInsets.only(
                        top: 60.0,
                      )),
                  child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: platformView(
                          orientation(context, images.length, images.length),
                          images.length),
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Wrap(
                            children: [
                              Center(
                                child: Container(
                                  width: platformView(
                                      MediaQuery.sizeOf(context).width / 1 / 2,
                                      MediaQuery.sizeOf(context).width /
                                          1 /
                                          2 *
                                          .8),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: ClipRRect(
                                    child: Image.asset(
                                      platformView(
                                          orientation(context, images[index],
                                              imagesL[index]),
                                          imagesD[index]),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 50,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomRight: Radius.circular(4),
                                            ))),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Text(
                                        onboardingTitle[index],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            fontSize: 18,
                                            height: 2,
                                            fontFamily: 'kufi'),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
