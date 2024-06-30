import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../../../../config/app_fonts.dart';

class PayButtomWidget extends StatelessWidget {
  const PayButtomWidget({
    super.key,
    required this.onPressed,
  });
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton1(
          onPress: onPressed,
          Width: AppSize.w446_6.w,
          Height: AppSize.h66_6.h,
          Title: getTranslated(context, "addBalance"),
          ButtonRadius: AppRadius.r10_6.r,
          TextSize: AppFontsSizeManager.s21_3.sp,
          ButtonBackground: AppColors.pink2,
          TextFont: getTranslated(context, "Montserratsemibold"),
          TextColor: AppColors.white),
    );
  }
}
