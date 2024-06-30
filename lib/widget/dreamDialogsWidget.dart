import 'package:flutter/material.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import '../methodes/pt_to_px.dart';

class MakeMyNikahDialogsWidget extends StatelessWidget {
  String lang = 'ar';
  Widget dialogContent;
  double? padRight;
  double? padTop;
  double? padLeft;
  double? padBottom;
  double? raduis;

  MakeMyNikahDialogsWidget({
    this.padRight,
    this.padTop,
    this.padLeft,
    this.padBottom,
    this.raduis,
    required this.dialogContent,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentTextStyle: TextStyle(
        fontFamily: lang == "ar"
            ? getTranslated(context, 'Ithra')
            : getTranslated(context, 'Montserrat'),
      ),
      contentPadding: EdgeInsets.only(
          right: padRight ?? convertPtToPx(AppPadding.p16.w),
          left: padLeft ?? convertPtToPx(AppPadding.p16.w),
          top: padTop ?? convertPtToPx(AppPadding.p16.h),
          bottom: padBottom ?? AppPadding.p32.h),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(raduis ?? AppRadius.r16.r),
        ),
      ),
      scrollable: true,
      elevation: 0.0,
      content: dialogContent,
    );
  }
}
