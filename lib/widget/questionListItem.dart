import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/widget/playVideoWidget.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../models/questions.dart';

class QuestionListItem extends StatefulWidget {
  final Questions question;

  QuestionListItem({required this.question});

  @override
  _QuestionListItemState createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<QuestionListItem>
    with SingleTickerProviderStateMixin {
  bool open = false;
  String lang = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    return Container(
      width: size.width,
      padding: EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: lang == "ar" ? 20 : 18,
          right: lang == "ar" ? 10 : 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.white.withOpacity(0.5),
            onTap: () {
              setState(() {
                open = !open;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: AppSize.h10_6.h,
                  width: AppSize.w10_6.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.pink2),
                ),
                SizedBox(
                  width: AppSize.w16.w,
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Text(
                        lang == "ar"
                            ? widget.question.arQuestion
                            : StringUtils.capitalize(
                                widget.question.enQuestion),
                        maxLines: open ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "academyFontFamily"),
                          fontSize: AppFontsSizeManager.s24.sp,
                          fontWeight: FontWeight.w400,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 0.3
                            ..color = Color.fromRGBO(48, 48, 48, 1),
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        lang == "ar"
                            ? widget.question.arQuestion
                            : StringUtils.capitalize(
                                widget.question.enQuestion),
                        maxLines: open ? 4 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "academyFontFamily"),
                          fontSize: AppFontsSizeManager.s24.sp,
                          color: Color.fromRGBO(48, 48, 48, 1),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                open
                    ? SvgPicture.asset(
                        AssetsManager.redIosArrowDownIconPath,
                        width: AppSize.w24.w,
                        height: AppSize.h24.h,
                      )
                    : SvgPicture.asset(
                        AssetsManager.redIosArrowRightIconPath,
                        width: AppSize.w24.w,
                        height: AppSize.h24.h,
                      ),
              ],
            ),
          ),
          open
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(),
          open
              ? Center(child: PlayVideoWidget(url: widget.question.link))
              : SizedBox(),
          SizedBox(
            height: open ? 5 : 0,
          ),
        ],
      ),
    );
  }
}
