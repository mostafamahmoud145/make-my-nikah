import 'dart:core';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../config/colorsFile.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../methodes/pt_to_px.dart';
import '../methodes/snackbar.dart';
import '../models/userDetails.dart';
import '../widget/app_bar_widget.dart';
import 'accountDetailsScreen.dart';

class PartnerSpecificationScreen extends StatefulWidget {
  final UserDetail? userDetail;

  const PartnerSpecificationScreen({Key? key, this.userDetail})
      : super(key: key);

  @override
  _PartnerSpecificationScreenState createState() =>
      _PartnerSpecificationScreenState();
}

class _PartnerSpecificationScreenState
    extends State<PartnerSpecificationScreen> {
  Size? size;

  RangeValues age = const RangeValues(15, 100);
  RangeValues height = const RangeValues(100, 250);
  RangeValues weight = const RangeValues(40, 100);
  String lang = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      //  this.userDetails = await getuserDetails(widget.user.uid);
    });
  }

  // Widget OutlineButton({required VoidCallback onpress, required String ButtonText, required bool isselected}) {
  //   return OutlinedButton(
  //       onPressed: onpress,
  //       child: Container(
  //           width: size!.width * 0.33,
  //           // height: size!.height * 0.037,
  //           child: Center(
  //               child: Text(
  //                 ButtonText,
  //                 maxLines: 2,softWrap: true,overflow:TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                     color: isselected ? AppColors.reddark : AppColors.black2,
  //                     fontFamily: getTranslated(context, "fontFamily"),
  //                     fontWeight: FontWeight.normal,
  //                     fontSize: 10),
  //               ))),
  //       style: OutlinedButton.styleFrom(
  //         backgroundColor: AppColors.white.withOpacity(0.4),
  //         side: BorderSide(
  //             color: isselected ? AppColors.reddark : AppColors.grey4),
  //       ));
  // }
  Widget OutlineButton(
      {required VoidCallback onpress,
      required String ButtonText,
      required bool isselected}) {
    return InkWell(
      onTap: onpress,
      child: Container(
          width: convertPtToPx(AppSize.w182.w),
          height: convertPtToPx(AppSize.h32.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r5.r),
            color: isselected ? AppColors.white : AppColors.time,
            border: Border.all(
                color: isselected ? AppColors.reddark : AppColors.white),
          ),
          child: Center(
              child: Text(
            ButtonText,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: isselected ? AppColors.reddark : AppColors.black2,
                fontFamily: getTranslated(context, "Montserratmedium"),
                fontWeight: FontWeight.normal,
                fontSize: convertPtToPx(AppFontsSizeManager.s14.sp)),
          ))),
    );
  }

  void showFailedSnakbar(String s) {
    SnackBar snackbar = SnackBar(
      content: Text(
        s,
        style: TextStyle(
          fontFamily: getTranslated(context, "fontFamily"),
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      action: SnackBarAction(
          label: 'OK', textColor: Colors.white, onPressed: () {}),
    );
    //_scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: size!.width,
                child: AppBarWidget2(
                                text: getTranslated(context, "partnerSpecification"),
                              )),
                              SizedBox(height: AppSize.h21_3.h,),
            Center(
                child: Container(
                    color: AppColors.white3, height: 1, width: size!.width)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(convertPtToPx(AppPadding.p24.r)),
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 74.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetsManager.process1ImagePath,
                          width: convertPtToPx(
                            275.w,
                          ),
                          height: convertPtToPx(AppSize.h26.h),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "origin")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerOrigin == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      //  if(widget.userDetail!.partnerOrigin == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "european";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "european"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "european")),
                                OutlineButton(
                                    onpress: () {
                                      //   if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "asian";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "asian"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "asian"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "african";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "african"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "african")),
                                OutlineButton(
                                    onpress: () {
                                      //  if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "latin";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "latin"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "latin")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      //  if(widget.userDetail!.partnerOrigin == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "eastAsian";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "eastAsian"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "eastAsian")),
                                OutlineButton(
                                    onpress: () {
                                      //   if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "africanAmerican";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "africanAmerican"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "africanAmerican"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "northAfrican";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "northAfrican"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "northAfrican")),
                                OutlineButton(
                                    onpress: () {
                                      //  if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "arabian";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "arabian"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "arabian")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      //  if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerOrigin =
                                            "notinterest";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "notinterest"),
                                    isselected:
                                        (widget.userDetail!.partnerOrigin !=
                                                null &&
                                            widget.userDetail!.partnerOrigin ==
                                                "notinterest")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "doctrine")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerDoctrine == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      //  if(widget.userDetail!.partnerOrigin == null )
                                      setState(() {
                                        widget.userDetail!.partnerDoctrine =
                                            "sunni";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "sunni"),
                                    isselected:
                                        (widget.userDetail!.partnerDoctrine !=
                                                null &&
                                            widget.userDetail!.partnerDoctrine ==
                                                "sunni")),
                                OutlineButton(
                                    onpress: () {
                                      //   if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerDoctrine =
                                            "shiite";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "shiite"),
                                    isselected:
                                        (widget.userDetail!.partnerDoctrine !=
                                                null &&
                                            widget.userDetail!.partnerDoctrine ==
                                                "shiite"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerDoctrine =
                                            "convert";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "convert"),
                                    isselected:
                                        (widget.userDetail!.partnerDoctrine !=
                                                null &&
                                            widget.userDetail!.partnerDoctrine ==
                                                "convert")),
                                OutlineButton(
                                    onpress: () {
                                      //  if(widget.userDetail!.partnerOrigin  == null )
                                      setState(() {
                                        widget.userDetail!.partnerDoctrine =
                                            "notinterest";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "notinterest"),
                                    isselected:
                                        (widget.userDetail!.partnerDoctrine !=
                                                null &&
                                            widget.userDetail!.partnerDoctrine ==
                                                "notinterest")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "age")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      Center(
                        child: Container(
                          width: AppSize.w200.w,
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.all(color: AppColors.pink4),
                            children: [
                              TableRow(children: [
                                Container(
                                  height: AppSize.h36.h,
                                  child: Center(
                                    child: Text(
                                      "${widget.userDetail!.partnerMinAge == null ? 15 : widget.userDetail!.partnerMinAge}",
                                      style: TextStyle(
                                        fontSize: AppFontsSizeManager.s18_6.sp,
                                        fontFamily: getTranslated(
                                            context, "Montserratmedium"),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: AppSize.h36.h,
                                  child: Center(
                                    child: Text(
                                      "${widget.userDetail!.partnerMaxAge == null ? 100 : widget.userDetail!.partnerMaxAge}",
                                      style: TextStyle(
                                        fontSize: AppFontsSizeManager.s18_6.sp,
                                        fontFamily: getTranslated(
                                            context, "Montserratmedium"),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      // Center(
                      //     child: Container(
                      //       height: AppSize.h36.h,
                      //       width: AppSize.w200.w,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: AppColors.pink4
                      //         ),
                      //       ),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //               "${widget.userDetail!.partnerMinAge == null ? 15 : widget.userDetail!.partnerMinAge}" ,
                      //           style: TextStyle(
                      //             fontSize: AppFontsSizeManager.s18_6.sp,
                      //             fontFamily: getTranslated(context, "Montserratmedium"),
                      //           ),
                      //           ),
                      //         Container(
                      //           height: AppSize.h36.h,
                      //           width: AppSize.w1_5.w,
                      //           color: AppColors.pink4,
                      //         ),
                      //           Text(
                      //               "${widget.userDetail!.partnerMaxAge == null ? 100 : widget.userDetail!.partnerMaxAge}",
                      //             style: TextStyle(
                      //               fontSize: AppFontsSizeManager.s18_6.sp,
                      //               fontFamily: getTranslated(context, "Montserratmedium"),
                      //
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     )),
                      Center(
                        child: Container(
                          width: AppSize.w292.w,
                          child: RangeSlider(
                            values: RangeValues(
                                widget.userDetail!.partnerMinAge == null
                                    ? 15
                                    : widget.userDetail!.partnerMinAge!
                                        .toDouble(),
                                widget.userDetail!.partnerMaxAge == null
                                    ? 100
                                    : widget.userDetail!.partnerMaxAge!
                                        .toDouble()),
                            min: 15,
                            max: 100,
                            activeColor: AppColors.green1,
                            onChanged: (RangeValues values) {
                              setState(() {
                                age = values;
                                widget.userDetail!.partnerMinAge =
                                    age.start.toInt();
                                widget.userDetail!.partnerMaxAge =
                                    age.end.toInt();
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42.h,
                      ),
                      getTitle(getTranslated(context, "height")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      Center(
                        child: Container(
                          width: AppSize.w200.w,
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.all(color: AppColors.pink4),
                            children: [
                              TableRow(children: [
                                Container(
                                  height: AppSize.h36.h,
                                  child: Center(
                                    child: Text(
                                      "${widget.userDetail!.partnerMinHeight == null ? 100 : widget.userDetail!.partnerMinHeight}",
                                      style: TextStyle(
                                        fontSize: AppFontsSizeManager.s18_6.sp,
                                        fontFamily: getTranslated(
                                            context, "Montserratmedium"),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: AppSize.h36.h,
                                  child: Center(
                                    child: Text(
                                      "${widget.userDetail!.partnerMaxHeight == null ? 250 : widget.userDetail!.partnerMaxHeight}",
                                      style: TextStyle(
                                        fontSize: AppFontsSizeManager.s18_6.sp,
                                        fontFamily: getTranslated(
                                            context, "Montserratmedium"),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
        
                      // Center(
                      //     child: Text(
                      //         "${widget.userDetail!.partnerMinHeight == null ? 100 : widget.userDetail!.partnerMinHeight}" +
                      //             " - " +
                      //             "${widget.userDetail!.partnerMaxHeight == null ? 250 : widget.userDetail!.partnerMaxHeight}")),
                      Center(
                        child: Container(
                          width: AppSize.w292.w,
                          child: RangeSlider(
                            values: RangeValues(
                                widget.userDetail!.partnerMinHeight == null
                                    ? 100
                                    : widget.userDetail!.partnerMinHeight!
                                        .toDouble(),
                                widget.userDetail!.partnerMaxHeight == null
                                    ? 250
                                    : widget.userDetail!.partnerMaxHeight!
                                        .toDouble()),
                            min: 100,
                            // divisions: 40,
                            max: 250,
                            activeColor: AppColors.green1,
                            onChanged: (RangeValues values) {
                              setState(() {
                                height = values;
                                widget.userDetail!.partnerMinHeight =
                                    height.start.toInt();
                                widget.userDetail!.partnerMaxHeight =
                                    height.end.toInt();
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "weight")),
                       SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      Center(
                        child: Container(
                          width: AppSize.w200.w,
                          color: Colors.white,
                          child: Table(
                            border: TableBorder.all(color: AppColors.pink4),
                            children: [
                              TableRow(children: [
                                Container(
                                  height: AppSize.h36.h,
                                  child: Center(
                                    child: Text(
                                      "${widget.userDetail!.partnerMinWeight == null ? 40 : widget.userDetail!.partnerMinWeight}",
                                      style: TextStyle(
                                        fontSize: AppFontsSizeManager.s18_6.sp,
                                        fontFamily: getTranslated(
                                            context, "Montserratmedium"),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: AppSize.h36.h,
                                  child: Center(
                                    child: Text(
                                      "${widget.userDetail!.partnerMaxWeight == null ? 100 : widget.userDetail!.partnerMaxWeight}",
                                      style: TextStyle(
                                        fontSize: AppFontsSizeManager.s18_6.sp,
                                        fontFamily: getTranslated(
                                            context, "Montserratmedium"),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
        
                      // Center(
                      //     child: Text(
                      //         "${widget.userDetail!.partnerMinWeight == null ? 40 : widget.userDetail!.partnerMinWeight}" +
                      //             " - " +
                      //             "${widget.userDetail!.partnerMaxWeight == null ? 100 : widget.userDetail!.partnerMaxWeight}")),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: AppSize.w292.w,
                          child: RangeSlider(
                            values: RangeValues(
                                widget.userDetail!.partnerMinWeight == null
                                    ? 40
                                    : widget.userDetail!.partnerMinWeight!
                                        .toDouble(),
                                widget.userDetail!.partnerMaxWeight == null
                                    ? 100
                                    : widget.userDetail!.partnerMaxWeight!
                                        .toDouble()),
                            min: 40,
                            // divisions: 40,
                            max: 100,
                            activeColor: AppColors.green1,
                            onChanged: (RangeValues values) {
                              setState(() {
                                weight = values;
        
                                widget.userDetail!.partnerMinWeight =
                                    weight.start.toInt();
                                widget.userDetail!.partnerMaxWeight =
                                    weight.end.toInt();
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "maritalstate")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerMaritalState == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerMaritalState == null)
                                    setState(() {
                                      widget.userDetail!.partnerMaritalState =
                                          "single1";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "single1"),
                                  isselected: (widget
                                              .userDetail!.partnerMaritalState !=
                                          null &&
                                      widget.userDetail!.partnerMaritalState ==
                                          "single1")),
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerMaritalState == null)
                                    setState(() {
                                      widget.userDetail!.partnerMaritalState =
                                          "divorced1";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "divorced1"),
                                  isselected: (widget
                                              .userDetail!.partnerMaritalState !=
                                          null &&
                                      widget.userDetail!.partnerMaritalState ==
                                          "divorced1")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    setState(() {
                                      widget.userDetail!.partnerMaritalState =
                                          "widow1";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "widow1"),
                                  isselected: (widget
                                              .userDetail!.partnerMaritalState !=
                                          null &&
                                      widget.userDetail!.partnerMaritalState ==
                                          "widow1")),
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerMaritalState  == null )
                                    setState(() {
                                      widget.userDetail!.partnerMaritalState =
                                          "notinterest";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "notinterest"),
                                  isselected: (widget
                                              .userDetail!.partnerMaritalState !=
                                          null &&
                                      widget.userDetail!.partnerMaritalState ==
                                          "notinterest")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "employmentStatus")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerEmploymentStatus == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerEmploymentStatus == null)
                                    setState(() {
                                      widget.userDetail!.partnerEmploymentStatus =
                                          "employee1";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "employee1"),
                                  isselected: (widget.userDetail!
                                              .partnerEmploymentStatus !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEmploymentStatus ==
                                          "employee1")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerEmploymentStatus == null)
                                    setState(() {
                                      widget.userDetail!.partnerEmploymentStatus =
                                          "manager1";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "manager1"),
                                  isselected: (widget.userDetail!
                                              .partnerEmploymentStatus !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEmploymentStatus ==
                                          "manager1"))
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerEmploymentStatus == null)
                                    setState(() {
                                      widget.userDetail!.partnerEmploymentStatus =
                                          "worker1";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "worker1"),
                                  isselected: (widget.userDetail!
                                              .partnerEmploymentStatus !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEmploymentStatus ==
                                          "worker1")),
                              OutlineButton(
                                  onpress: () {
                                    //  if(widget.userDetail!.partnerEmploymentStatus == null)
                                    setState(() {
                                      widget.userDetail!.partnerEmploymentStatus =
                                          "unemployed1";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "unemployed1"),
                                  isselected: (widget.userDetail!
                                              .partnerEmploymentStatus !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEmploymentStatus ==
                                          "unemployed1")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerEmploymentStatus  == null )
                                    setState(() {
                                      widget.userDetail!.partnerEmploymentStatus =
                                          "notinterest";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "notinterest"),
                                  isselected: (widget.userDetail!
                                              .partnerEmploymentStatus !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEmploymentStatus ==
                                          "notinterest")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "livingStander")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerLivingStander == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerLivingStander == null)
                                    setState(() {
                                      widget.userDetail!.partnerLivingStander =
                                          "highIncome";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "highIncome"),
                                  isselected: (widget
                                              .userDetail!.partnerLivingStander !=
                                          null &&
                                      widget.userDetail!.partnerLivingStander ==
                                          "highIncome")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerLivingStander == null)
                                    setState(() {
                                      widget.userDetail!.partnerLivingStander =
                                          "middleIncome";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "middleIncome"),
                                  isselected: (widget
                                              .userDetail!.partnerLivingStander !=
                                          null &&
                                      widget.userDetail!.partnerLivingStander ==
                                          "middleIncome"))
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerLivingStander == null)
                                    setState(() {
                                      widget.userDetail!.partnerLivingStander =
                                          "lowIncome";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "lowIncome"),
                                  isselected: (widget
                                              .userDetail!.partnerLivingStander !=
                                          null &&
                                      widget.userDetail!.partnerLivingStander ==
                                          "lowIncome")),
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerLivingStander  == null )
                                    setState(() {
                                      widget.userDetail!.partnerLivingStander =
                                          "notinterest";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "notinterest"),
                                  isselected: (widget
                                              .userDetail!.partnerLivingStander !=
                                          null &&
                                      widget.userDetail!.partnerLivingStander ==
                                          "notinterest")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "educationalLevel")),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerEducationalLevel == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerEducationalLevel == null)
                                    setState(() {
                                      widget.userDetail!.partnerEducationalLevel =
                                          "master";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "master"),
                                  isselected: (widget.userDetail!
                                              .partnerEducationalLevel !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEducationalLevel ==
                                          "master")),
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerEducationalLevel == null)
                                    setState(() {
                                      widget.userDetail!.partnerEducationalLevel =
                                          "phd";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "phd"),
                                  isselected: (widget.userDetail!
                                              .partnerEducationalLevel !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEducationalLevel ==
                                          "phd"))
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //  if(widget.userDetail!.partnerEducationalLevel == null)
                                    setState(() {
                                      widget.userDetail!.partnerEducationalLevel =
                                          "highschool";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "highschool"),
                                  isselected: (widget.userDetail!
                                              .partnerEducationalLevel !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEducationalLevel ==
                                          "highschool")),
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerEducationalLevel == null)
                                    setState(() {
                                      widget.userDetail!.partnerEducationalLevel =
                                          "uneducated";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "uneducated"),
                                  isselected: (widget.userDetail!
                                              .partnerEducationalLevel !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEducationalLevel ==
                                          "uneducated")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerEducationalLevel == null)
                                    setState(() {
                                      widget.userDetail!.partnerEducationalLevel =
                                          "bachelor";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "bachelor"),
                                  isselected: (widget.userDetail!
                                              .partnerEducationalLevel !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEducationalLevel ==
                                          "bachelor")),
                              OutlineButton(
                                  onpress: () {
                                    // if(widget.userDetail!.partnerEducationalLevel  == null )
                                    setState(() {
                                      widget.userDetail!.partnerEducationalLevel =
                                          "notinterest";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "notinterest"),
                                  isselected: (widget.userDetail!
                                              .partnerEducationalLevel !=
                                          null &&
                                      widget.userDetail!
                                              .partnerEducationalLevel ==
                                          "notinterest")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "Specialization")),
                       SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerSpecialization == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization == null)
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "economic";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "economic"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "economic")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization == null)
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "engineering";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "engineering"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "engineering")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization == null)
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "islamic";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "islamic"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "islamic")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization == null)
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "health";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "health"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "health")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization == null)
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "sport";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "sport"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "sport")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization == null)
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "arts";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "arts"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "arts")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization == null)
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "education";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "education"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "education")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSpecialization  == null )
                                    setState(() {
                                      widget.userDetail!.partnerSpecialization =
                                          "notinterest";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "notinterest"),
                                  isselected: (widget.userDetail!
                                              .partnerSpecialization !=
                                          null &&
                                      widget.userDetail!.partnerSpecialization ==
                                          "notinterest")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "Smoking")),
                       SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerSmoking == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSmoking == null)
                                    setState(() {
                                      widget.userDetail!.partnerSmoking =
                                          "smoker";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "smoker"),
                                  isselected:
                                      (widget.userDetail!.partnerSmoking !=
                                              null &&
                                          widget.userDetail!.partnerSmoking ==
                                              "smoker")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSmoking == null)
                                    setState(() {
                                      widget.userDetail!.partnerSmoking =
                                          "nonSmoker";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "nonSmoker"),
                                  isselected:
                                      (widget.userDetail!.partnerSmoking !=
                                              null &&
                                          widget.userDetail!.partnerSmoking ==
                                              "nonSmoker")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSmoking  == null )
                                    setState(() {
                                      widget.userDetail!.partnerSmoking =
                                          "notinterest";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "notinterest"),
                                  isselected:
                                      (widget.userDetail!.partnerSmoking !=
                                              null &&
                                          widget.userDetail!.partnerSmoking ==
                                              "notinterest")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h64.h,
                      ),
                      getTitle(getTranslated(context, "tribal")),
                       SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.userDetail!.partnerTribal == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSmoking == null)
                                    setState(() {
                                      widget.userDetail!.partnerTribal =
                                          "tribal";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "tribal"),
                                  isselected:
                                      (widget.userDetail!.partnerTribal !=
                                              null &&
                                          widget.userDetail!.partnerTribal ==
                                              "tribal")),
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSmoking == null)
                                    setState(() {
                                      widget.userDetail!.partnerTribal =
                                          "nonTribal";
                                    });
                                  },
                                  ButtonText: getTranslated(context, "nonTribal"),
                                  isselected:
                                      (widget.userDetail!.partnerTribal !=
                                              null &&
                                          widget.userDetail!.partnerTribal ==
                                              "nonTribal")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlineButton(
                                  onpress: () {
                                    //if(widget.userDetail!.partnerSmoking  == null )
                                    setState(() {
                                      widget.userDetail!.partnerTribal =
                                          "notinterest";
                                    });
                                  },
                                  ButtonText:
                                      getTranslated(context, "notinterest"),
                                  isselected:
                                      (widget.userDetail!.partnerTribal !=
                                              null &&
                                          widget.userDetail!.partnerTribal ==
                                              "notinterest")),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.h64.h,),
                      Center(
                        child: Container(
                          width: convertPtToPx(AppSize.w335.w),
                          height: convertPtToPx(AppSize.h50.h),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.r10_6.r),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.reddark2,
                                  AppColors.red1,
                                ],
                              )),
                          child: InkWell(
                            onTap: () async {
                              save();
                            },
                            child: Center(
                              child: Text(
                                getTranslated(context, "save"),
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratsemibold"),
                                  color: Colors.white,
                                  fontSize: AppFontsSizeManager.s21_3.sp,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
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
  }

  Widget getTitle(String title) {
    return Center(
      child: Container(
        width: size!.width * .6,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: getTranslated(context, "Montserratsemibold"),
                fontSize: AppFontsSizeManager.s21_3.sp,
                color: AppColors.reddark,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 1.0), // shadow direction: bottom right
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ));
  }

  save() async {
    if (widget.userDetail!.partnerEducationalLevel != null &&
        widget.userDetail!.partnerSpecialization != null &&
        widget.userDetail!.partnerMaritalState != null &&
        widget.userDetail!.partnerLivingStander != null &&
        widget.userDetail!.partnerEmploymentStatus != null &&
        widget.userDetail!.partnerSmoking != null &&
        widget.userDetail!.partnerOrigin != null &&
        widget.userDetail!.partnerDoctrine != null&&
        widget.userDetail!.partnerTribal != null) {
      print("fffffffff");
      await FirebaseFirestore.instance
          .collection('userDetail')
          .doc(widget.userDetail!.userId)
          .set({
        "partnerEducationalLevel": widget.userDetail!.partnerEducationalLevel,
        "partnerSpecialization": widget.userDetail!.partnerSpecialization,
        "partnerMaritalState": widget.userDetail!.partnerMaritalState,
        "partnerLivingStander": widget.userDetail!.partnerLivingStander,
        "partnerEmploymentStatus": widget.userDetail!.partnerEmploymentStatus,
        "partnerOrigin": widget.userDetail!.partnerOrigin,
        "partnerDoctrine": widget.userDetail!.partnerDoctrine,
        "partnerSmoking": widget.userDetail!.partnerSmoking,
        "partnerMinAge": widget.userDetail!.partnerMinAge == null
            ? 15
            : widget.userDetail!.partnerMinAge,
        "partnerMaxAge": widget.userDetail!.partnerMaxAge == null
            ? 100
            : widget.userDetail!.partnerMaxAge,
        "partnerMinHeight": widget.userDetail!.partnerMinHeight == null
            ? 100
            : widget.userDetail!.partnerMinHeight,
        "partnerMaxHeight": widget.userDetail!.partnerMaxHeight == null
            ? 250
            : widget.userDetail!.partnerMaxHeight,
        "partnerMinWeight": widget.userDetail!.partnerMinWeight == null
            ? 40
            : widget.userDetail!.partnerMinWeight,
        "partnerMaxWeight": widget.userDetail!.partnerMaxWeight == null
            ? 100
            : widget.userDetail!.partnerMaxWeight,
        "partnerTribal": widget.userDetail!.partnerTribal,
      }, SetOptions(merge: true)).then((value) async {
        await FirebaseFirestore.instance
            .collection(Paths.usersPath)
            .doc(widget.userDetail!.userId)
            .set({"smooking":widget.userDetail!.partnerSmoking,"tribal":widget.userDetail!.partnerTribal,'profileCompleted': true}, SetOptions(merge: true));
        Navigator.of(context, rootNavigator: true).pop();

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false,
        );


        showUpdatedAccountSnackBar(context);
      }).catchError((error) {
        showFailedSnakbar(error.toString());
      });
    } else
      print("fffffffffeeee");
  }
}
