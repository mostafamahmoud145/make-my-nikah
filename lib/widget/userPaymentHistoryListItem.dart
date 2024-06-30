import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/userPaymentHistory.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../config/assets_manager.dart';
import '../config/colorsFile.dart';

class UserPaymentHistoryListItem extends StatelessWidget {
  final UserPaymentHistory history;

  UserPaymentHistoryListItem({required this.history});

  @override
  Widget build(BuildContext context) {
    String lang = getTranslated(context, "lang");

    //p p
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: AppPadding.p10.h,
            left: AppPadding.p8.w,
            right: AppPadding.p8.w,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 10.0,
                spreadRadius: .0,
                color: AppColors.white3,
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(
              left: AppPadding.p26_6.w,
              right: AppPadding.p26_6.w,
              bottom: AppPadding.p14_6.h,
              top: AppPadding.p26_6.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsManager.calenderIcon2,
                          color: AppColors.pink2,
                          width: AppSize.w16.r,
                          height: AppSize.h16.r,
                        ),
                        SizedBox(width: AppSize.w10_6.w),
                        Text(
                          // DateFormat.jm().format(
                          //     DateTime.now()),
                          DateFormat('EEEE, d MMM').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                history.payDateValue),
                          ),

                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontWeight: AppFontsWeightManager.bold500,
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontStyle: FontStyle.normal,
                            fontSize: AppFontsSizeManager.s16.sp,
                          ),
                        ),
                        SizedBox(width: AppSize.w10_6.w),
                        // Text(
                        //     // DateFormat('d/M/yyyy').format(
                        //     //   DateTime.now()),
                        //   DateFormat('d/M/yyyy').format(
                        //       DateTime.fromMillisecondsSinceEpoch(
                        //           history.payDateValue.to)),
                        //   textAlign: TextAlign.start,
                        //   overflow: TextOverflow.ellipsis,
                        //   softWrap: false,
                        //   maxLines: 1,
                        //   style: TextStyle(
                        //     color: AppColors.darkGrey,
                        //     fontWeight: AppFontsWeightManager.bold500,
                        //     fontFamily:getTranslated(context, "Montserratmedium"),
                        //     fontStyle: FontStyle.normal,
                        //     fontSize:  AppFontsSizeManager.s16.sp,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(width: AppSize.w16.w),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsManager.greyClockIconPath,
                          width: AppSize.w16.r,
                          height: AppSize.h16.r,
                          color: AppColors.pink2,
                        ),
                        SizedBox(width: AppSize.w10_6.w),
                        Text(
                          // DateFormat.jm().format(
                          //     DateTime.now()),
                          DateFormat('h:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                history.payDateValue),
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontWeight: AppFontsWeightManager.bold500,
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontStyle: FontStyle.normal,
                            fontSize: AppFontsSizeManager.s16.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.h37_3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          // height: AppSize.h52.h,
                          // width: AppSize.w54_6.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.lightGrey4,
                          ),
                          child: history.otherData.image!.isEmpty
                              ? SvgPicture.asset(
                                  AssetsManager.logoIcon2,
                                  color: AppColors.pink2,
                                  height: AppSize.h52.h,
                                  width: AppSize.w54_6.w,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/icons/icon_person.png',
                                    height: AppSize.h52.h,
                                    width: AppSize.w54_6.w,
                                    placeholderScale: 0.5,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: AppSize.h52.r,
                                    ),
                                    image: history.otherData.image!,
                                    fit: BoxFit.cover,
                                    fadeInDuration: Duration(milliseconds: 250),
                                    fadeInCurve: Curves.easeInOut,
                                    fadeOutDuration:
                                        Duration(milliseconds: 150),
                                    fadeOutCurve: Curves.easeInOut,
                                  ),
                                ),
                        ),
                        SizedBox(width: AppSize.w10.w),
                        Container(
                          width: convertPtToPx(200).w,
                          child: Text(
                            history.otherData.name,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                              color: Colors.black,
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: AppSize.w72.w,
                      height: AppSize.h34_6.h,
                      padding: EdgeInsets.only(
                          top: lang == "ar" ? AppPadding.p5.h : 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppRadius.r5_3.r)),
                          border: Border.all(
                              color: AppColors.reddark2, width: AppSize.w1.w)),
                      child: Center(
                        child: Text(
                          //"30\$",
                          double.parse(history.amount.toString())
                                  .toStringAsFixed(0) +
                              "\$",
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratsemibold"),
                            color: AppColors.reddark2,
                            fontSize: AppFontsSizeManager.s21_3.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.h18_6.h,
                ),
                Center(
                  child: TextButton1(
                    onPress: () {},
                    Width: history.payType == "send"
                        ? AppSize.w133_3.w
                        : AppSize.w200.w,
                    Height: AppSize.h40.h,
                    Title: history.payType == "send"
                        ? getTranslated(context, "senD")
                        : history.payType == "refund"
                            ? getTranslated(context, "refund")
                            : getTranslated(context, "receive"),
                    ButtonRadius: AppRadius.r5_3.r,
                    TextSize: AppFontsSizeManager.s18_6.sp,
                    ButtonBackground: history.payType != "send"
                        ? AppColors.greenAccent2
                        : AppColors.lightGrey11,
                    TextFont: getTranslated(context, "Montserratsemibold"),
                    TextColor: history.payType == "send"
                        ? AppColors.pink2
                        : AppColors.greenAccent1,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: AppSize.h22.h,
        )
      ],
    );
  }
}
