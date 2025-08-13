import 'package:flutter/material.dart';
import 'package:horizontal_stepper_step/horizontal_stepper_step.dart';

import '../widgets/lists.dart';
import '../widgets/widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  int? pageNumber;
  double indicatorProgress = .0;
  bool progress = true;

  indicator(int pageNumber) {
    if (pageNumber == 0) {
      indicatorProgress = .0;
    } else if (pageNumber == 1) {
      indicatorProgress = .33;
    } else if (pageNumber == 2) {
      indicatorProgress = .66;
    } else if (pageNumber == 3) {
      indicatorProgress = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                      child: HorizontalStepper(
                        totalStep: 4,
                        completedStep: pageNumber ?? 1,
                        selectedColor: Theme.of(context).colorScheme.surface,
                        backGroundColor:
                            Theme.of(context).colorScheme.secondary,
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        pageNumber == 4
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
                                    if (pageNumber == 4) {
                                      Navigator.pop(context);
                                    } else {
                                      controller.animateToPage(
                                          controller.page!.toInt() + 1,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeIn);
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
                                  onPressed: () {
                                    controller.animateToPage(
                                        controller.page!.toInt() + 1,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeIn);
                                  },
                                ),
                              ),
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
                      controller: controller,
                      itemCount: platformView(
                          orientation(context, images.length, images.length),
                          images.length),
                      onPageChanged: (page) {
                        setState(() {
                          pageNumber = page + 1;
                          indicator(page);
                        });
                      },
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
