import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/report_screen2.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../widget/TextButton.dart';

class RatePartnerScreen extends StatefulWidget {
  const RatePartnerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<RatePartnerScreen> {
  bool adding = false, report = false;
  dynamic seriousRating = 0.0,
      politeRating = 0.0,
      exceptRating = 0.0,
      appropriateRating = 0.0,
      rating = 0.0,
      coachRate = 0.0;

  String name = "....", image = "", rateDescription = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String star = getTranslated(context, "stars");
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          SizedBox(
            height: AppSize.h42_6.h,
          ),
          Container(
              width: size.width,
              child: Padding(
                padding: EdgeInsets.only(
                    left: AppPadding.p13.w,
                    right: AppPadding.p32.w,
                    top: AppPadding.p20.h,
                    bottom: AppPadding.p8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              (route) => false,
                            );
                          },
                          icon: Image.asset(
                            AssetsManager.blackExitIconPath,
                            width: convertPtToPx(AppSize.w24.w),
                            height: convertPtToPx(AppSize.h24.h),
                          )),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  left: AppPadding.p32.w,
                  right: AppPadding.p32.w,
                  top: AppPadding.p26_5.h,
                  bottom: AppPadding.p26_5.h),
              children: [
                SizedBox(
                  height: AppSize.h70.h,
                ),
                Center(
                    child: Image.asset(
                  AssetsManager.review,
                  width: AppSize.w148.w,
                  height: AppSize.h158.h,
                )),
                SizedBox(
                  height: AppSize.h32.h,
                ),
                Center(
                  child: Text(
                    getTranslated(context, 'ratePartnerText'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratsemibold"),
                      fontSize: AppFontsSizeManager.s26_6.sp,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSize.h75.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, "Serious"),
                      style: TextStyle(
                          fontFamily: getTranslated(
                            context,
                            "Montserratmedium",
                          ),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          color: AppColors.black
                      ),
                    ),
                    RatingBar(
                      itemPadding:
                          EdgeInsets.symmetric(horizontal: AppPadding.p3.r),
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: AppSize.w24.w,
                      ratingWidget: RatingWidget(
                        full: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        half: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        empty: SvgPicture.asset(
                          AssetsManager.greyHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        seriousRating = rating;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.h37_3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, "polite"),
                      style: TextStyle(
                          fontFamily: getTranslated(
                            context,
                            "Montserratmedium",
                          ),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          color: AppColors.black),
                    ),
                    RatingBar(
                      itemPadding:
                          EdgeInsets.symmetric(horizontal: AppPadding.p3.r),
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: AppSize.w24.w,
                      ratingWidget: RatingWidget(
                        full: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        half: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        empty: SvgPicture.asset(
                          AssetsManager.greyHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        politeRating = rating;

                        print("polite = $politeRating");
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.h37_3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, "exceptional"),
                      style: TextStyle(
                          fontFamily: getTranslated(
                            context,
                            "Montserratmedium",
                          ),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          color: AppColors.black),
                    ),
                    RatingBar(
                      itemPadding:
                          EdgeInsets.symmetric(horizontal: AppPadding.p3.r),
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: AppSize.w24.w,
                      ratingWidget: RatingWidget(
                        full: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        half: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        empty: SvgPicture.asset(
                          AssetsManager.greyHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        exceptRating = rating;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.h37_3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, "appropriate"),
                      style: TextStyle(
                          fontFamily: getTranslated(
                            context,
                            "Montserratmedium",
                          ),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          color: AppColors.black),
                    ),
                    RatingBar(
                      itemPadding:
                          EdgeInsets.symmetric(horizontal: AppPadding.p3.r),
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: AppSize.w24.w,
                      ratingWidget: RatingWidget(
                        full: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        half: SvgPicture.asset(
                          AssetsManager.redHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                        empty: SvgPicture.asset(
                          AssetsManager.greyHeartIconPath,
                          width: AppSize.w24.w,
                          height: AppSize.w24_8.w,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        appropriateRating = rating;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.h64.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p30.r),
                  child: Center(
                    child: Container(
                      width: 446.6.h,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [AppColors.reddark2, AppColors.brown]),
                          borderRadius: BorderRadius.circular(
                              convertPtToPx(AppRadius.r8.r))),
                      height: AppSize.h66_6.h,
                      child: MaterialButton(
                        onPressed: () async {
                          reviewDialog();
                        },
                        //   color: AppColors.red1,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.r14.r),
                        ),
                        child: Text(
                          getTranslated(context, "sendRate"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratsemibold"),
                            color: AppColors.white,
                            fontSize: AppFontsSizeManager.s21_3.sp,
                            letterSpacing: 0.41,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSize.h41_3.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p30.r),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(convertPtToPx(AppRadius.r8.r)),
                      border: Border.all(
                        color: AppColors.pink2,
                      ),
                    ),
                    child: TextButton1(
                        onPress: () async {
                          setState(() {
                            report = true;
                          });

                          setState(() {
                            report = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondReportScreen()));
                        },
                        Width: AppSize.w446_6.w,
                        Height: AppSize.h66_6.h,
                        Title: getTranslated(context, "report"),
                        ButtonRadius: AppRadius.r10_6.r,
                        TextSize: AppFontsSizeManager.s21_3.sp,
                        ButtonBackground: AppColors.white,
                        TextFont:
                        getTranslated(context, "Montserratsemibold"),
                        TextColor: AppColors.reddark2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  //add review dialog
  reviewDialog() {
    return showDialog(
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: AppColors.white),),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: Container(
                      height: AppSize.h61_3.h,
                      width: AppSize.w61_3.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 12,
                            spreadRadius: 0.0,
                            offset:
                            Offset(0, 1.0), // shadow direction: bottom right
                          )
                        ],
                        shape: BoxShape.circle,
                        // color: Colors.white,
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: AppPadding.p10.w,vertical: AppPadding.p10.w),
                        child: SvgPicture.asset(AssetsManager.yellowStarIconPath,
                            fit: BoxFit.contain,
                            height: AppSize.h32.h,
                            width: AppSize.w32.w),
                      ))),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Text(
                getTranslated(context, "rateText"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s24.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Center(
                child: Container(
                  width: AppSize.w261_3.w,
                  height: AppSize.h61_3.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [AppColors.reddark2, AppColors.brown],
                      )),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        getTranslated(context, 'continue'),
                        style: TextStyle(
                          fontFamily: getTranslated(context, "Montserratmedium"),
                          color: Colors.white,
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }
}
