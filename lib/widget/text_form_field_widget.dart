import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/app_constat.dart';
import '../config/colorsFile.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscure;
  final bool? readOnly;
  final String? hint, initialValue;
  final Color? backGroundColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final int? maxLine;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final bool? enable, isDense,enableInteractiveSelection;
  bool iscenter = false;
  final Color? borderColor;
  final double? borderRadiusValue, width, height;
  final EdgeInsets? insidePadding;
  final Widget? prefixIcon, suffixIcon;
  final void Function(String)? onchange;
  final void Function(String?)? onsave;
  final Function()? onSuffixTap;
  final void Function()? onTap;
  final List<TextInputFormatter>? formatter;
  final TextInputAction? textInputAction;
  final Color? cursorColor;
  final int? maxLength;


  TextFormFieldWidget({
    Key? key,
    this.isDense,
    this.style,
    this.onchange,
    this.insidePadding,
    this.validator,
    this.maxLine,
    this.hint,
    this.backGroundColor,
    this.controller,
    this.initialValue,
    this.obscure = false,
    this.enable = true,
    this.readOnly = false,
    this.iscenter = false,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.borderColor,
    this.borderRadiusValue,
    this.prefixIcon,
    this.width,
    this.hintStyle,
    this.suffixIcon,
    this.onSuffixTap,
    this.height,
    this.onTap,
    this.formatter,
    this.onsave,
    this.enableInteractiveSelection,
    this.cursorColor,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      maxLength: maxLength,
         readOnly: readOnly ?? false,
      textAlignVertical: TextAlignVertical.center,
      validator: validator,
      textAlign: iscenter ? TextAlign.center : TextAlign.start,
      onTap: () => onTap,
      enabled: enable,
      inputFormatters: formatter ?? [],
      obscureText: obscure ?? false,
      obscuringCharacter: obscure != null ? "*" : '',
      textInputAction: textInputAction,
      controller: controller,
      onSaved: onsave,
      enableInteractiveSelection: enableInteractiveSelection,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        errorStyle: const TextStyle(height: 0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue ?? 10),
            borderSide:
            BorderSide(color: borderColor ?? AppColors.black1, width:AppSize.w1)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue ?? 10),
            borderSide:
            BorderSide(color: borderColor ?? const Color(0xff555555),  width: .5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue ?? 10),
            borderSide:
            BorderSide(color: borderColor ?? AppColors.black1, width: .5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue ?? 10),
            borderSide:
            BorderSide(color: borderColor ?? const Color(0xFF555555),  width: .5)),
        isDense: isDense ?? false,
        prefixIconConstraints: BoxConstraints(
            minWidth: prefixIcon == null ? 0 : 35, maxHeight: 20),
        suffixIconConstraints: BoxConstraints(
            minWidth: suffixIcon == null ? 0 : 45, maxHeight: 40),
        contentPadding: insidePadding ?? EdgeInsets.symmetric(vertical: 6),
        fillColor: backGroundColor,
        filled: backGroundColor != null,
        hintText: hint,
        prefixIcon: prefixIcon == null
            ? SizedBox(
          width: 10,
        )
            : SizedBox(width: 30, child: prefixIcon),
        suffixIcon: suffixIcon == null
            ? SizedBox(width: 5)
            : InkWell(
          onTap: onSuffixTap,
          child: SizedBox(width: 30, child: suffixIcon),
        ),
        hintStyle: hintStyle ??
            TextStyle(
                fontSize: 12,
                color: const Color(0xFFA5A5A5),
                fontWeight: FontWeight.w400),
      ),
      onChanged: onchange,
      initialValue: initialValue,
      textCapitalization: TextCapitalization.words,
      maxLines: maxLine ?? 1,
      keyboardType: textInputType,
      style: style ??
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black1,
            
          ),
    );
  }
}


class searchfield1 extends StatelessWidget {
  searchfield1(
      {super.key,
        required this.text,
        required this.width,
        required this.height,
        required this.textSize,
        required this.textfont,
        required this.textcolor,
        required this.icon,
        this.iconcolor,required this.iconwidth, required this.iconheight,required this.radius, required this.boxcolor, required this.searchController, required this.function, required this.horizontalpadding, required this.verticalpadding});

  final Function(String value) function;
  final double? width;
  final double? height;
  final double? horizontalpadding;
  final double? verticalpadding;
  final double? radius;
  final double? iconwidth;
  final Color? boxcolor;
  final double? iconheight;
  final String text;
  final String? textfont;
  final double? textSize;
  final Color? textcolor;
  final Widget icon;
  final Color? iconcolor;
  final TextEditingController searchController ;


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: height,
      width: width,

      padding: const EdgeInsets.symmetric( horizontal: AppPadding.p5, vertical: 0.0),
      decoration: BoxDecoration(
        color: boxcolor,
        borderRadius: BorderRadius.circular(radius?? AppRadius.r19),
      ),
      child: Center(
        child:  Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextField(
            onChanged: function,
            keyboardType: TextInputType.text,
            controller: searchController,
            textInputAction: TextInputAction.search,
            enableInteractiveSelection: true,
            readOnly: false,
            style: TextStyle(
              fontFamily: textfont,
              fontSize: textSize,
              color: textcolor,
              //letterSpacing:AppConstants.letterSpacing,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(  horizontal: AppPadding.p8, vertical: AppPadding.p8),
              prefixIcon: icon,
              border: InputBorder.none,
              hintText: // "Ask a question",
              text,
              hintStyle: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.w400,
                  fontFamily: textfont,
                  fontStyle: FontStyle.normal,
                  fontSize: textSize),
            ),
          ),
        ),
      ),
    );
  }
}