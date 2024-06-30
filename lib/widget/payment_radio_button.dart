import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../config/colorsFile.dart';

class PaymentRadioButton extends StatelessWidget {
  const PaymentRadioButton(
      {Key? key,
      required this.isSelected,
      required this.function,
      required this.icons,
      this.text,
      this.endPadding = 0,
      this.endIconWidth ,
      this.withBottomPadding = true,
      this.width,
      required this.endIcon, this.endIconhigh, this.paddingstart})
      : super(key: key);

  final List<String> icons;
  final String endIcon;
  final String? text;
  final bool isSelected;
  final Function function;
  final double? endIconWidth;
    final double? endIconhigh;
  final double? endPadding, width;
  final bool withBottomPadding;
  final double? paddingstart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: withBottomPadding
          ? EdgeInsets.only(
              bottom: AppSize.h21_3.h,
            )
          : EdgeInsets.zero,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: InkWell(
          onTap: () {
            function();
          },
          child: Container(
            height:convertPtToPx(AppSize.h57).h,
            width: width ?? null,
            padding: EdgeInsetsDirectional.only(
              start:paddingstart?? convertPtToPx(AppSize.h24).w,
              end: convertPtToPx(AppSize.h12).w,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                  kIsWeb ? AppRadius.r24.r : AppRadius.r10_6.r),
              border: Border.all(
                color: Color.fromRGBO(184, 180, 180, 1.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (getTranslated(context, "lang") != "ar")
                  isSvg(endIcon)
                      ? SvgPicture.asset(
                          endIcon,
                            height: endIconhigh,
                          width: endIconWidth,
                          //  height: AppSize.h32.h,
                        )
                      : Image.asset(
                          endIcon,
                          height: endIconhigh,
                          width: endIconWidth,
                          //  height: AppSize.h32.h,
                        ),
                if (getTranslated(context, "lang") == "ar")
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: convertPtToPx(AppSize.w28.w),
                    color: isSelected ? AppColors.linear2 :AppColors.red,
                  ),
                SizedBox(
                  width: AppSize.w21.w,
                ),
                if (text != null)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            text!,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.pink2,
                              fontSize:AppFontsSizeManager.s21_3.sp,
                              fontFamily: getTranslated(context, "Ithra"),
                              fontWeight: AppFontsWeightManager.semiBold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: AppSize.w16.w,
                        ),
                      ],
                    ),
                  ),
                if (text == null)...[
                  Spacer(),
                  Expanded(
                    flex: icons.length==2?1: 2,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => isSvg(icons[index])
                            ? SvgPicture.asset(
                                icons[index],
                                width:  convertPtToPx(AppSize.w32).w,
                                //  height: AppSize.h32.h,
                              )
                            : Image.asset(
                                icons[index],
                                width:  AppSize.w60.w,
                                //  height: AppSize.h32.h,
                              ),
                        separatorBuilder: (context, index) => SizedBox(
                              width: AppSize.w5.w,
                            ),
                        itemCount: icons.length),
                  ), SizedBox(
                    width: convertPtToPx(16).w,
                  ),]
                  ,
                if (getTranslated(context, "lang") == "ar")
                  isSvg(endIcon)
                      ? SvgPicture.asset(
                          endIcon,
                          width: (endIconWidth?? AppSize.w76).w,
                          //  height: AppSize.h32.h,
                        )
                      : Image.asset(
                          endIcon,
                          width: AppSize.w68.w,
                          //  height: AppSize.h32.h,
                        ),
                if (getTranslated(context, "lang") != "ar")
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: convertPtToPx(AppSize.w28.w),
                    color: isSelected ? AppColors.pink2 :  Color.fromRGBO(184, 180, 180, 1.0),
                  ),
                SizedBox(
                  width: convertPtToPx(20).w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isSvg(String path) => path.split('.').last == 'svg' ? true : false;
}
