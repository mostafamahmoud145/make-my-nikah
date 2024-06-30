import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';
import 'package:grocery_store/blocs/meet_cubit/review_web_rtc_bloc/review_end_dialog.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/services/call_services.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import '../../../Utils/network_manager.dart';
import '../../../config/app_constat.dart';
import '../../../config/colorsFile.dart';
import '../../../localization/localization_methods.dart';
import '../../../methodes/change_user_call_state.dart';
import '../../../methodes/stop_foreground_service.dart';
import '../call_cubit/call_cubit.dart';

class ReviewStartCall {
  ReviewStartCall(
      {required this.host,
      required this.context,
      this.iscaller,
      this.acceptNotfi,
      this.loggedUser,
      this.isVideo,
      this.normalCall,
      this.CallerId,
      this.ReciverId,
      this.fromChatScreen = false,
      this.onEndFunction,
      this.onCanceledFunction});
  Function? onEndFunction;
  Function? onCanceledFunction;
  final String host;
  bool? iscaller = false;
  bool? acceptNotfi = false;
  GroceryUser? loggedUser;
  GroceryUser? anotherSideUser;
  String? CallerId = "";
  String? ReciverId = "";
  bool? isVideo = true;
  bool? normalCall = true;
  String? _reciverId = '';
  GroceryUser? peerInfo;
  BuildContext context;
  Timer? _timer;
  bool fromChatScreen = false;
  bool isHangupBefore = false;
  bool isUserCanceled = false;
  bool isConferenceJoined = false;
  bool isConferenceWilljoin = false;
  Future startCall() async {
    if (CallerId == FirebaseAuth.instance.currentUser!.uid) {
      _reciverId = CallerId;
    } else {
      _reciverId = ReciverId;
    }
    anotherSideUser =
        await CallServices.getUserFromFirebase(userId: ReciverId!);
    Map<String, Object> featureFlags = {};
    Map<String, Object> configOverrides = {};
    var ref = await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(_reciverId)
        .withConverter(
          fromFirestore: GroceryUser.fromFirestore,
          toFirestore: (GroceryUser user, _) => user.toFirestore(),
        );
    final docSnap = await ref.get();
    peerInfo = await docSnap.data();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshotServer =
        await FirebaseFirestore.instance
            .collection('servers')
            .doc('settings')
            .get();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshotFeatureFlags =
        await FirebaseFirestore.instance
            .collection('servers')
            .doc('featureFlags')
            .get();
    final DocumentSnapshot<Map<String, dynamic>>
        documentSnapshotConfigOverrides = await FirebaseFirestore.instance
            .collection('servers')
            .doc('configOverrides')
            .get();

    documentSnapshotFeatureFlags.data()!.forEach((key, value) {
      featureFlags[key] = value;
    });

    documentSnapshotConfigOverrides.data()!.forEach((key, value) {
      configOverrides[key] = value;
    });
    //isAudioOnly  will be toggled
    // FeatureFlag will be toggled video-mute.enabled:false
    var options = JitsiMeetingOptions(
      roomNameOrUrl: CallerId!,
      serverUrl: documentSnapshotServer.data()!["jitsiServer"],
      subject: peerInfo!.name,
      token: documentSnapshotServer.data()!["jitsiToken"],
      isAudioMuted: false,
      isAudioOnly: true,
      isVideoMuted: false,
      userDisplayName: peerInfo!.name,
      userEmail: '',
      featureFlags: featureFlags,
      userAvatarUrl: NetworkManager.appLogo,
      configOverrides: configOverrides,
    );
    "JitsiMeetingOptions: $options".logPrint();

    try {
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () {
            'on opened'.logPrint();
          },
          onConferenceWillJoin: (url) {
            if (isConferenceWilljoin == false) {
              'onConference Will Join'.logPrint();
              if (!fromChatScreen) {
                checkCallerState();
              }
              isConferenceWilljoin = true;
            }
          },
          onConferenceJoined: (url) {
            if (isConferenceJoined == false) {
              'INF: onConferenceJoined'.logPrint();
              if (!fromChatScreen) {
                checkCallerState();
                changeReceiverState(StartCallStates.inCall);
              }
              isConferenceJoined = true;
            }
          },
          onConferenceTerminated: (url, error) {
            'ERROR: OnConferenceTerminated ${error.toString()}'.logPrint();
          },
          onAudioMutedChanged: (isMuted) {},
          onVideoMutedChanged: (isMuted) {},
          onScreenShareToggled: (participantId, isSharing) {},
          onParticipantJoined: (email, name, role, participantId) {
            'onParticipantJoined  Joined'.logPrint();
            startTimer();
          },
          onParticipantLeft: (participantId) {
            'onParticipantLeft'.logPrint();
            JitsiMeetWrapper.hangUp();
            if (fromChatScreen) {
              _hangUpChatMeeting();
            } else {
              _hangUp();
            }
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {},
          onChatMessageReceived: (senderId, message, isPrivate) {},
          onChatToggled: (isOpen) {},
          onClosed: () {
            if (fromChatScreen) {
              _hangUpChatMeeting();
            } else {
              _hangUp();
            }
          },
        ),
      );
    } catch (e) {
      'ERROR: START CALL'.logPrint();
      print(e);
    }
  }

  void startTimer() {
    Duration duration = Duration(minutes: AppConstants.callDurationToEnd);
    _timer = Timer(duration, () {
      JitsiMeetWrapper.hangUp();
      _hangUp();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  _hangUp() {
    if (isHangupBefore == false) {
      isHangupBefore = true;

      /// This function is passed and executed in on end call if exist
      if (onEndFunction != null) {
        onEndFunction!();
      }

      stopTimer();
      bye();
      if (Platform.isAndroid) {
        stopForegroundService();
      }
      if (!isUserCanceled) {
        // TODO: in the case of calling coach to girl they both will get the EndDialog
        if (loggedUser?.userType == AppConstants.support) {
          confirmEndCallDialog(
            context: context,
            user: anotherSideUser!,
          );
        }
      }
      changeReceiverState(StartCallStates.callEnded);
    }
  }

  /// End call when the current call system is jitsi from chat screen (jitsi as secondary system).
  _hangUpChatMeeting() async {
    if (loggedUser!.userType == AppConstants.support) {
      // show dialog to close the appointment.
      confirmEndCallDialog(
        context: context,
        user: anotherSideUser!,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void bye() {
    changeUserState(userId: CallerId!, state: 'closed');
    changeUserState(userId: ReciverId!, state: 'closed');
  }

  void checkCallerState() async {
    final FirebaseDatabase db = FirebaseDatabase.instance;
    final receiverState = await db
        .ref(Paths.userCallState)
        .child(_reciverId!)
        .child("callState")
        .once();
    final callerState = await db
        .ref(Paths.userCallState)
        .child(CallerId!)
        .child("callState")
        .once();
    // check call exists
    if (receiverState.snapshot.exists && callerState.snapshot.exists) {
      // check call state
      receiverState.snapshot.value.toString().logPrint();
      if (receiverState.snapshot.value == 'closed' ||
              receiverState.snapshot.value == 'refused' ||
              // receiverState.snapshot.value == 'calling' ||
              callerState.snapshot.value == 'closed' ||
              callerState.snapshot.value == 'refused'
          // || callerState.snapshot.value == 'calling'
          ) {
        'HangUp is Processing'.logPrint();

        JitsiMeetWrapper.hangUp();

        _hangUp();
        if (onCanceledFunction != null && !isUserCanceled) {
          onCanceledFunction!();
        }
        isUserCanceled = true;
      }
      //calling
      //refused
    }
  }

  void changeReceiverState(StartCallStates state) {
    try {
      context.read<CallCubit>().changeCallState(state);
    } catch (e) {
      if (e is ProviderNotFoundException) {
        // Handle the scenario where CallCubit is not provided
        // For example, show an error message or navigate to a different screen
        'CallCubit not found in the context'.logPrint();
      } else {
        // Handle other types of exceptions
        'An unexpected error occurred: $e'.logPrint();
      }
    }
  }
}

confirmEndCallDialog({
  required BuildContext context,
  required GroceryUser user,
}) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return ReviewEndCallDialog(
        user: user,
      );
    },
  );
}

Future<void> showUnExpectedErrorDialog(String name, context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16.sp), // Set border radius here
          ),
          alignment: Alignment.topCenter,
          backgroundColor: AppColors.white,
          contentPadding: EdgeInsets.all(24.w),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 24.w,
                      color: AppColors.red1,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      'انتهت المكالمة',
                      style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Ithra"), // 'Montserrat',
                        fontSize: 20,
                        color: AppColors.red1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'تم انهاء المكالمة من قبل ',
                    style: TextStyle(
                      fontFamily:
                          getTranslated(context, "Ithra"), // 'Montserrat',
                      fontSize: 14,
                      color: AppColors.black1, fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: name,
                    style: TextStyle(
                      fontFamily:
                          getTranslated(context, "Ithra"), // 'Montserrat',
                      fontSize: 14,
                      color: AppColors.red1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]))
              ],
            ),
          ),
        );
      });
}
