
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/screens/home_screen.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/text_form_field_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../methodes/snackbar.dart';
import '../widget/app_bar_widget.dart';
import '../widget/nikah_dialog.dart';
import 'google_apple_signup/views/widgets/phone_number_widget.dart';
class CoachScreen extends StatefulWidget {
  final GroceryUser user;
  final bool? firstLogged;
  const CoachScreen({Key? key, required this.user,  this.firstLogged}) : super(key: key);
  @override
  _CoachScreenState createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  late AccountBloc accountBloc;
PhoneNumber phoneNumber = PhoneNumber(isoCode: 'US');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay selectedTime = TimeOfDay.now();
  late String name,userName,bio,theme,age,education;
  late ScrollController scrollController;
  var image;bool deleting=false;
  File? selectedProfileImage;
  bool profileCompleted=false,dataSave=false,other = false;
  late Size size;
  String?
      price,
      workDays = "",
      lang = "",
      type = "",
      fromtext = "",
      totext = "",
      from,
      to;
  List<WorkTimes>? workTimes;
  List<String> daysValue = [];
  WorkTimes _workTime = new WorkTimes();
  TextEditingController? daysController,
      langController,
      typeController,
      fromController,
      toController;
  bool monday = false,
      tuesday = false,
      wednesday = false,
      thursday = false,
      friday = false,
      saturday = false,
      sunday = false,
      everyday = false,
     arabic=false,english=false,
      first = true;
  @override
  void initState() {
    super.initState();
     if ( widget.user.phoneNumber != null)
     phoneNumber = PhoneNumber(
          phoneNumber: widget.user.phoneNumber,
          dialCode: widget.user.countryCode,
          isoCode: widget.user.countryISOCode);
          print(widget.user.phoneNumber);
           print(widget.user.countryCode);
            print(widget.user.countryISOCode);
    widget.user.workDays!.forEach((day) {
      if (day == "1") monday = true;
      if (day == "2") tuesday = true;
      if (day == "3") wednesday = true;
      if (day == "4") thursday = true;
      if (day == "5") friday = true;
      if (day == "6") saturday = true;
      if (day == "7") sunday = true;
      if(widget.user.languages!.contains("arabic"))
        arabic=true;
      if(widget.user.languages!.contains("english"))
        english=true;
    });
    if (widget.user.workTimes!.length > 0) {
      _workTime = widget.user.workTimes![0];
      if (_workTime.from != null) {
        from = _workTime.from;
        int fromvalue = int.parse(_workTime.from!);
        if (fromvalue == 12)
          fromtext = "12 PM";
        else if (fromvalue == 0)
          fromtext = "12 AM";
        else if (fromvalue > 12)
          fromtext = (fromvalue - 12).toString() + " PM";
        else
          fromtext = fromvalue.toString() + " AM";
      }
      if (_workTime.to != null) {
        to = _workTime.to;
        int toValue = int.parse(_workTime.to!);
        if (toValue == 12)
          totext = "12 PM";
        else if (toValue == 0)
          totext = "12 AM";
        else if (toValue > 12)
          totext = (toValue - 12).toString() + " PM";
        else
          totext = toValue.toString() + " AM";
      }
    }
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.stream.listen((state) {

      if (state is UpdateAccountDetailsInProgressState) {
        //show dialog
        if(mounted)
          showUpdatingDialog();
      }
      if (state is UpdateAccountDetailsFailedState) {
        //show error
        if(mounted)
          showSnack(getTranslated(context, "error"), context,false);
      }
      if (state is UpdateAccountDetailsCompletedState) {
        if(mounted&&dataSave){
          dataSave=false;
          accountBloc.add(GetLoggedUserEvent());
          selectedProfileImage=null;
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

  void showSnack(String text, BuildContext context,bool status ) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: status?Theme.of(context).primaryColor:Colors.red.shade500,
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
        style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
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
  Widget OutlineButton({required VoidCallback onpress, required String ButtonText, required bool isselected}) {
    return OutlinedButton(
        onPressed: onpress,
        child: Container(
            width: size.width * 0.33,
            // height: size.height * 0.037,
            child: Center(
                child: Text(
                  ButtonText,
                  maxLines: 2,softWrap: true,overflow:TextOverflow.ellipsis,
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
        padTop:AppPadding.p32.h,
        radius: AppRadius.r21_3.r,
        dialogContent:Container(
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
                          deleting=true;
                        });
                        await FirebaseFirestore.instance
                            .collection(Paths.supportListPath)
                            .doc(widget.user.supportListId)
                            .delete();
                        await FirebaseFirestore.instance
                            .collection(Paths.usersPath)
                            .doc(widget.user.uid)
                            .delete();
                        FirebaseAuth.instance.signOut();
                        setState(() {
                          deleting=false;
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
                            fontFamily:
                            getTranslated(context, "Montserratsemibold"),
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
                      borderRadius:
                      BorderRadius.circular(AppRadius.r10_6.r),
                      border: Border.all(
                          color: AppColors.pink2
                      ),
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
    File croppedFile =File(image.path);
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding(
                    padding:  EdgeInsets.only(
                      bottom: AppPadding.p21_3.h
                        ),
                    ///--App Bar Widget--///
                    child: AppBarWidget2(
                      onPress: (){
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                              (route) => false,
                        );
                        setState(() {
                          
                        });
                      },
                      text: getTranslated(context, "profile"),
              ),
                  ))),
          Center(
              child: Container(
                  color: AppColors.white3,
                  height: 1,
                  width: size.width)),
                  SizedBox(height: AppSize.h32.h,),
          Expanded(
            child: ListView(padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
              children:  [
                Form(
                  key: _formKey,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: InkWell(
                          onTap: () {
                            cropImage(context);
                          },
                          child: Container(height: AppSize.h86_6.r,width:AppSize.h86_6.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: widget.user.photoUrl==null &&selectedProfileImage == null
                                ?   ClipRRect(borderRadius:BorderRadius.circular(35.0),child: Image.asset('assets/icons/icon/Mask Group 47.png', fit:BoxFit.fill,height: AppSize.h86_6.r,width:AppSize.h86_6.r))
                                : selectedProfileImage != null
                                ? ClipRRect(borderRadius:BorderRadius.circular(35.0),child: Image.file(selectedProfileImage!,fit:BoxFit.fill,height: AppSize.h86_6.r,width:AppSize.h86_6.r))
                                : ClipRRect(borderRadius:
                            BorderRadius.circular(35.0),
                              child: FadeInImage.assetNetwork(
                                placeholder:'assets/icons/icon/Mask Group 47.png',
                                placeholderScale: 0.5,
                                imageErrorBuilder: (context, error, stackTrace) =>
                                    Icon( Icons.person,color:Colors.black, size: 50.0,),
                                image: widget.user.photoUrl!,
                                fit: BoxFit.cover,
                                height: AppSize.h86_6.r,width:AppSize.h86_6.r,
                                fadeInDuration:
                                Duration(milliseconds: 250),
                                fadeInCurve: Curves.easeInOut,
                                fadeOutDuration:
                                Duration(milliseconds: 150),
                                fadeOutCurve: Curves.easeInOut,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.h21_3.h,),
                      (widget.user.name!=null&&widget.user.name!="")?Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: Text(
                            widget.user.name!,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow:TextOverflow.clip ,
                            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontSize: 19,color:AppColors.reddark2, ),),
                        ),
                      ):SizedBox(),
                     SizedBox(height: AppSize.h10_6.h,),
                      Center(
                        child: Text(
                          getTranslated(context, "welcomeBack"),
                          style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontSize: 13.0,color:AppColors.grey3, ),
                        ),
                      ),
                      SizedBox(height: AppSize.h32.h),

                      getTitle(getTranslated(context, "name")),
                      SizedBox(height: AppSize.h16.h,),
                      ///---------TextFormFieldWidget----------////
                      Container(
                        height: AppSize.h70_6.h,
                        child: TextFormFieldWidget(
                              style: TextStyle(
                                fontFamily:
                                getTranslated(context, "Montserratmedium"),
                                fontSize: AppFontsSizeManager.s21_3.sp,
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
                          borderColor: AppColors.lightGrey6,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),
                        //old
                        // child: TextFormField(
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //       fontFamily:
                        //       getTranslated(context, "fontFamily"),
                        //       fontSize: 14.0,
                        //       color: AppColors.balck2,
                        //     ),
                        //     cursorColor: AppColors.black,
                        //     initialValue: widget.user.name,
                        //     keyboardType: TextInputType.name,
                        //     validator: (String? val) {
                        //       if (val!.trim().isEmpty) {
                        //         return getTranslated(context, 'required');
                        //       }
                        //       return null;
                        //     },
                        //     onSaved: (val) {
                        //       widget.user.name = val;
                        //     },
                        //     enableInteractiveSelection: true,
                        //     decoration: inputDecoration()),
                      ),
                      SizedBox(height: AppSize.h32.h,),
                      getTitle("${getTranslated(context, 'price')} \$"),
                      SizedBox(height: AppSize.h16.h,),
                      Container(
                        height: AppSize.h70_6.h,
                        child: TextFormFieldWidget(
                          style: TextStyle(
                            fontFamily:
                            getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s21_3.sp,
                            color: AppColors.balck2,
                          ),
                          cursorColor: AppColors.black,
                          initialValue: widget.user.price.toString(),
                          textInputType: TextInputType.number,
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return getTranslated(context, 'required');
                            }
                            return null;
                          },
                          onsave: (val) {
                            widget.user.price = double.parse(val!);
                          },
                          enableInteractiveSelection: true,
                          borderColor: AppColors.lightGrey6,
                          borderRadiusValue: AppRadius.r10_6.r,
                        ),

                        //old
                        // child: TextFormField(
                        //     textAlign: TextAlign.center,
                        //     keyboardType:TextInputType.number,
                        //     style: TextStyle(
                        //       fontFamily:
                        //       getTranslated(context, "fontFamily"),
                        //       fontSize: 14.0,
                        //       color: AppColors.balck2,
                        //     ),
                        //     cursorColor: AppColors.black,
                        //     initialValue: widget.user.price.toString(),
                        //     validator: (String? val) {
                        //       if (val!.trim().isEmpty) {
                        //         return getTranslated(context, 'required');
                        //       }
                        //       return null;
                        //     },
                        //     onSaved: (val) {
                        //       widget.user.price = val;
                        //     },
                        //     enableInteractiveSelection: true,
                        //     decoration: inputDecoration()),
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
                          child: Container(
                            height: AppSize.h70_6.h,
                            padding: EdgeInsets.symmetric(
                                  horizontal: AppPadding.p21_3.w,
                                 // vertical: AppPadding.p24.h
                                  ),
                             decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.lightGrey6, width: 0.5),
                                borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
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
                      SizedBox(height: AppSize.h32.h,),
                      getTitle(getTranslated(context, "languages")),
                      widget.user.languages==null
                          ? Center(
                        child: Text(
                          getTranslated(context, "required"),
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                          : SizedBox(),

                      SizedBox(
                        height: AppSize.h21_3.h,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          langButton2(

                          width:  AppSize.w242_6.w,
                              onpress: () {
                                setState(() {
                                  arabic = !arabic;
                                });
                              },
                              ButtonText: "Arabic",
                              isselected: arabic),
                          langButton2(
                              width:  AppSize.w242_6.w,
                              onpress: () {
                                setState(() {
                                  english = !english;
                                });
                              },
                              ButtonText: "English",
                              isselected: english),

                        ],
                      ),
                      SizedBox(
                        height: AppSize.h32.h,
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
                        decoration: BoxDecoration(
                          border: Border.all(color:AppColors.lightGrey6,width: 0.5),
                          borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                        ),
                        child: TextFormField(
                          maxLines: 7,
                          maxLength: 150,
                          buildCounter: (_, {required currentLength, maxLength,required isFocused}) => Text(currentLength.toString() + "/" + maxLength.toString(),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s13_3.sp,
                            color: AppColors.darkGrey
                          ),),
                          style: TextStyle(
                            fontSize: AppFontsSizeManager.s21_3.sp,
                            fontFamily: getTranslated(context, "Montserratmedium"),
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
                          decoration:  InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: AppSize.w21_3.w,vertical: AppSize.h13_2.h ),
                            counterStyle: TextStyle(
                              fontFamily: getTranslated(context, "Montserratmedium"),
                              color: Colors.grey,
                              fontSize: AppFontsSizeManager.s21_3.sp,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: getTranslated(context, "Montserratmedium"),
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
                      SizedBox(
                        height: AppSize.h32.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/icon/Group 3642.png",
                            width:  AppSize.w32.r,
                            height: AppSize.w32.r,
                          ),
                          SizedBox(width: AppSize.w21_3.w,),
                          getTitle(getTranslated(context, "availability")),
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h26_6.h,
                      ),
                      widget.user.workDays == null
                          ? Center(
                        child: Text(
                          getTranslated(context, "required"),
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                          : SizedBox(),
                      Column(
                        children: [
                          Wrap(
                            spacing: AppSize.w32.w,
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                    onpress: () {
                                      setState(() {
                                        saturday = !saturday;
                                      });
                                    },
                                    ButtonText: "Saturday",
                                    isselected: saturday),
                              ),
                              Padding(
                                padding:   EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                    onpress: () {
                                      setState(() {
                                        sunday = !sunday;
                                      });
                                    },
                                    ButtonText: "Sunday",
                                    isselected: sunday),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                    onpress: () {
                                      setState(() {
                                        monday = !monday;
                                      });
                                    },
                                    ButtonText: "Monday",
                                    isselected: monday),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                    onpress: () {
                                      setState(() {
                                        tuesday = !tuesday;
                                      });
                                    },
                                    ButtonText: "Tuesday",
                                    isselected: tuesday),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                    onpress: () {
                                      setState(() {
                                        wednesday = !wednesday;
                                      });
                                    },
                                    ButtonText: "Wednesday",
                                    isselected: wednesday),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                    onpress: () {
                                      setState(() {
                                        thursday = !thursday;
                                      });
                                    },
                                    ButtonText: "Thursday",
                                    isselected: thursday),
                              ),
                              Padding(
                                padding:EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                    onpress: () {
                                      setState(() {
                                        friday = !friday;
                                      });
                                    },
                                    ButtonText: "Friday",
                                    isselected: friday),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSize.h10_6.h),
                                child: dayButton2(
                                  BorderSideColor: AppColors.grey3,
                                    textColor: AppColors.grey3,
                                    onpress: () {
                                      setState(() {
                                        everyday = !everyday;
                                      });
                                    },
                                    ButtonText: "Everyday",
                                    isselected: everyday),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppSize.h21_3.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/icon/Group 3643 2.png",
                                width: AppSize.h25_3.r,
                                height: AppSize.h25_3.r,
                              ),
                              SizedBox(width: AppSize.w21_3.w,),
                              Text(
                                getTranslated(context, "from"),
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontFamily: getTranslated(
                                        context, "Montserratmedium"),
                                    fontSize: AppFontsSizeManager.s21_3.sp),
                              ),
                              SizedBox(width: AppSize.w10_6.w,),
                              dayButton2(
                                textColor: AppColors.pink2,
                                  BorderSideColor:AppColors.gold,
                                  width: AppSize.w116.w,
                                  onpress: () {
                                    _selectTimeFrom(context);
                                  },
                                  ButtonText: fromtext!,
                                  isselected: false),
                              SizedBox(width: AppSize.w21_3.w,),
                              Text(

                                getTranslated(context, "to"),
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontFamily: getTranslated(
                                        context, "Montserratmedium"),
                                    fontSize: AppFontsSizeManager.s21_3.sp),
                              ),
                              SizedBox(width: AppSize.w10_6.w,),
                              dayButton2(textColor: AppColors.pink2,
                                  BorderSideColor:AppColors.gold,
                                  width: AppSize.w116.w,
                                  onpress: () {
                                    _selectTimeTo(context);
                                  },
                                  ButtonText: totext!,
                                  isselected: false),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      InkWell(
                        onTap: () {
                          showDeleteConfimationDialog(size);
                          setState(() {
                          });
                        },

                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AssetsManager.outlineDeleteIconPath,
                              width: AppSize.h32.r,
                              height:AppSize.h32.r,
                            ),
                               SizedBox(width: AppSize.w10_6,),
                               Text(
                               "Delete account",
                               style: TextStyle(
                               fontFamily: getTranslated(context, "Montserratmedium"),
                               fontSize: AppFontsSizeManager.s21_3.sp,
                               color: Color.fromRGBO(32, 32, 32, 1.0),
                               letterSpacing: -0.2,
                               ),
                               textAlign: TextAlign.center,
                               )

                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h42_6.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: AppSize.w446_6.w,
                            height: AppSize.h66_6.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              color: AppColors.pink2
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                if(from==null||to==null||(english==false&&arabic==false))
                                  Fluttertoast.showToast(
                                      msg: getTranslated(context, "required"),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  else
                                save();
                              },
                              child: Text(
                                getTranslated(context, "saveAndContinue"),
                                style: TextStyle(
                                  fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                                  color: Colors.white,
                                  fontSize: AppFontsSizeManager.s21_3.sp,
                                  fontWeight: FontWeight.w600,
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

              ],),
          ),
        ],
      ),
    );
  }
  Widget getTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: AppFontsSizeManager.s21_3.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          fontFamily: getTranslated(context, "Montserratsemibold"),
          color: AppColors.pink2,),
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
if (mounted) {
       daysValue=[];
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
}
    if (_formKey.currentState!.validate()&&querySnapshot.docs.length == 0&&daysValue.length>0&&
      (selectedProfileImage != null||(widget.user.photoUrl!=null&&widget.user.photoUrl!.isNotEmpty))&&
      (from!=null&&to!=null&&int.parse(to!)>int.parse(from!))) {
      _formKey.currentState!.save();
      try{
        List<String>splitList=widget.user.name!.split(" ");
        List<String>indexList=[];
        for(int i=0;i<splitList.length;i++)
        {
          for(int y=1;y<splitList[i].length;y++)
          {
            indexList.add(splitList[i].substring(0,y).toLowerCase());
          }
        }
        print(indexList);
        widget.user.searchIndex=indexList;
        widget.user.profileCompleted=true;
           widget.user.phoneNumber = phoneNumber.phoneNumber;
          widget.user.countryCode = phoneNumber.dialCode;
          widget.user.countryISOCode = phoneNumber.isoCode;
        widget.user.userLang=getTranslated(context, 'lang');
        //work days and time
        print("coach0");
        var datenow = DateTime.now();
        widget.user.fromUtc = DateTime(
            datenow.year, datenow.month, datenow.day, int.parse(from!), 0, 0)
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
        widget.user.languages!.clear();
        if(english)
          widget.user.languages!.add("english");
        if(arabic)
          widget.user.languages!.add("arabic");
        _workTime.from = from;
        _workTime.to = to;

        widget.user.workTimes!.clear();
        widget.user.workTimes!.add(_workTime);
        setState(() {
          dataSave=true;
        });
        if (selectedProfileImage != null) {
          accountBloc.add(UpdateAccountDetailsEvent(
              user: widget.user, profileImage: selectedProfileImage));
        } else {
          accountBloc.add(UpdateAccountDetailsEvent(user: widget.user));
        }

      }catch(e)
      {print("rrrrrrrrrr"+e.toString());}
    }
   else{
        if(_formKey.currentState!.validate()==false){
             showSnack(getTranslated(context, "allRequired"), context,false);

        }
      else if (querySnapshot.docs.length > 0) {
      print("3");
       showSnack(getTranslated(context, "phoneUsed"), context,false);
      }
        else if(daysValue.length==0)
         showSnack(getTranslated(context, "workDaysRequired"), context,false);
          else if(from==null||to==null||int.parse(from!)>int.parse(to!))
         showSnack(getTranslated(context, "invalidWorkTime"), context,false);
          else if (selectedProfileImage == null&&(widget.user.photoUrl==null||widget.user.photoUrl!.isEmpty))
         showSnack(getTranslated(context, "identityPhotoRequired"), context,false);
         else
          showSnack(getTranslated(context, "allRequired"), context,false);
      }
  }
  Widget dayButton({
    required VoidCallback onpress,
    required String ButtonText,
    required bool isselected,
    width,
    BorderSideColor,
    textColor,
  }) {
    return OutlinedButton(
      onPressed: onpress,
      child: Container(
        width: width ?? AppSize.w185_3.w,
        child: Center(
          child: Text(
            ButtonText,
            style: TextStyle(
              color: textColor ?? (isselected ? AppColors.pink2 : AppColors.black),
              fontFamily: getTranslated(context, "Montserratmedium"),
              fontSize: AppFontsSizeManager.s21_3.sp,
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
        ),
        maximumSize: Size(width ?? AppSize.w185_3.w, AppSize.h52.h),
        side: BorderSide(
          color: BorderSideColor ?? (isselected ? AppColors.pink2 : AppColors.time),
        ),
      ),
    );
  }
  Widget dayButton2({
    required VoidCallback onpress,
    required String ButtonText,
    required bool isselected,
    width,
    BorderSideColor,
    textColor,
  }) {
    return InkWell(
      onTap: onpress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(color:isselected ? Colors.transparent : AppColors.time,

          border: Border.all(
            color: BorderSideColor ?? (isselected ? AppColors.pink2 : AppColors.time),
          ),
          borderRadius: BorderRadius.circular(AppRadius.r5_3.r),),
        width: width ?? AppSize.w185_3.w,
        child: Center(
          child: Text(
            ButtonText,
            style: TextStyle(
              color: textColor ?? (isselected ? AppColors.pink2 : AppColors.black),
              fontFamily: getTranslated(context, "Montserratmedium"),
              fontSize: AppFontsSizeManager.s21_3.sp,
            ),
          ),
        ),
      ),
    );
  }
  Widget langButton({
    required VoidCallback onpress,
    required String ButtonText,
    required bool isselected,
    width,
    BorderSideColor,
    textColor,
  }) {
    return OutlinedButton(
      onPressed: onpress,
      child: Container(

        width: width ?? AppSize.w185_3.w,
        child: Center(
          child: Text(
            ButtonText,
            style: TextStyle(
              color: textColor ?? (isselected ? AppColors.pink2 : AppColors.black),
              fontFamily: getTranslated(context, "Montserratmedium"),
              fontSize: AppFontsSizeManager.s21_3.sp,
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor:isselected ? Colors.transparent : AppColors.time,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
        ),
        maximumSize: Size(width ?? AppSize.w185_3.w, AppSize.h52.h),
        side: BorderSide(
          color: BorderSideColor ?? (isselected ? AppColors.pink2 : AppColors.time),
        ),
      ),
    );
  }
  Widget langButton2({
    required VoidCallback onpress,
    required String ButtonText,
    required bool isselected,
    width,
    BorderSideColor,
    textColor,
  }) {
    return InkWell(
      onTap: onpress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(color:isselected ? Colors.transparent : AppColors.time,

          border: Border.all(
            color: BorderSideColor ?? (isselected ? AppColors.pink2 : AppColors.time),
          ),
          borderRadius: BorderRadius.circular(AppRadius.r5_3.r),),
        width: width ?? AppSize.w185_3.w,
        child: Center(
          child: Text(
            ButtonText,
            style: TextStyle(
              color: textColor ?? (isselected ? AppColors.pink2 : AppColors.black),
              fontFamily: getTranslated(context, "Montserratmedium"),
              fontSize: AppFontsSizeManager.s21_3.sp,
            ),
          ),
        ),
      ),
    );
  }

  _selectTimeFrom(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _workTime.from == null
          ? selectedTime
          : TimeOfDay(
          hour: int.parse(widget.user.workTimes![0].from.toString()), minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        from = timeOfDay.hour.toString();
        if (timeOfDay.hour == 12)
          fromtext = "12 PM";
        else if (timeOfDay.hour == 0)
          fromtext = "12 Am";
        else if (timeOfDay.hour > 12)
          fromtext = (timeOfDay.hour - 12).toString() + " PM";
        else
          fromtext = timeOfDay.hour.toString() + " AM";
      });
    }
  }

  _selectTimeTo(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _workTime.to == null
          ? selectedTime
          : TimeOfDay(hour: int.parse(widget.user.workTimes![0].to.toString()), minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        to = timeOfDay.hour.toString();
        if (timeOfDay.hour == 12)
          totext = "12 PM";
        else if (timeOfDay.hour == 0)
          totext = "12 Am";
        else if (timeOfDay.hour > 12)
          totext = (timeOfDay.hour - 12).toString() + " PM";
        else
          totext = timeOfDay.hour.toString() + " AM";
      });
    }
  }
  BoxShadow shadow(){return
    BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(
          0.0, 1.0), // shadow direction: bottom right
    );}
}
