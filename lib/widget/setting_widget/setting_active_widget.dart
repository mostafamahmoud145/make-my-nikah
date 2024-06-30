import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/app_fonts.dart';

class SettingActiveWidget extends StatelessWidget {
  const SettingActiveWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: AppPadding.p13_3.w),
      height: AppSize.h45_3.r,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.greenAccent1,
                borderRadius: BorderRadius.circular(AppRadius.r16.r)),
            height: AppSize.h14_6.r,
            width: AppSize.h14_6.r,
          ),
          SizedBox(
            width: AppSize.w10_6.w,
          ),
          Center(
            child:Text(
          getTranslated(context, "Harness"),
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: AppFontsSizeManager.s21_3.sp,
    color: AppColors.black,
    fontWeight: AppFontsWeightManager.bold500),
          ),
    )]
      ),
    );
  }
}
