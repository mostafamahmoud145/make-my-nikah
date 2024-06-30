import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/load_time_shimmer.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../../config/colorsFile.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import '../../../utils/service/CoachAppointmentCubit/coach_appointment_cubit.dart';
import 'custom_hours_dowbdown.dart';

class AvailableHourss extends StatelessWidget {
  final bool loadDates;
  final List<String> todayAppointmentList;
  final String intialSelectedTime;
  final void Function(String?)? onChanged;
  const AvailableHourss({
    super.key,
    required this.todayAppointmentList,
    required this.intialSelectedTime,
    required this.onChanged,
    required this.loadDates,
  });

  @override
  Widget build(BuildContext context) {
    final lang = getTranslated(context, "lang");
    if (BlocProvider.of<CoachAppointmentCubit>(context).date == null) {
      BlocProvider.of<CoachAppointmentCubit>(context).date = DateTime.parse(
          intialSelectedTime == ""
              ? (todayAppointmentList.isNotEmpty
                  ? todayAppointmentList.first
                  : DateTime.now().toString())
              : intialSelectedTime);
    }
    // size = MediaQuery.of(context).size;
    return loadDates == false
        ? Padding(
            padding: EdgeInsets.only(
              top: convertPtToPx(AppSize.h24).h,
            ),
            child: Container(
              //height: convertPtToPx(AppSize.h182).h,
              padding: EdgeInsets.symmetric(
                  horizontal: convertPtToPx(AppPadding.p16).w,
                  vertical: lang == "ar" ? AppPadding.p32.h : AppPadding.p50.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Color.fromRGBO(211, 211, 211, 1),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getTranslated(context, "selectTime"),
                    style: TextStyle(
                      fontFamily:getTranslated(context, "Montserratsemibold"),
                      color: Color.fromRGBO(32, 32, 32, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontsSizeManager.s21_3.sp,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(
                    height: convertPtToPx(AppSize.h24).h,
                  ),
                  Text(
                    getTranslated(context, "selectTimeNote"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily:getTranslated(context, "Montserratsemibold"),
                      color: AppColors.grey6,
                      fontSize: AppFontsSizeManager.s16.sp,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(
                    height: convertPtToPx(AppSize.h24).h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      color: Color.fromRGBO(247, 247, 247, 1),
                    ),
                    child: DropdownContainer(
                      options: todayAppointmentList,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          )
        : LoadTimesShimmer(
            height: AppSize.h173,
          );
  }
}

String calculateFinalTime(String rawTime) {
  String minutes = "00", period = "Am", finalTime = "";

  int parsedHour = DateTime.parse(rawTime).toLocal().hour;
  int parsedMinute = DateTime.parse(rawTime).toLocal().minute;

  if (parsedMinute != 0) {
    minutes = parsedMinute.toString().padLeft(2, '0');
  }
  if (parsedHour == 12) {
    finalTime = ("12" + ":" + minutes + "Pm");
  }
  else if (parsedHour == 0) {
    finalTime = ("12" + ":" + minutes + "Am");
  }

  else if (parsedHour > 12) {
    finalTime = ((parsedHour-12).toString()) + ":" + minutes + "Pm";
  } 
   
  
  else {
    finalTime = parsedHour.toString() + ":" + minutes + "Am";
  }

  return finalTime;
}
