import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class TextTitleWithFram extends StatelessWidget {
  const TextTitleWithFram({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final lang = getTranslated(context, "lang");

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        lang == "ar"
            ? SvgPicture.asset(
                AssetsManager.goldHeader2IconPath,
                height: AppSize.h21_3.h,
                width: AppSize.w8_3.w,
              )
            : SvgPicture.asset(
                AssetsManager.goldHeader1IconPath,
                height: AppSize.h21_3.h,
                width: AppSize.w8_3.w,
              ),
        SizedBox(
          width: AppSize.w16.w,
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: getTranslated(context, "Montserratsemibold"),
            color: AppColors.blackColor,
            fontSize: AppFontsSizeManager.s21_3.sp,
          ),
        ),
        SizedBox(
          width: AppSize.w16.w,
        ),
        lang == "ar"
            ? SvgPicture.asset(
                AssetsManager.goldHeader1IconPath,
                height: AppSize.h21_3.h,
                width: AppSize.w8_3.w,
              )
            : SvgPicture.asset(
                AssetsManager.goldHeader2IconPath,
                height: AppSize.h21_3.h,
                width: AppSize.w8_3.w,
              ),
      ],
    );
  }
}
