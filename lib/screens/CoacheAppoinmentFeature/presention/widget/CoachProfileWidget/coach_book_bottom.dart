import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class CoachBookBottom extends StatelessWidget {
  const CoachBookBottom({
    super.key,
     required this.onPress,
  });
final dynamic Function() onPress;
  

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetsManager.goldFlower3IconPath,
            width: AppSize.w30_1.w,
            height: AppSize.h30_1.h,
          ),
          TextButton1(
              onPress:onPress 
                // if (user == null)
                //   Navigator.pushNamed(
                //       context, '/Register_Type');
                // else if (user != null &&
                //     currentNumber == 0)
                //   orderPay();
                // else
                //   showAddAppointmentDialog(
                //       order!.orderId);
             ,
              Title: getTranslated(context, "confirm"),
              Width: AppSize.w446_6.w,
              Height: AppSize.h66_6.h,
              ButtonBackground: AppColors.pink2,
              ButtonRadius: AppRadius.r10_6.r,
              TextSize: AppFontsSizeManager.s21_3.sp,
              TextFont: getTranslated(
                  context, "Montserratsemibold"),
              TextColor: AppColors.white),
          SvgPicture.asset(
            AssetsManager.goldFlower4IconPath,
            width: AppSize.w30_1.w,
            height: AppSize.h30_1.h,
          ),
        ],
      );
  }
}
