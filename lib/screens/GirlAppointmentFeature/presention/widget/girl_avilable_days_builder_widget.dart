import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/presention/widget/day_frame_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../../../../localization/localization_methods.dart';

class GirlAvilableDaysBuilderWidget extends StatefulWidget {
  const GirlAvilableDaysBuilderWidget({
    super.key,
    required this.consultant,
  });

  final GroceryUser consultant;

  @override
  State<GirlAvilableDaysBuilderWidget> createState() =>
      _GirlAvilableDaysBuilderWidgetState();
}

class _GirlAvilableDaysBuilderWidgetState
    extends State<GirlAvilableDaysBuilderWidget> {
  List<String> dayList = [], dayListValue = [];
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
    return Padding(
      padding: EdgeInsets.only(
        left: AppPadding.p32.w,
        right: AppPadding.p32.w,
        top: AppPadding.p32.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetsManager.calenderIcon,
            width: AppSize.w26_6.w,
            height: AppSize.h26_6.h,
          ),
          SizedBox(
            width: AppSize.w21_3.w,
          ),
          Expanded(
            child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: AppSize.w16.w,
                spacing: AppSize.w16.w,
                direction: Axis.horizontal,
                children: [
                  for (int x = 0; x < dayListValue.length; x++)
                    DayFrameWidget(day: dayListValue[x]),
                ]),
          ),
        ],
      ),
    );
  }
}
