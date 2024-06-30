
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../config/colorsFile.dart';


class LoadTimesShimmer extends StatelessWidget {
  const LoadTimesShimmer({Key? key, this.height= AppSize.h158}) : super(key: key);

  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: convertPtToPx(height).h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          Shimmer.fromColors(
              period: Duration(milliseconds: 800),
              baseColor: Colors.grey,
              highlightColor: AppColors.balck2.withOpacity(0.6),
              child: Container(
                height: convertPtToPx(AppSize.h20).h,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.green2.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                ),
              )),
          SizedBox(height: AppSize.h15.h,),
          Shimmer.fromColors(
              period: Duration(milliseconds: 800),
              baseColor: Colors.grey,
              highlightColor: AppColors.balck2.withOpacity(0.6),
              child: Container(
                height: convertPtToPx(AppSize.h40).h,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.green2.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                ),
              )),
        ],
      ),
    );
  }
}
