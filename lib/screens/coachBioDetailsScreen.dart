import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import '../models/user.dart';
import '../widget/app_bar_widget.dart';
import '../widget/youtubePlayerWidget.dart';

class CoachBioDetailsScreen extends StatefulWidget {
  final GroceryUser consult;
  const CoachBioDetailsScreen({Key? key, required this.consult}) : super(key: key);

  @override
  _CoachBioDetailsScreenState createState() => _CoachBioDetailsScreenState();
}

class _CoachBioDetailsScreenState extends State<CoachBioDetailsScreen> {

  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lang = "";
    lang  = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    return
          Scaffold(backgroundColor: Colors.white,
                body:  SafeArea(
                  child: Column(children: [
                    Container(
                        width: size.width,
                        padding: EdgeInsets.only(
                          bottom: AppPadding.p21_3.h
                        ),
                        child: AppBarWidget2(
                          text: getTranslated(context, "bio") ,
                        )),

                    Center(
                        child: Container(
                            color: AppColors.lightGrey, 
                            height: AppSize.h1.h,
                             width: size.width )),
                             SizedBox(height: AppSize.h32.h,),
                    Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                            Center(
                              child: Container(
                                height: AppSize.h113_3.r,
                                width: AppSize.w113_3.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(32, 32, 32, 0.05),
                                      blurRadius: 17.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(0, 5.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                child: widget.consult.photoUrl!.isEmpty
                                    ? Image.asset(
                                  AssetsManager.loadGIF,
                                  width: convertPtToPx(AppSize.w0_85.w),
                                  height: convertPtToPx(AppSize.h28_5.h),
                                  fit: BoxFit.cover,
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:AssetsManager.loadGIF,
                                    placeholderScale: 0.5,
                                    imageErrorBuilder: (context, error,
                                        stackTrace) =>
                                        Image.asset(
                                            AssetsManager.loadGIF,
                                            width: convertPtToPx(AppSize.w0_85.w),
                                            height: convertPtToPx(AppSize.h28_5.h),
                                            fit: BoxFit.cover),
                                    image: widget.consult.photoUrl!,
                                    fit: BoxFit.cover,
                                    fadeInDuration:
                                    Duration(milliseconds: AppConstants.milliseconds250),
                                    fadeInCurve: Curves.easeInOut,
                                    fadeOutDuration:
                                    Duration(milliseconds: AppConstants.milliseconds150),
                                    fadeOutCurve: Curves.easeInOut,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              lang=="ar"?SvgPicture.asset(height: AppSize.h13_4.h,
                                width: AppSize.w24.w,AssetsManager.goldFlower2IconPath):
                                SvgPicture.asset(AssetsManager.goldFlower1IconPath,
                                height: AppSize.h13_4.h,
                                width: AppSize.w24.w,),
                                SizedBox(width: AppSize.w11_3.w,),
                                Text(
                                  widget.consult.name!,
                                  style: TextStyle(fontFamily: getTranslated(context, "Montserrat-SemiBold"), color: AppColors.pink2,
                                    fontSize: convertPtToPx(AppFontsSizeManager.s24.sp),
                                 
                                  
                                  ),
                                ),
                                 SizedBox(width: AppSize.w11_3.w,),
                               lang=="ar"?
                               SvgPicture.asset(AssetsManager.goldFlower1IconPath,
                                height: AppSize.h13_4.h): SvgPicture.asset(height: AppSize.h13_4.h,
                                width: AppSize.w24.w,AssetsManager.goldFlower2IconPath),
                                            
                              ],
                            ),
                            SizedBox(
                              height:convertPtToPx(AppSize.h43).h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.w32.w),
                              child: 
                              Text(
                                widget.consult.bio!,
                                textAlign:lang=="ar"? TextAlign.end:TextAlign.start,
                                               
                                style: TextStyle(
                                  fontSize: AppFontsSizeManager.s21_3.sp,
                                  fontFamily: getTranslated(context, "Montserrat"),
                                  color:AppColors.blackColor,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSize.h118_6.h,),
                              widget.consult.link!=null?
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                                child:  InkWell(
                                  onTap: (){
                                     Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              YouTubeVideoRow(link:widget.consult.link! , desc:widget.consult.name.toString(), ),
                                                
                                            ),
                                          );
                                  },
                                  child: Stack(children: [
                                                   
                                                    Container(
                                                     
                                                      child: ClipRRect(
                                                          borderRadius:
                                                           BorderRadius
                                                           .all(Radius.circular(AppRadius.r37_3.r)),
                                                          ),
                                                    ),
                                                     Container(
                                                      height: AppSize.h306_6.h,
                                                      padding:EdgeInsets.symmetric(
                                                      horizontal: AppPadding.p103_8.w,
                                                     ),
                                                      width: size.width,
                                                      decoration: BoxDecoration(
                                  
                                                         borderRadius:
                                                           BorderRadius
                                                           .all(Radius.circular(AppRadius.r37_3.r)),
                                                        gradient: LinearGradient(
                                                          
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [
                                                          AppColors.GradientColor1,
                                                          AppColors.GradientColor2
                                  
                                                        ])
                                  
                                                      ),
                                                      child: Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                           
                                                          SvgPicture.asset(
                                                            AssetsManager.logoWordIcon,
                                                          ),
                                                          Image.asset(
                                                            AssetsManager.vedioIconWhite,
                                                            height: AppSize.h80.h,
                                                            width: AppSize.w82_6.w,),
                                                        ],
                                                      ),
                                                   
                                                      
                                                    ),
                                                  ],),
                                ),
                                
                              )
                              :SizedBox(),
                              SizedBox(height: AppSize.h100.h,)
                          ]),
                        )),
                  
                  ],),
                ),
      );
  }
}