import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import '../../../../config/app_values.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class UppercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(" ", "");
    if (text.length > 16) {
      text = text.substring(0, 16);
    }
    String formattedText = '';
    for (int i = 0; i < text.length; i++) {
      formattedText += text[i];
      if ((i + 1) % 4 == 0 && (i + 1) < text.length) {
        formattedText += ' ';
      }
    }
    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection.copyWith(
        baseOffset: formattedText.length,
        extentOffset: formattedText.length,
      ),
    );
  }
}

// ignore: must_be_immutable
class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {super.key,
      required this.onPress,
      required this.text,
      this.width,
      this.height,
      this.vertical = 0.0,
      this.horizontal = 0.0,
      this.textSize,
      this.buttonRadius,
      this.normal = false,
      this.colors = false,
      this.color,
      this.gradientButton,
      this.save = false});

  final Function() onPress;

  final String text;
  final double? textSize;
  final double? buttonRadius;
  final double? width;
  final double vertical;
  final double horizontal;
  final bool? colors;
  bool? normal;
  bool? save;
  Color? color;
  LinearGradient? gradientButton;

  final double? height;

  static LinearGradient get gradiant => LinearGradient(
        begin: Alignment(-0.026087120175361633, 0.5),
        end: Alignment(1.0575249195098877, 0.5),
        colors: [
          AppColors.linear1,
          AppColors.linear2,
        ],
      );
  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    return Container(
      width: width ?? null,
      height: height ?? 60,
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      decoration: BoxDecoration(
        // color: color != null ? color! : null,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(207, 0, 54, 1),
            Color.fromRGBO(255, 47, 101, 1)
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(buttonRadius ?? 25)),
        //  save == true
        //     ? saveGradiant
        //     :
      ),
      child: InkWell(
        onTap: onPress,
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: getTranslated(context, "Montserratsemibold"),
                fontWeight: normal == true
                    ? AppFontsWeightManager.regular
                    : AppFontsWeightManager.semiBold,
                fontStyle: FontStyle.normal,
                color: AppColors.white1,
                fontSize: textSize ?? 15,
                // letterSpacing: AppConstants.letterSpacing0_5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//text form faild to bottom sheet payment
class TextFormFieldWidget2 extends StatelessWidget {
  const TextFormFieldWidget2(
      {required this.name,
      required this.controller,
      this.obscureText = false,
      this.icon,
      this.lines,
      this.isNumber,
      this.labelColor = AppColors.pink,
      required this.context,
      this.verticalPadding = AppPadding.p10,
      this.horizontalPadding = AppPadding.p10,
      required this.onTap,
      this.fontSize = AppFontsSizeManager.s21,
      this.radius = AppRadius.r10_6,
      this.fontColor = AppColors.darkGrey,
      this.fontFamily,
      this.inputFontFamily,
      this.formatter,
      this.validator,
      this.isReadOnly,
      this.focusNode,
      this.textDirection});

  final TextEditingController controller;
  final String name;
  final bool? obscureText;
  final bool? isNumber;
  final String? icon;
  final int? lines;
  final bool? isReadOnly;
  final BuildContext context;
  final Color labelColor;
  final double verticalPadding;
  final double horizontalPadding;
  final Function onTap;
  final double fontSize;
  final String? inputFontFamily;
  final Color fontColor;
  final double radius;
  final String? fontFamily;
  final List<TextInputFormatter>? formatter;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      focusNode: focusNode,
      textDirection: textDirection,
      inputFormatters: formatter,
      //textAlign: TextAlign.start,
      onTap: () {
        onTap();
      },
      controller: controller,
      obscureText: obscureText == null ? false : obscureText!,
      textAlignVertical: TextAlignVertical.center,
      validator: validator ??
          (String? val) {
            if (val!.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
      enableInteractiveSelection: true,
      style: style(size),
      maxLines: lines == null ? 1 : lines,
      readOnly: isReadOnly == null ? false : true,
      textInputAction:
          lines == null ? TextInputAction.done : TextInputAction.newline,
      keyboardType: lines == null
          ? isNumber != null
              ? TextInputType.number
              : TextInputType.text
          : TextInputType.multiline,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: verticalPadding.h, horizontal: horizontalPadding.w),
        errorStyle: style(size),
        hintStyle: style(size),
        prefixIcon: icon == null
            ? null
            : Image.asset(
                'assets/icons/' + icon!,
                width: AppSize.w14,
                height: AppSize.h12,
              ),
        prefixIconConstraints: BoxConstraints(
          minWidth: AppSize.w50_6,
        ),
        labelText: name,
        labelStyle: TextStyle(
          fontFamily: fontFamily ?? getTranslated(context, 'Ithralight'),
          fontSize: AppFontsSizeManager.s21_3.sp,
          color: labelColor,
        ),
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide(width: AppSize.w0_5, color: AppColors.grey3),
          borderRadius: BorderRadius.circular(radius.r),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide(width: AppSize.w0_5, color: AppColors.pink),
          borderRadius: BorderRadius.circular(radius.r),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey3),
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }

  TextStyle style(Size size) {
    return TextStyle(
        fontFamily: inputFontFamily ?? getTranslated(context, 'Ithra'),
        fontSize: fontSize.sp,
        color: fontColor,
        fontWeight: FontWeight.normal);
  }
}
