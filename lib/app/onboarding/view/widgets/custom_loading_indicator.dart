import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  List<Color>? colors;
  CustomLoadingIndicator({Key? key, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: AppSize.h30_6.h,
      width: AppSize.w30_6.w,
      child: LoadingIndicator(
        indicatorType: Indicator.lineSpinFadeLoader,

        /// Required, The loading type of the widget
        colors: colors ?? [AppColors.linear2],

        /// Optional, The color collections
        strokeWidth: 1,
      ),
    ));
  }
}
