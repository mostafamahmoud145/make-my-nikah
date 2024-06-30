import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';

Widget GmailAppleWidget(String fontFamily, String icon, String text) {
  return Container(
    height: AppSize.h64.h,
    width: AppSize.w244.w,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r8).r),
        border: Border.all(
          color: AppColors.lightGrey,
        )),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
            scale: 1.4,
            child: SvgPicture.asset(
              icon,
              height: AppSize.h32.h,
              width: AppSize.w32.w,
            )),
        SizedBox(
          width: AppSize.w10_6.w,
        ),
        Text(
          text,
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: fontFamily,
            color: AppColors.darkGrey3,
            fontSize: AppFontsSizeManager.s16.sp,
            //fontWeight: FontWeight.normal
          ),
        ),
      ],
    ),
  );
}
