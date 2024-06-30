import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/user.dart';
import '../models/userDetails.dart';
import '../widget/TextButton.dart';

class BioDetailsScreen extends StatefulWidget {
  final GroceryUser consult;
  final UserDetail consultDetails;
  final GroceryUser? loggedUser;
  final int screen;

  const BioDetailsScreen(
      {Key? key,
      required this.consult,
      this.loggedUser,
      required this.consultDetails,
      required this.screen})
      : super(key: key);

  @override
  _BioDetailsScreenState createState() => _BioDetailsScreenState();
}

class _BioDetailsScreenState extends State<BioDetailsScreen> {
  bool fav = false;

  String theme = "light";
  bool load = true, adding = false;
  String lang = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getTitle(String title) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      lang=="ar"?SvgPicture.asset(
          AssetsManager.goldFlower4IconPath,
          height: AppSize.h22_5.r,
          width: AppSize.w22_5.r,
        ):  SvgPicture.asset(
          AssetsManager.goldFlower3IconPath,
          height: AppSize.h22_5.r,
          width: AppSize.w22_5.r,
        ),
        SizedBox(
          width: AppSize.w10_6.w,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: getTranslated(context, "Montserratsemibold"),
            color: AppColors.pink2,
            fontSize: AppFontsSizeManager.s21_3.sp,
           
          ),
        ),
        SizedBox(
          width: AppSize.w10_6.w,
        ),
        lang=="ar"?SvgPicture.asset(
          AssetsManager.goldFlower3IconPath,
          height: AppSize.h22_5.r,
          width: AppSize.w22_5.r,
        ):
        SvgPicture.asset(
          AssetsManager.goldFlower4IconPath,
          height: AppSize.h22_5.r,
          width: AppSize.w22_5.r,
        ),
      ],
    );
  }

  Widget getContent(String content,{bool? medium=false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
      child: Container(
        child: Text(
          content,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyle(
            fontFamily:medium == true ?
            getTranslated(context, "Montserratmedium"):
             getTranslated(context, "Montserrat"),
            color: AppColors.darkGrey,
              fontSize: AppFontsSizeManager.s21_3.sp,)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                width: size.width,
                child: Padding(
                                padding:lang=="ar"?
                                EdgeInsets.only(
                  bottom: AppPadding.p21_3.h,left: AppPadding.p32.w): EdgeInsets.only(
                  bottom: AppPadding.p21_3.h,right: AppPadding.p32.w),
                                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarWidget2(text:  widget.consult.name!,),
                 
                  favWidget(),
                ],
                ),
                              )),
            Center(
                child: Container(
                    color: AppColors.white3, height: AppSize.h1.h,
                     width: size.width)),
            if (widget.screen == 1)
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p18.w),
                    child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: AppSize.h32.h,
                          ),
                          widget.consult.bio != null
                              ? Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child: Column(
                                        children: [
                                          getTitle(
                                            getTranslated(context, "bio"),
                                          ),
                                          SizedBox(
                                            height: AppSize.h16.h,
                                          ),
                                          getContent(widget.consult.bio!),
                                         
                                        ],
                                      ),
                                  ),
                                ),
                              )
                              : SizedBox(),
                          widget.consultDetails.priorties != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child: Column(
                                      children: [
                                        getTitle(
                                          getTranslated(context, "life"),
                                        ),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.priorties!),
                                       
                                      ],
                                    )),
                                ),
                              )
                              : SizedBox(),
                          widget.consultDetails.marriageYears != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child:  Column(
                                      children: [
                                        getTitle(
                                            getTranslated(context, "fiveYears")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                          widget.consultDetails.marriageYears!,
                                        ),
                                      
                                      ],
                                    ),)
                                ),
                              )
                              : SizedBox(),
                          widget.consultDetails.characterNature != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child:  Column(
                                      children: [
                                        getTitle(getTranslated(context, "nature")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.characterNature!),
                                      ],
                                    ),)
                                ),
                              )
                              : SizedBox(),
                          widget.consultDetails.values != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child:  Column(
                                      children: [
                                        getTitle(getTranslated(context, "values")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(widget.consultDetails.values!),
                                        
                                      ],
                                    ),
                                ),)
                              )
                              : SizedBox(),
                          widget.consultDetails.hobbies != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child: Column(
                                      children: [
                                        getTitle(getTranslated(context, "hobbies")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(widget.consultDetails.hobbies!),
                                        
                                      ],
                                    ),
                                ),
                              ))
                              : SizedBox(),
                          widget.consultDetails.habbits != ""
                              ? Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child: Column(
                                      children: [
                                        getTitle(getTranslated(context, "habits")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(widget.consultDetails.habbits!),
                                        
                                      ],
                                    ),
                                ),)
                              )
                              : SizedBox(),
                          widget.consultDetails.positivePoints != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child: Column(
                                      children: [
                                        getTitle(
                                            getTranslated(context, "positive")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.positivePoints!),
                                        
                                      ],
                                    ),
                                ),)
                              )
                              : SizedBox(),
                          widget.consultDetails.negativePoints != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child:  Column(
                                      children: [
                                        getTitle(
                                            getTranslated(context, "negative")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.negativePoints!),
                                        
                                      ],
                                    ),
                                ),)
                              )
                              : SizedBox(),
                          widget.consultDetails.lovableThings != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child: Column(
                                      children: [
                                        getTitle(getTranslated(context, "like")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.lovableThings!),
                                        
                                      ],
                                    ),)
                                ),
                              )
                              : SizedBox(),
                          widget.consultDetails.hatefulThings != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child: 
                                   Column(
                                      children: [
                                        getTitle(getTranslated(context, "disLike")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.hatefulThings!),
                                       
                                      ],
                                    ),)
                                ),
                              )
                              : SizedBox(),
                          widget.consultDetails.quranLevel != ""
                              ? Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child:  Column(
                                      children: [
                                        getTitle(getTranslated(context, "quran")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.quranLevel!),
                                        
                                      ],
                                    ),
                                ),)
                              )
                              : SizedBox(),
                          widget.consultDetails.religionLevel != ""
                              ?  Padding(
                                padding: EdgeInsets.only(bottom: AppPadding.p32.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                  ),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                          color: AppColors.white2,
                                           blurRadius: AppRadius.r25.r,
                                          spreadRadius: 12,
                                          offset: Offset(
                                          10, 10), // shadow direction: bottom right
                                                 )
                                           ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                       color: Colors.white,
                                    ),
                                    
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                  vertical: AppPadding.p34_6.h),
                                    child:  Column(
                                      children: [
                                        getTitle(
                                            getTranslated(context, "sciences")),
                                        SizedBox(
                                          height: AppSize.h16.h,
                                        ),
                                        getContent(
                                            widget.consultDetails.religionLevel!),
                                        
                                      ],
                                    ),)
                                ),
                              )
                              : SizedBox(),
                          widget.consultDetails.healthCondition != ""
                              ? Container(
                                padding: EdgeInsets.symmetric(horizontal: AppPadding.p14.w,
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                        BoxShadow(
                                        color: AppColors.white2,
                                         blurRadius: AppRadius.r25.r,
                                        spreadRadius: 12,
                                        offset: Offset(
                                        10, 10), // shadow direction: bottom right
                                               )
                                         ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
                                     color: Colors.white,
                                  ),
                                  
                                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p34_6.w,
                                vertical: AppPadding.p34_6.h),
                                  child:  Column(
                                  children: [
                                    getTitle(getTranslated(
                                        context, "healthConditions")),
                                    SizedBox(
                                      height: AppSize.h16.h,
                                    ),
                                    getContent(
                                      widget.consultDetails.healthCondition!,
                                    ),
                                  ],))
                                )
                              : SizedBox(),
                          SizedBox(
                            height: AppSize.h64.h,
                          ),
                          Padding(
                            padding:
                             EdgeInsets.only(left: AppPadding.p30_6.w,
                              right:AppPadding.p30_6.w,
                             ),child: TextButton1(onPress: () {
                              if (widget.loggedUser == null)
                                Navigator.pushNamed(context, '/Register_Type');
                              else
                                reportDialog(MediaQuery.of(context).size);
                          }, Width:size.width,
                          Height: AppSize.h66_6.h,
                          Title: getTranslated(context, "badContent"),
                           ButtonRadius: AppRadius.r10_6.r,
                            ButtonBackground: AppColors.pink2,
                            TextSize: AppFontsSizeManager.s21_3.sp,
                             TextFont:  getTranslated(context, "Montserratsemibold"),
                              TextColor: AppColors.white,IconSpace:AppSize.w13_3.w,
                              Icon: AssetsManager.whiteWarningIconPath.toString(),
                              IconColor: AppColors.white,
                              IconWidth: AppSize.w32.r,
                              IconHeight: AppSize.h32.r
                              ,Direction: TextDirection.rtl,),
                          ),
                            
                         /* reportWidget(size),*/
                          SizedBox(
                            height: AppSize.h53_3.h,
                          ),
                        ]),
                  )),
            if (widget.screen == 2)
              Expanded(
                  child: Padding(
                      padding:
                           EdgeInsets.only(left: AppPadding.p32.w, right: AppPadding.p32.w,),
                      child: ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: AppSize.h32.h,
                            ),
                            widget.consultDetails.partnerMinAge != null &&
                                    widget.consultDetails.partnerMaxAge != null
                                ? Column(
                                    children: [
                                      getTitle(
                                        getTranslated(context, "age"),
                                      ),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(medium: true,
                                          "${widget.consultDetails.partnerMinAge}" +
                                              " - " +
                                              "${widget.consultDetails.partnerMaxAge}"),
                                       SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerMinHeight != null &&
                                    widget.consultDetails.partnerMaxHeight != null
                                ? Column(
                                    children: [
                                     SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(
                                        getTranslated(context, "height"),
                                      ),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(
                                        medium: true,
                                          "${widget.consultDetails.partnerMinHeight}" +
                                              " - " +
                                              "${widget.consultDetails.partnerMaxHeight}"),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerMinWeight != null &&
                                    widget.consultDetails.partnerMaxWeight != null
                                ? Column(
                                    children: [
                                       SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(
                                        getTranslated(context, "weight"),
                                      ),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent( 
                                          "${widget.consultDetails.partnerMinWeight}" +
                                              " - " +
                                              "${widget.consultDetails.partnerMaxWeight}",medium: true,),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerEducationalLevel != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(
                                          getTranslated(context, "education")),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(
                                      getTranslated(
                                          context,
                                          widget.consultDetails
                                              .partnerEducationalLevel!),medium: true,),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerEmploymentStatus != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(getTranslated(
                                          context, "employmentStatus")),
                                       SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent( 
                                      getTranslated( context,
                                          widget.consultDetails
                                              .partnerEmploymentStatus!),medium: true,),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerLivingStander != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(getTranslated(
                                          context, "livingStander")),
                                     SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(
                                         
                                            getTranslated(
                                          context,
                                          widget.consultDetails
                                              .partnerLivingStander!),medium: true,),
                                     SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerMaritalState != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(
                                          getTranslated(context, "maritalstate")),
                                       SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(
                                      getTranslated(
                                          context,
                                          widget.consultDetails
                                              .partnerMaritalState!),medium: true,),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerSpecialization != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(getTranslated(
                                          context, "Specialization")),
                                     SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(
                               
                                        getTranslated(
                                          context,
                                          widget.consultDetails
                                              .partnerSpecialization!),medium: true,),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerSpecialization != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(getTranslated(context, "origin")),
                                      SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(
                                        getTranslated(context,
                                          widget.consultDetails.partnerOrigin!),medium: true,),
                                     SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      Container(
                                        width: size.width,
                                        height: AppSize.h1_5.h,
                                        color: AppColors.lightGray,
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            widget.consultDetails.partnerSmoking != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: AppSize.h42_6.h,
                                      ),
                                      getTitle(getTranslated(context, "Smoking")),
                                       SizedBox(
                                        height: AppSize.h21_3.h,
                                      ),
                                      getContent(
                                  
                                        getTranslated(context,
                                          widget.consultDetails.partnerSmoking!),medium: true,),
                                     
                                      
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 40,
                            ),
                          ]))),
          ],
        ),
      ),
    );
  }

  Widget favWidget() {
    return InkWell(
      onTap: () async {
        try {
          if (widget.loggedUser != null) {
            setState(() {
              fav = true;
            });
            if (widget.loggedUser!.wishlist!.contains(widget.consult.uid))
              setState(() {
                widget.loggedUser!.wishlist!
                    .removeWhere((element) => element == (widget.consult.uid));
                widget.consult.wishlist!.removeWhere(
                    (element) => element == (widget.loggedUser!.uid));
              });
            else
              setState(() {
                widget.loggedUser!.wishlist!.add(widget.consult.uid!);
                widget.consult.wishlist == null
                    ? widget.consult.wishlist = [widget.loggedUser!.uid!]
                    : widget.consult.wishlist!.add(widget.loggedUser!.uid!);
              });
            await FirebaseFirestore.instance
                .collection(Paths.usersPath)
                .doc(widget.loggedUser!.uid)
                .update({'wishlist': widget.loggedUser!.wishlist});
            await FirebaseFirestore.instance
                .collection(Paths.usersPath)
                .doc(widget.consult.uid)
                .update({'wishlist': widget.consult.wishlist});
            setState(() {
              fav = false;
            });
            Fluttertoast.showToast(
                msg: getTranslated(
                    context,
                    widget.loggedUser!.wishlist!.contains(widget.consult.uid)
                        ? "favoritesAdd"
                        : "favoritesRemoved"),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor:
                    widget.loggedUser!.wishlist!.contains(widget.consult.uid)
                        ? AppColors.green
                        : Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Navigator.pushNamed(context, '/Register_Type');
          }
        } catch (e) {
          print("ggg12345555" + e.toString());
          setState(() {
            fav = false;
          });
        }
      },
      child: Container(
      height: AppSize.h53_3.r,
      width: AppSize.w53_3.r,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey,
           width: AppSize.w1.w),
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: fav
              ? Padding(
                padding: EdgeInsets.all(
                  AppPadding.p10_6.r
                ),
                child: CircularProgressIndicator(),
              )
              : Image.asset(
                  (widget.loggedUser != null &&
                          widget.loggedUser!.wishlist!
                              .contains(widget.consult.uid))
                      ? AssetsManager.heartIcon
                      : AssetsManager.heartRedIcon,
                      
                  width:(widget.loggedUser != null &&
                          widget.loggedUser!.wishlist!
                              .contains(widget.consult.uid))?
                              AppSize.w26_6.r:
                               AppSize.w32.r,
                  height:(widget.loggedUser != null &&
                          widget.loggedUser!.wishlist!
                              .contains(widget.consult.uid))?
                              AppSize.h26_6.r: AppSize.h32.r,
                ),
        ),
      ),
    );
  }

  Widget reportWidget(Size size) {
    return InkWell(
      onTap: () {
        if (widget.loggedUser == null)
          Navigator.pushNamed(context, '/Register_Type');
        else
          addReport();
      },
      child: Center(
        child: adding
            ? CircularProgressIndicator()
            : Container(
                height: 40,
                width: size.width * .75,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(207, 0, 54, 1),
              Color.fromRGBO(255, 47, 101, 1)
            ],
          )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.report,
                      color: AppColors.white,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      getTranslated(context, "badContent"),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        color: AppColors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> addReport() async {
    setState(() {
      adding = true;
    });
    String reportId = Uuid().v4();
    await FirebaseFirestore.instance
        .collection(Paths.complaintsPath)
        .doc(reportId)
        .set({
      'appointmentId': "",
      'complaintTime': Timestamp.now(),
      'complaints': "bad content",
      "other": true,
      'consultName': widget.consult.name,
      'consultPhone': widget.consult.phoneNumber,
      'consultUid': widget.consult.uid,
      'id': reportId,
      'name': widget.loggedUser != null ? widget.loggedUser!.name : " ",
      'phone': widget.loggedUser != null ? widget.loggedUser!.phoneNumber : " ",
      'status': "new",
      'uid': widget.loggedUser != null ? widget.loggedUser!.uid : " ",
    }).then((value) {
      setState(() {
        adding = false;
        
      });
      appointmentDialog(MediaQuery.of(context).size);
    });
    //appointmentDialog(MediaQuery.of(context).size);

  }

  appointmentDialog(Size size) {
    return showDialog(
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.only(left: AppPadding.p32.w,right:AppPadding.p32.w ),
        iconPadding:EdgeInsets.only(left: AppPadding.p433_3.w,top:AppPadding.p26_6.h ),
        icon: IconButton(
          iconSize:24.sp,
            icon:SvgPicture.asset(AssetsManager.cancelIcon),
            onPressed:(){Navigator.pop(context);}),
        backgroundColor: AppColors.white1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.r21_3.r),
          ),
        ),
        elevation: 0.0,
        contentPadding:  EdgeInsets.only(
            left: AppPadding.p21_3.w, right: AppPadding.p21_3.w, top: AppPadding.p18_6.h, bottom:AppPadding.p32.h),
        content: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: Image.asset('assets/icons/icon/Union.png',
                      fit: BoxFit.contain, height: AppSize.h112.h, width: AppSize.w113_3.w)),
              SizedBox(
                height:AppSize.h10_6.h,
              ),
              Text(
                getTranslated(context, "reportSend"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s21_3.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Center(
                child: Container(
                  width: AppSize.w465_3.w,
                  height: AppSize.h56.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      color: AppColors.reddark2
                      ),
                  child: MaterialButton(
                    onPressed: () {
                     // addReport();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      getTranslated(context, 'Ok'),
                      style: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }
  reportDialog(Size size) {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p48.h,
        padLeft: AppPadding.p26_6.w,
        padReight: AppPadding.p26_6.w,
        padTop:AppPadding.p26_6.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
         width: AppSize.w400.w,
          child: Column(
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
                    child: SvgPicture.asset(
                      AssetsManager.redCancelIconPath,
                      height: AppSize.h32.r,
                      width:  AppSize.w32.r,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Text(
                getTranslated(context, "reportText"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s24.sp,
                  fontWeight:lang=="ar"? 
                  AppFontsWeightManager.semiBold
                  :null,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.h42_6.h,
              ),

              Row(
                children: [
                  Center(
                    child: Container(
                      width: AppSize.w160.w,
                      height: AppSize.h52.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppRadius.r5_3.r
                          ),
                        color: AppColors.reddark2,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          addReport();
                         // appointmentDialog(MediaQuery.of(context).size);
                        },
                        child: Text(
                          getTranslated(context, 'report'),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "Montserratsemibold"),
                            color: Colors.white,
                            fontSize: AppFontsSizeManager.s21_3.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AppSize.w53.w,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: AppSize.w160.w,
                        height: AppSize.h52.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              AppRadius.r5_3.r
                            ),
                          border: Border.all(
                            color: AppColors.reddark2,
                          ),

                        ),
                        child: MaterialButton(
                          onPressed: () {

                             Navigator.pop(context);

                          },
                          child: Text(
                            getTranslated(context, 'cancel'),
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Montserratsemibold"),
                              color: AppColors.reddark2,
                              fontSize: AppFontsSizeManager.s21_3.sp,
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

}
