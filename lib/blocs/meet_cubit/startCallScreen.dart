import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';
import 'package:grocery_store/blocs/meet_cubit/review_web_rtc_bloc/review_start_call.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/services/call_services.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Utils/app_shadow.dart';
import '../../config/app_constat.dart';
import '../../config/colorsFile.dart';
import '../../config/paths.dart';
import '../../localization/localization_methods.dart';
import '../../methodes/pt_to_px.dart';
import '../../methodes/show_call_permissions_dialog.dart';
import '../../methodes/show_failed_snackbar.dart';
import '../../models/AppAppointments.dart';
import '../../models/user.dart';
import 'call_cubit/call_cubit.dart';
import 'web_rtc_bloc/start_call.dart';

class startCallScreen extends StatefulWidget {
  @override
  State<startCallScreen> createState() => _startCallScreenState();
}

class _startCallScreenState extends State<startCallScreen> {
  late List<dynamic> data;
  bool callEnded = false;
  GroceryUser? groceryUser;
  initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      'GetActiveCall'.logPrint();
        getActiveCall(context);
    });
    //checkIfTheSenderCanceled();
  }

  /// Get the active call data from CallKit.
  /// end all calls.
  /// join the meeting.
  ///

  getActiveCall(context) async {
    await FlutterCallkitIncoming.activeCalls().then((value) {
      'activeCalls'.logPrint();
      data = value;
      FlutterCallkitIncoming.endAllCalls();
      data.runtimeType.toString().logPrint();
      if ((data as List).isEmpty) {
        CallCubit.get(context).changeCallState(StartCallStates.callEnded);
      } else {
        try {
          data[0] = data.firstWhere((element) => element?.length > 2);
        } catch (e) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          showFailedSnackBar(getTranslated(context, 'retry'));
        }
        'JoinCall'.logPrint();
        joinCall(context);
      }
    });
    // await CallKeep.instance.activeCalls().then((value) async{
    //   data = value[0];
    //   await CallKeep.instance.endAllCalls();
    //   joinCall(context);
    // });
  }

  /// if the user accept permissions for mic, [startCall] will called to :
  /// 1 => change current user state to 'oncall',
  /// 2 => get current user data by uId,
  /// 3 => get appointment data bu appointmentId,
  /// 4 => enter the call.

  startCall(BuildContext context) async {
    // var data = await FlutterCallkitIncoming.activeCalls();
    if (data[0]['extra'] != null) {
      try {
        'startCall'.logPrint();
        FirebaseDatabase.instance
            .ref('userCallState')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .child('callState')
            .set('oncall')
            .then((value) => FirebaseFirestore.instance
                    .collection(Paths.usersPath)
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then(
                  (user) {
                    if (!isInterviewCall()) {
                      return FirebaseFirestore.instance
                          .collection(Paths.appAppointments)
                          .doc(data[0]['extra']['appointmentId'])
                          .get()
                          .then((appointment) {
                        /// detect the call type and navigate to call screen.
                        AppAppointments appAppointment =
                            AppAppointments.fromMap(
                                appointment.data() as Map<dynamic, dynamic>);
                        groceryUser = GroceryUser.fromMap(
                            user.data() as Map<dynamic, dynamic>);
                        detectCallTypeAndNavigateToCall(
                            appointment: appAppointment,
                            user: groceryUser!,
                            data: data);
                      });
                    } else {
                      groceryUser = GroceryUser.fromMap(
                          user.data() as Map<dynamic, dynamic>);
                      detectCallTypeAndNavigateToCall(
                          user: groceryUser!, data: data);
                    }
                  },
                ));
      } catch (e) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        showFailedSnackBar(getTranslated(context, 'retry'));
        CallCubit.get(context).changeCallState(StartCallStates.callEnded);
      }
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      showFailedSnackBar(getTranslated(context, 'retry'));
      CallCubit.get(context).changeCallState(StartCallStates.callEnded);
    }
  }

  /// when the user enter to the call:
  /// => request permissions of mic from him.
  /// => if the permissions if granted, call [startCall] method to go direct to the call,
  /// => if denied, change callState in bloc to permissionNotAllowed, to rebuild the screen and show joinCall button.
  /// => if he denied multiple times, show the dialog to him to go to the settings to accept permissions.

  void joinCall(BuildContext context) async {
    await Permission.microphone.request().then((value) {
      if (value.isGranted == true) {
        startCall(context);
      } else if (value.isDenied == true) {
        CallCubit.get(context)
            .changeCallState(StartCallStates.permissionsNotAllowed);
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
        CallCubit.get(context)
            .changeCallState(StartCallStates.permissionsNotAllowed);
      }
    });
  }

  void onCanceledFunction() {
    'OnCanceled Function'.logPrint();
    // pop twice
    FlutterCallkitIncoming.endAllCalls();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    showUnExpectedErrorDialog(data[0]['extra']['callerName'] ?? '');
  }

  /// detect the call type and navigate to call screen.
  detectCallTypeAndNavigateToCall(
      {required var data,
      required GroceryUser user,
      AppAppointments? appointment}) async {
    GroceryUser? caller = await CallServices.getUserFromFirebase(
        userId: data[0]['extra']['callerId']);
    if (isInterviewCall() == false) {
      Future(() => StartCall(
            host: data[0]['extra']['appointmentId'],
            iscaller: false,
            isVideo: true,
            appointment: appointment,
            loggedUser: user,
            anotherSideUser: caller,
            normalCall: false,
            CallerId: data[0]['extra']['callerId'],
            ReciverId: FirebaseAuth.instance.currentUser!.uid,
            context: context,
            onCanceledFunction: onCanceledFunction,
          ).startCall());
    } else {
      Future(() => ReviewStartCall(
            host: data[0]['extra']['appointmentId'],
            iscaller: false,
            isVideo: true,
            loggedUser: user,
            normalCall: false,
            CallerId: data[0]['extra']['callerId'],
            ReciverId: FirebaseAuth.instance.currentUser!.uid,
            context: context,
            onCanceledFunction: onCanceledFunction,
          ).startCall());
    }
  }

  bool isInterviewCall() {
    return data[0]['extra']['appointmentId'] == AppConstants.inteview;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColors.pink,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// app logo
          Container(
              height: AppSize.h70,
              width: AppSize.w70,
              decoration: BoxDecoration(
                boxShadow: [AppShadow.primaryShadow],
                color: AppColors.white,
                border: Border.all(
                  width: AppSize.w6,
                  color: AppColors.white,
                ),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AssetsManager.mask_groupImagePath,
                color: AppColors.pink2,
                width: convertPtToPx(AppSize.w40_6.w),
                height: convertPtToPx(AppSize.h39.h),
              )),
          SizedBox(
            height: size.height * AppSize.h0_15,
          ),

          /// check for state of the call:
          /// if loading => load page.
          /// if the permission is disallowed => show joinCall button to open permission dialog, then enter call.
          /// if inCall => show (you are in the call now) page.
          /// if callEnded => show (ok) button to go to home.

          BlocConsumer<CallCubit, CallStates>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (context.read<CallCubit>().callState) {
                case StartCallStates.loading:
                  return Column(
                    children: [
                      loadingWidget(),
                      SizedBox(
                        height: (size.height * .15) + 40,
                      ),
                    ],
                  );

                case StartCallStates.inCall:
                  return Column(
                    children: [
                      Center(
                          child: text(
                              getTranslated(context, 'userInCallNow'),
                              13,
                              Color.fromRGBO(32, 32, 32, 1),
                              FontWeight.w500)),
                      SizedBox(
                        height: (size.height * .15) + 40,
                      ),
                    ],
                  );

                case StartCallStates.permissionsNotAllowed:
                  return Column(
                    children: [
                      loadingWidget(),
                      SizedBox(
                        height: size.height * .15,
                      ),
                      Center(
                          child: buttonWidget(
                              context: context,
                              buttonText: getTranslated(context, 'joinCall'),
                              function: () {
                                joinCall(context);
                              })),
                    ],
                  );

                case StartCallStates.callEnded:
                  return Column(
                    children: [
                      Center(
                          child: text(getTranslated(context, 'userClose'), 13,
                              Color.fromRGBO(32, 32, 32, 1), FontWeight.w500)),
                      SizedBox(
                        height: size.height * .15,
                      ),
                      if (groceryUser?.userType == AppConstants.consultant ||
                          groceryUser?.userType == AppConstants.user ||
                          groceryUser?.userType == AppConstants.clientAnonymous)
                        Center(
                            child: buttonWidget(
                                context: context,
                                buttonText: getTranslated(context, 'Ok'),
                                function: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/home', (route) => false);
                                })),
                    ],
                  );
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> showUnExpectedErrorDialog(String name) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16.sp), // Set border radius here
            ),
            surfaceTintColor: AppColors.white,
            alignment: Alignment.topCenter,
            backgroundColor: AppColors.white,
            contentPadding: EdgeInsets.all(24.w),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call_end_rounded,
                          size: 36.w,
                          color: AppColors.red1,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          getTranslated(context, "callEnded2"),
                          style: TextStyle(
                            fontFamily: getTranslated(
                                context, "Ithra"), // 'Montserrat',
                            fontSize: 20,
                            color: AppColors.red1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: getTranslated(context, "callEndedWithError"),
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "Ithra"), // 'Montserrat',
                          fontSize: 14,
                          color: AppColors.black1,
                        ),
                      ),
                      TextSpan(
                        text: " $name ",
                        style: TextStyle(
                          fontFamily:
                              getTranslated(context, "Ithra"), // 'Montserrat',
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ]))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget loadingWidget() => Center(
        child: Lottie.asset(
          'assets/lotifile/loading.json',
        ),
      );

  Widget text(String text, double size, Color color, FontWeight weight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "Ithra", // 'Montserrat',
          fontSize: size,
          color: color,
          fontWeight: weight),
    );
  }

  Widget buttonWidget(
      {context, required String buttonText, required Function function}) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        height: AppSize.h40,
        width: AppSize.w200,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(AppRadius.r20),
        ),
        child: Center(
          child: text(buttonText, 15, AppColors.white, FontWeight.w300),
        ),
      ),
    );
  }
}
