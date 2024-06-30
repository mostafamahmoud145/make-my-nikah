import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AskQusetions.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/questions/editQuestionScreen.dart';
import 'package:grocery_store/widget/playVideoWidget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/videoWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../models/questions.dart';

class RepeatedQuestionListItem extends StatefulWidget {
  final AskQuestions question;
  final GroceryUser user;

  RepeatedQuestionListItem({required this.question,required this.user});

  @override
  _QuestionListItemState createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<RepeatedQuestionListItem>
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
      // padding: EdgeInsets.only(
      //     top: 15,
      //     bottom: 15,
      //     left: lang == "ar" ? 20 : 18,
      //     right: lang == "ar" ? 10 : 18),
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
                  height: AppSize.h10_6.r,
                  width: AppSize.w10_6.r,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.pink2
                  ),
                ),
                SizedBox(width: AppSize.w8.w,),
                Expanded(
                  child: InkWell(
                    onTap: (){
                       (widget.user != null &&
                                  widget.user.userType == "SUPPORT")
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditQuestionScreen(
                                        questions: widget.question),
                                  ),
                                )
                              : SizedBox();
                    },
                    child: Text(
                     lang == "ar"
                              ? widget.question.arQuestion
                              : widget.question.enQuestion,
                      maxLines: open ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: getTranslated(context, "Montserratsemibold"),
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                open
                    ? SvgPicture.asset(
                  AssetsManager.redIosArrowDownIconPath,
                  width: AppSize.w24.r,
                  height: AppSize.h24.r,
                ):lang=="ar"?
                Icon(
                  Icons.keyboard_arrow_left_outlined,
                  size: AppSize.w24.r,
                  color: AppColors.pink2,
                )
                :SvgPicture.asset(
                  AssetsManager.redIosArrowRightIconPath,
                  width: AppSize.w24.r,
                  height: AppSize.h24.r,
                ),

              ],
            ),
          ),
          open
              ? SizedBox(
            height: AppSize.h37_3.h,
          )
              : SizedBox(),
          open
              ? IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  color: AppColors.pink2,
                  width: AppSize.w2.w,
                ),
                SizedBox(width: AppSize.w12.w,),
                SizedBox(
                  width: AppSize.w472.w,
                  child: Text(
                    lang == "ar"
                                  ? widget.question.arAnswer
                                  : widget.question.enAnswer,
                    style: TextStyle(
                      fontSize: AppFontsSizeManager.s18_6.sp,
                      color: AppColors.lightGrey7,
                      fontWeight: FontWeight.w400,
                       fontFamily: getTranslated(context, "Montserratmedium"),
                    ),
                  ),
                ),
              ],
            ),
          )
              : SizedBox(),
          SizedBox(
            height: open ? 5 : 0,
          ),
        ],
      ),
    );
  }
}
