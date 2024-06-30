import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/userAccountScreen.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';

changeTypeDialog(context, GroceryUser? user) {
  final lang = getTranslated(context, "lang");
  return showDialog(
    builder: (context) => NikahDialogWidget(
      padButtom: AppPadding.p32.h,
      padLeft: AppPadding.p32.w,
      padReight: AppPadding.p32.w,
      padTop: AppPadding.p32.h,
      radius: AppRadius.r21_3.r,
      dialogContent: Container(
        color: AppColors.white,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left:AppPadding.p325.w),
                      child: IconButton(
                          iconSize:24.sp,
                          icon:SvgPicture.asset(AssetsManager.cancelIcon),
                          onPressed:(){Navigator.pop(context);}),
                    ),
                    Center(
                      child: Text(
                        getTranslated(context, "attention"),
                        style: TextStyle(
                          fontFamily:
                          getTranslated(context, "Montserratsemibold"),
                          fontSize: AppFontsSizeManager.s29_3.sp,
                          color: AppColors.reddark2,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h10_6.h,
                    ),
                    Text(
                      getTranslated(context, "confirmChangeType"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: getTranslated(context, "Montserratmedium"),
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        fontWeight:
                        lang == "ar" ? AppFontsWeightManager.semiBold : null,
                        color: AppColors.balck2,
                      ),
                    ),
                    Text(
                      getTranslated(context, "confirmPay2"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: getTranslated(context, "Montserratmedium"),
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        fontWeight:
                        lang == "ar" ? AppFontsWeightManager.semiBold : null,
                        color: AppColors.reddark2,
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h24_6.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserAccountScreen(
                                      user: user!, firstLogged: false),
                                ),
                              );
                            },
                            child: Container(
                              width: AppSize.w211_3.w,
                              height: AppSize.h56.h,
                              decoration: BoxDecoration(
                                color: AppColors.reddark2,
                                borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  getTranslated(context, "yes"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: getTranslated(
                                        context, "Montserratbold"),
                                    color: Colors.white,
                                    fontSize: AppFontsSizeManager.s21_3.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: AppSize.w21_3.w,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: AppSize.w211_3.w,
                              height: AppSize.h56.h,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                                border: Border.all(color: AppColors.reddark2),
                              ),
                              child: Center(
                                child: Text(
                                  getTranslated(context, "no"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                          context, "Montserratbold"),
                                      color: AppColors.reddark2,
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
    barrierDismissible: false,
    context: context,
  );
}
