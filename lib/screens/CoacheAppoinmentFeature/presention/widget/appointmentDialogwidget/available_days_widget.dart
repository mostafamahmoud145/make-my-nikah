import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/colorsFile.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'error_message.dart';

class AvailableDays extends StatelessWidget {
  final bool isGregorian;
  final bool ishijri;
  final availableHours;
  final loadDates, showDayError;
  final displayedTime;
  final void Function() onTapHijri;
  final void Function() onTapGregorian;
  final void Function() onTapselectDay;
  const AvailableDays(
      {super.key,
      required this.isGregorian,
      required this.ishijri,
      required this.onTapHijri,
      required this.onTapGregorian,
      required this.onTapselectDay,
      this.availableHours,
      this.loadDates,
      this.showDayError,
      this.displayedTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: AppPadding.p32.h,
            horizontal: AppPadding.p21_3.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Color.fromRGBO(211, 211, 211, 1),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getTranslated(context, "selectSuitableDay"),
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontFamily:getTranslated(context, "Montserratsemibold") ,
                  fontSize: AppFontsSizeManager.s21_3.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: convertPtToPx(AppSize.h24).h,
              ),
              Container(
                height: convertPtToPx(AppSize.h54.h),
                padding: EdgeInsets.all(convertPtToPx(AppPadding.p8).w),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 247, 247, 1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: AppColors.green.withOpacity(0.6),
                        onTap: onTapGregorian,
                        child: Container(
                          alignment: Alignment.center,
                          height: convertPtToPx(AppSize.h38).h,
                          width: convertPtToPx(AppSize.w166_6).w,
                          decoration: BoxDecoration(
                            color: isGregorian
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                          ),
                          child: Text(
                            getTranslated(context, "gregorian"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Montserratsemibold"),
                              fontWeight: AppFontsWeightManager.semiBold,
                              color: isGregorian
                                  ? AppColors.white
                                  : Theme.of(context).primaryColor,
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s16).sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSize.w15.w,
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: AppColors.green.withOpacity(0.6),
                        onTap: onTapHijri,
                        child: Container(
                          alignment: Alignment.center,
                          height: convertPtToPx(AppSize.h38).h,
                          width: convertPtToPx(AppSize.w166_6).w,
                          decoration: BoxDecoration(
                            color: ishijri
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.r5),
                          ),
                          child: Text(
                            getTranslated(context, "hijri"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Montserratsemibold"),
                              fontWeight: AppFontsWeightManager.semiBold,
                              color: ishijri
                                  ? AppColors.white
                                  : Theme.of(context).primaryColor,
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s16).sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: convertPtToPx(AppSize.h24).h,
              ),
              Container(
                height: convertPtToPx(AppSize.h50).h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 247, 247, 1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: convertPtToPx(AppPadding.p16).w,
                  ),
                  child: InkWell(
                    splashColor: AppColors.white.withOpacity(0.6),
                    onTap: onTapselectDay,
                    child: Row(
                      children: [
                        Text(
                          displayedTime ?? getTranslated(context, 'selectDay'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: getTranslated(context, "Montserratsemibold"),
                            color: Color.fromRGBO(207, 0, 54, 1),
                            fontWeight: AppFontsWeightManager.semiBold,
                            fontSize: convertPtToPx(AppFontsSizeManager.s16).sp,
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          AssetsManager.calendarClockIconPath,
                          color: Color.fromRGBO(207, 0, 54, 1),
                          height: convertPtToPx(AppSize.w24).r,
                          width: convertPtToPx(AppSize.w24).r,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// error message when the user does not select the day.
        ///
        if (showDayError && loadDates == false)
          ErrorMessage(
            errorMessage: getTranslated(context, 'selectSuitableDay'),
            buttomPadding: 0.0,
          ),

        /// Available Hours
        availableHours(),
      ],
    );
  }
}
