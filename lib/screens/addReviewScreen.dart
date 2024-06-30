import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/consultReview.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/reportScreen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:uuid/uuid.dart';

import '../widget/TextButton.dart';
import '../widget/nikah_dialog.dart';

class AddReviewScreen extends StatefulWidget {
  final String consultId;
  final String userId;
  final String appointmentId;

  const AddReviewScreen(
      {Key? key,
      required this.consultId,
      required this.userId,
      required this.appointmentId})
      : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  bool load = true, adding = false, report = false;
  late GroceryUser consult, user;
  dynamic seriousRating = 0.0,
      politeRating = 0.0,
      exceptRating = 0.0,
      appropriateRating = 0.0,
      rating = 0.0,
      coachRate = 0.0;

  String name = "....", image = "", rateDescription = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getConsultDetails();
  }

  Future<void> getConsultDetails() async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.consultId);
    final DocumentSnapshot documentSnapshot = await docRef.get();

    DocumentReference docRef2 = FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.userId);
    final DocumentSnapshot documentSnapshot2 = await docRef2.get();
    setState(() {
      consult = GroceryUser.fromMap(documentSnapshot.data() as Map);
      name = consult.name!;
      image = consult.photoUrl!;

      seriousRating = (consult.serious == null) ? 0.0 : consult.serious;
      politeRating = (consult.polite == null) ? 0.0 : consult.polite;
      exceptRating = (consult.exceptional == null) ? 0.0 : consult.exceptional;
      appropriateRating =
          (consult.appropriate == null) ? 0.0 : consult.appropriate;

      user = GroceryUser.fromMap(documentSnapshot2.data() as Map);
      print("userdata");
      print(user.name);
      load = false;
    });
  }

  //add review dialog
  reviewDialog() {
    return showDialog(
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: AppColors.white),),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: Container(
                      height: AppSize.h61_3.h,
                      width: AppSize.w61_3.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 12,
                            spreadRadius: 0.0,
                            offset:
                            Offset(0, 1.0), // shadow direction: bottom right
                          )
                        ],
                        shape: BoxShape.circle,
                        // color: Colors.white,
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: AppPadding.p10.w,vertical: AppPadding.p10.w),
                        child: SvgPicture.asset(AssetsManager.yellowStarIconPath,
                            fit: BoxFit.contain,
                            height: AppSize.h32.h,
                            width: AppSize.w32.w),
                      ))),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Text(
                getTranslated(context, "rateText"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s24.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Center(
                child: Container(
                  width: AppSize.w261_3.w,
                  height: AppSize.h61_3.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [AppColors.reddark2, AppColors.brown],
                      )),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        getTranslated(context, 'continue'),
                        style: TextStyle(
                          fontFamily: getTranslated(context, "Montserratmedium"),
                          color: Colors.white,
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }


  void showNoNotifSnack(String text, bool status) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    String star = getTranslated(context, "stars");
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 30.0, bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                             /*  Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (route) => false,
                              ); */
                            },
                            icon: Image.asset(
                              AssetsManager.blackExitIconPath,
                              width: convertPtToPx(AppSize.w24.w),
                              height: convertPtToPx(AppSize.h24.h),
                            )),
                      ),
                    ),
                  ],
                ),
              ))),
          load
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 20),
                    children: [
                      consult.userType != "CONSULTANT"
                          ? Center(
                              child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                consult.photoUrl!,
                                width: convertPtToPx(AppSize.w85_3.w),
                                height: convertPtToPx(AppSize.h85.h),
                                fit: BoxFit.cover,
                              ),
                            ))
                          : Image.asset(
                              AssetsManager.review,
                              width: convertPtToPx(AppSize.w100.w),
                              height: convertPtToPx(AppSize.h104.h),
                            ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      consult.userType != "CONSULTANT"
                          ? Center(
                              child: Text(
                                consult.name!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratsemibold"),
                                  fontSize:
                                      convertPtToPx(AppFontsSizeManager.s20.sp),
                                  color: AppColors.black,
                                  //fontWeight: FontWeight.w300
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: AppSize.h48.h,
                      ),
                      Center(
                        child: Text(
                          consult.userType == "CONSULTANT"
                              ? getTranslated(context, "rateConsult")
                              : getTranslated(context, "rateCoach"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s18.sp),
                              color: AppColors.pink2,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      consult.userType == "CONSULTANT"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getTranslated(context, "Serious"),
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                        context,
                                        "fontFamily",
                                      ),
                                      fontSize: 14,
                                      color: AppColors.black),
                                ),
                                RatingBar(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: convertPtToPx(AppSize.w18.w),
                                  ratingWidget: RatingWidget(
                                    full: SvgPicture.asset(
                                      AssetsManager.redHeader1IconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    half: SvgPicture.asset(
                                      AssetsManager.redHeader1IconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    empty: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    seriousRating = rating;
                                    print("seious = $seriousRating");
                                  },
                                ),
                              ],
                            )
                          : SizedBox(),
                      consult.userType == "CONSULTANT"
                          ? SizedBox(
                              height: 30,
                            )
                          : SizedBox(),
                      consult.userType == "CONSULTANT"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getTranslated(context, "polite"),
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                        context,
                                        "fontFamily",
                                      ),
                                      fontSize: 14,
                                      color: AppColors.black),
                                ),
                                RatingBar(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: convertPtToPx(AppSize.w18.w),
                                  ratingWidget: RatingWidget(
                                    full: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    half: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    empty: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    politeRating = rating;

                                    print("polite = $politeRating");
                                  },
                                ),
                              ],
                            )
                          : SizedBox(),
                      consult.userType == "CONSULTANT"
                          ? SizedBox(height: 30)
                          : SizedBox(),
                      consult.userType == "CONSULTANT"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getTranslated(context, "exceptional"),
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                        context,
                                        "fontFamily",
                                      ),
                                      fontSize: 14,
                                      color: AppColors.black),
                                ),
                                RatingBar(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: convertPtToPx(AppSize.w18.w),
                                  ratingWidget: RatingWidget(
                                    full: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    half: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    empty: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    exceptRating = rating;
                                  },
                                ),
                              ],
                            )
                          : SizedBox(),
                      consult.userType == "CONSULTANT"
                          ? SizedBox(height: 30)
                          : SizedBox(),
                      consult.userType == "CONSULTANT"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getTranslated(context, "appropriate"),
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                        context,
                                        "fontFamily",
                                      ),
                                      fontSize: 14,
                                      color: AppColors.black),
                                ),
                                RatingBar(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: convertPtToPx(AppSize.w18.w),
                                  ratingWidget: RatingWidget(
                                    full: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    half: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                    empty: SvgPicture.asset(
                                      AssetsManager.greyHeartIconPath,
                                      width: convertPtToPx(AppSize.w18.w),
                                      height: convertPtToPx(AppSize.h18_6.h),
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    appropriateRating = rating;
                                  },
                                ),
                              ],
                            )
                          : SizedBox(),
                      consult.userType == "CONSULTANT"
                          ? SizedBox(
                              height: 30,
                            )
                          : SizedBox(),
                      consult.userType == "COACH"
                          ? Center(
                              child: RatingBar(
                                initialRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: convertPtToPx(AppSize.w18.w),
                                ratingWidget: RatingWidget(
                                  full: SvgPicture.asset(
                                    AssetsManager.redHeartIconPath,
                                    width: convertPtToPx(AppSize.w18.w),
                                    height: convertPtToPx(AppSize.h18_6.h),
                                  ),
                                  half: SvgPicture.asset(
                                    AssetsManager.redHeartIconPath,
                                    width: convertPtToPx(AppSize.w18.w),
                                    height: convertPtToPx(AppSize.h18_6.h),
                                  ),
                                  empty: SvgPicture.asset(
                                    AssetsManager.greyHeartIconPath,
                                    width: convertPtToPx(AppSize.w18.w),
                                    height: convertPtToPx(AppSize.h18_6.h),
                                  ),
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    coachRate = rating;
                                  });
                                  print("ratttttt");
                                  print(coachRate);
                                },
                              ),
                            )
                          : SizedBox(),
                      consult.userType == "COACH"
                          ? SizedBox(
                              height: AppSize.h64.h,
                            )
                          : SizedBox(),
                      Container(
                        height: AppSize.h200.h,
                        width: AppSize.w508.w,
                        //padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppRadius.r10_6.r),
                          border: Border.all(
                              color: AppColors.lightGrey6, width: 0.3),
                        ),
                        child: TextFormField(
                          maxLines: 7,

                          //maxLength: 152,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.black,
                          ),
                          cursorColor: Colors.black,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            setState(() {
                              rateDescription = value;
                            });
                          },
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p21_3.w),
                            counterStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: AppFontsSizeManager.s18_6.sp,
                            ),
                            hintStyle: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              color: Colors.grey,
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              letterSpacing: 0.5,
                            ),
                            hintText: getTranslated(context, 'description'),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,

                            //  hintText: sLabel
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h63_5.h,
                      ),
                      Center(
                        child: adding
                            ? CircularProgressIndicator()
                            : Container(
                              width: AppSize.w446_6.w,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        AppColors.reddark2,
                                        AppColors.brown
                                      ]),
                                  borderRadius: BorderRadius.circular(
                                      convertPtToPx(AppRadius.r8.r))),
                              height: convertPtToPx(AppSize.h50.h),
                              child: InkWell(
                                onTap: () async {
                                  if (consult.userType == "COACH")
                                    addCoachReview(coachRate);
                                  else
                                    addReview();
                                },
                                //   color: AppColors.red1,
                                child: Center(
                                  child: Text(
                                    getTranslated(context, "sendRate"),
                                    style: TextStyle(
                                      fontFamily: getTranslated(
                                          context, "Montserratsemibold"),
                                      color: AppColors.white,
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                      SizedBox(
                        height: AppSize.h30_6.h,
                      ),
                      report
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                            padding:  EdgeInsets.symmetric(horizontal: AppPadding.p25.w),
                            child: TextButton1(
                                                    BorderColor: AppColors.pink2,
                              onPress: () async {
                                setState(() {
                                  report = true;
                                });
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(Paths.complaintsPath)
                                        .where('uid',
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .where('appointmentId',
                                            isEqualTo: widget.appointmentId)
                                        .get();
                                setState(() {
                                  report = false;
                                });
                                if (querySnapshot.size > 0) {
                                  showSnack(
                                      getTranslated(context, "ratedbefor"),
                                      context);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReportScreen(
                                              user: this.user,
                                              consult: this.consult,
                                              appointmentId:
                                                  widget.appointmentId,
                                            )),
                                  );
                                }
                              },
                              Width: AppSize.w446_6.w,
                              Height: AppSize.h66_6.h,
                              Title: getTranslated(context, "report"),
                              ButtonRadius: AppRadius.r10_6.r,
                              TextSize: AppFontsSizeManager.s21_3.sp,
                              ButtonBackground: AppColors.white,
                              TextFont: getTranslated(
                                  context, "Montserratsemibold"),
                              TextColor: AppColors.reddark2,
                            ),
                          )
                    ],
                  ),
                ),
        ]),
      ),
    );
  }

  Future<void> addReview() async {
    setState(() {
      adding = true;
    });
    try {
      String reviewId = widget.appointmentId; //Uuid().v4();
      double review =
          (seriousRating + politeRating + exceptRating + appropriateRating) / 4;
      await FirebaseFirestore.instance
          .collection(Paths.consultReviewsPath)
          .doc(reviewId)
          .set({
        'serious': double.parse((seriousRating.toString())),
        'polite': double.parse((politeRating.toString())),
        'exceptional': double.parse((exceptRating.toString())),
        'appropriate': double.parse((appropriateRating.toString())),
        'review': review.toString(),
        'description': rateDescription,
        'uid': user.uid,
        'name': user.name,
        'image': user.photoUrl,
        'consultUid': consult.uid,
        'appointmentId': widget.appointmentId,
        'reviewTime': Timestamp.now(),
        'consultName': consult.name,
        'consultImage': consult.photoUrl,
      }, SetOptions(merge: true));

      //update user review
      List<ConsultReview> reviews;
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection(Paths.consultReviewsPath)
            .where('consultUid', isEqualTo: consult.uid)
            .get();

        reviews = List<ConsultReview>.from(
          (snap.docs).map(
            (e) => ConsultReview.fromMap(e.data() as Map),
          ),
        );
        double seriousRating = 0,
            politeRating = 0,
            exceptionalRating = 0,
            appropriateRating = 0;
        if (reviews.length > 0) {
          for (var review in reviews) {
            seriousRating =
                seriousRating + double.parse(review.serious.toString());
            politeRating =
                politeRating + double.parse(review.polite.toString());
            exceptionalRating =
                exceptionalRating + double.parse(review.exceptional.toString());
            appropriateRating =
                appropriateRating + double.parse(review.appropriate.toString());
          }
          seriousRating = seriousRating / reviews.length;
          politeRating = politeRating / reviews.length;
          exceptionalRating = exceptionalRating / reviews.length;
          appropriateRating = appropriateRating / reviews.length;

          seriousRating = double.parse((seriousRating.toStringAsFixed(1)));
          politeRating = double.parse((politeRating.toStringAsFixed(1)));
          exceptionalRating =
              double.parse((exceptionalRating.toStringAsFixed(1)));
          appropriateRating =
              double.parse((appropriateRating.toStringAsFixed(1)));

          await FirebaseFirestore.instance
              .collection(Paths.usersPath)
              .doc(consult.uid)
              .set({
            'serious': seriousRating,
            'polite': politeRating,
            'exceptional': exceptionalRating,
            'appropriate': appropriateRating,
            'reviewsCount': reviews.length,
          }, SetOptions(merge: true));
        }
        setState(() {
          adding = false;
        });
        Navigator.pop(context);
      } catch (e) {
        print("reviewwwwww" + e.toString());
      }
    } catch (e) {
      print("reviewwwwww222" + e.toString());
    }
    //}
  }

  Future<void> addCoachReview(double value) async {
    setState(() {
      adding = true;
    });
    print("addCoachReview");
    print(value);

    try {
      String reviewId = widget.appointmentId; //Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.consultReviewsPath)
          .doc(reviewId)
          .set({
        'rating': double.parse((value.toString())),
        'review': rateDescription,
        'uid': user.uid,
        'name': user.name,
        'image': user.photoUrl,
        'consultUid': consult.uid,
        'appointmentId': widget.appointmentId,
        'reviewTime': Timestamp.now(),
        'consultName': consult.name,
        'consultImage': consult.photoUrl,
      }, SetOptions(merge: true));
      print("addCoachReview11");
      //update user review
      List<ConsultReview> reviews;
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection(Paths.consultReviewsPath)
            .where('consultUid', isEqualTo: consult.uid)
            .get();
        print("addCoachReview1122");
        reviews = List<ConsultReview>.from(
          (snap.docs).map(
            (e) => ConsultReview.fromMap(e.data() as Map),
          ),
        );
        double _rating = 0;
        if (reviews.length > 0) {
          for (var review in reviews) {
            _rating = _rating + double.parse(review.rating.toString());
          }
          print("addCoachReview11333");
          _rating = _rating / reviews.length;
          _rating = double.parse((_rating.toStringAsFixed(1)));
          await FirebaseFirestore.instance
              .collection(Paths.usersPath)
              .doc(consult.uid)
              .set({
            'rating': _rating,
            'reviewsCount': reviews.length,
          }, SetOptions(merge: true));
        }
        print("addCoachReview11444");
        setState(() {
          adding = false;
        });
        reviewDialog();
      } catch (e) {
        print("reviewwwwww" + e.toString());
        return null;
      }
    } catch (e) {
      print("reviewwwwww222" + e.toString());
    }
  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: Colors.green.shade500,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

}
