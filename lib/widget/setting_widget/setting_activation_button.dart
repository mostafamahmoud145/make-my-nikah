import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/screens/walletFeature/utils/custom_widgets_for_payment_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/app_fonts.dart';

class SettingActivationButton extends StatelessWidget {
  const SettingActivationButton({
    super.key,
    this.function,
  });

  final function;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      buttonRadius: AppRadius.r5_3.r,
      color: AppColors.cherry,
      //width: AppSize.w116.w,
      horizontal: AppSize.w5.w,
      height: AppSize.h45_3.h,
      onPress: function,
      textSize: AppFontsSizeManager.s18_6.sp,
      text: getTranslated(context, "GrantOfPermission"),
    );
  }
}
