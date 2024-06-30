import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../../../../config/app_fonts.dart';
import '../../../../config/colorsFile.dart';

class DrowDownChargeToWidget extends StatelessWidget {
  const DrowDownChargeToWidget(
      {super.key, this.onChanged, required this.dropdownValue});
  final void Function(String?)? onChanged;
  final dropdownValue;

  @override
  Widget build(BuildContext context) {
    List<KeyValueModel> _datas = [
      KeyValueModel(
        key: 0,
        value: getTranslated(context, "toMe"),
      ),
      KeyValueModel(key: 1, value: getTranslated(context, "toOther")),
    ];

    return Container(
      height: AppSize.h70_6.h,
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p21_3.w,
      ),
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.lightGrey6, width: AppSize.w1.w),
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10_6.r))),
      child: Center(
        child: DropdownButton<String>(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.reddark2,
            size: 25,
          ),
          hint: Text(
            "lang",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: getTranslated(context, "Montserratmedium"),
              color: AppColors.darkGrey,
              fontSize: AppFontsSizeManager.s21_3.sp,
            ),
          ),
          underline: Container(),
          itemHeight: AppSize.h94_6.h,
          dropdownColor: AppColors.lightGrey9,
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
          borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
          isExpanded: true,
          value: dropdownValue,
          iconSize: AppSize.h24.r,
          elevation: 0,
          disabledHint: Divider(
            height: AppSize.h2.h,
            color: AppColors.lightGray,
          ),
          style: TextStyle(
            fontFamily: getTranslated(context, "Montserratmedium"),
            color: AppColors.lightGray,
            fontSize: AppFontsSizeManager.s21_3.sp,
          ),
          items: _datas
              .map((data) => DropdownMenuItem<String>(
                  child: Text(
                    data.value.toString(),
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      color: AppColors.blackColor,
                      fontSize: AppFontsSizeManager.s21_3.sp,
                    ),
                  ),
                  value: data.key.toString() //data.key,
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
