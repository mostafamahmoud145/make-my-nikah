
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/AppointmentChatScreen.dart';
import 'package:grocery_store/screens/interviewVideoCallScreen.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_voice/twilio_voice.dart';

import '../blocs/meet_cubit/jitsi_meet_rining_screeen.dart';
import '../blocs/meet_cubit/jitsi_service/meet_service_impl.dart';
import '../blocs/meet_cubit/meet_cubit.dart';
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../models/meet_model.dart';
import '../screens/beautVideoCallScreen.dart';
import '../screens/twCallScreen.dart';
import '../services/call_services.dart';

class AppointmentWiget extends StatefulWidget {
  final GroceryUser loggedUser;
  final AppAppointments appointment;
  final String? theme;
  final bool? woman;


  AppointmentWiget(
      {required this.appointment, required this.loggedUser, this.theme,this.woman=false});

  @override
  _AppointmentWigetState createState() => _AppointmentWigetState();
}

class _AppointmentWigetState extends State<AppointmentWiget>
    with SingleTickerProviderStateMixin {
  bool acceptLoad = false, loadingCall = false;
  String  lang ='';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lang  = getTranslated(context, "lang");
    Size size = MediaQuery.of(context).size;
    String time;
    DateFormat dateFormat = DateFormat('yyyy MMM dd');
    DateTime localDate;
    bool load = false;
    if (widget.appointment.utcTime != null)
      localDate = DateTime.parse(widget.appointment.utcTime).toLocal();
    else
      localDate = DateTime.parse(
              widget.appointment.appointmentTimestamp.toDate().toString())
          .toLocal();
    if (localDate.hour == 12)
      time = "12:00Pm";
    else if (localDate.hour == 0)
      time = "12:00Am";
    else if (localDate.hour > 12)
      time = localDate.minute.toString()=="0"? (localDate.hour - 12).toString() +
          ":0" +
          localDate.minute.toString() +
          "Pm":(localDate.hour - 12).toString() +
          ":" +
          localDate.minute.toString() +
          "Pm";
    else
      time =localDate.minute.toString()=="0"? (localDate.hour).toString() +
          ":0" +
          localDate.minute.toString() +
          "Am":(localDate.hour).toString() +
          ":" +
          localDate.minute.toString() +
          "Am";

    return Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.r21_3.r),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(32, 32, 32, 0.05),
              blurRadius: 12.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 5.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: AppSize.h26_6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              lang == "ar" ?

                SvgPicture.asset(
                  AssetsManager.redHeader2IconPath,
                  width: convertPtToPx(AppSize.w9_5.w),
                  height: convertPtToPx(AppSize.h15_3.h),
                )
              :  SvgPicture.asset(
                  AssetsManager.redHeader1IconPath,
                  width: convertPtToPx(AppSize.w9_5.w),
                  height: convertPtToPx(AppSize.h15_3.h),
                ),
                SizedBox(
                  width: AppSize.w6.w,
                ),
                Text(
                  widget.woman==true
                  ? widget.appointment.consult.name != null
                      ? widget.appointment.consult.name
                      : widget.appointment.consult.phone
                  : widget.appointment.user.name != null
                      ? widget.appointment.user.name
                      : widget.appointment.user.phone,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    color: AppColors.black,
                    fontSize: AppFontsSizeManager.s21_3.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: AppSize.w6.w,
                ),
                lang == "ar" ? SvgPicture.asset(
                  AssetsManager.redHeader1IconPath,
                  width: convertPtToPx(AppSize.w9_5.w),
                  height: convertPtToPx(AppSize.h15_3.h),
                ):   SvgPicture.asset(
                  AssetsManager.redHeader2IconPath,
                  width: convertPtToPx(AppSize.w9_5.w),
                  height: convertPtToPx(AppSize.h15_3.h),
                ),
              ],
            ),
            SizedBox(
              height: AppSize.h26_6.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p26_5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.greyCalenderIconPath,
                            width: convertPtToPx(AppSize.w12.w),
                            height: convertPtToPx(AppSize.h12.h),
                          ),
                          SizedBox(
                            width: AppSize.w6.w,
                          ),
                          Text(
                            '${dateFormat.format(localDate)}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserrat"),
                              color: AppColors.grey3,
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s12.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppSize.h10_6.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.greyClock2IconPath,
                            width: convertPtToPx(AppSize.w12.w),
                            height: convertPtToPx(AppSize.h12.h),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            time,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserrat"),
                              color: AppColors.grey3,
                              fontSize:
                                  convertPtToPx(AppFontsSizeManager.s12.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        widget.appointment.appointmentStatus == "open"
                            ? AssetsManager.roundDoneIconPath
                            : AssetsManager.roundCloseIconPath,
                        width: AppSize.w21_3.w,
                        height: AppSize.h21_3.h,
                      ),
                      SizedBox(
                        height: AppSize.h10_6.h,
                      ),
                      Text(
                        getTranslated(context, 'callStatus'),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "Montserratmedium"),
                          color: AppColors.grey3,
                          fontSize: convertPtToPx(AppFontsSizeManager.s12.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: convertPtToPx(AppSize.h17.h),
            ),
            Container(
              height: AppSize.h1.h,
              width: size.width,
              color: AppColors.lightGray,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: AppPadding.p18_6.h, bottom: AppPadding.p20.h),
                  child: messageWidget(size, context),
                ),
                Container(
                  height: AppSize.h81.h,
                  width: AppSize.w1.w,
                  color: AppColors.lightGray,
                ),
                Container(
                  width: AppSize.w224.w,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: AppPadding.p18_6.h, bottom: AppPadding.p20.h),
                    child: IconButton1(
                      onPress: () async {
                        setState(() {
                          loadingCall = true;
                        });
                        call();
                      },
                      Width: AppSize.w42_6.w,
                      Height: AppSize.h42_6.h,
                      ButtonBackground: Color.fromRGBO(18, 223, 95, 1),
                      BoxShape1: BoxShape.circle,
                      Icon: AssetsManager.phoneCall.toString(),
                      IconWidth: AppSize.w26_6.w,
                      IconHeight: AppSize.h26_6.h,
                      IconColor: AppColors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget messageWidget(Size size, BuildContext context) {
    return Container(
      width: AppSize.w232.w,
      child: IconButton1(
        onPress: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentChatScreen(
                  appointment: widget.appointment, user: widget.loggedUser),
            ),
          );
        },
        Width: AppSize.w42_6.w,
        Height: AppSize.h42_6.h,
        ButtonBackground: Color.fromRGBO(207, 0, 54, 0.05),
        BoxShape1: BoxShape.circle,
        Icon: AssetsManager.chat2IconPath.toString(),
        IconWidth: AppSize.w26_6.w,
        IconHeight: AppSize.h26_6.h,
        IconColor: Color.fromRGBO(207, 0, 54, 1),
      ),
    );
  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(AppMargin.m8),
      borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r7.r)),
      backgroundColor: Colors.red.shade400,
      animationDuration: Duration(milliseconds: AppConstants.milliseconds300),
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
      duration: Duration(milliseconds: AppConstants.milliseconds2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  call() async {
      setState(() {
        loadingCall = true;
      });
      await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId).set({
        'allowCall': true,
      }, SetOptions(merge: true));
      CallServices.startJisiCall(
          appointment: widget.appointment,
          loggedUser:widget.loggedUser,
          context: context,
          receiverId: widget.appointment.user.uid);
      setState(() {
        loadingCall = false;
      });
    }
  Future<void> sendCallNotification(String consultName,String userId,String appointmentId,String roomId) async {
    try{
      print("sendnot111");
      Map notifMap = Map();
      notifMap.putIfAbsent('consultName', () => consultName);
      notifMap.putIfAbsent('userId', () => userId);
      notifMap.putIfAbsent('appointmentId', () => appointmentId);
      notifMap.putIfAbsent('type', () => widget.appointment.consultType);
      notifMap.putIfAbsent('roomId', () => roomId);
      var refundRes= await http.post( Uri.parse('https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendCallNotification'),
        body: notifMap,
      );
      /*   print("sendnot11122");
      var refund = jsonDecode(refundRes.body);
      if (refund['message'] != 'Success') {
        print("sendnotification111  error");
      }
      else
      { print("sendnotification1111 success");}*/
    }catch(e){
      print("sendnotification111  "+e.toString());
    }


  }

}
