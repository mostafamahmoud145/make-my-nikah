import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../../../../../localization/localization_methods.dart';

class CoachDaysWidget extends StatefulWidget {
  final GroceryUser consultant;

  const CoachDaysWidget({super.key, required this.consultant});

  @override
  State<CoachDaysWidget> createState() => _CoachDaysWidgetState();
}

List<String> dayList = [], dayListValue = [];

class _CoachDaysWidgetState extends State<CoachDaysWidget> {
  @override
  void initState() {
    if (widget.consultant.workDays!.length > 0) {
      dayList = [];
      if (widget.consultant.workDays!.contains("1")) dayList.add("monday");
      if (widget.consultant.workDays!.contains("2")) dayList.add("tuesday");
      if (widget.consultant.workDays!.contains("3")) dayList.add("wednesday");
      if (widget.consultant.workDays!.contains("4")) dayList.add("thursday");
      if (widget.consultant.workDays!.contains("5")) dayList.add("friday");
      if (widget.consultant.workDays!.contains("6")) dayList.add("saturday");
      if (widget.consultant.workDays!.contains("7")) dayList.add("sunday");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dayListValue = [];
    for (var i = 0; i < dayList.length; i++) {
      dayListValue.add(getTranslated(context, dayList[i]));
    }
    return Column(
      children: [
        SizedBox(
          height: AppSize.h32.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetsManager.goldHeader1IconPath,
              height: AppSize.h21_3.h,
              width: AppSize.w8_3.w,
            ),
            SizedBox(
              width: AppSize.w16.w,
            ),
            Text(
              getTranslated(context, "workTime"),
              style: TextStyle(
                fontFamily: getTranslated(context, "Montserratsemibold"),
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600,
                fontSize: AppFontsSizeManager.s21_3.sp,
              ),
            ),
            SizedBox(
              width: AppSize.w16.w,
            ),
            SvgPicture.asset(
              AssetsManager.goldHeader2IconPath,
              height: AppSize.h21_3.h,
              width: AppSize.w8_3.w,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: AppPadding.p56_6.w,
              right: AppPadding.p56_6.w,
              top: AppPadding.p32.h,
              bottom: AppPadding.p50.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetsManager.redCalenderIconPath,
                width: convertPtToPx(AppSize.w20.w),
                height: convertPtToPx(AppSize.h20.h),
              ),
              SizedBox(
                width: convertPtToPx(AppSize.w20.w),
              ),
              Expanded(
                child: Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: AppSize.w16.w,
                    spacing: AppSize.w16.w,
                    direction: Axis.horizontal,
                    children: [
                      for (int x = 0; x < dayListValue.length; x++)
                        CoachDayTextWidget(day: dayListValue[x]),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CoachDayTextWidget extends StatefulWidget {
  final String day;
  const CoachDayTextWidget({
    super.key,
    required this.day,
  });

  @override
  State<CoachDayTextWidget> createState() => _CoachDayTextWidgetState();
}

class _CoachDayTextWidgetState extends State<CoachDayTextWidget> {
   String lang = "";
  @override
  Widget build(BuildContext context) {
   lang=getTranslated(context,"lang");
    return Container(
      width: AppSize.w60.w,
      height: 60.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AssetsManager.roundHeader1IconPath,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width:7.w,),
            Text(
              widget.day,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontFamily: getTranslated(context, "Montserratmedium"),
                color: AppColors.black,
                fontWeight: FontWeight.w300,
                fontSize: convertPtToPx(AppFontsSizeManager.s12.sp),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
