import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class GirlRateWidget extends StatelessWidget {
  const GirlRateWidget({
    super.key,
    required this.title,
    required this.rate,
  });
  final String title;
  final num rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontFamily: getTranslated(context, "Montserratsemibold"),
            color: AppColors.black,
            fontSize: AppFontsSizeManager.s18_6.sp,
          ),
        ),
        Expanded(child: SizedBox()),
        RatingBar(
          initialRating: double.parse(rate.toString()),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: AppSize.w16.r,
          itemPadding: EdgeInsets.symmetric(horizontal: AppPadding.p2.w),
          ratingWidget: RatingWidget(
            full: Image.asset(
              "assets/icons/icon/baseline-favorite-24px.png",
              width: AppSize.w16.h,
              height: AppSize.h16.r,
            ),
            half: Image.asset(
              "assets/icons/icon/baseline-favorite-2.png",
              width: AppSize.w16.r,
              height: AppSize.h16.r,
            ),
            empty: Image.asset(
              "assets/icons/icon/baseline-favorite-1.png",
              width: AppSize.w16.r,
              height: AppSize.h16.r,
            ),
          ),
          onRatingUpdate: (double value) {},
        ),
      ],
    );
  }
}
