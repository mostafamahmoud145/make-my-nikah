import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/widget/TextButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../../config/colorsFile.dart';
import '../../localization/localization_methods.dart';
import '../../models/user.dart';
import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/paths.dart';
import '../methodes/pt_to_px.dart';
import '../models/consultReview.dart';
import '../screens/reviews_screen.dart';
import 'consultReviewWidget.dart';

class ReviewWidget extends StatefulWidget {
  final GroceryUser consultant;

  ReviewWidget({required this.consultant});

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget>
    with SingleTickerProviderStateMixin {
  bool loadReviews = true;
  int reviewLength = 1;
  List<ConsultReview> reviews = [];
  String lang= "";

  @override
  void initState() {
    super.initState();
    getConsultReviews();
  }

  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    return Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal:convertPtToPx(AppPadding.p24.w)),
                      child: Container(
                        width: size.width,
                        
                        decoration: BoxDecoration(
                         
                          borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r25.r)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.white4,
                              blurRadius: AppRadius.r25.r,
                                spreadRadius: 2,
                               offset: Offset(
                              0, 10), // shadow direction: bottom right
                              )
                                            
                                             ],
                        ),
                        child: Container(
                          padding:  EdgeInsets.only(
                          bottom:  AppPadding.p24.h,
                          top:  AppPadding.p21_3.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: 
                          BorderRadius.circular(convertPtToPx(AppRadius.r24).r),
                         
                        ),child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              lang=="ar"?
              SvgPicture.asset(
                  AssetsManager.goldHeader2IconPath,
                  height: AppSize.h21_3.h,
                  width: AppSize.w8_3.w,
                ):  SvgPicture.asset(
                  AssetsManager.goldHeader1IconPath,
                  height: AppSize.h21_3.h,
                  width: AppSize.w8_3.w,
                ),
                SizedBox(
                  width: AppSize.w16.w,
                ),
                Text(
                  getTranslated(context, "Reviews"),
                  style: TextStyle(
                    fontFamily:
                    getTranslated(context, "Montserratsemibold"),
                    color: AppColors.blackColor,
                    fontSize: AppFontsSizeManager.s21_3.sp,
                  ),
                ),
                SizedBox(
                  width: AppSize.w16.w,
                ),
               lang=="ar"?
               SvgPicture.asset(
                  AssetsManager.goldHeader1IconPath,
                  height: AppSize.h21_3.h,
                  width: AppSize.w8_3.w,
                ): SvgPicture.asset(
                  AssetsManager.goldHeader2IconPath,
                  height: AppSize.h21_3.h,
                  width: AppSize.w8_3.w,
                ),
              ],
            ),
            
            SizedBox(
              height: 5,
            ),
            loadReviews
                ? Center(child: CircularProgressIndicator())
                : SizedBox(),
            (loadReviews == false && reviews.length == 0)
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: AppSize.h32.h,
                      ),
                      Text(
                        getTranslated(context, "noReviews"),
                        style: TextStyle(
                          fontFamily: getTranslated(context, "Montserratsemibold"),
                          color: Colors.black.withOpacity(0.5),
                         fontSize: AppFontsSizeManager.s21_3.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h32.h,
                      ),
                    ],
                  ),
                )
                : SizedBox(),
            (loadReviews == false && reviews.length > 0)
                ? ListView.separated(
                    itemCount: reviews.length > 2 ? 2 : reviews.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                   
                    itemBuilder: (context, index) {
                      return ConsultReviewWidget(review: reviews[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: AppPadding.p32.h),
                        child: Center(
                            child: Container(
                          color: AppColors.lightGrey8,
                          width: size.width,
                          height: AppSize.h1.h,
                        )),
                      );
                    },
                  )
                : SizedBox(),
           
            TextButton1(onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreens(
                      consult: widget.consultant,
                      reviewLength: reviews.length),
                ),
              );
            }, Width: AppSize.w138_6.w,
            Height: AppSize.h42_6.h,
            Title: getTranslated(context, "readMore"),
             ButtonRadius: AppRadius.r5_3.r
             , ButtonBackground: AppColors.pink2,
             TextSize: AppFontsSizeManager.s16.sp,
              TextFont:  getTranslated(context, "Montserratsemibold"),
               TextColor: AppColors.white,
               IconSpace:AppSize.w5_3.w,
               Icon: AssetsManager.backIcon,
               IconColor: AppColors.white,
               IconWidth: AppSize.w21_3.r,
               IconHeight: AppSize.h21_3.r,
               Direction: TextDirection.ltr,),
          ],
        ),
      ),
    )));
  }

  getConsultReviews() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.consultReviewsPath)
          .where('consultUid', isEqualTo: widget.consultant.uid)
          .limit(3)
          .orderBy("reviewTime", descending: true)
          .get();
      var reviewsList = List<ConsultReview>.from(
        querySnapshot.docs.map(
          (snapshot) => ConsultReview.fromMap(snapshot.data() as Map),
        ),
      );
      setState(() {
        reviewLength = reviewsList.length;
        reviews = reviewsList;
        loadReviews = false;
      });
    } catch (e) {
      setState(() {
        loadReviews = false;
      });
    }
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 1.0), // shadow direction: bottom right
    );
  }
}
