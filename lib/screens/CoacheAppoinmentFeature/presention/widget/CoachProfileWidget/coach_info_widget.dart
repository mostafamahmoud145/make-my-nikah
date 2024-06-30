import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/CoachProfileWidget/coach_image_widget.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/CoachProfileWidget/coach_rate_numcalls_price_row.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class CoacheInfoWidget extends StatelessWidget {
  final GroceryUser consultant;

  const CoacheInfoWidget({super.key, required this.consultant});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppSize.h45_3.h,
        ),
        CoachProfileImageWidget(consultant: consultant),
        SizedBox(
          height: AppSize.h10_6.h,
        ),
        Text(
          consultant.name!,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontFamily: getTranslated(context, "Montserratsemibold"),
              color: AppColors.black,
              fontSize: AppFontsSizeManager.s21_3.sp,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: AppSize.h21_3.h,
        ),
        CoachRateNumCallsPriceRow(consultant: consultant),
        SizedBox(
          height: AppSize.h42_6.h,
        ),
      ],
    );
  }
}
