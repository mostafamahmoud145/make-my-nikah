// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/screens/google_apple_signup/views/widgets/phone_number_widget.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../config/assets_manager.dart';
import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../methodes/snackbar.dart';
import '../widget/IconButton.dart';
import '../widget/TextButton.dart';
import '../widget/app_bar_widget.dart';
import '../widget/text_form_field_widget.dart';

class UserAccountScreen extends StatefulWidget {
  final GroceryUser user;
  final bool? firstLogged;

  const UserAccountScreen({Key? key, required this.user, this.firstLogged})
      : super(key: key);

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
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
  String lang = "";
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
          showUpdatedAccountSnackBar(context);
        }
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
    return InkWell(
      onTap: onpress,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
            border: Border.all(
              color: isselected ? AppColors.pink2 : AppColors.time,
              width: AppSize.w1_5.w,
            ),
            color: isselected ? AppColors.white : AppColors.time,
          ),
          height: AppSize.h49_3.h,
          width: AppSize.w242_6.w,
          // height: size.height * 0.037,
          child: Center(
              child: Text(
            ButtonText,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: isselected ? AppColors.reddark : AppColors.blackColor,
                fontFamily: getTranslated(context, "Montserrat"),
                fontSize: AppFontsSizeManager.s18_6.sp),
          ))),
    );
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
  //                 deleting
  //                     ? CircularProgressIndicator()
  //                     : Container(
  //                         width: 50.0,
  //                         child: MaterialButton(
  //                           padding: const EdgeInsets.all(0.0),
  //                           onPressed: () async {
  //                             setState(() {
  //                               deleting = true;
  //                             });
  //                             await FirebaseFirestore.instance
  //                                 .collection(Paths.supportListPath)
  //                                 .doc(widget.user.supportListId)
  //                                 .delete();
  //                             await FirebaseFirestore.instance
  //                                 .collection(Paths.usersPath)
  //                                 .doc(widget.user.uid)
  //                                 .delete();
  //                             FirebaseAuth.instance.signOut();
  //                             setState(() {
  //                               deleting = false;
  //                             });
  //                             Navigator.pushNamedAndRemoveUntil(
  //                               context,
  //                               '/Register_Type',
  //                               (route) => false,
  //                             );
  //                           },
  //                           child: Text(
  //                             getTranslated(context, 'yes'),
  //                             style: TextStyle(
  //                               fontFamily:
  //                                   getTranslated(context, "fontFamily"),
  //                               fontSize: 15.0,
  //                               color: Colors.red.shade700,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
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

  void showFailedSnakbar(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
    lang = getTranslated(context, "lang");
    return Scaffold(
      backgroundColor: AppColors.white,
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: AppPadding.p21_3.h,
                  ),

                  ///--App Bar Widget--///
                  child: AppBarWidget2(
                    onPress: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                      setState(() {});
                    },
                    text: getTranslated(context, "profile"),
                  ),
                )),
            Center(
                child: Container(
                    color: AppColors.white3,
                    height: AppSize.h1.h,
                    width: size.width)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                children: [
                  SizedBox(
                    height: AppSize.h32.h,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                            child: Image.asset(AssetsManager.logoLoveIcon,
                                fit: BoxFit.contain,
                                height: AppSize.h68_5.h,
                                width: AppSize.w72.w)),
                        SizedBox(
                          height: AppSize.h10_6.h,
                        ),
                        (widget.user.name != null && widget.user.name != "")
                            ? Center(
                                child: Text(
                                  widget.user.name!,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontFamily: getTranslated(
                                          context, "Montserratsemibold"),
                                      fontSize: AppFontsSizeManager.s26_6.sp,
                                      color: AppColors.pink2,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: AppSize.h64_8.h,
                        ),
                        getTitle(getTranslated(context, "name")),

                        ///---------TextFormFieldWidget----------////

                        Padding(
                          padding: EdgeInsets.only(top: AppPadding.p21_3.h),
                          child: Container(
                            height: AppSize.h70_6.h,
                            child: TextFormFieldWidget(
                              insidePadding: EdgeInsets.symmetric(
                                  horizontal: AppPadding.p21_3.w,
                                  vertical: AppPadding.p24.h),

                              borderColor: AppColors.grayShade300,
                              borderRadiusValue: AppRadius.r10_6.r,

                              //iscenter: true,
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "Montserratmedium"),
                                fontSize: AppFontsSizeManager.s18_6.sp,
                                color: AppColors.balck2,
                              ),
                              cursorColor: AppColors.black,
                              initialValue: widget.user.name,
                              textInputType: TextInputType.name,
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
                              onsave: (val) {
                                widget.user.name = val;
                              },
                              enableInteractiveSelection: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle(getTranslated(context, "age")),
                        Padding(
                          padding: EdgeInsets.only(top: AppPadding.p21_3.h),
                          child: SizedBox(
                            height: AppSize.h70_6.h,
                            child: Theme(
                              data: new ThemeData(
                                primaryColor: Colors.redAccent,
                                primaryColorDark: Colors.red,
                              ),
                              //old
                              child: TextFormFieldWidget(
                                insidePadding: EdgeInsets.symmetric(
                                    horizontal: AppPadding.p21_3.w,
                                    vertical: AppPadding.p24.h),

                                borderColor: AppColors.grayShade300,
                                borderRadiusValue: AppRadius.r10_6.r,
                                //iscenter: true,
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratmedium"),
                                  fontSize: AppFontsSizeManager.s18_6.sp,
                                  color: AppColors.balck2,
                                ),
                                cursorColor: AppColors.pink,
                                initialValue: widget.user.age != null
                                    ? widget.user.age.toString()
                                    : "",
                                textInputType: TextInputType.number,
                                formatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                validator: (String? val) {
                                  // Check if the value is empty
                                  print(val);
                                  if (val == null || val.trim().isEmpty) {
                                    return getTranslated(context, 'required');
                                  }

                                  // Try parsing the value to an integer
                                  int? age;
                                  try {
                                    age = int.parse(val.trim());
                                  } catch (e) {
                                    return getTranslated(context, 'invalidNumber'); // Provide a translation key for invalid number format
                                  }

                                  // Check if the height is within the valid range
                                  if (age < 30 || age > 100) {
                                    return getTranslated(context, 'ageRange');
                                  }

                                  return null;
                                },
                                onsave: (val) {
                                  widget.user.age = int.parse(val!);
                                },
                                enableInteractiveSelection: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle(getTranslated(context, "weight")),

                        Padding(
                          padding: EdgeInsets.only(top: AppPadding.p21_3.h),
                          child: SizedBox(
                            height: AppSize.h70_6.h,
                            child: Theme(
                              data: new ThemeData(
                                primaryColor: Colors.redAccent,
                                primaryColorDark: Colors.red,
                              ),
                              child: TextFormFieldWidget(
                                insidePadding: EdgeInsets.symmetric(
                                    horizontal: AppPadding.p21_3.w,
                                    vertical: AppPadding.p24.h),
                                borderColor: AppColors.grayShade300,
                                borderRadiusValue: AppRadius.r10_6.r,
                                //iscenter: true,
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratmedium"),
                                  fontSize: AppFontsSizeManager.s18_6.sp,
                                  color: AppColors.balck2,
                                ),
                                cursorColor: AppColors.pink,
                                initialValue: widget.user.weight != null
                                    ? widget.user.weight.toString()
                                    : "",
                                textInputType: TextInputType.number,
                                formatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                validator: (String? val) {
                                  // Check if the value is empty
                                  if (val == null || val.trim().isEmpty) {
                                    return getTranslated(context, 'required');
                                  }

                                  // Try parsing the value to an integer
                                  double? weight;
                                  try {
                                    weight = double.parse(val.trim());
                                  } catch (e) {
                                    return getTranslated(context, 'invalidNumber'); // Provide a translation key for invalid number format
                                  }

                                  // Check if the height is within the valid range
                                  if (weight < 40 || weight > 200) {
                                    return getTranslated(context, 'weightRange');
                                  }

                                  return null;
                                },
                                onsave: (val) {
                                  widget.user.weight = double.parse(val!);
                                },
                                enableInteractiveSelection: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle(getTranslated(context, "height")),

                        Padding(
                          padding: EdgeInsets.only(top: AppPadding.p21_3.h),
                          child: SizedBox(
                            height: AppSize.h70_6.h,
                            child: Theme(
                              data: new ThemeData(
                                primaryColor: Colors.redAccent,
                                primaryColorDark: Colors.red,
                              ),
                              child: TextFormFieldWidget(
                                insidePadding: EdgeInsets.symmetric(
                                    horizontal: AppPadding.p21_3.w,
                                    vertical: AppPadding.p24.h),
                                borderColor: AppColors.grayShade300,
                                borderRadiusValue: AppRadius.r10_6.r,
                                //iscenter: true,
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratmedium"),
                                  fontSize: AppFontsSizeManager.s18_6.sp,
                                  color: AppColors.balck2,
                                ),
                                cursorColor: AppColors.pink,
                                initialValue: widget.user.length != null
                                    ? widget.user.length.toString()
                                    : "",
                                textInputType: TextInputType.number,
                                formatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                validator: (String? val) {
                                  // Check if the value is empty
                                  if (val == null || val.trim().isEmpty) {
                                    return getTranslated(context, 'required');
                                  }

                                  // Try parsing the value to an integer
                                  double? height;
                                  try {
                                    height = double.parse(val.trim());
                                  } catch (e) {
                                    return getTranslated(context, 'invalidNumber'); // Provide a translation key for invalid number format
                                  }

                                  // Check if the height is within the valid range
                                  if (height < 100 || height > 250) {
                                    return getTranslated(context, 'heightRange');
                                  }

                                  return null;
                                },
                                onsave: (val) {
                                  widget.user.length = double.parse(val!);
                                },
                                enableInteractiveSelection: true,
                              ),
                              //oldTextForm
                              // child: TextFormField(
                              //     textAlign: TextAlign.center,
                              //     //readOnly: widget.user.length != null ? true : false,
                              //     style: TextStyle(
                              //       fontFamily:
                              //           getTranslated(context, "fontFamily"),
                              //       fontSize: 13.0,
                              //       color: Colors.black.withOpacity(0.6),
                              //     ),
                              //     cursorColor: AppColors.pink,
                              //     initialValue: widget.user.length != null
                              //         ? widget.user.length.toString()
                              //         : "",
                              //     keyboardType: TextInputType.number,
                              //     validator: (String? val) {
                              //       if (val!.trim().isEmpty) {
                              //         return getTranslated(context, 'required');
                              //       }
                              //       return null;
                              //     },
                              //     onSaved: (val) {
                              //       widget.user.length = int.parse(val!);
                              //     },
                              //     enableInteractiveSelection: true,
                              //     decoration: inputDecoration()),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "doctrine")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.doctrine == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.doctrine  == null )
                                      setState(() {
                                        widget.user.doctrine = "sunni";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "sunni"),
                                    isselected: (widget.user.doctrine != null &&
                                        widget.user.doctrine == "sunni")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.doctrine  == null )
                                      setState(() {
                                        widget.user.doctrine = "shiite";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "shiite"),
                                    isselected: (widget.user.doctrine != null &&
                                        widget.user.doctrine == "shiite")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.doctrine  == null )
                                      setState(() {
                                        widget.user.doctrine = "convert";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "convert"),
                                    isselected: (widget.user.doctrine != null &&
                                        widget.user.doctrine == "convert")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "employmentStatus")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.employment == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.employment == null)
                                      setState(() {
                                        widget.user.employment = "employee1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "employee1"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "employee1")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.employment == null)
                                      setState(() {
                                        widget.user.employment = "manager1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "manager1"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "manager1"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.employment == null)
                                      setState(() {
                                        widget.user.employment = "worker1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "worker1"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "worker1")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.employment == null)
                                      setState(() {
                                        widget.user.employment = "unemployed1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "unemployed1"),
                                    isselected:
                                        (widget.user.employment != null &&
                                            widget.user.employment ==
                                                "unemployed1")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.employment == null)
                                      setState(() {
                                        widget.user.employment = "self";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "self"),
                                    isselected:
                                        (widget.user.employment != null &&
                                            widget.user.employment == "self")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.employment == null)
                                      setState(() {
                                        widget.user.employment = "business1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "business1"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "business1")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "livingStander")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.living == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.living == null)
                                      setState(() {
                                        widget.user.living = "highIncome";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "highIncome"),
                                    isselected: (widget.user.living != null &&
                                        widget.user.living == "highIncome")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// //if(widget.user.living == null)
                                      setState(() {
                                        widget.user.living = "middleIncome";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "middleIncome"),
                                    isselected: (widget.user.living != null &&
                                        widget.user.living == "middleIncome"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.living == null)
                                      setState(() {
                                        widget.user.living = "lowIncome";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "lowIncome"),
                                    isselected: (widget.user.living != null &&
                                        widget.user.living == "lowIncome"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "educationalLevel")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.education == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.education == null)
                                      setState(() {
                                        widget.user.education = "master";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "master"),
                                    isselected:
                                        (widget.user.education != null &&
                                            widget.user.education == "master")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.education == null)
                                      setState(() {
                                        widget.user.education = "phd";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "phd"),
                                    isselected:
                                        (widget.user.education != null &&
                                            widget.user.education == "phd"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.education == null)
                                      setState(() {
                                        widget.user.education = "highschool";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "highschool"),
                                    isselected: (widget.user.education !=
                                            null &&
                                        widget.user.education == "highschool")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.education == null)
                                      setState(() {
                                        widget.user.education = "uneducated";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "uneducated1"),
                                    isselected: (widget.user.education !=
                                            null &&
                                        widget.user.education == "uneducated")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.education == null)
                                      setState(() {
                                        widget.user.education = "bachelor";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "bachelor"),
                                    isselected: (widget.user.education !=
                                            null &&
                                        widget.user.education == "bachelor")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "Specialization")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.specialization == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.specialization == null)
                                      setState(() {
                                        widget.user.specialization = "economic";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "economic"),
                                    isselected:
                                        (widget.user.specialization != null &&
                                            widget.user.specialization ==
                                                "economic")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.specialization == null)
                                      setState(() {
                                        widget.user.specialization =
                                            "engineering";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "engineering"),
                                    isselected:
                                        (widget.user.specialization != null &&
                                            widget.user.specialization ==
                                                "engineering")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.specialization == null)
                                      setState(() {
                                        widget.user.specialization = "islamic";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "islamic"),
                                    isselected:
                                        (widget.user.specialization != null &&
                                            widget.user.specialization ==
                                                "islamic")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.specialization == null)
                                      setState(() {
                                        widget.user.specialization = "arts";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "arts"),
                                    isselected: (widget.user.specialization !=
                                            null &&
                                        widget.user.specialization == "arts")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.specialization == null)
                                      setState(() {
                                        widget.user.specialization = "health";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "health"),
                                    isselected:
                                        (widget.user.specialization != null &&
                                            widget.user.specialization ==
                                                "health")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.specialization == null)
                                      setState(() {
                                        widget.user.specialization = "sport";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "sport"),
                                    isselected: (widget.user.specialization !=
                                            null &&
                                        widget.user.specialization == "sport")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.specialization == null)
                                      setState(() {
                                        widget.user.specialization =
                                            "education";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "education"),
                                    isselected:
                                        (widget.user.specialization != null &&
                                            widget.user.specialization ==
                                                "education")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//
                                      setState(() {
                                        //other = true;
                                        widget.user.specialization = "other";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "other"),
                                    isselected: (other ||
                                            (widget.user.specialization !=
                                                    null &&
                                                widget.user.specialization ==
                                                    "other")
                                        /* (widget.user.specialization != "medicine" && widget.user.specialization != "arts"
                                                            && widget.user.specialization != "engineering" && widget.user.specialization != "math" && widget.user.specialization != null)*/
                                        )),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "origin")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.origin == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "european";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "european"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin == "european")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "asian";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "asian"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin == "asian"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "african";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "african"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin == "african")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "latin";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "latin"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin == "latin")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "eastAsian";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "eastAsian"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin == "eastAsian")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "africanAmerican";
                                      });
                                    },
                                    ButtonText: getTranslated(
                                        context, "africanAmerican"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin ==
                                            "africanAmerican")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "northAfrican";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "northAfrican"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin == "northAfrican")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.origin  == null )
                                      setState(() {
                                        widget.user.origin = "arabian";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "arabian"),
                                    isselected: (widget.user.origin != null &&
                                        widget.user.origin == "arabian")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      setState(() {
                                        widget.user.origin = "other";
                                      });
                                    },
                                    ButtonText: getTranslated(context, "other"),
                                    isselected: (other ||
                                        (widget.user.origin != null &&
                                            widget.user.origin == "other"))),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "maritalstate")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.maritalStatus == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.maritalStatus == null)
                                      setState(() {
                                        widget.user.maritalStatus = "single1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "single1"),
                                    isselected:
                                        (widget.user.maritalStatus != null &&
                                            widget.user.maritalStatus ==
                                                "single1")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.maritalStatus == null)
                                      setState(() {
                                        widget.user.maritalStatus = "divorced1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "divorced1"),
                                    isselected:
                                        (widget.user.maritalStatus != null &&
                                            widget.user.maritalStatus ==
                                                "divorced1")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: AppSize.h21_3.h,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.maritalStatus == null)
                                      setState(() {
                                        widget.user.maritalStatus = "widow1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "widow1"),
                                    isselected: (widget.user.maritalStatus !=
                                            null &&
                                        widget.user.maritalStatus == "widow1")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)//if(widget.user.maritalStatus == null)
                                      setState(() {
                                        widget.user.maritalStatus = "married1";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "married1"),
                                    isselected:
                                        (widget.user.maritalStatus != null &&
                                            widget.user.maritalStatus ==
                                                "married1")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle2(getTranslated(context, "Smoking")),
                        SizedBox(
                          height: AppSize.h26_6.h,
                        ),
                        widget.user.smooking == null
                            ? Center(
                                child: Text(
                                  getTranslated(context, "required"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.smooking == null)
                                      setState(() {
                                        widget.user.smooking = "smoker";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "smoker"),
                                    isselected: (widget.user.smooking != null &&
                                        widget.user.smooking == "smoker")),
                                OutlineButton(
                                    onpress: () {
                                      // if(widget.user.profileCompleted==false)// if(widget.user.smooking == null)
                                      setState(() {
                                        widget.user.smooking = "nonSmoker";
                                      });
                                    },
                                    ButtonText:
                                        getTranslated(context, "nonSmoker"),
                                    isselected: (widget.user.smooking != null &&
                                        widget.user.smooking == "nonSmoker")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                        getTitle(getTranslated(context, "about")),
                        widget.user.aboutMe == ""
                            ? Center(
                                child: Text(
                                  getTranslated(context, "about"),
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: AppSize.h21_3.h,
                        ),
                        Container(
                          width: size.width,
                          height: AppSize.h200.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.grey3, width: AppSize.w1.w),
                            borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p21_3.w,
                                vertical: AppPadding.p13_3.h),
                            child: TextFormFieldWidget(
                              maxLine: 7,
                              maxLength: 150,
                              insidePadding: EdgeInsets.all(0),
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "Montserratmedium"),
                                fontSize: AppFontsSizeManager.s18_6.sp,
                                color: AppColors.black,
                              ),
                              cursorColor: Colors.black,
                              initialValue: widget.user.bio,
                              textInputType: TextInputType.multiline,
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return getTranslated(context, 'required');
                                }
                                return null;
                              },
                              onsave: (val) {
                                widget.user.bio = val;
                              },
                              hintStyle: TextStyle(
                                fontFamily:
                                    getTranslated(context, "Montserratmedium"),
                                color: Colors.grey,
                                fontSize: AppFontsSizeManager.s18_6.sp,
                                letterSpacing: 0.5,
                              ),
                              hint: getTranslated(context, 'abutText'),
                              borderColor: AppColors.white,
                            ),
                          ),
                        ),
                        if (widget.user.isPhoneMain == false) 
                         SizedBox(
                          height: AppSize.h37_3.h,
                        ),
                      if (widget.user.isPhoneMain == false)
                        getTitle(getTranslated(context, "phoneNumber")),
                      if (widget.user.isPhoneMain == false)
                             Padding(
                          padding: EdgeInsets.only(top: AppPadding.p21_3.h),
                          child: PhoneNumberWidget(
                            phoneNumber:phoneNumber,
                            onChanged: (newNum) {
                              phoneNumber = newNum;
                            },
                             onSave: (val) {
                            phoneNumber = val;
                          },
                          )),
                      
                      if (widget.user.isPhoneMain == false)
                        SizedBox(height: 20),
                        SizedBox(
                          height: AppSize.h42_6.h,
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                showDeleteConfimationDialog(size);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsManager.deleteIconRed,
                                    width: AppSize.w32.r,
                                    height: AppSize.h32.r,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: AppSize.w18_6.w,
                                  ),
                                  Text(
                                    getTranslated(context, "deleteAccount"),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: getTranslated(
                                            context, "Montserratsemibold"),
                                        fontSize: AppFontsSizeManager.s21_3.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h64.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton1(
                                onPress: () async {
                                  save();
                                },
                                Width: AppSize.w446_6.w,
                                Height: AppSize.h66_6.h,
                                Title:
                                    getTranslated(context, "saveAndContinue"),
                                ButtonRadius: AppRadius.r10_6.r,
                                TextSize: AppFontsSizeManager.s21_3.sp,
                                ButtonBackground: AppColors.pink2,
                                TextFont: getTranslated(
                                    context, "Montserratsemibold"),
                                TextColor: AppColors.white),
                          ],
                        ),
                        SizedBox(
                          height: AppSize.h34_6.h,
                        ),
                      ],
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

  Widget getTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: getTranslated(context, "Montserratsemibold"),
        fontSize: AppFontsSizeManager.s21_3.sp,
        color: AppColors.pink2,
      ),
    );
  }

  Widget getTitle2(String title) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: getTranslated(context, "Montserratsemibold"),
          fontSize: AppFontsSizeManager.s21_3.sp,
          color: AppColors.pink2,
        ),
      ),
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
     var querySnapshot = await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .where('phoneNumber', isEqualTo: phoneNumber.phoneNumber)
        .where("uid", isNotEqualTo: widget.user.uid)
        .get();
    print("2");
   
     if (_formKey.currentState!.validate()&& querySnapshot.docs.isEmpty) {
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
        widget.user.userType = "USER";
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
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 1.0), // shadow direction: bottom right
    );
  }

