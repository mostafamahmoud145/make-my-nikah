import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/api/pdf_api.dart';
import 'package:grocery_store/api/pdf_paragraph_api.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/payHistory.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/models/userPaymentHistory.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../widget/IconButton.dart';
import '../methodes/pt_to_px.dart';
import '../widget/app_bar_widget.dart';

class ConsultPaymentHistoryScreen extends StatefulWidget {
  final GroceryUser user;

  const ConsultPaymentHistoryScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _ConsultPaymentHistoryScreenState createState() =>
      _ConsultPaymentHistoryScreenState();
}

class _ConsultPaymentHistoryScreenState
    extends State<ConsultPaymentHistoryScreen>{
  List<PayHistory> PayHistoryList = [];
  List<UserPaymentHistory> userPayHistoryList = [];
  bool load = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.
   addPostFrameCallback((_) => getPaymentHistory());
  
    WidgetsBinding.instance.
   addPostFrameCallback((_) => getPaymentHistoryCoach());
    
  }
  getPaymentHistoryCoach() async {
    try {
      print("**************************");
      print(widget.user.uid);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.userPaymentHistory)
          .where('otherData.uid', isEqualTo:widget.user.uid)
          .orderBy("payDateValue",descending: true)
          .get();
          print("0000000000000000000000000");
      var payList2 = List<UserPaymentHistory>.from(
        querySnapshot.docs.map(
          (snapshot) => 
          UserPaymentHistory.fromMap(snapshot.data() as Map),
        ),
      );
       print(payList2.length);
      print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      print(payList2.length);
      setState(() {
        userPayHistoryList = payList2;
        load = false;
      });
      
    } catch (e) {
      setState(() {
        load = false;
      });
    }
    
  }

  getPaymentHistory() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.payHistoryPath)
          .where('consultUid', isEqualTo: widget.user.uid)
          .orderBy("payDate", descending: true)
          .get();
      var payList = List<PayHistory>.from(
        querySnapshot.docs.map(
          (snapshot) => PayHistory.fromMap(snapshot.data() as Map),
        ),
      );
      print(payList.length);
      print(querySnapshot);
      setState(() {
        PayHistoryList = payList;
        load = false;
      });
    } catch (e) {
      setState(() {
        load = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int numItems = 10;
    List<bool> selected = List<bool>.generate(numItems, (int index) => false);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppBarWidget2(
                        text: getTranslated(context, "paymentHistory"),
                      ),
                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
            Center(
                child: Container(
                    color: AppColors.white3,
                    height: convertPtToPx(AppSize.h1.h),
                    width: size.width)),
            SizedBox(
              height: convertPtToPx(AppSize.h32.h),
            ),
            Center(
              child: Container(
                  width: convertPtToPx(AppSize.w133_5.w),
                  height: convertPtToPx(AppSize.h154_5.h),
                  child: SvgPicture.asset(
                    AssetsManager.paymentImagePath,
                  )),
            ),
            SizedBox(
              height: convertPtToPx(AppSize.h30.h),
            ),
            load
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(convertPtToPx(AppPadding.p20.r)),
                      children: [
                        for (int x = 0; x < PayHistoryList.length; x++)
                          Container(
                            height: convertPtToPx(AppSize.h48.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // '${new DateFormat('dd MMM yyyy, hh:mm a').format((PayHistoryList[x].payTime.toDate()))}',
                                widget.user.userType=="COACH"?
                                '${new DateFormat('dd MMM yyyy').format((                                
                                    userPayHistoryList[x].payDate.toDate()))}'
                                :  '${new DateFormat('dd MMM yyyy').format((                                
                                    PayHistoryList[x].payTime.toDate()))}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                          context, "Montserrat-Medium"),
                                      fontSize: convertPtToPx(
                                          AppFontsSizeManager.s14.sp),
                                      color: AppColors.lightGrey5,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  widget.user.userType=="COACH"?
                                   double.parse(userPayHistoryList[x]
                                              .amount
                                              .toString())
                                          .toStringAsFixed(1) +
                                      "\$":
                                  double.parse(PayHistoryList[x]
                                              .balance
                                              .toString())
                                          .toStringAsFixed(1) +
                                      "\$",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                          context, "Montserrat-SemiBold"),
                                      fontSize: convertPtToPx(
                                          AppFontsSizeManager.s16.sp),
                                      color: AppColors.balck3,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final String date =widget.user.userType=="COACH"?
                                    '${new DateFormat('dd MMM yyyy').format(userPayHistoryList[x].payDate.toDate())}':
                                        '${new DateFormat('dd MMM yyyy').format(PayHistoryList[x].payTime.toDate())}';
                                    final pdfFile =
                                        await PdfParagraphApi.generate(
                                            widget.user,
                                            PayHistoryList[x],
                                            date,
                                            size);
        
                                    ///TODO : package
                                    ///PdfApi.openFile(pdfFile);
                                  },
                                  child: SvgPicture.asset(
                                    AssetsManager.roundDownloadIconPath,
                                    color: AppColors.pink2,
                                    width: AppSize.w32.w,
                                    height: AppSize.h32.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding:
                              EdgeInsets.all(convertPtToPx(AppPadding.p10.r)),
                          child: Container(
                            width: size.width,
                            height: AppSize.h0_5.h,
                            color: AppColors.grey3,
                          ),
                        )
                      ],
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(top: convertPtToPx(AppPadding.p80.h)),
            ),
            //=========
          ],
        ),
      ),
    );
  }
}
