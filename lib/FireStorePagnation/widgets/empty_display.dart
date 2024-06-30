import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/resopnsive.dart';

class EmptyDisplay extends StatelessWidget {
  final String emptyText;
  const EmptyDisplay({Key? key,  required this.emptyText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: AppSize.h148.h,
            ),
            Text(
              getTranslated(context, emptyText),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.chatTime,
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize:  AppFontsSizeManager.s22.sp),
            ),
          ],
        ));
  }
}
