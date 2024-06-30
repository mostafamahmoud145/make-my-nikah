import 'package:flutter/material.dart';


extension Responsive on num{
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double mobileWidth = 574.0;
  static double mobileHeight = 1234.0;
  static double webWidth = 1920.0;
  static double webHeight = 1074.0;
  static double maxMobileWidth = 570.0;

  static void init(BuildContext context) {
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
  }

  double get w {
    double appropriateWidth = screenWidth >= maxMobileWidth ? webWidth : mobileWidth;
    return (this / appropriateWidth) * screenWidth;
  }
  double get h {
    double appropriateHeight = screenHeight >= maxMobileWidth ? webHeight : mobileHeight;
    return (this / appropriateHeight) * screenHeight;
  }
  double get sp {
    double appropriateHeight = screenWidth >= maxMobileWidth ? webWidth : mobileWidth;
    return (this / appropriateHeight) * screenWidth ;
  }

  double get r {
    double appropriateHeight = screenWidth >= maxMobileWidth ? webWidth : mobileWidth;
    return (this / appropriateHeight) * screenWidth;
  }
}