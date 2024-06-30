import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../../config/colorsFile.dart';
import '../../models/consultReview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../localization/localization_methods.dart';

class ConsultReviewWidget extends StatelessWidget {
  final ConsultReview review;

  ConsultReviewWidget({required this.review});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppPadding.p32.w,right: AppPadding.p32.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: convertPtToPx(AppSize.w44.w),
                height: convertPtToPx(AppSize.h44.h),
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.black, width: .5),
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey4,
                ),
                child: Center(
                  child: review.image.isEmpty
                      ? Padding(
                        padding:  EdgeInsets.only(left: convertPtToPx(AppPadding.p10.w,),right:convertPtToPx(AppPadding.p5.w,) ),
                        child: Image.asset(
                          AssetsManager.userCheckIconPath,

                          ),
                      )
                      : Padding(
                        padding:  EdgeInsets.only(left: convertPtToPx(AppPadding.p3.w)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r100.r)),
                            child: FadeInImage.assetNetwork(
                              placeholder: AssetsManager.userCheckIconPath,
                              placeholderScale: 0.5,
                              imageErrorBuilder:
                                  (context, error, stackTrace) => Icon(
                                Icons.person,
                                color: AppColors.grey3,
                                size:convertPtToPx(AppSize.w20.r),
                              ),
                              image: review.image,
                              fit: BoxFit.cover,
                              fadeInDuration: Duration(milliseconds: AppConstants.milliseconds250),
                              fadeInCurve: Curves.easeInOut,
                              fadeOutDuration: Duration(milliseconds: AppConstants.milliseconds150),
                              fadeOutCurve: Curves.easeInOut,

                            ),
                          ),
                      ),
                ),
              ),
              SizedBox(width: AppSize.w10_6.w,),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Montserratsemibold"),
                              color: AppColors.black,
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  review.rating.toStringAsFixed(1),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: getTranslated(context, "Montserratmedium"),
                                    color: AppColors.black,
                                    fontSize: AppFontsSizeManager.s16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: AppSize.w3.w,
                                ),
                                Icon(
                                  Icons.star,
                                  size: AppSize.w16.w,
                                  color: AppColors.yellow,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.all(convertPtToPx(AppPadding.p5.r)),
                      child: Container(
                        child: ReadMoreText(
                          review.description,
                          trimLines: 1,
                          textAlign: TextAlign.start,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: TextStyle(
                            fontFamily: getTranslated(context, "Montserrat"),
                            fontSize: AppFontsSizeManager.s16.sp,
                            color: AppColors.reddark2,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.5,
                          ),
                          lessStyle: TextStyle(
                            fontFamily: getTranslated(context, "Montserrat"),
                            fontSize: AppFontsSizeManager.s16.sp,
                            color: AppColors.reddark2,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.5,
                          ),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "Montserrat"),
                            fontSize: AppFontsSizeManager.s16.sp,
                            color: AppColors.grey6,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.5,
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
      ],
    );
  }
}
