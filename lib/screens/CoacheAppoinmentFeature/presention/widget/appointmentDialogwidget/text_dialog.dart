
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/colorsFile.dart';


customTextDialog({
  required context,
  required String text,
  String? title,
  required String buttonText,
  double textSize = AppFontsSizeManager.s21_3,
  required Function okFunction,
}) {
  return showDialog(
    builder: (context) => NikahDialogWidget(
      padButtom: AppPadding.p38.h,
      padTop: AppPadding.p24.h,
      padLeft: AppPadding.p32.w,
      padReight: AppPadding.p32.w,
      dialogContent: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AssetsManager.redCancelIconPath,
                  width: AppSize.w37_3.r,
                  height: AppSize.h37_3.r,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.h28.h),
          if (title != null)
            Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: getTranslated(context, 'Montserratsemibold'),
                    fontSize: AppFontsSizeManager.s32.sp,
                    color: AppColors.linear2,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSize.h17_3.h),
              ],
            ),
          TextWidget(
            text: text,
            lines: 2,
            color: AppColors.black1,
            size: AppFontsSizeManager.s26_6.sp,
            weight: FontWeight.w600,
            family: getTranslated(context, "Montserratsemibold"),
            align: TextAlign.center,
          ),
          SizedBox(height: text.length > 24 ? AppSize.h46.h : AppSize.h57.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  okFunction();
                },
                child: Container(
                  width: AppSize.w160.w,
                  height: AppSize.h56.h,
                  //   alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.red2,
                    borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: getTranslated(context, 'yes'),
                      color: AppColors.white1,
                      size: AppFontsSizeManager.s21_3.sp,
                      weight: FontWeight.w600,
                      family: getTranslated(context, "Montserratsemibold"),
                      align: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.w57_3.w),
              // Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: AppSize.w160.w,
                  height: AppSize.h56.h,
                  //   alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(AppRadius.r10_6.r)),
                      border: Border.all(
                        color: AppColors.red2,
                        width: 1.5.w,
                      )),
                  child: Center(
                    child: TextWidget(
                      text: getTranslated(context, 'no'),
                      color: AppColors.red2,
                      size: AppFontsSizeManager.s21_3.sp,
                      weight: FontWeight.w600,
                      family: getTranslated(context, "Montserratsemibold"),
                      align: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    barrierDismissible: false,
    context: context,
  );
}


class TextWidget extends StatelessWidget {
  const TextWidget(
      {required this.text,
      required this.color,
      required this.size,
      this.weight,
      required this.align,
      this.lines,
      this.height,
      this.family});

  final String text;
  final String? family;
  final Color color;
  final double size;
  final FontWeight? weight;
  final TextAlign align;
  final int? lines;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: (lines == null) ? 1 : lines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          height: height ?? null,
          fontFamily: family == null ? "Ithra" : family,
          fontSize: size,
          color: color,
          fontWeight: weight ?? null),
    );
  }
}

class SingleLineTextWidget extends StatelessWidget {
  const SingleLineTextWidget(
      {required this.text,
      required this.color,
      required this.size,
      required this.weight,
      required this.align,
      required this.family,
      this.lines});

  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextAlign align;
  final String family;
  final String? lines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: (lines == null) ? 1 : int.parse(lines!),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: family, // 'Montserrat',
          fontSize: size,
          color: color,
          fontWeight: weight),
    );
  }
}
