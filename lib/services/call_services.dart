import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';
import 'package:grocery_store/blocs/meet_cubit/jitsi_service/review_meet_service.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import 'package:grocery_store/models/user.dart';
import 'package:permission_handler/permission_handler.dart';

import '../blocs/meet_cubit/jitsi_meet_rining_screeen.dart';
import '../blocs/meet_cubit/jitsi_service/meet_service_impl.dart';
import '../blocs/meet_cubit/meet_cubit.dart';
import '../blocs/meet_cubit/web_rtc_bloc/start_call.dart';

import '../config/app_constat.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../methodes/change_user_call_state.dart';
import '../methodes/pt_to_px.dart';
import '../methodes/show_call_permissions_dialog.dart';

import '../models/AppAppointments.dart';
import '../models/meet_model.dart';

abstract class CallServices {
  /// refused the incoming calls.
  static Future<void> refuseCall({
    required bool withNavigatorBack,
    required String state,
    BuildContext? context,
    required String callerId,
  }) async {
    // CallKeep.instance.endAllCalls().then((value) {
    ///================== change caller and user state to refused, then show dialog to current user contains (refused) ================///

    changeUserState(userId: callerId, state: state);
    changeUserState(
        userId: FirebaseAuth.instance.currentUser!.uid, state: state);

    if (context != null)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.white,
          content: Container(
            //height: 200,
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.pink,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              getTranslated(context, 'userRefuse'),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: getTranslated(context, "Ithra"),
                color: AppColors.white,
                fontSize: convertPtToPx(13.sp),
              ),
            ),
          ),
        ),
      );
  }
  // }

  /// get permissions from user, if permissions in denied,
  /// display dialog to user to request permissions,
  /// if permissions in granted, navigate to [JitsiMeetRiningScreen] via [webRtcCall] method.
  static Future<void> startJisiCall({
    required BuildContext context,
    required GroceryUser loggedUser,
    required AppAppointments appointment,
    required String receiverId,
  }) async {
    Permission.microphone.request().then((value) {
      if (value.isGranted == true) {
        var (String callerId, String receiverId) =
        getCallerAndReceiver(appointment!, loggedUser);
        webRtcCall(
            context: context,
            appointment: appointment,
            loggedUser: loggedUser,
            receiverId: receiverId);
      } else if (value.isDenied == true) {
        showPermissionsDialog(
          context: context,
          text: getTranslated(context, 'getPermissions'),
          buttonTitle: getTranslated(context, 'allow'),
          function: () {
            Navigator.pop(context);
          },
          refusedFunction: () {
            Navigator.pop(context);
          },
        );
      } else if (value.isPermanentlyDenied == true) {
        showPermissionsDialog(
          context: context,
          text: getTranslated(context, 'getSettings'),
          buttonTitle: getTranslated(context, 'goToSettings'),
          function: () {
            Navigator.pop(context);
            AppSettings.openAppSettings(
              type: AppSettingsType.settings,
            );
          },
          refusedFunction: () {
            Navigator.pop(context);
          },
        );
      }
    });
  }

  static Future<void> startInterviewCall({
    required BuildContext context,
    required GroceryUser loggedUser,
    required String receiverId,
  }) async {
    Permission.microphone.request().then((value) {
      if (value.isGranted == true) {
        Future(() => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (con) => BlocProvider<MeetCubit>(
                    create: (context) => MeetCubit(ReviewJitsiMeetService(
                        MeetModel(
                          AppConstants.inteview,
                          loggedUser: loggedUser,
                          normalCall: false,
                          isVideoCall: false,
                          callerId: FirebaseAuth.instance.currentUser!.uid,
                          receiverId: receiverId,
                          appointmentId: AppConstants.inteview,
                          iscaller: true,
                        ),
                        context)),
                    child: JitsiMeetRiningScreen())),
            (predict) => predict.isCurrent ? false : true));
      } else if (value.isDenied == true) {
        showPermissionsDialog(
          context: context,
          text: getTranslated(context, 'getPermissions'),
          buttonTitle: getTranslated(context, 'allow'),
          function: () {
            Navigator.pop(context);
          },
          refusedFunction: () {
            Navigator.pop(context);
          },
        );
      } else if (value.isPermanentlyDenied == true) {
        showPermissionsDialog(
          context: context,
          text: getTranslated(context, 'getSettings'),
          buttonTitle: getTranslated(context, 'goToSettings'),
          function: () {
            Navigator.pop(context);
            AppSettings.openAppSettings(
              type: AppSettingsType.settings,
            );
          },
          refusedFunction: () {
            Navigator.pop(context);
          },
        );
      }
    });
  }

  static Future<void> webRtcCall({
    required BuildContext context,
    required GroceryUser loggedUser,
    AppAppointments? appointment,
    required String receiverId,
  }) async {
    try {

      FirebaseAuth.instance.currentUser!.uid.toString().logPrint();
      Future(() => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (con) => BlocProvider<MeetCubit>(
                  create: (context) => MeetCubit(JitsiMeetService(
                      MeetModel(
                          appointment?.appointmentId ?? AppConstants.inteview,
                          loggedUser: loggedUser,
                          normalCall: false,
                          isVideoCall: false,
                          callerId: FirebaseAuth.instance.currentUser!.uid,
                          receiverId: receiverId,
                          appointmentId: appointment?.appointmentId ??
                              AppConstants.inteview,
                          iscaller: true,
                          appointment: appointment),
                      context)),
                  child: JitsiMeetRiningScreen())),
          (predict) => predict.isCurrent ? false : true));
    } catch (e) {}
  }

  static Future<GroceryUser?> getUserFromFirebase(
      {required String userId}) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(userId)
        .get();
    return GroceryUser.fromMap(snapshot.data() as Map<dynamic, dynamic>);
  }
  static (String caller, String receiver) getCallerAndReceiver(
      AppAppointments appointment, GroceryUser loggedUser) {
    if (loggedUser.uid == appointment.consult.uid) {
      return (appointment.consult.uid, appointment.user!.uid);
    } else {
      return (appointment.user!.uid, appointment.consult.uid);
    }
  }
}
