import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/text_form_field_widget.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:uuid/uuid.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';

class SecondReportScreen extends StatefulWidget {
  const SecondReportScreen({Key? key}) : super(key: key);

  @override
  State<SecondReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<SecondReportScreen> {
  late String reportReason;
  bool other = false;
  final TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: size.width,
                  child: Padding(
                                    padding:  EdgeInsets.only(
                    bottom: AppPadding.p21_3.h),
                                    child: AppBarWidget2(
                  text: getTranslated(context, "report"),
                                    ),
                                  )),
              Container(
                  color: AppColors.white3,
                  height: AppSize.h1_3.h,
                  width: size.width),
              SizedBox(
                height: AppSize.h42_6.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranslated(context, 'PleaseSpecifyTheReason'),
                      style: TextStyle(
                          color: AppColors.grey3,
                          fontFamily:
                              getTranslated(context, "Montserratsemibold"),
                          fontSize: AppFontsSizeManager.s21_3.sp,
                      fontWeight: FontWeight.w600),
                    ),
                    ReportListView(),
                    SizedBox(height: AppSize.h8.h,),
                    Container(
                      height: AppSize.h169_3.h,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: AppColors.lightGrey6),
                      //     borderRadius: BorderRadius.circular(AppRadius.r10.r)),
                      padding:  EdgeInsets.all(AppPadding.p6.r),
                      child: TextFormFieldWidget(
                        controller: description,
                        onsave: (value) {
                          setState(() {
                            reportReason = value.toString();
                            other = true;
                          });
                        },
                        maxLine: 6,
                        hintStyle: TextStyle(
                          fontFamily:
                              getTranslated(context, "Montserrat-Regular"),
                          color: Colors.grey,
                          fontSize: AppFontsSizeManager.s16.sp,
                          letterSpacing: 0.5,
                        ),
                        hint: getTranslated(context, 'enterOtherReason'),
                        borderColor: AppColors.white,
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: AppFontsSizeManager.s16.sp,
                          color: AppColors.black,
                        ),
                        cursorColor: Colors.black,
                        textInputType: TextInputType.multiline,
                      ),
                    ),
                    Container(
                      width: AppSize.w472.w,
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h31_3.h,
                    ),
                    Center(
                      child: Text(
                        getTranslated(context, "applicationtext"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppColors.lightGrey7,
                            fontSize: AppFontsSizeManager.s16.sp,
                            fontFamily: 'Inter-Medium'),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h165_3.h
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: AppPadding.p32.w),
                        child: Container(
                          width:  AppSize.w446_6.w,
                          height: AppSize.h65.h,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.r10_6.r),
                              color: AppColors.reddark2),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Text(getTranslated(context, "senD"),
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: AppFontsSizeManager.s21_3.sp,
                                    fontFamily: getTranslated(
                                        context, "Montserratmedium"))),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  String reportText;
  bool isSelected = false;

  ReportItem({
    super.key,
    required this.reportText,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            reportText,
            style: TextStyle(
                color: AppColors.black,
                fontFamily: getTranslated(context, "Montserratmedium"),
                fontSize: AppFontsSizeManager.s18_6.sp,
                fontWeight: FontWeight.w500,),
          ),
        ),
        SizedBox(
          width: AppSize.w20.w,
        ),
        SvgPicture.asset(
          isSelected
              ? AssetsManager.redEllipseIconPath
              : AssetsManager.greyEllipseIconPath,
          width: AppSize.w20.r,
          height: AppSize.h20.r,
        ),
      ],
    );
  }
}

class ReportListView extends StatefulWidget {
  const ReportListView({super.key});

  @override
  State<ReportListView> createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView> {
  List<String> reportTextItem = [
    "Feeling of cheating on the part of the partner",
    "Profile information does not match",
    "The response is not polite",
    "Not feeling safe while talking",
    "Other",
  ];
  int select = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppPadding.p32.h),
        child: GestureDetector(
          onTap: () {
            select = index;
            setState(() {});
          },
          child: ReportItem(
            reportText: reportTextItem[index],
            isSelected: select == index,
          ),
        ),
      ),
      itemCount: reportTextItem.length,
    );
  }
}
