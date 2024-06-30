import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../config/app_values.dart';
import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import 'custom_back_button.dart';

class AppBarWidget1 extends StatelessWidget {
  const AppBarWidget1({
    Key? key,
    this.height,
    this.width = double.infinity,
    this.margin,
    this.padding,
    this.imagePath1,
    this.borderColor1,
    this.borderRadius1,
    this.borderWidth1,
    this.imagePath2,
    this.imagePath3,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    required this.onPress1,
    required this.onPress2,
  }) : super(key: key);
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String? imagePath1;
  final String? imagePath2;
  final String? imagePath3;
  final Color? borderColor;
  final Color? borderColor1;
  final double? borderRadius;
  final double? borderRadius1;
  final double? borderWidth;
  final double? borderWidth1;
  final Function() onPress1;
  final Function() onPress2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppSize.h0,
      width: width ?? AppSize.w0,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.grey,
                    width: AppSize.w1,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.r8)),
              child: IconButton(
                onPressed: onPress1,
                icon: SvgPicture.asset(AssetsManager.drawerIconPath),
              ),
            ),
            SvgPicture.asset(imagePath3! ?? ''),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor1!,
                    width: borderWidth1!,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius1!)),
              child: IconButton(
                onPressed: onPress2,
                icon: SvgPicture.asset(imagePath2!),
              ),
            ),
          ]),
    );
  }
}

class AppBarWidget2 extends StatelessWidget {
  const AppBarWidget2({
    required this.text,
    this.onPress,
  });

  final String text;
  final Function() ?onPress;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: AppPadding.p10_6.h,left: AppPadding.p32.w,right:AppPadding.p32.w,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomBackButton(
            onPress: onPress,
          ),
          SizedBox(
            width: AppSize.w21_3.w,
          ),
          Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: getTranslated(context, "Montserratsemibold"),
                fontSize: AppFontsSizeManager.s21_3.sp,
                color: AppColors.black),
          ),
        ],
      ),
    );
  }
}

class AppBarWidget3 extends StatelessWidget {
  const AppBarWidget3({
    Key? key,
    this.iconWidth,
    this.iconHeight,
    required this.text,
    required this.imagePath,
    required this.onPress,
  }) : super(key: key);
  final double? iconHeight;
  final double? iconWidth;
  final String text;
  final String imagePath;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CustomBackButton(),
        Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppPadding.p16),
          child: InkWell(
            onTap: onPress,
            child: SvgPicture.asset(
              imagePath,
              width: iconWidth,
              height: iconHeight,
            ),
          ),
        ),
      ]),
    );
  }
}

class AppBarWidget4 extends StatelessWidget {
  final Function() onPress;

  AppBarWidget4({required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
      child: Row(
        children: [
          CustomBackButton(),
          Spacer(),
          IconButton(
            onPressed: onPress,
            icon: SvgPicture.asset(
              AssetsManager.blackShareIconPath,
              width: AppSize.w24,
              height: AppSize.h24,
            ),
          ),
        ],
      ),
    );
  }
}
