import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:http/http.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/text_form_field_widget.dart';
import 'package:uuid/uuid.dart';


import '../methodes/pt_to_px.dart';
import '../widget/TextButton.dart';
import '../widget/app_bar_widget.dart';

class SuggestionScreen extends StatefulWidget {
  final GroceryUser? loggedUser;

  const SuggestionScreen({Key? key, this.loggedUser}) : super(key: key);

  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool saving = false;
  late GroceryUser user;
  List<GroceryUser> users = [];
  String? title, des, theme;
  String lang = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getThemeName().then((theme) {
      setState(() {
        this.theme = theme;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.white1,
        body: SafeArea(
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: size.width,
                    // height: 80,
                    // color: Colors.white,
                    padding: EdgeInsets.only(
                      bottom: AppPadding.p21_3.h
                    ),
                    child: AppBarWidget2(
                        text: getTranslated(context, "suggestions") ,
                      )
                ),
                Center(
                    child: Container(
                        color: AppColors.white3, height: 1, width: size.width)),
                Expanded(
                  child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: <Widget>[
                        SizedBox(height: AppSize.h42_6.h,),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  AssetsManager.suggetionImagePath,
                                  width: AppSize.w162_3.w,
                                  height: AppSize.h191.h,
                                ),
                                SizedBox(height: AppSize.h42_6.h,),
                                /*Text(
                            getTranslated(context, "suggestionText"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 6,
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 12.0,color:AppColors.grey2),
                          ),
                          SizedBox(
                            height: size.height * 0.1,
                          ),*/
                                ///---------TextFormFieldWidget----------////
          
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTitle(getTranslated(context, 'title'),),
                                    SizedBox(
                                      height: AppSize.h21_3.h,
                                    ),
                                    Container(
                                      width: AppSize.w506_6.w,
                                      height: AppSize.h70_6.h,
                                      padding: EdgeInsets.zero,
                                      child: TextFormFieldWidget(
                                          style: TextStyle(
                                            fontFamily:
                                                getTranslated(context, "Montserratmedium"),
                                            fontSize: AppFontsSizeManager.s16.sp,
                                            color: AppColors.grey2,
                                          ),
                                           cursorColor: AppColors.reddark2,
                                        textInputType:TextInputType.text,
                                        //iscenter: true,
                                          validator: (String? val) {
                                            if (val!.trim().isEmpty) {
                                              return getTranslated(context, 'required');
                                            }
                                            return null;
                                          },
                                          onsave: (val) {
                                            title = val!;
                                          },
                                          enableInteractiveSelection: true,
                                            insidePadding:
                                                EdgeInsets.only(left: AppPadding.p1.r, right: AppPadding.p1.r),
                                            hintStyle: TextStyle(
                                              fontFamily:
                                                  getTranslated(context, "Montserratmedium"),
                                              color: Colors.grey,
                                              fontSize: AppFontsSizeManager.s21_3.sp,
                                              letterSpacing: 0.5,
                                            ),
                                            hint: getTranslated(context, 'title'),
                                        borderRadiusValue: AppRadius.r10_6.r,
                                        backGroundColor: AppColors.white,
                                        borderColor: AppColors.grey3,
                                      ),
                                      //old
          
                                      // child: TextFormField(
                                      //   style: TextStyle(
                                      //     fontFamily:
                                      //         getTranslated(context, "fontFamily"),
                                      //     fontSize: 12.0,
                                      //     color: AppColors.grey2,
                                      //   ),
                                      //   cursorColor: AppColors.reddark2,
                                      //   keyboardType: TextInputType.text,
                                      //   textAlign: TextAlign.center,
                                      //   validator: (String? val) {
                                      //     if (val!.trim().isEmpty) {
                                      //       return getTranslated(context, 'required');
                                      //     }
                                      //     return null;
                                      //   },
                                      //   onSaved: (val) {
                                      //     title = val!;
                                      //   },
                                      //   enableInteractiveSelection: true,
                                      //   decoration: new InputDecoration(
                                      //     contentPadding:
                                      //         EdgeInsets.only(left: 1, right: 1),
                                      //     hintStyle: TextStyle(
                                      //       fontFamily:
                                      //           getTranslated(context, "fontFamily"),
                                      //       color: Colors.grey,
                                      //       fontSize: 12,
                                      //       letterSpacing: 0.5,
                                      //     ),
                                      //     hintText: getTranslated(context, 'title'),
                                      //     prefixIcon: Icon(
                                      //       Icons.location_on_outlined,
                                      //       size: 20,
                                      //       color: AppColors.reddark2,
                                      //     ),
                                      //     // Center(child: Image.asset("assets/icons/icon/location.png",width: 5,height: 5,)),
                                      //     focusedBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(10.0),
                                      //     ),
                                      //     enabledBorder: OutlineInputBorder(
                                      //       borderSide: const BorderSide(
                                      //           color: AppColors.grey3, width: 0.5),
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //     ),
                                      //
                                      //     //  hintText: sLabel
                                      //   ),
                                      // ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppSize.h32.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTitle( getTranslated(context, 'description')),
                                    SizedBox(
                                      height: AppSize.h21_3.h,
                                    ),
                                    Container(
                                      height: AppSize.h173_3.h,
                                      width: AppSize.w506_6.w,
                                      padding:  EdgeInsets.all(AppPadding.p5.r),
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.circular(AppRadius.r10_6.r,),
                                        border: Border.all(
                                            color: AppColors.grey3),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding:  EdgeInsets.only(top: AppPadding.p16.h,right: AppPadding.p6.w),
                                          child: TextFormFieldWidget(
                                            height: AppSize.h173.h,
                                              maxLine: 5,
                                              maxLength: 152,
                                            style: TextStyle(
                                              fontFamily:
                                              getTranslated(context, "fontFamily"),
                                              fontSize: AppFontsSizeManager.s16.sp,
                                              color: AppColors.grey2,
                                            ),
                                            cursorColor: AppColors.black,
                                            textInputType:TextInputType.text,
                                            //iscenter: true,
                                            validator: (String? val) {
                                              if (val!.trim().isEmpty) {
                                                return getTranslated(context, 'required');
                                              }
                                              return null;
                                            },
                                            onsave: (val) {
                                              des = val!;
                                            },
                                            enableInteractiveSelection: true,
                                            insidePadding:
                                            EdgeInsets.only(left: AppPadding.p1.r, right: AppPadding.p1.r),
                                            hintStyle: TextStyle(
                                              fontFamily:
                                              getTranslated(context, "fontFamily"),
                                              color: Colors.grey,
                                              fontSize: AppFontsSizeManager.s21_3.sp,
                                              letterSpacing: 0.5,
                                            ),
                                            initialValue: des,
                                            hint: getTranslated(context, 'description'),
                                            borderRadiusValue: AppRadius.r10_6.r,
                                            backGroundColor: AppColors.white,
                                            borderColor: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: AppSize.h117_3.h,
                                ),
                                TextButton1(onPress: () {
                                  if (widget.loggedUser == null)
                                    Navigator.pushNamed(
                                        context, '/Register_Type');
                                  else
                                    save();
                                },Width: AppSize.w466_6.w,
                                    Height: AppSize.h66_6.h,
                                    Title: getTranslated(context, "save") ,
                                    ButtonRadius: AppRadius.r10_6.r,
                                    TextSize: AppFontsSizeManager.s21_3.sp,
                                    ButtonBackground: Color.fromRGBO(207, 0, 54, 1),
                                    TextFont: getTranslated(context, "Montserrat-SemiBold"),
                                    TextColor: AppColors.white,
                                ),
                               /* InkWell(
                                  onTap: () {
                                    if (widget.loggedUser == null)
                                      Navigator.pushNamed(
                                          context, '/Register_Type');
                                    else
                                      save();
                                  },
                                  child: Container(
                                    width: size.width * .65,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromRGBO(207, 0, 54, 1),
                                          Color.fromRGBO(
                                              255, 47, 101, 1)
                                        ],
                                      ),
                                    ),
                                    child: saving
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : Center(
                                            child: Text(
                                              getTranslated(context, "save"),
                                              style: TextStyle(
                                                fontFamily: getTranslated(
                                                    context, "fontFamily"),
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ]),
        ));
  }

  Widget getTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: getTranslated(context, "Montserrat-SemiBold"),
          fontSize: convertPtToPx(AppFontsSizeManager.s21_3.sp),
          color: AppColors.pink2,
          fontWeight: FontWeight.w500),
    );
  }
  save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          saving = true;
        });
        String suggestionId = Uuid().v4();
        await FirebaseFirestore.instance
            .collection(Paths.suggestionsPath)
            .doc(suggestionId)
            .set({
          "userUid": widget.loggedUser!.uid,
          'suggestionId': suggestionId,
          'status': false,
          'sendTime': Timestamp.now(),
          'title': title,
          'desc': des,
          'userData': {
            'uid': widget.loggedUser!.uid,
            'name': widget.loggedUser!.name,
            'image': widget.loggedUser!.photoUrl,
            'phone': widget.loggedUser!.phoneNumber,
          },
        });
        setState(() {
          saving = false;
        });
        addingDialog(MediaQuery.of(context).size, true);
      } catch (e) {
        print("rrrrrrrrrr" + e.toString());
      }
    }
  }

  addingDialog(Size size, bool status) {
    return showDialog(
      builder: (context) =>  NikahDialogWidget(
        padButtom: AppPadding.p32.h,
        padLeft: AppPadding.p29_3.w,
        padReight: AppPadding.p29_3.w,
        padTop:AppPadding.p32.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
       width: AppSize.w394_6.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                  AssetsManager.handHeartIconPath,
                height: AppSize.h53_3.r,
                width: AppSize.w53_3.r,
              ),

              SizedBox(
                height: AppSize.h26_6.h,
              ),
              Text(
                getTranslated(context, "thanks"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s24.sp,
                  fontWeight: lang=="ar"?
                  AppFontsWeightManager.semiBold
                  :null,
                  letterSpacing: 0.3,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Center(
                child: Container(
                  width: AppSize.w261_3.w,
                  height:AppSize.h61_3.h ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
                    color: AppColors.pink2,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    child: Center(
                      child: Text(
                        getTranslated(context, 'continue'),
                        style: TextStyle(
                          fontFamily: getTranslated(context, "Montserratsemibold"),
                          color: Colors.white,
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  void showSnakbar(String s, bool status) {
    Fluttertoast.showToast(
        msg: getTranslated(context, "paidDone"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
        fillColor: Colors.white,
        hintText: getTranslated(context, 'title'),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: AppColors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: AppColors.grey,
            width: 1.0,
          ),
        ));
  }
}
