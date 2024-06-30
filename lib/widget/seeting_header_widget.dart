import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/custom_back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/app_fonts.dart';

class SettingHeaderWidget extends StatelessWidget {
  const SettingHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: AppPadding.p32.w,
        left: AppPadding.p32.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomBackButton(),
              SizedBox(width: AppSize.w21_3.w),
         Text(
             getTranslated(context, "settings"),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: getTranslated(context, "Ithra"), // 'Montserrat',
            fontSize: AppFontsSizeManager.s21_3.sp,
            color: AppColors.black,
            fontWeight: AppFontsWeightManager.bold500),
      ),

            ],
          ),
          SizedBox()
        ],
      ),
    );
  }
}
