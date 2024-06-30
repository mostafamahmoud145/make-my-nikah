import 'package:flutter/material.dart';

import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import '../widget/dreamDialogsWidget.dart';

showPermissionsDialog(
    {required context,
    required String text,
    required String buttonTitle,
    required Function function,
    required Function refusedFunction}) {
  return showDialog(
    context: context,
    builder: (context) => MakeMyNikahDialogsWidget(
      raduis: AppRadius.r21_3.w,
      padBottom: 0,
      padTop: 0,
      padLeft: 0,
      padRight: 0,
      dialogContent: Container(
        width: AppSize.w441_3.w,
        padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p32.w, vertical: AppPadding.p32.h),
        // height: AppSize.h292.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    AssetsManager.black_cancel_iconPath,
                    width: AppSize.w32.w,
                    height: AppSize.h32.h,
                  ),
                )
              ],
            ),
            SizedBox(height: AppSize.h1_3.h),
            Container(
              //color: Colors.red,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: AppSize.h2.h,
                  overflow: TextOverflow.clip,

                  // fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontFamily: getTranslated(context, 'Ithra'),
                  color: AppColors.black4,
                  fontSize: AppFontsSizeManager.s21_3.sp,
                  //fontSize: checkIfWeb(context)? 30.sp: convertPtToPx(14.sp),
                ),
              ),
            ),
            SizedBox(
              height: AppSize.h53_3.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      //if(await checkCallPermissions(context)){
                      function();
                    },
                    child: Container(
                      height: AppSize.h56.h,
                      // width: AppSize.w178.w,
                      //   alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.Gradient_Color1,
                              AppColors.Gradient_Color2,
                            ]),
                        borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      ),
                      child: Center(
                        child: Text(
                          buttonTitle,
                          style: TextStyle(
                            fontFamily: getTranslated(context, 'Ithra'),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.white1,
                            fontStyle: FontStyle.normal,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.w21_3),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      refusedFunction();
                    },
                    child: Container(
                      height: AppSize.h56.h,
                      // width: AppSize.w178.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: AppPadding.p20.w),
                      //   alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppRadius.r10_6.r)),
                          border: Border.all(
                            color: AppColors.linear2,
                            width: 1.5.w,
                          )),
                      child: Center(
                        child: Text(
                          getTranslated(context, 'cancel'),
                          style: TextStyle(
                            fontFamily: getTranslated(context, 'Ithra'),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.linear2,
                            // fontStyle: FontStyle.normal,
                            // fontWeight: FontWeight.w700,
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
  );
}
