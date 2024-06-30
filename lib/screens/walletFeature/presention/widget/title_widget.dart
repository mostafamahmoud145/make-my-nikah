import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class StripTitleWidget extends StatelessWidget {
  final String title;
  const StripTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.h21_3.h, bottom: AppSize.h26_6.h),
      child: Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: getTranslated(context, "Montserratsemibold"),
            fontSize: AppFontsSizeManager.s21_3.sp,
            color: AppColors.pink2,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}

class AddBalanceText extends StatelessWidget {
  const AddBalanceText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p18_6.w),
      child: Text(
        getTranslated(context, "addBalanceText"),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 6,
        style: TextStyle(
            fontFamily: getTranslated(context, "Montserrat"),
            fontSize: AppFontsSizeManager.s21_3.sp,
            color: AppColors.chatTime),
      ),
    );
  }
}
