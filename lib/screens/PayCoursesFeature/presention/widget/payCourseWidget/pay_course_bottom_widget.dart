import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../../../../../config/app_fonts.dart';

class PayCourseBottom extends StatelessWidget {
  final Courses course;
  final dynamic Function() onPress;
  final int paidSince;
  final bool load;
  PayCourseBottom(
      {required this.course,
      required this.onPress,
      required this.paidSince,
      required this.load});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppPadding.p32.w,
        right: AppPadding.p32.w,
        top: AppPadding.p98_6.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  StringUtils.capitalize(course.title),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(32, 32, 32, 1),
                    fontSize: AppFontsSizeManager.s24.sp,
                    fontFamily: getTranslated(context, "academyFontFamily"),
                  ),
                ),
              ),
              SizedBox(
                width: AppSize.w48.w,
              ),
              if (course.price != "0")
                load
                    ? CircularProgressIndicator()
                    : paidSince != -1
                        ? Text(
                            paidSince == 0
                                ? "paid today"
                                : "paid Since: $paidSince day",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.w600,
                              fontFamily:
                                  getTranslated(context, "academyFontFamily"),
                              fontStyle: FontStyle.normal,
                              fontSize: 15,
                            ),
                          )
                        : Center(
                            child: TextButton1(
                              onPress: onPress,
                              Width: AppSize.w206_6.w,
                              Height: AppSize.h50_6.h,
                              Title: getTranslated(context, "buy") +
                                  course.price +
                                  "\$",
                              ButtonRadius: AppRadius.r10_6.r,
                              TextSize: AppFontsSizeManager.s18_6.sp,
                              GradientColor: Color.fromRGBO(207, 0, 54, 1),
                              GradientColor2: Color.fromRGBO(224, 16, 70, 1),
                              GradientColor3: Color.fromRGBO(255, 47, 101, 1),
                              TextFont:
                                  getTranslated(context, "academyFontFamily"),
                              TextColor: AppColors.white,
                            ),
                          ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsManager.outlineLayersIconPath,
                    height: AppSize.h24_6.h,
                    width: AppSize.w24_6.w,
                  ),
                  SizedBox(
                    width: AppSize.w14_6.w,
                  ),
                  Text(
                    course.videoNum.toString() + " Videos",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGrey,
                      fontSize: AppFontsSizeManager.s21_3.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
