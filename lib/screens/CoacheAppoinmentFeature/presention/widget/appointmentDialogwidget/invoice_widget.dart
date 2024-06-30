import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/order_details_line.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/service/Funcation/convert_time.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';


class InvoiceCoachWidget extends StatefulWidget {
  const InvoiceCoachWidget({
    super.key,
    // required this.widget,
    required this.displayedTime,
    required this.selectedTime,
    required this.discount,
    required this.package,
  });

  // final CoachAppointment widget;
  final consultPackage package;
  final String? displayedTime;
  final String? selectedTime;
  final discount;

  @override
  State<InvoiceCoachWidget> createState() => _InvoiceCoachWidgetState();
}

class _InvoiceCoachWidgetState extends State<InvoiceCoachWidget> {
  String getDayOfWeek(String dateString) {
  // Define the input format
  DateFormat inputFormat = DateFormat("M/d/yyyy");
  
  // Parse the input string into a DateTime object
  DateTime dateTime = inputFormat.parse(dateString);
  
  // Define the output format (EEEE gives the full name of the day)
  DateFormat outputFormat = DateFormat("EEEE");
  
  // Format the DateTime object to get the day of the week as a string
  String dayOfWeek = outputFormat.format(dateTime).substring(0, 3);
  print(dayOfWeek);
  return dayOfWeek;
}
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: convertPtToPx(AppPadding.p16).w,right: convertPtToPx(AppPadding.p16).w,
      top: convertPtToPx(AppPadding.p16).h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r12).r),
          border: Border.all(
              color: AppColors.lightGrey6,
              width: AppSize.w1.w)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated(context, "orderDetails"),
            style: TextStyle(
              color: AppColors.pink2,
              fontWeight: AppFontsWeightManager.semiBold,
              fontSize: convertPtToPx(AppFontsSizeManager.s14).sp,
              fontFamily: getTranslated(context, "Montserratsemibold"),
            ),
          ),
          Center(
            child: Container(
                margin: EdgeInsets.only(
                    top: convertPtToPx(AppSize.h7).h,
                    bottom: convertPtToPx(AppSize.h8).h),
                color: AppColors.lightGrey,
                height: AppSize.h1.h,
                width: AppSize.w410_6.w),
          ),
    
          /// Call numbers.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "packageCall"),
            value: '${widget.package.callNum}',
          ),
    
          /// The appointment.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "theAppointment"),
            value:'${getDayOfWeek(widget.displayedTime!)} ${widget.displayedTime}-${widget.selectedTime == null ? '' : convertTime(widget.selectedTime!, context)}',
          ),
    
          /// Package price.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "packagePrice"),
            value:
                '${((widget.package.price * 100) / (100 - widget.package.discount)).toStringAsFixed(2)}\$', //'${widget.package.price} \$',
          ),
    
          /// discount.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "discount"),
            value: widget.package.discount == null || widget.package.discount == 0
                ? '- ${((widget.discount * widget.package.price) / 100).toStringAsFixed(2)}\$'
                : '- ${(widget.package.discount).toStringAsFixed(2)}',
          ),
    
          /// package price after discount.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "packagePriceAfter"),
            value:
                '${(widget.package.price - ((widget.discount * widget.package.price) / 100)).toStringAsFixed(2)}\$',
          ),
    
          Container(
              margin: EdgeInsets.only(
                  top: convertPtToPx(AppSize.h3).h,
                  bottom: convertPtToPx(AppSize.h11).h),
              color: AppColors.lightGrey,
              height: AppSize.h1.h,
              width: double.infinity),
          OrderDetailsLine(
            bottomPadding: AppPadding.p21_3.h,
            header: getTranslated(context, "totalAmount"),
            value:
                '${(widget.package.price - ((widget.discount * widget.package.price) / 100)).toStringAsFixed(2)}\$',
            headerColor: AppColors.pink2,
            valueColor: AppColors.pink2,
          ),
        ],
      ),
    );
  }


  
}
