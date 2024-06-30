import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../config/assets_manager.dart';
import '../../../../config/app_values.dart';

class ChooseCallType extends StatelessWidget {
  final Function() onPressVoice;
  final Function() onPressVideo;
final String type;
  const ChooseCallType(
      {super.key, required this.onPressVoice, required this.onPressVideo, required this.type});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width,
        padding: EdgeInsets.only(
          top: AppPadding.p32.h,
          bottom: AppPadding.p34_6.h,
          right: AppPadding.p53_3.w,
          left: AppPadding.p53_3.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r32.r),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(48, 48, 48, 0.06),
              blurRadius: 18.r,
              spreadRadius: 0.0,
              offset: Offset(0, 9.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 25,
                  width: size.width * .30,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      getTranslated(context, "callMe"),
                      style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Montserratsemibold"),
                        color: AppColors.black,
                        fontSize: AppFontsSizeManager.s21_3.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: AppColors.pink2,
              width: AppSize.w76.w,
              height: AppSize.h2_6.h,
            ),
            SizedBox(
              height: AppSize.h24.h,
            ),
            //ig
            Image.asset(
              AssetsManager.sendIcon,
              height: AppSize.h130_6.h,
              width: AppSize.w156.w,
              fit: BoxFit.fill,
            ),
            //voice&video button
            Padding(
              padding: EdgeInsets.only(
                  left: AppPadding.p53_3.w,
                  right: AppPadding.p53_3.w,
                  top: AppPadding.p32.h,
                  bottom: AppPadding.p32.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton1(
                        onPress: onPressVoice,
                        Width: AppSize.w45,
                        Height: AppSize.h45,
                        ButtonRadius: AppRadius.r10_6.r,
                        ButtonBackground: type=="audio"? AppColors.pink2:AppColors.whitered,
                        Icon: AssetsManager.phoneCall.toString(),
                        IconWidth: AppSize.w37_3.w,
                        IconHeight: AppSize.h37_3.h,
                         IconColor: type=="audio"? AppColors.white:AppColors.pink2,
                        BorderColor: AppColors.pink2,
                        borderWidth:AppSize.w1_5.w ,

                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      Text(
                        getTranslated(context, "voiceCall"),
                        style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: AppColors.black,
                            fontSize: AppFontsSizeManager.s18_6.sp),
                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "30\$",
                            style: TextStyle(
                                fontFamily: getTranslated(
                                    context, "Montserratsemibold"),
                                color: AppColors.darkGrey,
                                fontSize: AppFontsSizeManager.s21_3.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton1(
                        onPress: onPressVideo,
                        Width: AppSize.w45,
                        Height: AppSize.h45,
                        ButtonRadius: AppRadius.r10_6.r,
                        ButtonBackground:type=="video"? AppColors.pink2:AppColors.whitered,
                        Icon: AssetsManager.whiteVideoIconPath.toString(),
                        IconWidth: AppSize.w32.w,
                        IconHeight: AppSize.h20_4.h,
                        IconColor: type=="video"? AppColors.white:AppColors.pink2,
                        BorderColor: AppColors.pink2,
                        borderWidth:AppSize.w1_5.w ,
                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      Text(
                        getTranslated(context, "videoCall"),
                        style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: AppColors.black,
                            fontSize: AppFontsSizeManager.s18_6.sp),
                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "30 \$",
                            style: TextStyle(
                                fontFamily: getTranslated(
                                    context, "Montserratsemibold"),
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w300,
                                fontSize: AppFontsSizeManager.s21_3.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Text.rich(
              TextSpan(
                text: getTranslated(context, "itIs"),
                style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratmedium"),
                    color: AppColors.grey3,
                    fontSize: AppFontsSizeManager.s18_6.sp,
                    fontWeight: FontWeight.normal),
                children: <TextSpan>[
                  TextSpan(
                    text: getTranslated(context, "notAllowedVideo"),
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      decorationThickness: 1,
                      color: AppColors.pink2,
                      fontSize: AppFontsSizeManager.s18_6.sp,
                    ),
                  ),
                  TextSpan(
                    text: " ",
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      decorationThickness: 1,
                      color: AppColors.pink2,
                      fontSize: AppFontsSizeManager.s18_6.sp,
                    ),
                  ),
                  TextSpan(
                    text: getTranslated(context, "typeText"),
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      decorationThickness: 1,
                      color: AppColors.grey3,
                      fontSize: AppFontsSizeManager.s18_6.sp,
                    ),
                  ),
                ],
              ),
              softWrap: true,
              maxLines: 10,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
