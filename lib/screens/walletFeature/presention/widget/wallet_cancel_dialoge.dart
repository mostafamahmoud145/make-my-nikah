
  import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import '../../../../config/app_values.dart';
import 'package:grocery_store/widget/resopnsive.dart';

  cantAddingDialog(context,{required String data,required bool status}) {
    return showDialog(
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: AppColors.white),),

        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppRadius.r21_3.r),
            ),
          ),
          elevation: 5.0,
          contentPadding: EdgeInsets.only(
              left: AppPadding.p32.w,
              right: AppPadding.p32.w,
              top: AppPadding.p32.h,
              bottom: AppPadding.p32.h),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(AssetsManager.closeIcon,width: AppSize.w21.w,height: AppSize.h21.h,),
                  ),
                ],
              ),
              Text(
                getTranslated(context, "errorTxt"),
                style: TextStyle(
                  fontFamily: getTranslated(context, 'Montserratsemibold'),
                  fontSize: AppFontsSizeManager.s29_3.sp,
                  color: AppColors.dark_red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppSize.h16.h,
              ),
              Text(
                data,
                style: TextStyle(
                  fontFamily: getTranslated(context, 'Montserratmedium'),
                  fontSize: AppFontsSizeManager.s21_3.sp,
                  color: AppColors.black1,
                  letterSpacing: AppConstants.letterSpacing0_3,
                  fontWeight: AppFontsWeightManager.bold300,
                  fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Row(
                children: [

                  Center(
                    child: Container(
                      width: AppSize.w186_6.w,
                      height: AppSize.h56.h,
                      //   alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.dark_red,
                        borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            getTranslated(context, 'tryAgainTxt'),
                            style: TextStyle(
                              fontFamily: getTranslated(context, 'Montserratbold'),
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: AppConstants.letterSpacing0_3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppSize.w21_3.w,
                  ),
                  Center(
                    child: Container(
                      width: AppSize.w186_6.w,
                      height: AppSize.h56.h,
                      //   alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                        border: Border.all(
                          color: AppColors.dark_red,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            getTranslated(context, 'cancel'),
                            style: TextStyle(
                              fontFamily: getTranslated(context, 'Montserratbold'),
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              color: AppColors.dark_red,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: AppConstants.letterSpacing0_3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }
