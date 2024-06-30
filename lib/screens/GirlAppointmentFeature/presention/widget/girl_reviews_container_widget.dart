import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/presention/widget/girl_rate_widget.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/presention/widget/text_title_with_fram.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../../../config/app_values.dart';
import 'girl_info_read_more.dart';

class GirlReviewsContainerWidget extends StatelessWidget {
  const GirlReviewsContainerWidget({
    super.key,
    required this.consultant,
  });

  final GroceryUser consultant;

  @override
  Widget build(BuildContext context) {
    return GirlDetailsContainer(
      child: Column(
        children: [
          TextTitleWithFram(title: getTranslated(context, "Reviews")),
          SizedBox(
            height: AppSize.h32.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GirlRateWidget(
                  title: getTranslated(context, "Serious"),
                  rate: consultant.serious!),
              SizedBox(
                height: AppSize.h16.h,
              ),
              GirlRateWidget(
                  title: getTranslated(context, "polite"),
                  rate: consultant.polite!),
              SizedBox(
                height: AppSize.h16.h,
              ),
              GirlRateWidget(
                  title: getTranslated(context, "exceptional"),
                  rate: consultant.exceptional!),
              SizedBox(
                height: AppSize.h16.h,
              ),
              GirlRateWidget(
                  title: getTranslated(context, "appropriate"),
                  rate: consultant.appropriate!),
            ],
          ),
        ],
      ),
    );
  }
}
