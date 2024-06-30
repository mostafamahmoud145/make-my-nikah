import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/AppointmentChatScreen.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl/intl.dart';
import '../blocs/meet_cubit/jitsi_meet_rining_screeen.dart';
import '../blocs/meet_cubit/jitsi_service/meet_service_impl.dart';
import '../blocs/meet_cubit/meet_cubit.dart';
import '../config/assets_manager.dart';
import '../methodes/pt_to_px.dart';
import '../models/meet_model.dart';
import 'endCallDialog.dart';

class UserAppointmentWiget extends StatefulWidget {
  final GroceryUser loggedUser;
  final AppAppointments appointment;
  UserAppointmentWiget({required this.appointment, required this.loggedUser});
  @override
  State<UserAppointmentWiget> createState() => _UserAppointmentWigetState();
}

class _UserAppointmentWigetState extends State<UserAppointmentWiget> {
  String lang = "";
  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    var size = MediaQuery.of(context).size;
    String time;
    DateFormat dateFormat = DateFormat('yyyy MMM d');
    DateTime localDate;
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
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black5,
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
         lang=="ar"?    SvgPicture.asset(
                   AssetsManager.redHeader2IconPath,
                   width: AppSize.w12_2.w,
                   height: AppSize.h20_6.h,
                 ):  SvgPicture.asset(
                   AssetsManager.redHeader1IconPath,
                   width: AppSize.w12_2.w,
                   height: AppSize.h20_6.h,
                 ),

                 Padding(

                 padding:  EdgeInsets.only(
                    right:lang=="ar"?widget.appointment.appointmentStatus == "open"?
                    AppPadding.p10.w
                    :AppPadding.p10.w:
                     widget.appointment.appointmentStatus == "open"?
                    AppPadding.p6.w:AppPadding.p0.w,
                    left: AppPadding.p10_6.w
                    ),
                   child: Text(
                     this.widget.appointment.consult.name != null
                         ? this.widget.appointment.consult.name
                         : this.widget.appointment.consult.phone,
                     textAlign: TextAlign.start,
                     overflow: TextOverflow.ellipsis,
                     maxLines: 1,
                     style: TextStyle(
                       fontFamily: getTranslated(context, "Montserratsemibold"),
                       color: AppColors.black,
                       fontSize: AppFontsSizeManager.s21_3.sp,
                     ),
                   ),
                 ),

