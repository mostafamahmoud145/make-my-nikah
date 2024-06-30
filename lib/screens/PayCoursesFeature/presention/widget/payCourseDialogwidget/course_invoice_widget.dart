import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/coursePackage.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/order_details_line.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class CourseInvoiceWidget extends StatelessWidget {
  const CourseInvoiceWidget({
    super.key,
    required this.discount,
    required this.package,
  });

  // final CoachAppointment widget;
  final CoursePackage package;
  final discount;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(convertPtToPx(AppPadding.p16).w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r12).r),
          border: Border.all(
              color: Color.fromRGBO(211, 211, 211, 1.0),
              width: AppRadius.r1.r)),
  child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated(context, "orderDetails"),
            style: TextStyle(
                          color: AppColors.pink2,

              fontWeight: AppFontsWeightManager.semiBold,
              fontSize: convertPtToPx(AppFontsSizeManager.s14).sp,
              fontFamily: getTranslated(context, "Ithra"),
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

          /// Package price.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "packagePrice"),
            value:
                '${((package.price * 100) / (100 - package.discount)).toStringAsFixed(2)} \$', //'${widget.package.price} \$',
          ),

          /// discount.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "discount2"),
            value: package.discount == null || package.discount == 0
                ? '- ${((discount * package.price) / 100).toStringAsFixed(2)} \$'
                : '- ${(package.discount).toStringAsFixed(2)}',
          ),

          /// package price after discount.
          ///
          OrderDetailsLine(
            header: getTranslated(context, "packagePriceAfter"),
            value:
                '${(package.price - ((discount * package.price) / 100)).toStringAsFixed(2)} \$',
          ),

          Container(
              margin: EdgeInsets.only(
                  top: convertPtToPx(AppSize.h3).h,
                  bottom: convertPtToPx(AppSize.h8).h),
              color: AppColors.lightGrey,
              height: AppSize.h1.h,
              width: double.infinity),
          SizedBox(
            height: AppSize.h10_6.h,
          ),

          OrderDetailsLine(
            header: getTranslated(context, "totalAmount"),
            value:
                '${(package.price - ((discount * package.price) / 100)).toStringAsFixed(2)} \$',
            headerColor: AppColors.pink2,
            valueColor: AppColors.pink2,
          ),
        ],
      ),
    );
  }
}
