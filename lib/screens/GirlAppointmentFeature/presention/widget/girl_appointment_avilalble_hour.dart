import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class GirlClockWidget extends StatefulWidget {
  final GroceryUser consultant;

  const GirlClockWidget({super.key, required this.consultant});

  @override
  State<GirlClockWidget> createState() => _GirlClockWidgetState();
}

class _GirlClockWidgetState extends State<GirlClockWidget> {
  late int localFrom, localTo;
  String from = "", to = "";

  @override
  void initState() {
    localFrom = DateTime.parse(widget.consultant.fromUtc!).toLocal().hour;
    localTo = DateTime.parse(widget.consultant.toUtc!).toLocal().hour;
    if (localTo == 0) localTo = 24;

    if (widget.consultant.workTimes!.length > 0) {
      if (localFrom == 12)
        from = "12 PM";
      else if (localFrom == 0)
        from = "12 AM";
      else if (localFrom > 12)
        from = ((localFrom) - 12).toString() + " PM";
      else
        from = (localFrom).toString() + " AM";
    }
    if (widget.consultant.workTimes!.length > 0) {
      if (localTo == 12)
        to = "12 PM";
      else if (localTo == 0 || localTo == 24)
        to = "12 AM";
      else if (localTo > 12)
        to = ((localTo) - 12).toString() + " PM";
      else
        to = (localTo).toString() + " AM";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = getTranslated(context, "lang");

    return Padding(
      padding: EdgeInsets.only(
          top: AppPadding.p16.h,
          left: AppPadding.p32.w,
          right: lang == "ar" ? AppPadding.p32.w : AppPadding.p24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetsManager.clockIcon,
            width: AppSize.w26_6.r,
            height: AppSize.h26_6.r,
          ),
          SizedBox(
            width: AppSize.w24.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(context, "From"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Montserratsemibold"),
                        color: AppColors.black,
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: AppSize.w10_6.w,
                  ),
                  GirlFrameClock(clock: from)
                ],
              ),
              SizedBox(
                width: AppSize.w18.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(context, "to"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Montserratsemibold"),
                        color: AppColors.black,
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: AppSize.w10_6.w,
                  ),
                  GirlFrameClock(clock: to)
                ],
              ),
            ],
          ),
          SizedBox(),
        ],
      ),
    );
  }
}

class GirlFrameClock extends StatelessWidget {
  const GirlFrameClock({super.key, required this.clock});
  final String clock;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.h45_3.h,
      width: AppSize.w138_6.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AssetsManager.borderIcon,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Text(
          clock,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: getTranslated(context, "Montserratsemibold"),
            color: AppColors.black,
            fontSize: AppFontsSizeManager.s18_6.sp,
          ),
        ),
      ),
    );
  }
}