                lang=="ar"?   SvgPicture.asset(
                   AssetsManager.redHeader1IconPath,
                   width: AppSize.w12_2.w,
                   height: AppSize.h20_6.h,
                 ):SvgPicture.asset(
                   AssetsManager.redHeader2IconPath,
                   width: AppSize.w12_2.w,
                   height: AppSize.h20_6.h,
                 )
               ],
             ),
            SizedBox(height:AppSize.h26_4.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p26_6.w
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.greyCalenderIconPath,
                            width: AppSize.w16.r,
                            height: AppSize.h16.r,
                          ),
                          SizedBox(
                            width: AppSize.w6_6.w,
                          ),
                          Text(
                            '${dateFormat.format(localDate)}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Montserratmedium"),
                              color: AppColors.grey3,
                              fontSize: AppFontsSizeManager.s16.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.h13_4.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetsManager.alarmIcon,
                            width: AppSize.w16.w,
                            height: AppSize.h16.h,
                          ),
                          SizedBox(
                            width: AppSize.w8.w,
                          ),
                          Text(
                            time,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Montserratmedium"),
                              color: AppColors.grey3,
                              fontSize: AppFontsSizeManager.s16.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //pb f
                      widget.appointment.appointmentStatus == "open"?SvgPicture.asset(
                        AssetsManager.roundDoneIconPath,
                        width: AppSize.w21_3.r,
                        height: AppSize.h21_3.r,
                      ):SvgPicture.asset(
                        AssetsManager.roundCloseIconPath,
                        width: AppSize.w21_3.r,
                        height: AppSize.h21_3.r,
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
                          fontFamily: getTranslated(context, "Montserratmedium"),
                          color: AppColors.grey3,
                          fontSize: AppFontsSizeManager.s16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            SizedBox(
              height: convertPtToPx(AppSize.h17_2.h),
            ),
            Container(
              height: AppSize.h1.h,
              width: size.width,
              color: AppColors.lightGray,
            ),

            widget.appointment.appointmentStatus == "open"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /*messageWidget(size, context),*/
                      SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                     height: AppSize.h18_4.h,
                     ),
                          Center(
                          child:   InkWell(
                          onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentChatScreen(
                                        appointment: this.widget.appointment, user: this.widget.loggedUser),
                                  ),
                                );
                          },
                           child: Container(
                                       width: convertPtToPx(AppSize.w32.r),
                                       height: convertPtToPx(AppSize.h32.r),
                                       decoration: BoxDecoration(
                                         color:  AppColors.lightPink2,
                                         shape: BoxShape.circle,
                                       ),
                                       child: Stack(alignment: Alignment.center, children: <Widget>[
                                         SvgPicture.asset(
                                           AssetsManager.chat2IconPath,
                                           width: convertPtToPx(AppSize.w20.r),
                                           height: convertPtToPx(AppSize.h20.r),
                                         ),
                                         SizedBox(
                                           width: convertPtToPx(AppSize.w5.w),
                                         ),
                                         this.widget.appointment.consultChat > 0
                                             ?
                                              Positioned(
                                                left: 2,
                                                 top: 2,
                                                 child: Container(
                                                   height: AppSize.h9_3.r,
                                                   width: AppSize.w9_3.r,
                                                   alignment: Alignment.center,
                                                   decoration: BoxDecoration(
                                                     shape: BoxShape.circle,
                                                     color: Colors.amber,
                                                   ),
                                                 ),
                                               )
                                           : SizedBox()])),
                                                     )

                          ),

                         SizedBox(
                     height: AppSize.h20.h,
                      ),],
                      ),
                      Container(
                        height:AppSize.h80.h,
                        width: AppSize.h1.h,
                        color: Color.fromRGBO(237, 237, 237, 1),
                      ),
                      Container(
                       alignment: Alignment.center,
                        child: Center(
                          child: IconButton1(
                            onPress: () async {
                              Future(() => Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (con) => BlocProvider<MeetCubit>(
                                          create: (context) => MeetCubit(JitsiMeetService(
                                              MeetModel(widget.appointment.appointmentId,
                                                  loggedUser: widget.loggedUser,
                                                  normalCall: false,
                                                  isVideoCall: false,
                                                  callerId: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  receiverId: widget
                                                      .appointment.consult.uid,
                                                  appointmentId: widget
                                                      .appointment
                                                      .appointmentId,
                                                  iscaller: true,
                                                  appointment:
                                                      widget.appointment),
                                              context)),
                                          child: JitsiMeetRiningScreen())),
                                    (predict) => predict.isCurrent ? false : true));
                              //   if (widget.appointment.allowCall) {
                              //     // For Calling Coach
                              //
                              //     Future(() => Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                              //         MaterialPageRoute(
                              //             builder: (con) => BlocProvider<MeetCubit>(
                              //                 create: (context) => MeetCubit(JitsiMeetService(
                              //                     MeetModel(widget.appointment.appointmentId,
                              //                         loggedUser:
                              //                             widget.loggedUser,
                              //                         normalCall: false,
                              //                         isVideoCall: false,
                              //                         callerId: FirebaseAuth
                              //                             .instance
                              //                             .currentUser!
                              //                             .uid,
                              //                         receiverId: widget
                              //                             .appointment
                              //                             .consult
                              //                             .uid,
                              //                         appointmentId: widget
                              //                             .appointment
                              //                             .appointmentId,
                              //                         iscaller: true,
                              //                         appointment: widget.appointment),
                              //                     context)),
                              //                 child: JitsiMeetRiningScreen())),
                              //         (predict) => predict.isCurrent ? false : true));
                              //     // Navigator.of(context, rootNavigator: true).push(
                              //     //     MaterialPageRoute(
                              //     //         fullscreenDialog: true,
                              //     //         builder: (context) =>
                              //     //             BeautVideoCallScreen(
                              //     //               appointment: appointment,
                              //     //               loggedUser: loggedUser,
                              //     //             )));
                              // } else
                              //   Fluttertoast.showToast(
                              //       msg: getTranslated(context, "callNotStart"),
                              //       toastLength: Toast.LENGTH_SHORT,
                              //       gravity: ToastGravity.BOTTOM,
                              //       backgroundColor: Colors.red,
                              //       textColor: Colors.white,
                              //       fontSize: 16.0);
                            },
                            Width: AppSize.w42_6.r,
                          Height: AppSize.h42_6.r,
                          ButtonBackground: AppColors.green2,
                          BoxShape1: BoxShape.circle,
                            Icon: AssetsManager.whiteSmallCallIconPath
                                    .toString(),
                          IconWidth: convertPtToPx(AppSize.w20.r),
                          IconHeight: convertPtToPx(AppSize.w20.r),
                          IconColor: AppColors.white,)
                          ,
                        ),
                      ),
                   SizedBox() ],
                  )
                : Column(
                  children: [
                    SizedBox(
                     height: AppSize.h18_4.h,
                     ),
                    Center(child: messageWidget(size, context)),
                     SizedBox(
                     height: AppSize.h20.h,
                      ),
                  ],
                  ),
          ],
        ));
  }

  Widget messageWidget(Size size, BuildContext context) {
    return Container(

      child: Center(
        child: InkWell(
          splashColor: Colors.green.withOpacity(0.6),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentChatScreen(
                    appointment: this.widget.appointment, user: this.widget.loggedUser),
              ),
            );
          },
          child: Container(
            width: convertPtToPx(AppSize.w32.r),
            height: convertPtToPx(AppSize.h32.r),
            decoration: BoxDecoration(
              color:  AppColors.lightPink2,
              shape: BoxShape.circle,
            ),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              SvgPicture.asset(
                AssetsManager.chat2IconPath,
                width: convertPtToPx(AppSize.w20.r),
                height: convertPtToPx(AppSize.h20.r),
              ),
              SizedBox(
                width: convertPtToPx(AppSize.w5.w),
              ),
              this.widget.appointment.consultChat > 0
                  ?
                   Positioned(
                      child: Container(
                        height: AppSize.h9_3.r,
                        width: AppSize.w9_3.r,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      ),
                    )
                : SizedBox()
            ]),
          ),
        ),
      ),
    );
  }
}
