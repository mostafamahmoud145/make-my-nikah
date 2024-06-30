import 'dart:core';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/appointmentDialogwidget/custom_stepper.dart';
import 'package:grocery_store/screens/home_screen.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uuid/uuid.dart';

import '../config/app_constat.dart';
import '../config/assets_manager.dart';
import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../config/colorsFile.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../models/userDetails.dart';
import '../widget/IconButton.dart';
import '../widget/TextButton.dart';
import '../widget/app_bar_widget.dart';
import '../widget/text_form_field_widget.dart';
import 'accountDetailsScreen.dart';
import 'google_apple_signup/views/widgets/phone_number_widget.dart';

class AccountScreen extends StatefulWidget {
  final GroceryUser user;
  final bool? firstLogged;

  const AccountScreen({Key? key, required this.user, this.firstLogged})
      : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountBloc? accountBloc;
  bool profileCompleted = false, dataSave = false, showCheck = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'US');
  String? name,
      price,
      bio,
      workDays = "",
      lang = "",
      type = "",
      fromtext = "",
      totext = "",
      from,
      to,
      theme = "light",
      location;
  TextEditingController? daysController,
      langController,
      typeController,
      fromController,
      toController;
  bool saving = false,
      monday = false,
      tuesday = false,
      wednesday = false,
      thursday = false,
      friday = false,
      saturday = false,
      sunday = false,
      everyday = false,
      other = false,
      first = true;

  ScrollController? scrollController;
  List<WorkTimes>? workTimes;
  List<String> daysValue = [];
  WorkTimes _workTime = new WorkTimes();
  var image;
  File? selectedProfileImage;
  Size? size;

  bool deleting = false;
  UserDetail userDetails = UserDetail();

  TextEditingController? namecontroller,
      agecontroller,
      heightController,
      weightController;
  bool married = false,
      single = false,
      anotherWife = false,
      divorced = false,
      master = false,
      phd = false,
      highSchool = false,
      bachelor = false,
      uneducated = false,
      white = false,
      wheatishLight = false,
      bronze = false,
      wheatish = false,
      lightBlack = false,
      darkBlack = false,
      smokeyes = false,
      smokeno = false;

  String maritalStatus = "",
      education = "",
      skinColor = "",
      age = "",
      height = "",
      weight = "",
      smoke = "";

  File? _image;
  String? _uploadedFileURL;
  final picker = ImagePicker();
  bool deleteImage = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<UserDetail> getuserDetails(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(Paths.userDetail)
        .doc(userID)
        .get();

    UserDetail userDetail = UserDetail.fromMap(snapshot.data() as Map);

    return userDetail;
  }

  @override
  void initState() {
    super.initState();
    print(_image);
    print("account screen");
    if (widget.user.phoneNumber != null)
      phoneNumber = PhoneNumber(
          phoneNumber: widget.user.phoneNumber,
          dialCode: widget.user.countryCode,
          isoCode: widget.user.countryISOCode);

    widget.user.workDays!.forEach((day) {
      if (day == "1") monday = true;
      if (day == "2") tuesday = true;
      if (day == "3") wednesday = true;
      if (day == "4") thursday = true;
      if (day == "5") friday = true;
      if (day == "6") saturday = true;
      if (day == "7") sunday = true;
    });

    // from = widget.user.workTimes[0].from;
    // to = widget.user.workTimes[0].to;

    profileCompleted = widget.user.profileCompleted!;
    name = widget.user.name;
    // namecontroller = TextEditingController();
    // agecontroller = TextEditingController();
    // heightController = TextEditingController();
    // weightController = TextEditingController();

    Future.delayed(Duration.zero, () async {
      this.userDetails = await getuserDetails(widget.user.uid!);
    });

    accountBloc = BlocProvider.of<AccountBloc>(context);

    accountBloc?.stream.listen((state) {
      print(state);
      print("11111111$state");
      if (state is GetLoggedUserCompletedState) {
        if (mounted && dataSave) {
          dataSave = false;
          print("111111112222");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountDetailScreen(
                userid: widget.user.uid!,
                user: widget.user,
              ),
            ),
          );
        }
      }
      if (state is UpdateAccountDetailsInProgressState) {
        //show dialog
        if (mounted) showUpdatingDialog();
      }
      if (state is UpdateAccountDetailsFailedState) {
        //show error
        showSnack(getTranslated(context, "error"), context, false);
      }
      if (state is UpdateAccountDetailsCompletedState) {
        print("11111111$state");
        if (mounted) {
          accountBloc?.add(GetLoggedUserEvent());
          selectedProfileImage = null;
          Navigator.of(context, rootNavigator: true).pop();
          print("11111111");
          // accountBloc.add(GetAccountDetailsEvent(widget.user.uid));
        }
      }
    });
    if (widget.user.workTimes != null && widget.user.workTimes!.isNotEmpty) {
      _workTime = widget.user.workTimes![0];

      if (_workTime.from != null) {
        from = _workTime.from;
        List<String> fromParts = from!.split(':');
        int fromHour = 0;
        int fromMinute = 0;

        if (fromParts.length == 1) {
          fromHour = int.parse(fromParts[0]);
        } else if (fromParts.length == 2) {
          fromHour = int.parse(fromParts[0]);
          fromMinute = int.parse(fromParts[1]);
        } else {
          fromtext = "Invalid time format";
        }

        if (fromtext != "Invalid time format") {
          if (fromHour == 12)
            fromtext = "12:${fromMinute.toString().padLeft(2, '0')} PM";
          else if (fromHour == 0)
            fromtext = "12:${fromMinute.toString().padLeft(2, '0')} AM";
          else if (fromHour > 12)
            fromtext = (fromHour - 12).toString() + ":${fromMinute.toString().padLeft(2, '0')} PM";
          else
            fromtext = fromHour.toString() + ":${fromMinute.toString().padLeft(2, '0')} AM";
        }
      }

      if (_workTime.to != null) {
        to = _workTime.to;
        List<String> toParts = to!.split(':');
        int toHour = 0;
        int toMinute = 0;

        if (toParts.length == 1) {
          toHour = int.parse(toParts[0]);
        } else if (toParts.length == 2) {
          toHour = int.parse(toParts[0]);
          toMinute = int.parse(toParts[1]);
        } else {
          totext = "Invalid time format";
        }

        if (totext != "Invalid time format") {
          if (toHour == 12)
            totext = "12:${toMinute.toString().padLeft(2, '0')} PM";
          else if (toHour == 0)
            totext = "12:${toMinute.toString().padLeft(2, '0')} AM";
          else if (toHour > 12)
            totext = (toHour - 12).toString() + ":${toMinute.toString().padLeft(2, '0')} PM";
          else
            totext = toHour.toString() + ":${toMinute.toString().padLeft(2, '0')} AM";
        }
      }
    } else {
      fromtext = "No work times available";
      totext = "No work times available";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // showDeleteConfimationDialog(Size size) {
  //   return showDialog(
  //     builder: (context) => NikahDialogWidget(
  //       padButtom: AppPadding.p32.h,
  //       padLeft: AppPadding.p12.w,
  //       padReight: AppPadding.p12.w,
  //       padTop: AppPadding.p32.h,
  //       radius: AppRadius.r21_3.r,
  //       dialogContent: Container(
  //         //width: AppSize.w429_3.h,
  //         color: Colors.white,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: SvgPicture.asset(
  //                     AssetsManager.redCancelIconPath,
  //                     height: AppSize.h32.r,
  //                     width: AppSize.w32.r,
  //                     color: AppColors.pink2,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SvgPicture.asset(
  //               AssetsManager.outlineDeleteIconPath,
  //               height: AppSize.h53_3.r,
  //               width: AppSize.w53_3.r,
  //             ),
  //             SizedBox(
  //               height: AppSize.h21_3.h,
  //             ),
  //             Text(
  //               getTranslated(context, "deleteText"),
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontFamily: getTranslated(context, "Montserratmedium"),
  //                 fontSize: AppFontsSizeManager.s21_3.sp,
  //                 color: Colors.black87,
  //                 fontWeight:
  //                     lang == "ar" ? AppFontsWeightManager.semiBold : null,
  //               ),
  //             ),
  //             SizedBox(
  //               height: AppSize.h32.h,
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(
  //                   right: AppPadding.p28_6.w, left: AppPadding.p28_6.w),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.max,
  //                 children: <Widget>[
  //                   deleting
  //                       ? CircularProgressIndicator()
  //                       : Container(
  //                           width: AppSize.w160.w,
  //                           height: AppSize.h52.h,
  //                           decoration: BoxDecoration(
  //                             color: AppColors.reddark2,
  //                             borderRadius:
  //                                 BorderRadius.circular(AppRadius.r5_3.r),
  //                           ),
  //                           child: InkWell(
  //                             onTap: () async {
  //                               setState(() {
  //                                 deleting = true;
  //                               });
  //                               await FirebaseFirestore.instance
  //                                   .collection(Paths.supportListPath)
  //                                   .doc(widget.user.supportListId)
  //                                   .delete();
  //                               await FirebaseFirestore.instance
  //                                   .collection(Paths.userDetail)
  //                                   .doc(widget.user.uid)
  //                                   .delete();
  //                               await FirebaseFirestore.instance
  //                                   .collection(Paths.userSearch)
  //                                   .doc(widget.user.uid)
  //                                   .delete();
  //                               await FirebaseFirestore.instance
  //                                   .collection(Paths.usersPath)
  //                                   .doc(widget.user.uid)
  //                                   .delete();
  //                               FirebaseAuth.instance.signOut();
  //                               setState(() {
  //                                 deleting = false;
  //                               });
  //                               Navigator.pushNamedAndRemoveUntil(
  //                                 context,
  //                                 '/Register_Type',
  //                                 (route) => false,
  //                               );
  //                             },
  //                             child: Center(
  //                               child: Text(
  //                                 getTranslated(context, 'delete'),
  //                                 style: TextStyle(
  //                                   fontFamily: getTranslated(
  //                                       context, "Montserratsemibold"),
  //                                   fontSize: AppFontsSizeManager.s21_3.sp,
  //                                   color: AppColors.white,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                   SizedBox(
  //                     width: AppSize.w53_3.w,
  //                   ),
  //                   Container(
  //                     width: AppSize.w160.w,
  //                     height: AppSize.h52.h,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
  //                       border: Border.all(color: AppColors.pink2),
  //                     ),
  //                     child: InkWell(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Center(
  //                         child: Text(
  //                           getTranslated(context, 'cancel'),
  //                           style: TextStyle(
  //                             fontFamily:
  //                                 getTranslated(context, "Montserratsemibold"),
  //                             fontSize: AppFontsSizeManager.s21_3.sp,
  //                             color: AppColors.reddark2,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: false,
  //     context: context,
  //   );
  // }

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
                              /*   await FirebaseFirestore.instance
                                  .collection(Paths.supportListPath)
                                  .doc(widget.user.supportListId)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection(Paths.userDetail)
                                  .doc(widget.user.uid)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection(Paths.userSearch)
                                  .doc(widget.user.uid)
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
          fontFamily: getTranslated(context, "Montserratsemibold"),
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

  void showFailedSnakbar(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.red,
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

  // Widget OutlineButton({ required VoidCallback onpress, required String ButtonText, required bool isselected}) {
  //   return OutlinedButton(
  //       onPressed: onpress,
  //       child: Container(
  //           width:isselected ? size!.width * 0.33:convertPtToPx(AppSize.w162_3.w),
  //           height: size!.height * 0.037,
  //           color: isselected?AppColors.white:AppColors.time,
  //           child: Center(
  //               child: Text(
  //             ButtonText,
  //             maxLines: 2,
  //             softWrap: true,
  //             overflow: TextOverflow.ellipsis,
  //             style: TextStyle(
  //                 color: isselected ? AppColors.reddark : AppColors.black2,
  //                 fontFamily: getTranslated(context, "fontFamily"),
  //                 fontWeight: FontWeight.normal,
  //                 fontSize: 10),
  //           ))),
  //
  //   );
  // }
  Widget OutlineButton(
      {required VoidCallback onpress,
      required String ButtonText,
      required bool isselected}) {
    return InkWell(
      onTap: onpress,
      child: Container(
          width: convertPtToPx(AppSize.w182.w),
          height: convertPtToPx(AppSize.h32.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r5.r),
            color: isselected ? AppColors.white : AppColors.time,
            border: Border.all(
                color: isselected ? AppColors.reddark : AppColors.white),
          ),
          child: Center(
              child: Text(
            ButtonText,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: isselected ? AppColors.reddark : AppColors.black2,
                fontFamily: getTranslated(context, "Montserratmedium"),
                fontWeight: FontWeight.normal,
                fontSize: convertPtToPx(AppFontsSizeManager.s14.sp)),
          ))),
    );
  }

  Widget dayButton(
      {required VoidCallback onpress,
      required String ButtonText,
      required bool isselected}) {
    return InkWell(
      onTap: onpress,
      child: Container(
          width: AppSize.w140.w,
          height: AppSize.h44.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: isselected ? AppColors.reddark : AppColors.lightGrey5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
          ),
          child: Center(
              child: Text(
            ButtonText,
            style: TextStyle(
                color: isselected ? AppColors.reddark : AppColors.lightGrey5,
                fontFamily: getTranslated(context, "Montserratsemibold"),
                fontSize: convertPtToPx(AppFontsSizeManager.s14.sp)),
          ))),
    );
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
              width: size!.width,
              // height: 80,
              // color: Colors.white,
              child: SafeArea(
                  child: AppBarWidget2(
                onPress: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                  setState(() {});
                },
                text: getTranslated(context, "account"),
              ))),
          SizedBox(
            height: convertPtToPx(16).h,
          ),
          Center(
              child: Container(
                  color: AppColors.white3,
                  height: AppSize.h1,
                  width: size!.width)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.r),
              children: [
                SizedBox(
                  height: AppSize.h21_3.h,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: widget.user.photoUrl!.isEmpty
                            ? SvgPicture.asset(
                                AssetsManager.mask_groupImagePath,
                                color: AppColors.pink2,
                                height: convertPtToPx(AppSize.h57).w,
                                width: convertPtToPx(AppSize.w60).h,
                                fit: BoxFit.scaleDown,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: AssetsManager.loadGIF,
                                  placeholderScale: 0.5,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                    AssetsManager.loadGIF,
                                    height: convertPtToPx(AppSize.h70),
                                    width: convertPtToPx(AppSize.w70),
                                    fit: BoxFit.cover,
                                  ),
                                  image: widget.user.photoUrl!,
                                  fit: BoxFit.cover,
                                  fadeInDuration: Duration(
                                      milliseconds:
                                          AppConstants.milliseconds250),
                                  fadeInCurve: Curves.easeInOut,
                                  fadeOutDuration: Duration(
                                      milliseconds:
                                          AppConstants.milliseconds150),
                                  fadeOutCurve: Curves.easeInOut,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: AppSize.h10_6.h,
                      ),
                      Center(
                        child: Text(
                          widget.user.name!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                              color: AppColors.pink2,
                              fontSize: AppFontsSizeManager.s26_6.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      Center(
                        child: Text(
                          getTranslated(context, "welcomeBack"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserrat-Medium"),
                              color: AppColors.black,
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42.h,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: AppPadding.p80.w),
                          child: Image.asset(
                            AssetsManager.process3ImagePath,
                            width: AppSize.w360.w,
                            height: AppSize.h34.h,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h33.h),
                      ),

                      getTitle(getTranslated(context, "name")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),

                      ///---------TextFormFieldWidget----------////
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: TextFormFieldWidget(
                          height: AppSize.h70_6.h,
                          width: AppSize.w506_6.w,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.black,
                          ),
                          initialValue: widget.user.fullName != null
                              ? widget.user.fullName.toString()
                              : "",
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
                            widget.user.fullName = val;
                          },
                          enableInteractiveSelection: true,
                          hintStyle: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: Colors.black,
                            fontSize: AppFontsSizeManager.s21_3.sp,
                            letterSpacing: 0.5,
                          ),
                          hint: getTranslated(context, 'fullNameText'),
                          borderColor: AppColors.lightGrey6,
                          backGroundColor: AppColors.white,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      Text(
                        getTranslated(context, "fullNameNoteTxt"),
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "Montserratmedium"),
                          fontSize: convertPtToPx(AppFontsSizeManager.s10.sp),
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h32.h,
                      ),
                      getTitle(getTranslated(context, "userNameTxt")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: TextFormFieldWidget(
                          //controller: userNameController,
                          height: AppSize.h70_6.h,
                          width: AppSize.w506_6.w,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.black,
                          ),
                          initialValue: widget.user.name != null
                              ? widget.user.name.toString()
                              : "",
                          textInputType: TextInputType.name,
                          validator: (String? val) {
                            var valArray =
                                val!.trimLeft().trimRight().split(' ');
                            if (val!.trim().isEmpty) {
                              return getTranslated(context, 'required');
                            } else if (valArray.length < 2)
                              return getTranslated(
                                  context, 'userNameConsistAtLeastOf2Parts');
                            else
                              return null;
                          },
                          onsave: (val) {
                            widget.user.name = val;
                          },
                          enableInteractiveSelection: true,
                          hintStyle: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: Colors.black,
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            letterSpacing: 0.5,
                          ),
                          hint: getTranslated(context, 'userNameTxt'),
                          borderColor: AppColors.lightGrey6,
                          backGroundColor: AppColors.white,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h16.h,
                      ),
                      Text(
                        getTranslated(context, "userNameNoteTxt"),
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "Montserratmedium"),
                          fontSize: convertPtToPx(AppFontsSizeManager.s10.sp),
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "age")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),

                      ///---------TextFormFieldWidget----------////
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: TextFormFieldWidget(
                          height: AppSize.h70_6.h,
                          width: AppSize.w506_6.w,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.black,
                          ),
                          initialValue: widget.user.age != null
                              ? widget.user.age.toString()
                              : "",
                          textInputType: TextInputType.number,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return getTranslated(context, 'required');
                            } else if (int.parse(val) > 100 ||
                                int.parse(val) < 15)
                              return getTranslated(context, 'ageRange');
                            else
                              return null;
                          },
                          onsave: (val) {
                            widget.user.age = int.parse(val!);
                          },
                          enableInteractiveSelection: true,
                          hintStyle: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: Colors.black,
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            letterSpacing: 0.5,
                          ),
                          hint: getTranslated(context, 'age'),
                          borderColor: AppColors.lightGrey6,
                          backGroundColor: AppColors.white,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "weightTxt")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),

                      ///---------TextFormFieldWidget----------////
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: TextFormFieldWidget(
                          height: AppSize.h70_6.h,
                          width: AppSize.w506_6.w,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.black,
                          ),
                          initialValue: widget.user.weight != null
                              ? widget.user.weight.toString()
                              : "",
                          textInputType: TextInputType.number,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return getTranslated(context, 'required');
                            } else if (double.parse(val) > 200 ||
                                double.parse(val) < 40)
                              return getTranslated(context, 'weightRange');
                            else
                              return null;
                          },
                          onsave: (val) {
                            widget.user.weight = double.parse(val!);
                          },
                          enableInteractiveSelection: true,
                          hintStyle: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: Colors.black,
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            letterSpacing: 0.5,
                          ),
                          hint: getTranslated(context, 'weightTxt'),
                          borderColor: AppColors.lightGrey6,
                          backGroundColor: AppColors.white,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "heightTxt")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),

                      ///---------TextFormFieldWidget----------////
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: TextFormFieldWidget(
                          height: AppSize.h70_6.h,
                          width: AppSize.w506_6.w,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.black,
                          ),
                          initialValue: widget.user.length != null
                              ? widget.user.length.toString()
                              : "",
                          textInputType: TextInputType.number,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return getTranslated(context, 'required');
                            } else if (double.parse(val) > 250 ||
                                double.parse(val) < 100)
                              return getTranslated(context, 'heightRange');
                            else
                              return null;
                          },
                          onsave: (val) {
                            widget.user.length = double.parse(val!);
                          },
                          enableInteractiveSelection: true,
                          hintStyle: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: Colors.black,
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            letterSpacing: 0.5,
                          ),
                          hint: getTranslated(context, 'heightTxt'),
                          borderColor: AppColors.lightGrey6,
                          backGroundColor: AppColors.white,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "childrenNumberTxt")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),

                      ///---------TextFormFieldWidget----------////
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: TextFormFieldWidget(
                          height: AppSize.h70_6.h,
                          width: AppSize.w506_6.w,
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            color: AppColors.black,
                          ),
                          initialValue: widget.user.childrenNum != null
                              ? widget.user.childrenNum.toString()
                              : "",
                          textInputType: TextInputType.number,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return getTranslated(context, 'required');
                            } else if (int.parse(val) > 10)
                              return getTranslated(context, 'childRange');
                            else
                              return null;
                          },
                          onsave: (val) {
                            widget.user.childrenNum = int.parse(val!);
                          },
                          enableInteractiveSelection: true,
                          hintStyle: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            color: Colors.black,
                            fontSize: AppFontsSizeManager.s18_6.sp,
                            letterSpacing: 0.5,
                          ),
                          hint: getTranslated(context, 'childrenNumberTxt'),
                          borderColor: AppColors.lightGrey6,
                          backGroundColor: AppColors.white,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),
                      ),

                      ///---------------------
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "skincolor")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.color == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.color == null)
                                        setState(() {
                                          widget.user.color = "wheatishlight";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "wheatishlight"),
                                    isselected: (widget.user.color != null &&
                                        widget.user.color == "wheatishlight")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.color == null)
                                        setState(() {
                                          widget.user.color = "white";
                                        });
                                    },
                                    ButtonText: getTranslated(context, "white"),
                                    isselected: (widget.user.color != null &&
                                        widget.user.color == "white"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.color == null)
                                        setState(() {
                                          widget.user.color = "bronze";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "bronze"),
                                    isselected: (widget.user.color != null &&
                                        widget.user.color == "bronze")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.color == null)
                                        setState(() {
                                          widget.user.color = "wheatish";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "wheatish"),
                                    isselected: (widget.user.color != null &&
                                        widget.user.color == "wheatish"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.color == null)
                                        setState(() {
                                          widget.user.color = "lightblack";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "lightblack"),
                                    isselected: (widget.user.color != null &&
                                        widget.user.color == "lightblack")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.color == null)
                                        setState(() {
                                          widget.user.color = "darkblack";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "darkblack"),
                                    isselected: (widget.user.color != null &&
                                        widget.user.color == "darkblack"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "maritalstate")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),

                      widget.user.maritalStatus == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.maritalStatus == null)
                                        setState(() {
                                          widget.user.maritalStatus = "single";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "single"),
                                    isselected: (widget.user.maritalStatus !=
                                            null &&
                                        widget.user.maritalStatus == "single")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.maritalStatus == null)
                                        setState(() {
                                          widget.user.maritalStatus =
                                              "divorced";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "divorced"),
                                    isselected:
                                        (widget.user.maritalStatus != null &&
                                            widget.user.maritalStatus ==
                                                "divorced")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.maritalStatus == null)
                                        setState(() {
                                          widget.user.maritalStatus = "widow";
                                        });
                                    },
                                    ButtonText: getTranslated(context, "widow"),
                                    isselected: (widget.user.maritalStatus !=
                                            null &&
                                        widget.user.maritalStatus == "widow")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "doctrine")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.doctrine == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //&&widget.user.doctrine  == null )
                                        setState(() {
                                          widget.user.doctrine = "sunni";
                                        });
                                    },
                                    ButtonText: getTranslated(context, "sunni"),
                                    isselected: (widget.user.doctrine != null &&
                                        widget.user.doctrine == "sunni")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //&&widget.user.doctrine  == null )
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //&&widget.user.doctrine  == null )
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
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "origin")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.origin == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.origin  == null )
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
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.origin  == null )
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.origin  == null )
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
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.origin  == null )
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.origin  == null )
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
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.origin  == null )
                                        setState(() {
                                          widget.user.origin =
                                              "africanAmerican";
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.origin  == null )
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
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.origin  == null )
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
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "employmentStatus")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.employment == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.employment == null)
                                        setState(() {
                                          widget.user.employment = "employee";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "employee"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "employee")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.employment == null)
                                        setState(() {
                                          widget.user.employment = "manager";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "manager"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "manager"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.employment == null)
                                        setState(() {
                                          widget.user.employment = "worker";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "worker"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "worker")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.employment == null)
                                        setState(() {
                                          widget.user.employment = "unemployed";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "unemployed"),
                                    isselected:
                                        (widget.user.employment != null &&
                                            widget.user.employment ==
                                                "unemployed")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.employment == null)
                                        setState(() {
                                          widget.user.employment = "self1";
                                        });
                                    },
                                    ButtonText: getTranslated(context, "self1"),
                                    isselected:
                                        (widget.user.employment != null &&
                                            widget.user.employment == "self1")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.employment == null)
                                        setState(() {
                                          widget.user.employment = "business2";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "business2"),
                                    isselected: (widget.user.employment !=
                                            null &&
                                        widget.user.employment == "business2")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "livingStander")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.living == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.living == null)
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
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.living == null)
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.living == null)
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
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "educationalLevel")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.education == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.education == null)
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
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.education == null)
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.education == null)
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
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.education == null)
                                        setState(() {
                                          widget.user.education = "uneducated";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "uneducated"),
                                    isselected: (widget.user.education !=
                                            null &&
                                        widget.user.education == "uneducated")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.education == null)
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
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "Specialization")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.specialization == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.specialization == null)
                                        setState(() {
                                          widget.user.specialization =
                                              "economic";
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
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.specialization == null)
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.specialization == null)
                                        setState(() {
                                          widget.user.specialization =
                                              "islamic";
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
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.specialization == null)
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.specialization == null)
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
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.specialization == null)
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.specialization == null)
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
                                      if (widget.user.profileCompleted ==
                                          false) //
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
                      ),

                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "hijab")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.hijab == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.hijab == null)
                                        setState(() {
                                          widget.user.hijab = "niqab";
                                        });
                                    },
                                    ButtonText: getTranslated(context, "niqab"),
                                    isselected: (widget.user.hijab != null &&
                                        widget.user.hijab == "niqab")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //  if(widget.user.hijab == null)
                                        setState(() {
                                          widget.user.hijab = "jilbab";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "jilbab"),
                                    isselected: (widget.user.hijab != null &&
                                        widget.user.hijab == "jilbab"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.hijab == null)
                                        setState(() {
                                          widget.user.hijab = "veil";
                                        });
                                    },
                                    ButtonText: getTranslated(context, "veil"),
                                    isselected: (widget.user.hijab != null &&
                                        widget.user.hijab == "veil")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.hijab == null)
                                        setState(() {
                                          widget.user.hijab = "nonVeiled";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "nonVeiled"),
                                    isselected: (widget.user.hijab != null &&
                                        widget.user.hijab == "nonVeiled"))
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "Smoking")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.smooking == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.smooking == null)
                                        setState(() {
                                          widget.user.smooking = "smoker1";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "smoker1"),
                                    isselected: (widget.user.smooking != null &&
                                        widget.user.smooking == "smoker1")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.smooking == null)
                                        setState(() {
                                          widget.user.smooking = "nonSmoker1";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "nonSmoker1"),
                                    isselected: (widget.user.smooking != null &&
                                        widget.user.smooking == "nonSmoker1")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "marriageType")),
                      widget.user.marriage == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) // if(widget.user.marriage == null)
                                        setState(() {
                                          widget.user.marriage = "normal";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "normal"),
                                    isselected: (widget.user.marriage != null &&
                                        widget.user.marriage == "normal")),
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.profileCompleted ==
                                          false) //if(widget.user.marriage == null)
                                        setState(() {
                                          widget.user.marriage = "polygamy";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "polygamy"),
                                    isselected: (widget.user.marriage != null &&
                                        widget.user.marriage == "polygamy")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                OutlineButton(
                                    onpress: () {
                                      if (widget.user.marriage == null)
                                        setState(() {
                                          widget.user.marriage = "notinterest";
                                        });
                                    },
                                    ButtonText:
                                        getTranslated(context, "notinterest"),
                                    isselected: (widget.user.marriage != null &&
                                        widget.user.marriage == "notinterest")),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),

                      ///=========================
                      //  if (widget.user.isPhoneMain == false)
                      SizedBox(
                        height: AppSize.h37_3.h,
                      ),
                      if (widget.user.isPhoneMain == false)
                        getTitle(getTranslated(context, "phoneNumber")),
                      if (widget.user.isPhoneMain == false)
                        Padding(
                            padding: EdgeInsets.only(top: AppPadding.p21_3.h),
                            child: Container(
                              height: AppSize.h70_6.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p21_3.w,
                                // vertical: AppPadding.p24.h
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.grayShade300, width: 0.5),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r10_6.r),
                              ),
                              child: PhoneNumberWidget(
                                phoneNumber: phoneNumber,
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
                      /////-------------------------///////////////////////////////////////
                      SizedBox(
                        height: convertPtToPx(AppSize.h32.h),
                      ),
                      getTitle(getTranslated(context, "about")),
                      SizedBox(
                        height: convertPtToPx(AppSize.h16.h),
                      ),
                      widget.user.aboutMe == ""
                          ? Center(
                              child: Text(
                                getTranslated(context, "about"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: Container(
                          height: AppSize.h200.h,
                          width: AppSize.w506_6.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lightGrey6,
                              width: AppSize.w2.w,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                          ),
                          child: TextFormFieldWidget(
                            insidePadding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p32.w,
                                vertical: AppPadding.p16.h),
                            maxLength: 150,
                            maxLine: 5,
                            height: AppSize.h200.h,
                            width: AppSize.w506_6.w,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              fontSize: AppFontsSizeManager.s18.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            initialValue: widget.user.bio != null
                                ? widget.user.bio.toString()
                                : "",
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
                            enableInteractiveSelection: true,
                            hintStyle: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              color: Colors.black,
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              letterSpacing: 0.5,
                            ),
                            hint: getTranslated(context, 'abutText'),
                            borderColor: AppColors.white,
                            //controller:namecontroller ,
                            backGroundColor: AppColors.white,

                            borderRadiusValue: AppRadius.r10_6.r,
                            cursorColor: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      getTitle(getTranslated(context, "aboutSpouseTxt")),
                      SizedBox(height: AppSize.h21_3.h),
                      Theme(
                        data: new ThemeData(
                          primaryColor: AppColors.redAccent,
                          primaryColorDark: AppColors.red,
                        ),
                        child: Container(
                          height: AppSize.h200.h,
                          width: AppSize.w506_6.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lightGrey6,
                              width: AppSize.w2.w,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                          ),
                          child: TextFormFieldWidget(
                            insidePadding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p32.w,
                                vertical: AppPadding.p16.h),
                            maxLength: 150,
                            maxLine: 5,
                            height: AppSize.h200.h,
                            width: AppSize.w506_6.w,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                              fontSize: AppFontsSizeManager.s17.sp,
                              color: AppColors.black,
                            ),
                            initialValue: widget.user.partnerSpecifications !=
                                    null
                                ? widget.user.partnerSpecifications.toString()
                                : "",
                            textInputType: TextInputType.multiline,
                            validator: (String? val) {
                              if (val!.trim().isEmpty) {
                                return getTranslated(context, 'required');
                              }
                              return null;
                            },
                            onsave: (val) {
                              widget.user.partnerSpecifications = val;
                            },
                            enableInteractiveSelection: true,
                            hintStyle: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              color: Colors.black,
                              fontSize: AppFontsSizeManager.s18.sp,
                              letterSpacing: 0.5,
                            ),
                            hint: getTranslated(context, 'aboutSpouseTxt'),
                            borderColor: AppColors.white,
                            backGroundColor: AppColors.white,
                            borderRadiusValue: AppRadius.r10_6.r,
                            cursorColor: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h46.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.goldCalenderIconPath,
                            width: convertPtToPx(AppSize.w24.w),
                            height: convertPtToPx(AppSize.h24.h),
                          ),
                          SizedBox(
                            width: AppSize.w16.w,
                          ),
                          getTitle(getTranslated(context, "availability")),
                        ],
                      ),

                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      widget.user.workDays == null
                          ? Center(
                              child: Text(
                                getTranslated(context, "required"),
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppPadding.p80.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        saturday = !saturday;
                                      });
                                    },
                                    ButtonText: "Saturday",
                                    isselected: saturday),
                                SizedBox(
                                  width: AppSize.w64.w,
                                ),
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        sunday = !sunday;
                                      });
                                    },
                                    ButtonText: "Sunday",
                                    isselected: sunday),
                              ],
                            ),
                            SizedBox(height: AppSize.h16.w),
                            Row(
                              children: [
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        monday = !monday;
                                      });
                                    },
                                    ButtonText: "Monday",
                                    isselected: monday),
                                SizedBox(
                                  width: AppSize.w64.w,
                                ),
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        tuesday = !tuesday;
                                      });
                                    },
                                    ButtonText: "Tuesday",
                                    isselected: tuesday),
                              ],
                            ),
                            SizedBox(height: AppSize.h16.w),
                            Row(
                              children: [
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        wednesday = !wednesday;
                                      });
                                    },
                                    ButtonText: "Wednesday",
                                    isselected: wednesday),
                                SizedBox(
                                  width: AppSize.w64.w,
                                ),
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        thursday = !thursday;
                                      });
                                    },
                                    ButtonText: "Thursday",
                                    isselected: thursday),
                              ],
                            ),
                            SizedBox(height: AppSize.h16.w),
                            Row(
                              children: [
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        friday = !friday;
                                      });
                                    },
                                    ButtonText: "Friday",
                                    isselected: friday),
                                SizedBox(
                                  width: AppSize.w64.w,
                                ),
                                dayButton(
                                    onpress: () {
                                      setState(() {
                                        everyday = !everyday;
                                      });
                                    },
                                    ButtonText: "Everyday",
                                    isselected: everyday),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h50.h,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.goldClockIconPath,
                            width: convertPtToPx(AppSize.w19.w),
                            height: convertPtToPx(AppSize.h19.h),
                          ),
                          SizedBox(
                            width: convertPtToPx(AppSize.w16.w),
                          ),
                          Text(
                            getTranslated(context, "from"),
                            style: TextStyle(
                              color: AppColors.black,
                              fontFamily: getTranslated(
                                  context, "Montserratsemibold"),
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s16.sp),
                            ),
                          ),
                          SizedBox(
                            width: convertPtToPx(AppSize.w8.w),
                          ),
                          Container(
                            //width: convertPtToPx(AppSize.w90_5.w),
                            height: convertPtToPx(AppSize.h28.h),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.brown,
                                ),
                                borderRadius: BorderRadius.circular(
                                    convertPtToPx(AppRadius.r16.r))),
                            child: MaterialButton(
                              onPressed: () {
                                _selectTimeFrom(context);
                              },
                              child: Center(
                                child: Text(
                                  fromtext!,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: getTranslated(
                                        context, "Montserratmedium"),
                                    color: AppColors.black,
                                    fontSize: convertPtToPx(
                                        AppFontsSizeManager.s10.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: convertPtToPx(AppSize.w10.w),
                          ),
                          Text(
                            getTranslated(context, "to"),
                            style: TextStyle(
                              color: AppColors.black,
                              fontFamily: getTranslated(
                                  context, "Montserratsemibold"),
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s16.sp),
                            ),
                          ),
                          SizedBox(
                            width: convertPtToPx(AppSize.w8.w),
                          ),
                          Container(
                            //width: convertPtToPx(AppSize.w90_5.w),
                            height: convertPtToPx(AppSize.h30.h),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.brown,
                                ),
                                borderRadius: BorderRadius.circular(
                                    convertPtToPx(AppRadius.r16.r))),
                            child: MaterialButton(
                              onPressed: () {
                                _selectTimeTo(context);
                              },
                              child: Text(
                                totext!,
                                maxLines: 1,

                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratmedium"),
                                  color: AppColors.black,
                                  fontSize: convertPtToPx(
                                      AppFontsSizeManager.s10.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      Center(
                          child: Text(
                        getTranslated(context, "identityPhoto"),
                        style: TextStyle(
                            color: AppColors.pink2,
                            fontSize: convertPtToPx(16).sp,
                            fontWeight: FontWeight.w500),
                      )),
                      SizedBox(
                        height: convertPtToPx(16).h,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppPadding.p70.w),
                        child: Container(
                          width: AppSize.w372.w,
                          height: AppSize.h348.h,
                          decoration: BoxDecoration(
                            color: AppColors.time,
                            borderRadius:
                                BorderRadius.circular(AppRadius.r10_6.r),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: AppPadding.p20.w,
                                    right: AppPadding.p20.w,
                                    top: AppPadding.p20.w,
                                    bottom: AppPadding.p8.w),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          deleteImage = true;
                                          _image = null;
                                          widget.user.ImageUrl = "";
                                        });
                                        await deletePhoto();
                                      },
                                      child: SvgPicture.asset(
                                        AssetsManager.outlineDeleteIconPath,
                                        width: AppSize.w26_6.w,
                                        height: AppSize.h26_6.h,
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: SvgPicture.asset(
                                        AssetsManager.upload,
                                        width: AppSize.w26_6.w,
                                        height: AppSize.h26_6.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r10_6.r),
                                child: _image != null
                                    ? Image.file(
                                        _image!,
                                        width: AppSize.w338.w,
                                        height: AppSize.h285.h,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.r10_6.r),
                                        child: widget.user.ImageUrl == "" &&
                                                //deleteImage == true ||
                                                _image == null
                                            ? SizedBox()
                                            : Image.network(
                                                widget.user.ImageUrl!
                                                    .toString(),
                                                width: AppSize.w338.w,
                                                height: AppSize.h285.h,
                                              ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h46.h,
                      ),
                      InkWell(
                        onTap: () {
                          showDeleteConfimationDialog(size!);
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                AssetsManager.outlineDeleteIconPath),
                            SizedBox(
                              width: AppSize.w4.w,
                            ),
                            Text(
                              getTranslated(context, "deleteAccount"),
                              style: TextStyle(
                                fontSize:
                                    convertPtToPx(AppFontsSizeManager.s16.sp),
                                fontFamily:
                                    getTranslated(context, 'Montserratmedium'),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: AppSize.h46.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   getTranslated(context, "leftrose"),
                          //   width: 30,
                          //   height: 30,
                          // ),
                          // SizedBox(width: 10,),
                          saving
                              ? CircularProgressIndicator()
                              : TextButton1(
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
                                  TextColor: AppColors.white,
                                ),
                          /*  Container(
                            width: size!.width * 0.8,
                            height: size!.height * 0.054,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    AppColors.reddark2,
                                    AppColors.reddark2,
                                  ],
                                )),
                            child: MaterialButton(
                              onPressed: () async {
                                save();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r10.r)),
                              ),
                              child: Text(
                                getTranslated(context, "saveAndContinue"),
                                style: TextStyle(
                                  fontFamily:
                                      getTranslated(context,  "Montserrat-SemiBold"),
                                  color: Colors.white,
                                  fontSize: convertPtToPx(AppFontsSizeManager.s16.sp),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),*/
                          // SizedBox(width: 10,),
                          // Image.asset(
                          //   getTranslated(context, "rightrose"),
                          //   width: 30,
                          //   height: 30,
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: convertPtToPx(AppSize.h53.h),
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

  Widget getTitle(String title) {
    lang = getTranslated(context, "lang");
    return Text(
      title,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: getTranslated(context, "Montserratsemibold"),
          fontSize: convertPtToPx(AppFontsSizeManager.s16.sp),
          color: AppColors.labelColor,
          fontWeight: FontWeight.w500),
    );
  }

  Widget getHint(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
          fontFamily: getTranslated(context, "Montserratsemibold"),
          fontSize: convertPtToPx(AppFontsSizeManager.s12.sp),
          color: AppColors.darkGrey,
          fontWeight: FontWeight.normal),
    );
  }

  _selectTimeFrom(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _workTime.from == null
          ? selectedTime
          : TimeOfDay(
              hour: int.parse(widget.user.workTimes![0].from.toString()),
              minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        from = timeOfDay.hour.toString();
        if (timeOfDay.hour == 12)
          fromtext = "12 : 00 PM";
        else if (timeOfDay.hour == 0)
          fromtext = "12 : 00 AM";
        else if (timeOfDay.hour > 12)
          fromtext = "${(timeOfDay.hour - 12).toString()}:${timeOfDay.minute.toString().padLeft(2, '0')} PM";
        else
          fromtext = "${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')} AM";
      });
    }
  }

  _selectTimeTo(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _workTime.to == null
          ? selectedTime
          : TimeOfDay(
              hour: int.parse(widget.user.workTimes![0].to.toString()),
              minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        to = timeOfDay.hour.toString();
        if (timeOfDay.hour == 12)
          totext = "12 : 00 PM";
        else if (timeOfDay.hour == 0)
          totext = "12 : 00 AM";
        else if (timeOfDay.hour > 12)
          totext = "${(timeOfDay.hour - 12).toString()}:${timeOfDay.minute.toString().padLeft(2, '0')} PM";
        else
          totext = "${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')} AM";
      });
    }
  }

  void _show(BuildContext ctx, size) {
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: Colors.transparent,
      context: ctx,
      builder: (ctx) => Container(
        height: size!.height * .8,
        width: size!.width,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
            )),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      getTranslated(context, "workDays"),
                      style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Montserrat-SemiBold"),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        color: theme == "light"
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: monday,
                          onChanged: (value) {
                            setState(() {
                              monday = value!; //!monday;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "monday"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserrat-SemiBold"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: tuesday,
                          onChanged: (value) {
                            setState(() {
                              tuesday = !tuesday;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "tuesday"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserrat-SemiBold"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: wednesday,
                          onChanged: (value) {
                            setState(() {
                              wednesday = !wednesday;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "wednesday"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserrat-SemiBold"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: thursday,
                          onChanged: (value) {
                            setState(() {
                              thursday = !thursday;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "thursday"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserrat-SemiBold"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: friday,
                          onChanged: (value) {
                            setState(() {
                              friday = !friday;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "friday"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserrat-SemiBold"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: saturday,
                          onChanged: (value) {
                            setState(() {
                              saturday = !saturday;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "saturday"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserrat-SemiBold"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: sunday,
                          onChanged: (value) {
                            setState(() {
                              sunday = !sunday;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "sunday"),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserrat-SemiBold"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        height: 35,
                        width: size!.width * 0.5,
                        child: MaterialButton(
                          onPressed: () {
                            workDays = "";

                            setState(() {
                              daysController!.text = workDays!;
                              print("days   " + daysController!.text);
                              widget.user.workDays = daysValue;
                            });
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Text(
                            getTranslated(context, "done"),
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserrat-SemiBold"),
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 1.0), // shadow direction: bottom right
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

  Future uploadFile() async {
    if (_image == null) return;

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('idImages/${DateTime.now().millisecondsSinceEpoch}');

    UploadTask uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() async {
      setState(() {
        print('File Uploaded');
      });

      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
        });
      });
    });
  }

  Future<void> deletePhoto() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.user.uid!)
          .update({
        'ImageUrl': "",
      });
      print("Firestore document updated.");
    } catch (e) {
      print("Error deleting photo: $e");
    }
  }

  save() async {
    if (mounted) {
      setState(() {
        saving = true;
      });
      daysValue = [];
      if (monday) {
        daysValue.add("1");
      }
      if (tuesday) {
        daysValue.add("2");
      }
      if (wednesday) {
        daysValue.add("3");
      }
      if (thursday) {
        daysValue.add("4");
      }
      if (friday) {
        daysValue.add("5");
      }
      if (saturday) {
        daysValue.add("6");
      }
      if (sunday) {
        daysValue.add("7");
      }

      if (everyday) {
        daysValue.clear();
        daysValue.add("1");
        daysValue.add("2");
        daysValue.add("3");
        daysValue.add("4");
        daysValue.add("5");
        daysValue.add("6");
        daysValue.add("7");
      }
      var querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .where('phoneNumber', isEqualTo: phoneNumber.phoneNumber)
          .where("uid", isNotEqualTo: widget.user.uid)
          .get();
      print("2");
      if (_formKey.currentState!.validate() &&
          querySnapshot.docs.length == 0 &&
          daysValue.length > 0 &&
          (_image != null ||
              (widget.user.ImageUrl != null &&
                  widget.user.ImageUrl!.isNotEmpty)) &&
          (from != null && to != null && int.parse(to!) > int.parse(from!))) {
        _formKey.currentState!.save();
        if (_image != null) {
          await uploadFile();
          widget.user.ImageUrl = _uploadedFileURL;
        }

        //work days and time
        var datenow = DateTime.now();
        widget.user.fromUtc = DateTime(datenow.year, datenow.month, datenow.day,
                int.parse(from!), 0, 0)
            .toUtc()
            .toString();
        widget.user.toUtc = DateTime(
                datenow.year, datenow.month, datenow.day, int.parse(to!), 0, 0)
            .toUtc()
            .toString();
        setState(() {
          dataSave = true;
        });

        widget.user.workDays = daysValue;

        _workTime.from = from;
        _workTime.to = to;
        widget.user.phoneNumber = phoneNumber.phoneNumber;
        widget.user.countryCode = phoneNumber.dialCode;
        widget.user.countryISOCode = phoneNumber.isoCode;
        widget.user.workTimes!.clear();
        widget.user.workTimes!.add(_workTime);
        // if (widget.user.origin != null &&
        //     widget.user.workDays != null &&
        //     widget.user.workTimes != null &&
        //     widget.user.employment != null &&
        //     widget.user.color != null &&
        //     widget.user.smooking != null &&
        //     widget.user.doctrine != null &&
        //     widget.user.education != null &&
        //     widget.user.living != null &&
        //     widget.user.hijab != null &&
        //     widget.user.maritalStatus != null &&
        //     widget.user.marriage != null &&
        //     widget.user.specialization != null) {
        List<String> splitList = name!.split(" ");
        List<String> indexList = [];
        for (int i = 0; i < splitList.length; i++) {
          for (int y = 1; y < splitList[i].length; y++) {
            indexList.add(splitList[i].substring(0, y).toLowerCase());
          }
        }
        widget.user.searchIndex = indexList;
        widget.user.userLang = getTranslated(context, 'lang');
        widget.user.phoneNumber = phoneNumber.phoneNumber;
        widget.user.countryCode = phoneNumber.dialCode;
        widget.user.countryISOCode = phoneNumber.isoCode;
        if (widget.user.order == null) widget.user.order = 0;
        if (selectedProfileImage != null)
          accountBloc!.add(UpdateAccountDetailsEvent(
              user: widget.user, profileImage: selectedProfileImage));
        else
          accountBloc!.add(UpdateAccountDetailsEvent(user: widget.user));
        final snapShot = await FirebaseFirestore.instance
            .collection('userDetail')
            .doc(widget.user.uid)
            .get();

        if (snapShot == null || !snapShot.exists) {
          await FirebaseFirestore.instance
              .collection('userDetail')
              .doc(widget.user.uid)
              .set({
                "userId": widget.user.uid,
                "name": widget.user.name,
                "characterNature": "",
                "habits": "",
                "hatefulThings": "",
                "healthCondition": "",
                "hobbies": "",
                "lovableThings": "",
                "marriageYears": "",
                "negativePoints": "",
                "positivePoints": "",
                "priorties": "",
                "quranLevel": "",
                "religionLevel": "",
                "values": "",
                /* "partnerOrigin": "",
             "partnerDoctrine": "",
             "partnerMaritalState": "",
             "partnerLivingStander": "",
             "partnerEmploymentStatus": "",
             "partnerEducationalLevel": "",
             "partnerSpecialization": "",
             "partnerSmoking": "",
             "partnerMinAge": ,
             "partnerMaxAge": ,
             "partnerMinHeight": ,
             "partnerMaxHeight": ,
             "partnerMinWeight": ,
             "partnerMaxWeight": ,*/
              })
              .then((value) {})
              .catchError((error) {
                showFailedSnakbar(error.toString());
              });
        }
        setState(() {
          saving = false;
        });
      } else {
        setState(() {
          saving = false;
        });
        if (_formKey.currentState!.validate() == false) {
          showFailedSnakbar(getTranslated(context, "allRequired"));
        } else if (querySnapshot.docs.length > 0) {
          print("3");
          showFailedSnakbar(getTranslated(context, 'phoneUsed'));
        } else if (daysValue.length == 0)
          showFailedSnakbar(getTranslated(context, "workDaysRequired"));
        else if (from == null ||
            to == null ||
            int.parse(from!) > int.parse(to!))
          showFailedSnakbar(getTranslated(context, "invalidWorkTime"));
        else if (_image == null &&
            (widget.user.ImageUrl == null || widget.user.ImageUrl!.isEmpty))
          showFailedSnakbar(getTranslated(context, "identityPhotoRequired"));
        else
          showFailedSnakbar(getTranslated(context, "allRequired"));
      }
    }
  }
}
