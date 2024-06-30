import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberWidget extends StatefulWidget {
  final ValueChanged<PhoneNumber> onChanged;
  final ValueChanged<PhoneNumber> onSave;
  final PhoneNumber phoneNumber;

  PhoneNumberWidget(
      {required this.onChanged,
      required this.onSave,
      required this.phoneNumber});

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  //PhoneNumber number22 = PhoneNumber(isoCode: 'US');

  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      textAlignVertical: TextAlignVertical.top,
      textStyle: TextStyle(
        fontSize: AppFontsSizeManager.s24.sp,
      ),
      searchBoxDecoration: InputDecoration(
        counterStyle: TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        labelStyle: TextStyle(
            fontFamily: getTranslated(context, "Montserratmedium"),
            color: AppColors.grey,
            fontSize: AppFontsSizeManager.s18_6.sp,
            fontWeight: FontWeight.bold),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.h10_6.r),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.lightGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.h10_6.r),
          borderSide: BorderSide(
            width: AppSize.w2.w,
            color: AppColors.grey3,
          ),
        ),
        contentPadding:
            EdgeInsets.only(left: AppSize.w16.w, right: AppSize.w21_3.w),
        helperStyle: TextStyle(
          fontFamily: getTranslated(context, "Montserratmedium"),
          color: AppColors.pureBlack.withOpacity(0.65),
        ),
        hintStyle: TextStyle(
          fontFamily: getTranslated(context, "Montserratmedium"),
          color: Colors.grey, //[400],
          fontSize: AppFontsSizeManager.s21_3.sp,
          //letterSpacing:CustomSizes.letterSpacing,
        ),
        labelText: getTranslated(context, "countrySearch"),
        hintText: getTranslated(context, 'enterMobile'),
      ),
      inputDecoration: InputDecoration(
        counterStyle: TextStyle(
            //height: double.minPositive,
            ),
        counterText: "",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.h10_6.r),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.lightGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.h10_6.r),
          borderSide: BorderSide(
            width: AppSize.w2.w,
            color: AppColors.grey3,
          ),
        ),


        contentPadding: getTranslated(context, "lang") == "ar"
            ? EdgeInsets.only(
                // bottom: AppSize.h10.h,
                right: AppSize.w21_3.w,
                 // left: AppSize.w21_3.w
              )
            : EdgeInsets.only(
                //bottom: AppSize.s20.h,
                left: AppSize.w21_3.w,
                // right: AppSize.s60.w,
                ),
        hintStyle: TextStyle(
          fontFamily: getTranslated(context, "Montserratmedium"),
          color: AppColors.darkGrey3,
          fontSize: AppFontsSizeManager.s21_3.sp,
          //letterSpacing:CustomSizes.letterSpacing,
        ),
        hintText: getTranslated(context, 'enterMobile'),
      ),
      onInputChanged: (PhoneNumber selectedNumber) {
        print("PhoneNumber change");
        widget.onChanged(selectedNumber);
      },
      onInputValidated: (bool value) {},
      locale: getTranslated(context, 'lang'),
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        trailingSpace: false,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: TextStyle(
        color: AppColors.grey7,
        fontFamily: getTranslated(context, "Montserratmedium"),
        fontSize: AppFontsSizeManager.s24.sp,
      ),
      initialValue: widget.phoneNumber,
      // textFieldController: controller,
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      onSaved: (PhoneNumber selectedNumber) {
        widget.onSave(selectedNumber);
      },
    );
  }
}
