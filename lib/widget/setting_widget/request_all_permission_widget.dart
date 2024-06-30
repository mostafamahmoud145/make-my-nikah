import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/setting_cubit/setting_cubit.dart';
import 'package:grocery_store/screens/walletFeature/utils/custom_widgets_for_payment_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/app_values.dart';
import 'setting_active_widget.dart';

class RequestAllPermissionWidget extends StatelessWidget {
  const RequestAllPermissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getTranslated(context, "permissions"),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: getTranslated(context, "Ithra"), // 'Montserrat',
              fontSize: AppFontsSizeManager.s21_3.sp,
              color: AppColors.black,
              fontWeight: AppFontsWeightManager.bold500),
        ),
        BlocProvider.of<SettingCubit>(context).all
            ? SettingActiveWidget()
            : PrimaryButton(
          buttonRadius: AppRadius.r5_3.r,
          color: AppColors.cherry,
          //width: AppSize.w125_3.r,
          horizontal: AppSize.w5.w,
          height: AppSize.h45_3.r,
          onPress: () {
            BlocProvider.of<SettingCubit>(context).RequestAllPermission();
          },
          textSize: AppFontsSizeManager.s18_6.sp,
          text: getTranslated(context, "activateAll"),
        ),
      ],
    );
  }
}
