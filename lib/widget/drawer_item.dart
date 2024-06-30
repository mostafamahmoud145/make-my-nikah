import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/assets_manager.dart';
import '../config/colorsFile.dart';


///-- for svg images --///

class DrawerItemWidget extends StatefulWidget {
  String imagePath;
  String title;
  double iconWidth;
  double iconHeight;
   DrawerItemWidget({super.key,required this.iconHeight, required this.iconWidth,required this.imagePath,required this.title});

  @override
  State<DrawerItemWidget> createState() => _DrawerItemWidgetState();
}

class _DrawerItemWidgetState extends State<DrawerItemWidget> {
  String lang ="";
  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p36.r),
      child: Container(
        width: AppSize.w404.w,
        height: AppSize.h66_6.h,
        decoration: BoxDecoration(
          color: AppColors.drawerItemColor,
          borderRadius: BorderRadius.circular(AppRadius.r10_6.r),

        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p21_3.r),
          child: Row(
            children: [
              SvgPicture.asset(
                  widget.imagePath,
                width: widget.iconWidth,
                height: widget.iconHeight,
              ),
              SizedBox(width: AppSize.w21_3.w,),
              Text(
                widget.title,
              style: TextStyle(
                color: AppColors.black,
                fontFamily: getTranslated(context, "Montserratmedium"),
                fontSize: AppFontsSizeManager.s21_3.sp,
              ),
              ),
          Spacer(),
              SvgPicture.asset(
                lang == "ar" ? AssetsManager.blackIosArrowLeftIconPath : AssetsManager.blackIosArrowRightIconPath,
                width: AppSize.w8_3.w,
                height: AppSize.h15_3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


///-- for png images --///

class MenuItemWidget extends StatefulWidget {
  String imagePath;
  String title;
  double iconWidth;
  double iconHeight;
  MenuItemWidget({super.key,required this.iconHeight, required this.iconWidth,required this.imagePath,required this.title});

  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  String lang ="";
  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p36.r),
      child: Container(
        width: AppSize.w404.w,
        height: AppSize.h66_6.h,
        decoration: BoxDecoration(
          color: AppColors.drawerItemColor,
          borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p21_3.r),
          child: Row(
            children: [
              Image.asset(
                widget.imagePath,
                width: widget.iconWidth,
                height: widget.iconHeight,
                color: AppColors.pink2,
              
              ),
              SizedBox(width: AppSize.w21_3.w,),
              Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s21_3.sp,
                ),
              ),
         Spacer(),
              SvgPicture.asset(
                lang == "ar" ? AssetsManager.blackIosArrowLeftIconPath : AssetsManager.blackIosArrowRightIconPath,
                width: AppSize.w8_3.w,
                height: AppSize.h15_3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
