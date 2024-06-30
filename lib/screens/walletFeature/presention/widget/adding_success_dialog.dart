import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';

import 'package:grocery_store/widget/resopnsive.dart';

  addingSuccessDialog(context,{required Size size,bool? transfer=false,required bool status, required amount}) {
    final lang = getTranslated(context, "lang");
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p32.h,
        padLeft:transfer==true?0: AppPadding.p54_6.w,
        padReight:transfer==true?0: AppPadding.p54_6.w,
        padTop:AppPadding.p32.h,
        radius: AppRadius.r21_3.r,
        
        dialogContent: Container(
          width:transfer==true?
          AppSize.w453_3.w
          : AppSize.w344.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            status?  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                     transfer==true?
                     getTranslated(context, "transferMoney")
                     
                     : getTranslated(context, "addMoney"),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: getTranslated(context, "Montserratsemibold"),
                      fontSize: AppFontsSizeManager.s29.sp,
                      letterSpacing: 0.3,
                      color: AppColors.reddark2,
                    ),
                  ),
                  SizedBox(
                    width: AppSize.w16.w,
                  ),
                 transfer==true?
                 SvgPicture.asset(
                      AssetsManager.transferIcon,
                  width: AppSize.w32.w,
                    height: AppSize.h32_9.h,
                  )
                 : Image.asset(
                      AssetsManager.wallet2IconPath,
                  width: AppSize.w32.w,
                    height: AppSize.h32_9.h,
                  ),
                ],
              )
              :SvgPicture.asset(
                    AssetsManager.errorIcon,
                    height: AppSize.h52.r,
                    width: AppSize.w52.r,
                  ),
              
              SizedBox(
                height:status==true?
                transfer==true?AppSize.h42_6.h
                : AppSize.h24.h:
                 AppSize.h17_3.h,
              ),
              Text(
               status?
               transfer==true?
               getTranslated(context, "moneyTransferredSuccessfully")
               :
               
               lang=="ar"?getTranslated(context, "addMoney2")+" ${amount}\$"
               :"${amount}\$ " + getTranslated(context, "addMoney2"):
                 getTranslated(context, "noUser")
               ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: AppSize.h1_8.h,
                  fontWeight:lang=="ar"? AppFontsWeightManager.semiBold:null,
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s24.sp,
                  letterSpacing: 0.3,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height:status==true?
                 transfer==true?
                 AppSize.h42_6.h:
                 AppSize.h24.h:
                 AppSize.h26_6.h,
              ),
              Center(
                child: Container(
                  width: AppSize.w261_3.w,
                  height:AppSize.h61_3.h ,
                  decoration: BoxDecoration(
                    color: AppColors.pink2,
                    borderRadius: 
                    BorderRadius.circular(AppRadius.r5_3.r),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                       status? getTranslated(context, 'continue')
                       :getTranslated(context, "Retry"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          
                          fontWeight:lang=="ar"? AppFontsWeightManager.semiBold:null,
                          fontFamily: getTranslated(context, "Montserratmedium"),
                          color: Colors.white,
                          fontSize:AppFontsSizeManager.s21_3.sp,
                          letterSpacing: 0.3,
                        ),
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
