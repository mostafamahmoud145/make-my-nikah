import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/screens/google_apple_signup/views/widgets/phone_number_widget.dart';

import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../methodes/snackbar.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../widget/nikah_dialog.dart';

class ClientScreen extends StatefulWidget {
  final GroceryUser user;
  final bool? firstLogged;
  const ClientScreen({Key? key, required this.user, this.firstLogged})
      : super(key: key);
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  late AccountBloc accountBloc;
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'US');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  late String name, userName, bio, theme, age, education;
  late ScrollController scrollController;
  var image;
  bool deleting = false;
  File? selectedProfileImage;
  bool profileCompleted = false, dataSave = false, other = false;
  late Size size;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if ( widget.user.phoneNumber != null)
     phoneNumber = PhoneNumber(
          phoneNumber: widget.user.phoneNumber,
          dialCode: widget.user.countryCode,
          isoCode: widget.user.countryISOCode);
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.stream.listen((state) {
      if (state is UpdateAccountDetailsInProgressState) {
        //show dialog
        if (mounted) showUpdatingDialog();
      }
      if (state is UpdateAccountDetailsFailedState) {
        //show error
        if (mounted) showSnack(getTranslated(context, "error"), context, false);
      }
      if (state is UpdateAccountDetailsCompletedState) {
        if (mounted && dataSave) {
          dataSave = false;
          accountBloc.add(GetLoggedUserEvent());
          selectedProfileImage = null;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        }
        showUpdatedAccountSnackBar(context);
      }
    });
  }

  void showSnack(String text, BuildContext context, bool status) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
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

  Widget OutlineButton(
      {required VoidCallback onpress,
      required String ButtonText,
      required bool isselected}) {
    return OutlinedButton(
        onPressed: onpress,
        child: Container(
            width: size.width * 0.33,
            // height: size.height * 0.037,
            child: Center(
                child: Text(
              ButtonText,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isselected ? AppColors.reddark : AppColors.black2,
                  fontFamily: getTranslated(context, "fontFamily"),
                  fontWeight: FontWeight.normal,
                  fontSize: 10),
            ))),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white.withOpacity(0.4),
          side: BorderSide(
              color: isselected ? AppColors.reddark : AppColors.grey4),
        ));
  }

  showDeleteConfimationDialog(Size size) {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p32.h,
        padLeft: AppPadding.p25_3.w,
        padReight: AppPadding.p25_3.w,
        padTop: AppPadding.p32.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          // width: AppSize.w429_3.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AssetsManager.redCancelIconPath,
                      height: AppSize.h32.r,
                      width: AppSize.w32.r,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                AssetsManager.outlineDeleteIconPath,
                height: AppSize.h53_3.r,
                width: AppSize.w53_3.r,
              ),
              SizedBox(
                height: AppSize.h13.h,
              ),
              Text(
                getTranslated(context, "deleteAccount"),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratsemibold"),
                  fontSize: AppFontsSizeManager.s26.sp,
                  color: AppColors.black,
                  // fontWeight: getTranslated(context,"Montserratsemibold"),
                ),
              ),
              SizedBox(
                height: AppSize.h13.h,
              ),
              Text(
                getTranslated(context, "deleteText"),
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "InterRegular"),
                  fontSize: AppFontsSizeManager.s21_3.sp,
                  color: AppColors.balck3,
                  // fontWeight: lang=="ar"?
                  // AppFontsWeightManager.semiBold
                  // :null,
                ),
              ),
              SizedBox(
                height: AppSize.h16_7.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  deleting
                      ? CircularProgressIndicator()
                      : Container(
                          width: AppSize.w178.w,
                          height: AppSize.h56.h,
                          decoration: BoxDecoration(
                            color: AppColors.reddark2,
                            borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                          ),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                deleting = true;
                              });
                             /*  await FirebaseFirestore.instance
                                  .collection(Paths.supportListPath)
                                  .doc(widget.user.supportListId)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection(Paths.usersPath)
                                  .doc(widget.user.uid)
                                  .delete(); */
                              FirebaseAuth.instance.signOut();
                              setState(() {
                                deleting = false;
                              });
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/Register_Type',
                                (route) => false,
                              );
                            },
                            child: Center(
                              child: Text(
                                getTranslated(context, 'delete'),
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratsemibold"),
                                  fontSize: AppFontsSizeManager.s21_3.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: AppSize.w21.w,
                  ),
                  Container(
                    width: AppSize.w178.w,
                    height: AppSize.h56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      border: Border.all(color: AppColors.pink2),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          getTranslated(context, 'cancel'),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratsemibold"),
                            fontSize: AppFontsSizeManager.s21_3.sp,
                            color: AppColors.reddark2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  // showDeleteConfimationDialog(Size size) {
  //   return showDialog(
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(15.0),
  //         ),
  //       ),
  //       elevation: 5.0,
  //       contentPadding: const EdgeInsets.only(
  //           left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
  //       content: Container(
  //         color: Colors.white,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Text(
  //               getTranslated(context, "deleteAccount"),
  //               style: TextStyle(
  //                   fontFamily: getTranslated(context, "fontFamily"),
  //                   fontSize: 16.0,
  //                   color: AppColors.black,
  //                   fontWeight: FontWeight.w500),
  //             ),
  //             SizedBox(
  //               height: 15.0,
  //             ),
  //             Text(
  //               getTranslated(context, "deleteText"),
  //               style: TextStyle(
  //                   fontFamily: getTranslated(context, "fontFamily"),
  //                   fontSize: 12.0,
  //                   color: Colors.black87,
  //                   fontWeight: FontWeight.w300),
  //             ),
  //             SizedBox(
  //               height: 5.0,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.max,
  //               children: <Widget>[
  //                 Container(
  //                   width: 50.0,
  //                   child: MaterialButton(
  //                     padding: const EdgeInsets.all(0.0),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       getTranslated(context, 'no'),
  //                       style: TextStyle(
  //                         fontFamily: getTranslated(context, "fontFamily"),
  //                         fontSize: 13.0,
  //                         color: Colors.black87,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 deleting?CircularProgressIndicator():Container(
  //                   width: 50.0,
  //                   child: MaterialButton(
  //                     padding: const EdgeInsets.all(0.0),
  //                     onPressed: () async {
  //                       setState(() {
  //                         deleting=true;
  //                       });
  //                       await FirebaseFirestore.instance
  //                           .collection(Paths.supportListPath)
  //                           .doc(widget.user.supportListId)
  //                           .delete();
  //                       await FirebaseFirestore.instance
  //                           .collection(Paths.usersPath)
  //                           .doc(widget.user.uid)
  //                           .delete();
  //                       FirebaseAuth.instance.signOut();
  //                       setState(() {
  //                         deleting=false;
  //                       });
  //                       Navigator.pushNamedAndRemoveUntil(
  //                         context,
  //                         '/Register_Type',
  //                             (route) => false,
  //                       );
  //                     },
  //                     child: Text(
  //                       getTranslated(context, 'yes'),
  //                       style: TextStyle(
  //                         fontFamily: getTranslated(context, "fontFamily"),
  //                         fontSize: 15.0,
  //                         color: Colors.red.shade700,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: false,
  //     context: context,
  //   );
  // }

  Future cropImage(context) async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File croppedFile = File(image.path);
    if (croppedFile != null) {
      setState(() {
        selectedProfileImage = croppedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      icon: Image.asset(
                        getTranslated(context, "back"),
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Text(
                      getTranslated(context, "profile"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 17.0,
                          color: AppColors.balck2),
                    ),
                    InkWell(
                      onTap: () {
                        showDeleteConfimationDialog(size);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                          Text(
                            getTranslated(context, "deleteAccount"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontSize: 10.0,
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.011,
                      ),
                      Center(
                          child: Image.asset(
                              'assets/icons/icon/Mask Group 47.png',
                              fit: BoxFit.contain,
                              height: 35,
                              width: 55)),
                      SizedBox(
                        height: size.height * 0.011,
                      ),
                      (widget.user.name != null && widget.user.name != "")
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  widget.user.name!,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: 19,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          getTranslated(context, "welcomeBack"),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 11.0,
                            color: AppColors.grey3,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      getTitle(getTranslated(context, "name")),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Container(
                          height: size.height * 0.05,
                           width: size.width * .85,
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontSize: 14.0,
                                color: AppColors.balck2,
                              ),
                              cursorColor: AppColors.black,
                              initialValue: widget.user.name,
                              keyboardType: TextInputType.name,
                              validator: (String? val) {
                                var valArray =
                                    val!.trimLeft().trimRight().split(' ');
                                if (val.trim().isEmpty) {
                                  return getTranslated(context, 'required');
                                } else if (valArray.length < 3)
                                  return getTranslated(
                                      context, 'nameConsistAtLeastOf3Parts');
                                else
                                  return null;
                              },
                              onSaved: (val) {
                                widget.user.name = val;
                              },
                              enableInteractiveSelection: true,
                              decoration: inputDecoration()),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (widget.user.isPhoneMain == false)
                        getTitle(getTranslated(context, "phoneNumber")),
                      if (widget.user.isPhoneMain == false)
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Container(
                              width: size.width * .85,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.grey3, width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: PhoneNumberWidget(
                                phoneNumber:phoneNumber,
                                onChanged: (newNum) {
                                  phoneNumber = newNum;
                                },
                                 onSave: (val) {
                                phoneNumber = val;
                              },
                              ),
                            )),
                      
                      if (widget.user.isPhoneMain == false)
                        SizedBox(height: 20),
                      getTitle(getTranslated(context, "about")),
                      widget.user.aboutMe == ""
                          ? Center(
                              child: Text(
                                getTranslated(context, "about"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Container(
                          width: size.width * .85,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.grey3, width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              maxLines: 7,
                              maxLength: 150,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontSize: 14.0,
                                color: AppColors.black,
                              ),
                              cursorColor: Colors.black,
                              initialValue: widget.user.bio,
                              keyboardType: TextInputType.multiline,
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return getTranslated(context, 'required');
                                }
                                return null;
                              },
                              onSaved: (val) {
                                widget.user.bio = val;
                              },
                              decoration: InputDecoration(
                                counterStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                hintStyle: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  color: Colors.grey,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                                hintText: getTranslated(context, 'abutText'),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,

                                //  hintText: sLabel
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.7,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.reddark2,
                                    AppColors.reddark2,
                                  ],
                                )),
                            child: MaterialButton(
                              onPressed: () async {
                                save();
                              },
                              child: Text(
                                getTranslated(context, "saveAndContinue"),
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "fontFamily"),
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(width: 10,),
                          // Image.asset(
                          //   getTranslated(context, "rightrose"),
                          //   width: 30,
                          //   height: 30,
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showFailedSnakbar(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget getTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            getTranslated(context, "Group2830"),
            width: 15,
            height: 10,
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 25,
            //width: size.width * .3,
            decoration: BoxDecoration(
              color: AppColors.white1,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [shadow()],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      fontSize: 11.0,
                      color: AppColors.reddark,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Image.asset(
            getTranslated(context, "Group2831"),
            width: 15,
            height: 10,
          ),
        ],
      )),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ));
  }

  save() async {
    print("gggggggg");
    print(phoneNumber.phoneNumber);
    print(phoneNumber.dialCode);
    print(phoneNumber.isoCode);
    var querySnapshot = await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .where('phoneNumber', isEqualTo: phoneNumber.phoneNumber)
        .where("uid", isNotEqualTo: widget.user.uid)
        .get();
    print("2");
   
     if (_formKey.currentState!.validate()&&querySnapshot.docs.length == 0) {
      _formKey.currentState!.save();
      try {
        List<String> splitList = widget.user.name!.split(" ");
        List<String> indexList = [];
        for (int i = 0; i < splitList.length; i++) {
          for (int y = 1; y < splitList[i].length; y++) {
            indexList.add(splitList[i].substring(0, y).toLowerCase());
          }
        }
        print(indexList);
        widget.user.searchIndex = indexList;
        widget.user.profileCompleted = true;
          widget.user.phoneNumber = phoneNumber.phoneNumber;
          widget.user.countryCode = phoneNumber.dialCode;
          widget.user.countryISOCode = phoneNumber.isoCode;
        widget.user.userLang = getTranslated(context, 'lang');
        setState(() {
          dataSave = true;
        });
        if (selectedProfileImage != null) {
          accountBloc.add(UpdateAccountDetailsEvent(
              user: widget.user, profileImage: selectedProfileImage));
        } else {
          accountBloc.add(UpdateAccountDetailsEvent(user: widget.user));
        }
      } catch (e) {
        print("rrrrrrrrrr" + e.toString());
      }
    } else {
      print("llllll");
       if (querySnapshot.docs.length > 0) {
      print("3");
      showFailedSnakbar(getTranslated(context, 'phoneUsed'));
    }
    else
       showFailedSnakbar(getTranslated(context, 'allRequired'));
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
