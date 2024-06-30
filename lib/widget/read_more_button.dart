import 'package:flutter/material.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import 'TextButton.dart';

class ReadMoreButton extends StatelessWidget {
  final Function() onPress;

  const ReadMoreButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton1(
      onPress: onPress,
      Width: AppSize.w138_6.w,
      Height: AppSize.h42_6.h,
      Title: getTranslated(context, "readMore"),
      ButtonRadius: AppRadius.r5_3.r,
      ButtonBackground: AppColors.pink2,
      TextSize: AppFontsSizeManager.s16.sp,
      TextFont: getTranslated(context, "Montserratsemibold"),
      TextColor: AppColors.white,
      IconSpace: AppSize.w5_3.w,
      Icon: AssetsManager.readMore.toString(),
      IconColor: AppColors.white,
      IconWidth: AppSize.w21_3.w,
      IconHeight: AppSize.h21_3.h,
      Direction: TextDirection.ltr,
    );
  }
}
