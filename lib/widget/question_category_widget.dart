import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/category_question_model.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import '../config/app_values.dart';
import '../config/paths.dart';
import '../models/questions.dart';
import 'questionListItem.dart';

class QuestionCategoryWidget extends StatefulWidget {
  final CategoryQuestion categoryQuestion;

  const QuestionCategoryWidget({required this.categoryQuestion});

  @override
  _QuestionCategoryWidgetState createState() => _QuestionCategoryWidgetState();
}

class _QuestionCategoryWidgetState extends State<QuestionCategoryWidget>
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
    return SingleChildScrollView(
      child: Container(
        width: size.width,
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
              child: Container(
                color: Color.fromRGBO(243, 245, 247, 1.0),
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p21_3.h,
                  horizontal: AppPadding.p32.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lang == "ar"
                            ? widget.categoryQuestion.titleAr
                            : StringUtils.capitalize(
                                widget.categoryQuestion.titleEn),
                        maxLines: open ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "academyFontFamily"),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          color: Color.fromRGBO(48, 48, 48, 1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    open ? Icon(Icons.remove) : Icon(Icons.add),
                  ],
                ),
              ),
            ),
            open
                ? SizedBox(
                    height: 10,
                  )
                : SizedBox(),
            open
                ? Center(
                    child: Questionslist(questionid: widget.categoryQuestion.id),
                  )
                : SizedBox(),
            SizedBox(
              height: open ? 5 : 0,
            ),
          ],
        ),
      ),
    );
  }
}

class Questionslist extends StatelessWidget {
  final String questionid;
  const Questionslist({
    super.key,
    required this.questionid,
  });

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      shrinkWrap: true,
      separator: Container(
        height: .5,
        width: AppSize.w506_6.w,
        color: Color.fromRGBO(211, 211, 211, 1.0),
      ),
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (context, documentSnapshot, index) {
        return QuestionListItem(
          question: Questions.fromMap(documentSnapshot[index].data() as Map),
        );
      },
      query: FirebaseFirestore.instance
          .collection(Paths.questionPath)
          .where('status', isEqualTo: true)
          .where("categoryQuestionListIds", arrayContains: questionid),
      isLive: true,
    );
  }
}
