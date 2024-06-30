import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/text_form_field_widget.dart';
import '../../../../config/app_fonts.dart';

class TextFormFaildPayment extends StatelessWidget {
  const TextFormFaildPayment({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon
  });

  final String hint;
  final TextEditingController? controller;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final lang = getTranslated(context, "lang");
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: lang == "ar" ? 0 : AppPadding.p21_3.w,
              right: lang == "ar" ? AppPadding.p21_3.w : 0),
          child:icon,
        ),
        Expanded(
          child: TextFormFieldWidget(
            controller: controller,
            borderColor: AppColors.white,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: getTranslated(context, "Montserratmedium"),
              fontSize: AppFontsSizeManager.s21_3.sp,
              color: AppColors.grey2,
            ),
            cursorColor: AppColors.balck2,
            textInputType: TextInputType.number,
            iscenter: false,
            enableInteractiveSelection: true,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: getTranslated(context, "Montserratmedium"),
              color: AppColors.grey3,
              fontSize: AppFontsSizeManager.s21_3.sp,
              letterSpacing: 0.5,
            ),
            hint: hint,
          ),
        ),
      ],
    );
  }
}
