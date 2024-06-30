
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/colorsFile.dart';

class OrderDetailsLine extends StatelessWidget {
  const OrderDetailsLine({
    Key? key,
    required this.header,
    required this.value,
    this.headerColor ,
    this.valueColor = AppColors.balckColor2,
    this.headerFontSize,
    this.valueFontSize,
    this.bottomPadding,
  }) : super(key: key);

  final Color? headerColor;
  final Color valueColor;
  final String header, value;
  final double? headerFontSize, valueFontSize, bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? AppSize.h10_6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header,
            style: TextStyle(
              color: headerColor??AppColors.grey6,
              //fontWeight: AppFontsWeightManager.semiBold,
              fontSize:
                  headerFontSize ??AppFontsSizeManager.s18_6.sp,
              fontFamily: getTranslated(context, "Montserratsemibold"),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: valueColor,
                fontSize:
                    valueFontSize ?? AppFontsSizeManager.s18_6.sp,
              fontFamily: getTranslated(context, "Montserratsemibold"),
                fontWeight: AppFontsWeightManager.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
