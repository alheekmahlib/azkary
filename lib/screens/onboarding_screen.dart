import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';
import '../azkar/screens/azkar_home.dart';
import '../shared/lists.dart';
import '../shared/widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  int? pageNumber;
  double indicatorProgress = .25;
  bool progress = true;

  indicator(int pageNumber){
    if (pageNumber == 0){
        indicatorProgress = .25;
    } else if (pageNumber == 1){
        indicatorProgress = .50;
    } else if (pageNumber == 2){
        indicatorProgress = .75;
    } else if (pageNumber == 3){
        indicatorProgress = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Padding(
                padding: orientation(context,
                    const EdgeInsets.only(top: 84.0,),
                    const EdgeInsets.only(top: 60.0,)),
                child: PageView.builder(
                    controller: controller,
                    itemCount: platformView(
                        orientation(context, images.length, images.length),
                        images.length),
                    onPageChanged: (page) {
                      setState(() {
                        pageNumber = page;
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
                                    MediaQuery.of(context).size.width / 1 / 2,
                                    MediaQuery.of(context).size.width / 1 / 2 * .8),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: ClipRRect(
                                  child: Image.asset(
                                    platformView(
                                        orientation(context, images[index], imagesL[index]),
                                        imagesD[index]),
                                  ),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(4),
                                        bottomRight: Radius.circular(4),
                                      )
                                    )
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      onboardingTitle[index],
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).colorScheme.surface,
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
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  child: const Text(
                    'تخطي',
                    style: TextStyle(
                      color: Color(0xff91a57d),
                      fontSize: 18.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, elevation: 0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              pageNumber == 3
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          child: SquarePercentIndicator(
                            height: 70,
                            width: 70,
                            startAngle: StartAngle.topRight,
                            // reverse: true,
                            borderRadius: 8,
                            shadowWidth: 7,
                            progressWidth: 7,
                            shadowColor: Colors.grey,
                            progressColor: Theme.of(context).primaryColorDark,
                            progress: indicatorProgress,
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Color(0xff91a57d),
                              ),
                              child: Center(
                                child: Text('أبدأ',
                                    style: TextStyle(
                                        fontFamily: 'kufi',
                                        fontSize: 20,
                                        color: Theme.of(context).canvasColor)),
                              ),
                            ),
                          ),
                          onTap: () {
                            if (pageNumber == 3) {
                              Navigator.pop(context);
                            } else {
                              controller.animateToPage(
                                  controller.page!.toInt() + 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            }
                          },
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          child: SquarePercentIndicator(
                            height: 60,
                            width: 60,
                            startAngle: StartAngle.topRight,
                            // reverse: true,
                            borderRadius: 8,
                            shadowWidth: 7,
                            progressWidth: 7,
                            shadowColor: Colors.grey.shade500,
                            progressColor: Theme.of(context).primaryColorDark,
                            progress: indicatorProgress,
                            child: Container(
                              height: 50,
                              width: 60,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Color(0xff91a57d),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Color(0xfff3efdf),
                              ),
                            ),
                          ),
                          onTap: () {
                            controller.animateToPage(
                                controller.page!.toInt() + 1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
