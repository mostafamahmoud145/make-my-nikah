import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';

class PermissionTitleWidget extends StatelessWidget {
  const PermissionTitleWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SvgPicture.asset(
        icon,
        width: AppSize.w32.r,
        height: AppSize.h32.r,
        color: AppColors.cherry,
      ),
      SizedBox(
        width: AppSize.w16.w,
      ),
      Text(
        getTranslated(context, title),
        style: TextStyle(
            fontFamily: getTranslated(context, "Ithra"),
            fontSize: AppFontsSizeManager.s21_3.sp,
            color: AppColors.black,
            fontWeight: AppFontsWeightManager.bold500),
      )
    ]);
  }
}
