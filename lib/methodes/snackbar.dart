import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';

showUpdatedAccountSnackBar(context){
  return  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: AppColors.snackBarColor,
      behavior: SnackBarBehavior.floating,
      width: AppSize.w506_6.w,
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(AppRadius.r10_6.r))),
      content: Container(
        height: AppSize.h72.h,
        child: Row(
          children: [
            SvgPicture.asset(
              AssetsManager.checkCircleIconPath,
              width: AppSize.w30.w,
              height: AppSize.h30.h,
              color: AppColors.white,
            ),
            SizedBox(
              width: AppSize.w21_3.w,
            ),
            Text(
              getTranslated(context, "accountUpdatedTxt"),
              style: TextStyle(
                fontFamily:
                getTranslated((context), "Montserratsemibold"),
                fontSize: AppFontsSizeManager.s21_3.sp,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}