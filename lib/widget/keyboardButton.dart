

import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/app_values.dart';
import '../config/colorsFile.dart';

Widget KeyboardButton(String number ,{String letters = ""}) {

    return Container(
      width: AppSize.w98_6.w,
      height: AppSize.h72.h,
      decoration:number == "x"?null : BoxDecoration(
          color: Color.fromRGBO(249, 250, 251, 1) ,
          borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
          border: Border.all(color: AppColors.darkGrey,width: .8)
      ),
      child: Column(
        crossAxisAlignment: number == "x"?CrossAxisAlignment.end:CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          number == "x" ? Image.asset("assets/icons/icon/Group2991.png",width: AppSize.w53.w,height: AppSize.h31_3.h,):
          Text("$number",style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: number=="delete"?
                  AppFontsSizeManager.s24.sp: AppFontsSizeManager.s32.sp,
              color: AppColors.balck2),),
          letters == "." ?
          SizedBox():
          Text("$letters",style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: AppFontsSizeManager.s16.sp,
            fontWeight: FontWeight.w400,
          ),
          ),
        ],
      ),
    );
  }

