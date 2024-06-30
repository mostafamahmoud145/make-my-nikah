import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class CoachRateNumCallsPriceRow extends StatelessWidget {
  final GroceryUser consultant;

  const CoachRateNumCallsPriceRow({super.key, required this.consultant});

  @override
  Widget build(BuildContext context) {
    final lang = getTranslated(context, "lang");

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  consultant.rating.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppFontsSizeManager.s18_6.sp,
                    fontFamily: getTranslated(context, "Montserratmedium"),
                  ),
                ),
                SizedBox(
                  width: AppSize.w5_3.w,
                ),
                Icon(
                  Icons.star,
                  color: Color.fromRGBO(255, 213, 8, 1),
                  size: AppSize.w16.w,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: AppSize.w21_3.w,
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  consultant.ordersNumbers.toString() + " ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppFontsSizeManager.s18_6.sp,
                    fontFamily: getTranslated(context, "Montserratmedium"),
                  ),
                ),
                SizedBox(
                  width: AppSize.w5_3.w,
                ),
                SvgPicture.asset(
                  AssetsManager.whiteSmallCallIconPath,
                  width: AppSize.w16.w,
                  height: AppSize.h16.h,
                  color: AppColors.pink2,
                  //fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: AppSize.w21_3.w,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                consultant.price.toString(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontsSizeManager.s18_6.sp,
                  fontFamily: getTranslated(context, "Montserratmedium"),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: lang == "ar" ? AppPadding.p4.h : 0),
                child: Text(
                  "\$",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontSize: AppFontsSizeManager.s18_6.sp,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
