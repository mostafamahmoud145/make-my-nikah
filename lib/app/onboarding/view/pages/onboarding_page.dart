import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/app/onboarding/data/onboarding_model.dart';
import 'package:grocery_store/app/onboarding/view/widgets/custom_action_forward_button.dart';
import 'package:grocery_store/app/onboarding/view/widgets/custom_loading_indicator.dart';
import 'package:grocery_store/app/onboarding/view/widgets/firebase_video_player.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';

import 'dart:math' as math;

import '../../../../localization/localization_methods.dart';

// Construct Dots Indicator
class OnBoardingPageArgs {
  const OnBoardingPageArgs();
}

/// #### Widget for displaying onboarding screens.
///
/// This widget displays onboarding screens to introduce users to the app.
///
/// Required parameters:
/// - [args]: Arguments for the onboarding page.
///
/// Example usage:
/// ```dart
/// OnBoardingPage(
///   args: OnBoardingPageArgs(),
/// );
/// ```
class OnBoardingPage extends StatefulWidget {
  static const String routeName = '/on_boarding_screen';

  ///
  final OnBoardingPageArgs args;

  const OnBoardingPage(this.args, {Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  // declare and initialize the page controllers
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);

  // the index of the current page
  int _activePage = 0;

  int currentIndex = 0;
  late int itemCount;
  List<OnBoardingModel> onBoardingList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchOnBoardingData());
  }

  Future<void> fetchOnBoardingData() async {
    DocumentReference docRef2 =
        FirebaseFirestore.instance.collection("OnBoarding").doc('ar');
    final DocumentSnapshot documentSnapshot = await docRef2.get();
    var pagesArray = documentSnapshot.get('pages') as List;
    for (var page in pagesArray) {
      onBoardingList
          .add(OnBoardingModel.fromJson(page as Map<String, dynamic>));
    }
    if (onBoardingList.isNotEmpty) {
      setState(() {
        loading = false;
        itemCount = onBoardingList.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: AppSize.h66_6.h),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 2.5.r,

            //transform: GradientRotation(250),
            stops: [
              0.1,
              0.3,
              0.4,
              0.5,
              0.6,
              0.8,
              0.85,
              1,
              0.95,
            ],
            colors: [
              Color.fromARGB(121, 243, 143, 170).withOpacity(0.2),
              Colors.white,
              Colors.white,
              Color.fromARGB(121, 243, 143, 170).withOpacity(0.2),
              Color.fromARGB(121, 243, 143, 170).withOpacity(0.2),
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        height: double.infinity,
        child: Column(
          children: [
            Container(
              width: size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  right: AppSize.h32.w,
                  left: AppSize.h32.w,
                  top: AppSize.h16.h,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      currentIndex > 0
                          ? CustomActionForwardButton(
                              onPressed: () {
                                setState(() {
                                  currentIndex--;
                                  _pageController.animateToPage(currentIndex,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                });
                              },
                            )
                          : SizedBox(),
                      TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                              context,
                              '/home',
                              arguments: {
                                'userType': "CLIENT",
                              },
                            );
                          },
                          child: Text(
                            getTranslated(context, "skip"),
                            style: TextStyle(
                                fontFamily: getTranslated(context, "Ithra"),
                                color: AppColors.black,
                                fontSize: AppSize.h25_3.sp,
                                fontWeight: AppFontsWeightManager.bold700),
                          ))
                    ]),
              ),
            ),
            SizedBox(
              height: AppSize.h66_6.h,
            ),
            loading
                ? CustomLoadingIndicator()
                : Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: PageView.builder(
                              controller: _pageController,
                              physics: NeverScrollableScrollPhysics(),
                              onPageChanged: (int page) {
                                setState(() {
                                  _activePage = page;
                                });
                              },
                              itemCount: itemCount,
                              itemBuilder: (BuildContext context, int index) {
                                return PageContent(onBoardingList[index],
                                    _activePage != index);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: AppSize.h32.h,
            ),
          ],
        ),
      ),
    );
  }

  /// #### Constructs the content for an individual onboarding page.
  ///
  /// This method takes an [OnBoardingModel] item representing the data for the
  /// onboarding page and constructs the UI layout to display its content.
  /// The content includes an image, progress indicators, title, and body text.
  ///
  Widget PageContent(OnBoardingModel item, bool isSecondary) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure space between top and bottom elements
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            FirebaseVideoPlayerWidget(item.image, isSecondary),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSize.h90.r)),
            padding: EdgeInsets.all(AppPadding.p25.r),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(90.w, 90.w),
                  painter: _StepIndicatorPainter(
                    itemCount: itemCount,
                    currentIndex: currentIndex,
                  ),
                ),
                Container(
                  height: AppSize.h70.w,
                  width: AppSize.h70.w,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        currentIndex++;
                        if (currentIndex == itemCount) {
                          Navigator.popAndPushNamed(
                            context,
                            '/home',
                            arguments: {
                              'userType': "CLIENT",
                            },
                          );
                        } else {
                          _pageController.animateToPage(currentIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        }
                      });
                    },
                    child: Container(
                        height: AppSize.h70.w,
                        width: AppSize.h70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.GradientColor1,
                              AppColors.GradientColor2,
                            ],
                          ),
                        ),
                        child: Icon(
                          getTranslated(context, "lang") == "ar"
                              ? Icons.arrow_back_ios_new
                              : Icons.arrow_forward_ios,
                          size: AppSize.h25.w,
                        )),
                    shape: CircleBorder(),
                  ),
                ),
                Positioned(
                  top: AppSize.h126.h,
                  child: Text(
                    item.title,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: getTranslated(context, 'Ithra'),
                      color: AppColors.black,
                      fontSize: AppSize.h26_6.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.h21_3.h), // Add some spacing if needed

        ],
      ),
    );
  }
}

/// #### A custom painter for drawing a step indicator with a gradient effect.
///
/// This class extends [CustomPainter] and is responsible for painting the step
/// indicator on a canvas. It takes the number of items (steps) and the current
/// index as input and draws the indicator accordingly.
///
/// The indicator consists of segments representing each step, with a gradient
/// effect applied to show progress. The gradient colors are defined by two
/// colors specified in the [gradient] property.
///
class _StepIndicatorPainter extends CustomPainter {
  final int itemCount;
  final int currentIndex;

  _StepIndicatorPainter({required this.itemCount, required this.currentIndex});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 3.5;
    double gapSize = 2 * math.pi / 600; // Gap size between segments
    double segmentSize = (2 * math.pi - gapSize * itemCount) / itemCount;

    // Define the gradient colors and stops for two colors
    final Gradient gradient = LinearGradient(
      colors: [
        AppColors.GradientColor1,
        AppColors.GradientColor2,
      ], // Two gradient colors
    );

    // Create the Shader from the gradient and the bounds of the canvas
    final Rect arcRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - strokeWidth,
      height: size.height - strokeWidth,
    );
    final Shader shader = gradient.createShader(arcRect);

    Paint inactivePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint activePaint = Paint()
      ..shader = shader // Use shader for gradient effect
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < itemCount; i++) {
      // Use the active paint with gradient for the active segments
      Paint paint = (i <= currentIndex) ? activePaint : inactivePaint;

      canvas.drawArc(
        arcRect,
        -math.pi / 2 + i * (segmentSize + gapSize),
        segmentSize,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StepIndicatorPainter oldDelegate) {
    return oldDelegate.currentIndex != currentIndex ||
        oldDelegate.itemCount != itemCount;
  }
}
