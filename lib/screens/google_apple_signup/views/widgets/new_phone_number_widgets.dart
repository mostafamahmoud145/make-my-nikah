import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class NewPhoneNumberWidget extends StatefulWidget {
  final ValueChanged<PhoneNumber> onChanged;

  NewPhoneNumberWidget({required this.onChanged});

  @override
  State<NewPhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<NewPhoneNumberWidget> {
  PhoneNumber number = PhoneNumber(isoCode: 'SA');

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.w32.w),
      child: InternationalPhoneNumberInput(
        spaceBetweenSelectorAndTextField: AppSize.h32.w,
        textAlignVertical: TextAlignVertical.top,
        textStyle: TextStyle(
          fontSize: AppSize.w24.sp,
        ),
        searchBoxDecoration: InputDecoration(
          filled: false,
          counterStyle: TextStyle(
            height: double.minPositive,
          ),
          counterText: "",

          labelStyle: TextStyle(
              fontFamily: getTranslated(context, 'Ithra'),
              color: AppColors.grey,
              fontSize: AppSize.w18_6.sp,
              fontWeight: AppFontsWeightManager.bold300),
          // fillColor: AppColors.white,filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.h10_6.r),
            borderSide: BorderSide(
              width: 1,
              color: AppColors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.h10_6.r),
            borderSide: BorderSide(
              width: 1,
              color: AppColors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.h10_6.r),
            borderSide: BorderSide(
              width: AppSize.w2.w,
              color: AppColors.grey,
            ),
          ),
          contentPadding:
              EdgeInsets.only(left: AppSize.w16.w, right: AppSize.w21_3.w),
          helperStyle: TextStyle(
            fontFamily: getTranslated(context, 'Ithra'),
            color: AppColors.pureBlack.withOpacity(0.65),
            letterSpacing: AppConstants.letterSpacing,
          ),
          hintStyle: TextStyle(
            fontFamily: getTranslated(context, 'Ithra'),
            color: Colors.grey, //[400],
            fontSize: AppSize.w21_3.sp,
            //letterSpacing:CustomSizes.letterSpacing,
          ),
          labelText: getTranslated(context, "countrySearch"),
          hintText: getTranslated(context, 'enterMobile'),
        ),
        inputDecoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            //gapPadding: AppSize.w6.w,
            borderRadius: BorderRadius.circular(AppSize.w10_6.r),
            borderSide: BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1),
              width: 0.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            //gapPadding: AppSize.w6.w,
            borderRadius: BorderRadius.circular(AppSize.w10_6.r),
            borderSide: BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //gapPadding: AppSize.w6.w,
            borderRadius: BorderRadius.circular(AppSize.w10_6.r),
            borderSide: BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            //gapPadding: AppSize.w6.w,
            borderRadius: BorderRadius.circular(AppSize.w10_6.r),
            borderSide: BorderSide(
              color: Color.fromRGBO(211, 211, 211, 1),
            ),
          ),
          contentPadding: getTranslated(context, "lang") == "ar"
              ? EdgeInsets.only(
                  bottom: AppSize.w10.h,
                  right: AppSize.w32.w,
                  // left: AppSize.w60.w
                )
              : EdgeInsets.only(
                  //bottom: AppSize.w20.h,
                  left: AppSize.w32.w,
                  //right: AppSize.w60.w,
                ),
          hintStyle: TextStyle(
            fontFamily: getTranslated(context, 'Ithra'),
            color: Color.fromRGBO(175, 175, 175, 1),
            fontSize: AppSize.w21_3.sp,
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
          fontFamily: getTranslated(context, 'Ithra'),
          fontSize: AppSize.w24.sp,
        ),
        initialValue: number,
        // textFieldController: controller,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.6.r)),

        onSaved: (PhoneNumber selectedNumber) {},
      ),
    );
  }
}
