import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/presention/widget/text_title_with_fram.dart';
import 'package:grocery_store/widget/read_more_button.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class GirlInfoReadMore extends StatelessWidget {
  const GirlInfoReadMore({
    super.key,
    required this.onTapreadMore,
    required this.title,
    required this.summry,
  });

  final dynamic Function() onTapreadMore;
  final String title;
  final String summry;

  @override
  Widget build(BuildContext context) {
    return GirlDetailsContainer(
      child: Column(
        children: [
          TextTitleWithFram(title: title),
          SizedBox(
            height: AppSize.h26_6.h,
          ),
          Text(
            summry,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: getTranslated(context, "Montserratmedium"),
              color: AppColors.darkGrey,
              fontSize: AppFontsSizeManager.s18_6.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: AppSize.h26_6.h,
          ),
          ReadMoreButton(
            onPress: onTapreadMore,
          ),
        ],
      ),
    );
  }
}

class GirlDetailsContainer extends StatelessWidget {
  const GirlDetailsContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
        child: Container(
            width: size.width,
            padding: EdgeInsets.only(
                top: AppPadding.p21_3.h,
                right: AppPadding.p32.w,
                left: AppPadding.p32.w,
                bottom: AppPadding.p32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(32, 32, 32, 0.06),
                  blurRadius: 18.r,
                  spreadRadius: 0.0,
                  offset: Offset(0, 9.0), // shadow direction: bottom right
                )
              ],
            ),
            child: child));
  }
}
