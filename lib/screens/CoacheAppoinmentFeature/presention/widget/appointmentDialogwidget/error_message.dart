import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/colorsFile.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key? key, required this.errorMessage, this.buttomPadding= AppSize.h32}) : super(key: key);
  final String errorMessage;
  final buttomPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: convertPtToPx(AppSize.h16).h,
        bottom: convertPtToPx(buttomPadding).h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_outlined,
            color: AppColors.red1,
            size: convertPtToPx(AppSize.h20).h,
          ),
          SizedBox(
            width: convertPtToPx(AppSize.w8).w,
          ),
          Expanded(
            child: Text(
              errorMessage,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: getTranslated(context, 'Ithra'),
                fontSize: convertPtToPx(AppFontsSizeManager.s12).sp,
                fontWeight: FontWeight.bold,
                letterSpacing: convertPtToPx(-0.24),
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
