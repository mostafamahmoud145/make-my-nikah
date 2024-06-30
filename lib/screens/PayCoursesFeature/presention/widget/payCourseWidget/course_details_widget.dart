import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:readmore/readmore.dart';

import '../../../../../config/app_fonts.dart';

class CourseDetailsWidget extends StatefulWidget {
  const CourseDetailsWidget({
    super.key,
    required this.title, required this.description,  this.rate,
  });
  final String title;
  final String description;
  final String? rate;

  @override
  State<CourseDetailsWidget> createState() => _CourseDetailsWidgetState();
}

class _CourseDetailsWidgetState extends State<CourseDetailsWidget> {
  bool isReadMore = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.w506_6.w,
      padding: EdgeInsets.all(AppPadding.p21_3.r),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(48, 48, 48, 0.08),
            blurRadius: AppSize.h29_3.r,
            offset: Offset(0.0, 4.0),
          ),
        ],
        borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AssetsManager.goldFlower3IconPath,
                height: AppSize.h18_7.r,
                width: AppSize.w18_7.r,
              ),
              SizedBox(
                width: AppSize.w8.w,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: getTranslated(context, "academyFontFamily"),
                    color: AppColors.balck2,
                    fontSize: AppFontsSizeManager.s24.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: AppSize.w8.w,
              ),
              SvgPicture.asset(
                AssetsManager.goldFlower4IconPath,
                height: AppSize.h18_7.r,
                width: AppSize.w18_7.r,
              ),
              //pb
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.rate==null?" ":widget.rate.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "academyFontFamily"),
                      fontWeight: FontWeight.w500,
                      color: AppColors.balck2,
                      fontSize: AppFontsSizeManager.s18_6.sp,
                    ),
                  ),
                  SizedBox(
                    width: AppSize.w5_3.w,
                  ),
                  widget.rate!=null?Icon(
                     Icons.star,
                    color: Color.fromRGBO(255, 188, 0, 1),
                    size: 16,
                  ):SizedBox(),
                ],
              ),
            ],
          ),
          SizedBox(
            height: AppSize.h12.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(
                 child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      textAlign: TextAlign.start,
                      maxLines:isReadMore? null : 3,

                      overflow:isReadMore?  TextOverflow.visible:TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: getTranslated(context, "academyFontFamily"),
                          color: AppColors.darkGrey,
                          fontSize: AppFontsSizeManager.s18_6.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    if(widget.description.length> 50)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isReadMore = !isReadMore;
                          });
                        },
                        child: Text(
                          isReadMore ? getTranslated(context, "ReadLess") : getTranslated(context, "ReadMore"),
                          style: TextStyle(fontSize: AppFontsSizeManager.s18_6.sp, color: AppColors.reddark2),
                        ),
                      ),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
