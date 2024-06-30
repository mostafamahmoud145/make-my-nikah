import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';

import '../../../../config/app_values.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../config/assets_manager.dart';

showAddingBalanceDialoge(
    {required String title,
    required String msg,
    required String amount,
    required String to,
    required context,
    required void Function()? pay}) {
  return showDialog(
    builder: (context) {
      String lang = getTranslated(context, "lang");
      return NikahDialogWidget(
        padButtom: AppPadding.p32.h,
        padLeft: AppPadding.p32.w,
        padReight: AppPadding.p32.w,
        padTop: AppPadding.p21_3.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          // height: 235.h,
          width: AppSize.w372.w,
          //color: AppColors.red,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      AssetsManager.closeIcon,
                      color: AppColors.pink2,
                      width: AppSize.w32.r,
                      height: AppSize.h32.r,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppSize.h13.h,
                    right: lang == "ar" ? AppSize.w10_6.w : 0),
                child: Column(
                  children: [
                    Text(
                      title,
                      //getTranslated(context, "balanceTransfer"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: getTranslated(context, "Ithra"),
                        fontSize: AppFontsSizeManager.s26_6.sp,
                        color: AppColors.pink2,
                        fontStyle: FontStyle.normal,
                        //fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h18_6.h,
                    ),
                    Text(
                      // getTranslated(context, "SureTransferAmount")
                      //msg + " 20\$",
                      msg + " $amount\$",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: lang == "ar" ? AppSize.h1_8.h : null,
                        fontFamily: getTranslated(context, "Ithralight"),
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        color: AppColors.black1,
                        //fontWeight: AppFontsWeightManager.bold300,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      //getTranslated(context, "toPhone") + " 01144313832",
                      getTranslated(context, "toPhone") + " $to",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: lang == "ar" ? AppSize.h1_8.h : null,
                        fontFamily: getTranslated(context, "Ithralight"),
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        color: AppColors.black1,
                        //fontWeight: AppFontsWeightManager.bold300,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h24.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: pay,
                            child: Container(
                              width: AppSize.w160.w,
                              height: AppSize.h50.h,
                              decoration: BoxDecoration(
                                color: AppColors.pink2,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r10_6.r),
                              ),
                              child: Center(
                                child: Text(
                                  getTranslated(context, 'sure'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: getTranslated(context, "Ithra"),
                                    fontSize: AppFontsSizeManager.s21_3.sp,
                                    color: AppColors.white1,
                                    fontStyle: FontStyle.normal,
                                    //fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Spacer(),
                        SizedBox(width: AppSize.w21_3.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: AppSize.w160.w,
                              height: AppSize.h50.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppRadius.r10_6.r)),
                                  border: Border.all(
                                    color: AppColors.pink2,
                                    width: AppSize.w1_5.w,
                                  )),
                              child: Center(
                                child: Text(
                                  getTranslated(context, 'cancel'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: getTranslated(context, "Ithra"),
                                    fontSize: AppFontsSizeManager.s21_3.sp,
                                    color: AppColors.primary,
                                    // fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
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
            ],
          ),
        ),
      );
    },
    barrierDismissible: false,
    context: context,
  );
}
