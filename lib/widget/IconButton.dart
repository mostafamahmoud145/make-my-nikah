// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grocery_store/widget/custom_outlined_button.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/colorsFile.dart';

class IconButton1 extends StatelessWidget {
  const IconButton1(
      {super.key,
      required this.onPress,
      required this.Width,
      required this.Height,
      this.ButtonRadius,
      this.ButtonBackground,
      this.Icon,
      this.GradientColor,
      this.GradientColor2,
      this.ButtonColor,
      this.IconColor,
      this.IconWidth,
      this.IconHeight,
        this.borderWidth,
      this.BoxShape1, this.BoxShadow1, this.Begin, this.End, this.BorderColor});

  final Function() onPress;

  final double? ButtonRadius;
  final Color? ButtonBackground;
  final double? Width, IconWidth;
  final double? Height, IconHeight,borderWidth;
  final String? Icon;

  ////

  final Color? GradientColor, GradientColor2,BorderColor;
  final Color? ButtonColor;
  final List<BoxShadow>? BoxShadow1;
  final Color? IconColor;
  final BoxShape? BoxShape1;
  final Alignment? Begin,End;

  LinearGradient get Gradiant => LinearGradient(
    begin: Begin??Alignment.bottomCenter,
    end: End??Alignment.topCenter,
        colors: [
          GradientColor!,
          GradientColor2!,
        ],
      );

  @override
  Widget build(BuildContext context) {

    return Container(
      height: Height!,
      width: Width!,

      decoration:  (ButtonBackground!=null&&ButtonRadius==null)?
      (BoxShadow1!=null)?BoxDecoration(
        color: ButtonBackground,

        shape: BoxShape1??BoxShape.rectangle,
        boxShadow: BoxShadow1!,
        border: Border.all(color: BorderColor ?? AppColors.lightGrey, width:borderWidth?? .5.w),


      ): BoxDecoration(
        color: ButtonBackground,

        shape: BoxShape1??BoxShape.rectangle,
        border: Border.all(color: BorderColor ?? AppColors.lightGrey, width:borderWidth?? .5.w),


      )
          :(ButtonBackground!=null&&ButtonRadius!=null)?
      BoxDecoration(
        color: ButtonBackground,

        borderRadius: BorderRadius.circular(ButtonRadius ?? 0),
        border: Border.all(color: BorderColor ?? AppColors.lightGrey, width:borderWidth?? .5.w),


      ):
      (GradientColor!=null&&ButtonRadius==null)?
      BoxDecoration(
        gradient: Gradiant,
        shape: BoxShape1??BoxShape.rectangle,
        border: Border.all(color: BorderColor ?? AppColors.lightGrey, width:borderWidth?? .5.w),
      ):
      BoxDecoration(
        gradient: Gradiant,
        borderRadius: BorderRadius.circular(ButtonRadius ?? 0),
        border: Border.all(color: BorderColor ?? AppColors.lightGrey, width:borderWidth?? .5.w),
      ),

      child: Center(
        child: (IconColor!=null)?InkWell(

          onTap: onPress,
          child: (Icon!.substring(Icon!.length - 3, Icon!.length) == 'png')
              ? Image.asset(
                  Icon!,
                  width: IconWidth!,
                  height: IconHeight!,
                  color: IconColor!,
                )
              : SvgPicture.asset(
                  Icon!,
                  width: IconWidth!,
                  height: IconHeight!,
                  color: IconColor!,
                ),
        ):Center(
          child: InkWell(
            onTap: onPress,
            child: (Icon!.substring(Icon!.length - 3, Icon!.length) == 'png')
                ? Image.asset(
              Icon!,
              width: IconWidth!,
              height: IconHeight!,
            )
                : SvgPicture.asset(
              Icon!,
              width: IconWidth!,
              height: IconHeight!,
            ),
          ),
        ),
      ),
    );
  }
}
