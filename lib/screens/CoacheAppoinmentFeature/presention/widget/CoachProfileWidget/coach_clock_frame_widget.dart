import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class CoachClockFrameWidget extends StatelessWidget {
  final String time;
  const CoachClockFrameWidget({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.h45_3.h,
      width: AppSize.w138_6.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AssetsManager.timeBody,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: getTranslated(context, "Montserratsemibold"),
              color: AppColors.black,
              fontSize: AppFontsSizeManager.s18_6.sp,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
