import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class CoachPriceWidget extends StatelessWidget {
  final GroceryUser consultant;
  const CoachPriceWidget({super.key, required this.consultant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: AppSize.w42_6.w,
        ),
        Center(
          child: Image.asset(
            AssetsManager.visaImage,
            width: AppSize.w199_7.w,
            height: AppSize.h147_8.h,
            //fit: BoxFit.fill
          ),
        ),
        Row(children: [SizedBox(width:  265.w),Text(
          consultant.price.toString() ,
          style: TextStyle(
              fontFamily: getTranslated(context, "Montserratsemibold"),
              color: AppColors.black,
              fontWeight: FontWeight.w500,
              fontSize: AppFontsSizeManager.s33.sp),
        ),Image.asset(AssetsManager.dollar, height: AppFontsSizeManager.s29_3.h,width: AppFontsSizeManager.s29_3.w,),],),
        SizedBox(
          height: AppSize.h21_3.h,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            getTranslated(context, "bookText"),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: getTranslated(context, "Montserratmedium"),
                color: AppColors.darkGrey,
                //fontWeight: FontWeight.w400,
                fontSize: AppFontsSizeManager.s21_3.sp),
          ),
        ),
        SizedBox(
          height: AppSize.h58_8.h,
        ),
      ],
    );
  }
}
