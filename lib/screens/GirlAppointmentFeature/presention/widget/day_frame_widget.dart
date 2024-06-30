import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class DayFrameWidget extends StatefulWidget {
  const DayFrameWidget({
    super.key,
    required this.day,
  });
  final String day;

  @override
  State<DayFrameWidget> createState() => _DayFrameWidgetState();
}

class _DayFrameWidgetState extends State<DayFrameWidget> {
  String lang = "";
  @override
  Widget build(BuildContext context) {
    lang=getTranslated(context,"lang");
    return Container(
      width: AppSize.w60.w,
      height: AppSize.h73_3.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AssetsManager.circleIcon,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        lang!="ar"? Text(" "):
         SizedBox(),
          Text(
            widget.day,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontFamily: getTranslated(context, "Montserratsemibold"),
              color: AppColors.blackColor,
              fontSize: AppFontsSizeManager.s16.sp,
            ),
          ),
          lang=="ar"? Text(" "):
          SizedBox(),
        ],
      ),
    );
  }
}
