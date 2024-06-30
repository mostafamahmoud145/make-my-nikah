import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/read_more_button.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import '../methodes/pt_to_px.dart';
import '../screens/coachBioDetailsScreen.dart';
import 'TextButton.dart';

class AboutMeWidget extends StatefulWidget {
  final GroceryUser consultant;

  const AboutMeWidget({super.key,required this.consultant});

  @override
  State<AboutMeWidget> createState() => _AboutMeWidgetState();
}

class _AboutMeWidgetState extends State<AboutMeWidget> {
  String lang ="";
  @override
  Widget build(BuildContext context) {
    return                   Center(
      child: Container(
        width: AppSize.w506_6.w,
        padding: EdgeInsets.all(convertPtToPx(AppPadding.p18.r)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
              convertPtToPx(AppRadius.r24.r)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(48, 48, 48, 0.06),
              blurRadius: 18.0,
              spreadRadius: 0.0,
              offset: Offset(
                  0, 9.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lang == "ar"
                    ? RotationTransition(
                  turns: AlwaysStoppedAnimation(180 / 360),

                  child: SvgPicture.asset(
                    AssetsManager.goldHeader1IconPath,
                    height: AppSize.h21_3.h,
                    width: AppSize.w8_3.w,
                  ),
                )
                    : SvgPicture.asset(
                  AssetsManager.goldHeader1IconPath,
                  height: AppSize.h21_3.h,
                  width: AppSize.w8_3.w,
                ),
                SizedBox(
                  width: AppSize.w16.w,
                ),
                Text(
                  getTranslated(context, "bio2"),
                  maxLines: 3,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: getTranslated(
                        context, "Montserratsemibold"),
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontsSizeManager.s21_3.sp,
                  ),
                ),
                SizedBox(
                  width: AppSize.w16.w,
                ),
                lang  == "ar" ? RotationTransition(
                  turns: AlwaysStoppedAnimation(180 / 360),

                  child: SvgPicture.asset(
                    AssetsManager.goldHeader1IconPath,
                    height: AppSize.h21_3.h,
                    width: AppSize.w8_3.w,
                  ),
                ):SvgPicture.asset(
                  AssetsManager.goldHeader2IconPath,
                  height: AppSize.h21_3.h,
                  width: AppSize.w8_3.w,
                ),
              ],
            ),
            SizedBox(
              height: AppSize.h26_6.h,
            ),
            Text(
              widget.consultant.bio!.length > 165
                  ? widget.consultant.bio!.substring(0, 165)
                  : widget.consultant.bio!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: getTranslated(context, "Montserrat"),
                color: AppColors.darkGrey,
                fontSize: AppFontsSizeManager.s18_6.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: AppSize.h26_6.h,
            ),
            ReadMoreButton(
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoachBioDetailsScreen(
                      consult: widget.consultant,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}
