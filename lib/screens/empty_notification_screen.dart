import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/colorsFile.dart';

class EmptyNotificationScreen extends StatelessWidget {
  const EmptyNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: AppBarWidget2(
                text: getTranslated(context, "notification"),
            ),
          ),
          SizedBox(height: AppSize.h323.h,),
          Text(
            getTranslated(context, "noNotificationText"),
            style: TextStyle(
              fontSize: AppFontsSizeManager.s24.sp,
              fontFamily: getTranslated(context, "Montserratsemibold"),
              color: AppColors.grey3
            ),
          ),
          SizedBox(height: AppSize.h32.h,),
          SvgPicture.asset(AssetsManager.noNotificationIconPath)
        ],
      ),
    );
  }
}
