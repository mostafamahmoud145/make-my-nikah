import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';

/// A custom action back button widget with customizable background.
///
/// This widget provides a customizable back button with the ability to customize its background.
///
/// Required parameters:
/// - [onPressed]: A Function to be called when the button is pressed.
///
class CustomActionForwardButton extends StatelessWidget {
  final Function onPressed;
  CustomActionForwardButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  // String lang

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        child: Center(
          child: Image.asset(
            getTranslated(context, 'lang') == "ar"
                ? AssetsManager.BackArrowRightIconPath
                : AssetsManager.leftArrowIconPath,
            height: AppSize.h32.h,
            width: AppSize.h32.w,
          ),
        ),
        width: convertPtToPx(AppSize.h38).w,
        height: convertPtToPx(AppSize.h38).w,
      ),
    );
  }
}
