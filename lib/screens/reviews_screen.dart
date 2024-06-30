
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/consultReview.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/consultReviewWidget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../widget/IconButton.dart';
import '../widget/app_bar_widget.dart';
class ReviewScreens extends StatefulWidget {
  final GroceryUser consult;
  final int reviewLength;
  const ReviewScreens({Key? key, required this.consult, required this.reviewLength}) : super(key: key);
  @override
  _ReviewScreensState createState() => _ReviewScreensState();
}

class _ReviewScreensState extends State<ReviewScreens> {
  late List<ConsultReview>reviews;
  String lang = "";
  String theme="light";
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    lang  = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(children: [
            AppBarWidget2(
              text: getTranslated(context, "Reviews"),
            ),
            SizedBox(height: AppSize.h21_3.h,),
            Center(
                child: Container(
                    color: AppColors.white3, height: 1, width: size.width )),
            Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppSize.h42.h,
                  ),
                  //pb i
                  Center(
                    child: SvgPicture.asset(AssetsManager.mask_groupImagePath,
                    color: AppColors.pink2,
                    width: convertPtToPx(AppSize.w40_6.w),
                      height: convertPtToPx(AppSize.h39.h),
                    ),
                  ),
                  SizedBox(height: AppSize.h32.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   lang == "ar" ? SvgPicture.asset(
                     AssetsManager.goldHeader2IconPath,
                     height: AppSize.h26_6.h,
                     width: AppSize.w10_6.w,
                   ) :  SvgPicture.asset(
                        AssetsManager.goldHeader1IconPath,
                        height: AppSize.h26_6.h,
                        width: AppSize.w10_6.w,
                      ),
                      SizedBox(
                        width: AppSize.w16.w,
                      ),
                      Text(
                        widget.consult.name!,
                        style: TextStyle(
                          fontFamily:
                          getTranslated(context, "Montserratsemibold"),
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: AppFontsSizeManager.s26_6.sp,
                        ),
                      ),
                      SizedBox(
                        width:AppSize.w16.w,
                      ),
                      lang == "ar" ? SvgPicture.asset(
                        AssetsManager.goldHeader1IconPath,
                        height: AppSize.h26_6.h,
                        width: AppSize.w10_6.w,
                      ) :   SvgPicture.asset(
                        AssetsManager.goldHeader2IconPath,
                        height: AppSize.h26_6.h,
                        width: AppSize.w10_6.w,
                      ),
                    ],
                  ),
          
                ],
              ),
            ),
           SizedBox(height: AppSize.h32.h,),
           Expanded(
              child: PaginateFirestore(
                itemBuilderType: PaginateBuilderType.listView,
               //Change types accordingly
                itemBuilder: ( context, documentSnapshot,index) {
                  return  ConsultReviewWidget(
                    review: ConsultReview.fromMap(documentSnapshot[index].data() as Map), );
                },
                separator:Padding(
                  padding:  EdgeInsets.symmetric(vertical: AppPadding.p24.h,horizontal: AppPadding.p32.w),
                  child: Container(
                      color: AppColors.white3, height: AppSize.h1_3.h, width: size.width),
                ),
                query: FirebaseFirestore.instance.collection('ConsultReview')
                    .where('consultUid', isEqualTo: widget.consult.uid)
                    .orderBy("reviewTime", descending: true),
                /*widget.consult.userType=="CONSULTANT"? FirebaseFirestore.instance.collection('ConsultReview')
                    .where('consultUid', isEqualTo: widget.consult.uid)
                    .orderBy("reviewTime", descending: true):
                FirebaseFirestore.instance.collection('ConsultReview')
                    .where('uid', isEqualTo: widget.consult.uid)
                    .orderBy("reviewTime", descending: true),*/
                // to fetch real-time data
                isLive: true,
              ),
            )
          ],),
        ),
      ),
    );
  }


}
