import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/partenerSpecificationScreen.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/text_form_field_widget.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../methodes/pt_to_px.dart';
import '../models/userDetails.dart';
import '../widget/processing_dialog.dart';

class AccountDetailScreen extends StatefulWidget {
  final String userid;
  final GroceryUser user;

  const AccountDetailScreen(
      {Key? key, required this.userid, required this.user})
      : super(key: key);

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  UserDetail? userDetails;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // late AccountBloc accountBloc;
  bool loadData = true;

  void getuserDetails(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(Paths.userDetail)
        .doc(userID)
        .get();
    setState(() {
      userDetails = UserDetail.fromMap(snapshot.data() as Map);
      loadData = false;
    });
  }

  @override
  void initState() {
    //String uid = ModalRoute.of(context).settings.arguments as String;
    getuserDetails(widget.userid);
    super.initState();
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: getTranslated(context, "loading"),
        );
      },
    );
  }

  void showSnack(String text, BuildContext context, bool status) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(10),
      backgroundColor:
          status ? Theme.of(context).primaryColor : Colors.red.shade500,
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
        style: TextStyle(
          fontFamily: getTranslated(context, "fontFamily"),
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  bottom: AppPadding.p21_3.h
                ),
                child: AppBarWidget2(
                  text: getTranslated(context, "account"),
                )),
            Center(
                child: Container(
                    color: AppColors.white3, height: 1, width: size.width)),
            loadData
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(left: AppSize.w20.w, right: AppSize.w20.w),
                      children: [
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(left: 64.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
        
                                    children: [
                                      Image.asset(
                                                                        AssetsManager.process2ImagePath,
                                                                        width: convertPtToPx(
                                      275.w,
                                                                        ),
                                                                        height: convertPtToPx(AppSize.h26.h),
                                                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppSize.h42.h,),
                                // Center(
                                //   child: InkWell(
                                //     onTap: () {
                                //       cropImage(context);
                                //     },
                                //     child: Container(height: 70,width: 70,
                                //       decoration: BoxDecoration(
                                //         shape: BoxShape.circle,
                                //         color: Colors.white,
                                //         boxShadow: [
                                //           BoxShadow(
                                //             offset: Offset(0, 0.0),
                                //             blurRadius: 5.0,
                                //             spreadRadius: 1.0,
                                //             color: Colors.black.withOpacity(0.6),
                                //           ),
                                //         ],
                                //       ),
                                //       child: widget.user.photoUrl==null &&selectedProfileImage == null
                                //           ?  Image.asset('assets/icons/icon/Mask Group 47.png', fit:BoxFit.fill,height: 70,width: 70)
                                //           : selectedProfileImage != null
                                //           ? ClipRRect(borderRadius:BorderRadius.circular(35.0),child: Image.file(selectedProfileImage,fit:BoxFit.fill,height: 70,width: 70))
                                //           : ClipRRect(borderRadius:
                                //       BorderRadius.circular(35.0),
                                //         child: FadeInImage.assetNetwork(
                                //           placeholder:'assets/icons/icon_person.png',
                                //           placeholderScale: 0.5,
                                //           imageErrorBuilder: (context, error, stackTrace) =>
                                //               Icon( Icons.person,color:Colors.black, size: 50.0,),
                                //           image: widget.user.photoUrl,
                                //           fit: BoxFit.cover,
                                //           fadeInDuration:
                                //           Duration(milliseconds: 250),
                                //           fadeInCurve: Curves.easeInOut,
                                //           fadeOutDuration:
                                //           Duration(milliseconds: 150),
                                //           fadeOutCurve: Curves.easeInOut,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(height: 10,),
                                // Center(
                                //   child: Text(
                                //     getTranslated(context, "welcomeBack"),
                                //     style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                //       color: AppColors.grey,
                                //       fontSize: 13.0,
                                //       fontWeight: FontWeight.normal,
                                //     ),),
                                // ),
                                // (widget.user.name!=null&&widget.user.name!="")?Center(
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(left: 20,right: 20),
                                //     child: Text(
                                //       widget.user.name,
                                //       maxLines: 1,
                                //       textAlign: TextAlign.center,
                                //       overflow:TextOverflow.clip ,
                                //       style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                                //         color: Theme.of(context).primaryColor,
                                //         fontSize: 20.0,
                                //       ),),
                                //   ),
                                // ):SizedBox(),
                                // SizedBox(height: 25,),
        
                                getTitle(getTranslated(context, "life")),
                                // widget.user.partnerSpecifications == ""
                                //     ? Center(
                                //   child: Text(
                                //     getTranslated(context, "about"),
                                //     style: TextStyle(color: Colors.red),
                                //   ),
                                // )
                                //     : SizedBox(),
        
                                ///------------------------TextFormFieldWidget------------------------////
        
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        iscenter: false,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.priorties == null
                                                ? ""
                                                : userDetails!.priorties,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.priorties = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(context, 'lifeText'),
                                        borderColor: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
        
                                SizedBox(height: AppSize.h16.h,),
        
                                getTitle(getTranslated(context, "fiveYears")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
        
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        iscenter: false,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.marriageYears == null
                                                ? ""
                                                : userDetails!.marriageYears,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.marriageYears = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'fiveYearsText'),
                                        borderColor: AppColors.white,
        
        
                                      ),
                                    ),
                                  ),
                                ),
        
                                SizedBox(height: AppSize.h16.h,),
        
                                getTitle(getTranslated(context, "nature")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        iscenter: false,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.characterNature == null
                                                ? ""
                                                : userDetails!.characterNature,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.characterNature = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'natureText'),
                                        borderColor: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
        
                                getTitle(getTranslated(context, "values")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
        
                                        maxLine: 6,
                                        iscenter: false,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue: userDetails!.values == null
                                            ? ""
                                            : userDetails!.values,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.values = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'valuesText'),
                                        borderColor: AppColors.white,
        
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
        
                                getTitle(getTranslated(context, "positive")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.positivePoints == null
                                                ? ""
                                                : userDetails!.positivePoints,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.positivePoints = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'positiveText'),
                                        borderColor: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(getTranslated(context, "negative")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        iscenter: false,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.negativePoints == null
                                                ? ""
                                                : userDetails!.negativePoints,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.negativePoints = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'negativeText'),
                                        borderColor: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(getTranslated(context, "habits")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue: userDetails!.habbits == null
                                            ? ""
                                            : userDetails!.habbits,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.habbits = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'habitsText'),
                                        borderColor: AppColors.white,
        
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(getTranslated(context, "hobbies")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue: userDetails!.hobbies == null
                                            ? ""
                                            : userDetails!.hobbies,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.hobbies = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'hobbiesText'),
                                        borderColor: AppColors.white,
        
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(getTranslated(context, "like")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.lovableThings == null
                                                ? ""
                                                : userDetails!.lovableThings,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.lovableThings = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint:
                                        getTranslated(context, 'likeText'),
                                        borderColor: AppColors.white,
        
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(getTranslated(context, "disLike")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.hatefulThings == null
                                                ? ""
                                                : userDetails!.hatefulThings,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.hatefulThings = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'disLikeText'),
                                        borderColor: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(
                                    getTranslated(context, "healthConditions")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height: convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.healthCondition == null
                                                ? ""
                                                : userDetails!.healthCondition,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.healthCondition = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'healthText'),
                                        borderColor: AppColors.white,
        
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(getTranslated(context, "quran")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height:convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          fontSize: 10.0,
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.quranLevel == null
                                                ? ""
                                                : userDetails!.quranLevel,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.quranLevel = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint:
                                        getTranslated(context, 'quranText'),
                                        borderColor: AppColors.white,
        
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSize.h16.h,),
                                getTitle(getTranslated(context, "sciences")),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: convertPtToPx(AppPadding.p10.r),
                                      bottom: convertPtToPx(AppPadding.p10.r)),
                                  child: Container(
                                    width: size.width * AppSize.w0_85,
                                    height:convertPtToPx(AppSize.h130.h),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.grey4),
                                        borderRadius: BorderRadius.circular(
                                            convertPtToPx(AppRadius.r10.r))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          convertPtToPx(AppPadding.p10.r)),
                                      child: TextFormFieldWidget(
                                        maxLine: 6,
                                        maxLength: 150,
                                        style: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "Montserrat-Medium"),
                                          fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                                          color: AppColors.grey,
                                        ),
                                        cursorColor: Colors.black,
                                        initialValue:
                                            userDetails!.religionLevel == null
                                                ? ""
                                                : userDetails!.religionLevel,
                                        textInputType: TextInputType.multiline,
                                        validator: (val) {
                                          // if (val.trim().isEmpty) {
                                          //   return getTranslated(context, 'required');
                                          // }
                                          return null;
                                        },
                                        onsave: (val) {
                                          userDetails!.religionLevel = val;
                                        },
                                        hintStyle: TextStyle(
                                          fontFamily: getTranslated(
                                              context, "fontFamily"),
                                          color: Colors.grey,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                        hint: getTranslated(
                                            context, 'sciencesText'),
                                        borderColor: AppColors.white,
        
                                      ),
                                    ),
                                  ),
                                ),
        
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: Container(
                                    width:convertPtToPx(AppSize.w335.w),
                                    height:convertPtToPx(AppSize.h50.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            AppColors.reddark2,
                                            AppColors.reddark2,
                                          ],
                                        )),
        
                                    child: InkWell(
                                      onTap: () async {
                                        save();
                                      },
                                      //   color: AppColors.red1,
        
                                      child: Center(
                                        child: Text(
                                          getTranslated(context, "saveAndContinue"),
                                          style: TextStyle(
                                            fontFamily:
                                                getTranslated(context, "Montserratsemibold"),
                                            color: Colors.white,
                                            fontSize: convertPtToPx(AppFontsSizeManager.s16.sp),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance
          .collection(Paths.userDetail)
          .doc(userDetails!.userId)
          .update(
        {
          "characterNature": userDetails!.characterNature,
          "habits": userDetails!.habbits,
          "hatefulThings": userDetails!.hatefulThings,
          "healthCondition": userDetails!.healthCondition,
          "hobbies": userDetails!.hobbies,
          "lovableThings": userDetails!.lovableThings,
          "marriageYears": userDetails!.marriageYears,
          "negativePoints": userDetails!.negativePoints,
          "positivePoints": userDetails!.positivePoints,
          "priorties": userDetails!.priorties,
          "quranLevel": userDetails!.quranLevel,
          "religionLevel": userDetails!.religionLevel,
          "values": userDetails!.values,
        },
      ).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PartnerSpecificationScreen(
                      userDetail: this.userDetails,
                    )));
      }).catchError((error) {
        print("error in adding data is $error");
        // showFailedSnakbar(error.toString());
      });
    }
  }
String  lang  = "";
  Widget getTitle(String title) {
    lang = getTranslated(context, "lang");
    return Text(
      title,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: getTranslated(context, "Montserratsemibold"),
          fontSize: convertPtToPx(AppFontsSizeManager.s16.sp),
          color: AppColors.reddark,
          fontWeight: FontWeight.w500),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: AppColors.grey.withOpacity(0.6),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: AppColors.grey.withOpacity(0.6),
            width: 1.0,
          ),
        ));
  }
}
