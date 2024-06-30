import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';
import 'package:grocery_store/blocs/meet_cubit/jitsi_service/meet_service.dart';
import 'package:grocery_store/blocs/meet_cubit/review_web_rtc_bloc/review_start_call.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Utils/exception.dart';
import '../../../config/app_constat.dart';
import '../../../models/meet_model.dart';
import '../../../models/user.dart';
import '../../../services/call_services.dart';
import '../review_web_rtc_bloc/review_check_call_state.dart';
import '../web_rtc_bloc/check_call_state.dart';
import '../web_rtc_bloc/start_call.dart';
import 'meet_service_impl.dart';

class ReviewJitsiMeetService implements MeetService {
  BuildContext context;
  @override
  MeetModel meetDetails;

  ReviewJitsiMeetService(this.meetDetails, this.context);

  @override
  Future<void> requestCallPermissions() async {
    await Permission.microphone.request();
    var micStatus = await Permission.microphone.status;
    if (micStatus.isGranted) {
      checkCallPermissions(
          call_permission.micGranted, call_permission.micGranted);
    } else {
      checkCallPermissions(
          call_permission.micDenied, call_permission.micDenied);
    }
  }

  @override
  void checkCallPermissions(
      call_permission permission1, call_permission permission2) {
    // switch (permission1) {
    //   case call_permission.cameraGranted:
    //     // cameraGranted = true;
    //     break;
    //   case call_permission.micGranted:
    //     // micGranted = true;
    //
    //     break;
    //   case call_permission.cameraDenied:
    //     // cameraGranted = false;
    //     break;
    //   case call_permission.micDenied:
    //     // micGranted = false;
    //     break;
    // }
    //
    // switch (permission2) {
    //   case call_permission.cameraGranted:
    //     // cameraGranted = true;
    //     break;
    //   case call_permission.micGranted:
    //     // micGranted = true;
    //
    //     break;
    //   case call_permission.cameraDenied:
    //     // cameraGranted = false;
    //     break;
    //   case call_permission.micDenied:
    //     // micGranted = false;
    //     break;
    // }

    //   if (micGranted) {

    //checkIfTheReceiverNotificationBlocked(appointmentId: widget.appointment!.appointmentId);
/*
    if (context.mounted) {


      setState(() {
        fristload = false;
      });



    }
   */
  }

  @override
  Future<call_state> checkCallState(
    call_state state,
  ) async {
    switch (state) {
      case call_state.anotherCall:
        return call_state.anotherCall;

      case call_state.calling:

        // checkIfTheReceiverNotificationBlocked(
        //     appointmentId: widget.appointment!.appointmentId);

        if (!meetDetails.iscaller!) {
          if (context.mounted) {
            return call_state.calling;
          }
        }

        break;
      case call_state.refused:
        if (context.mounted) {
          return call_state.refused;
        }

        break;
      case call_state.closed:
        if (context.mounted) {
          return call_state.closed;
        }
        break;
      case call_state.inCall:
        return call_state.inCall;

      case call_state.timeOut:
    }

    /// Default return if there is no returned values from previous cases
    return call_state.closed;
  }

  /// ##########################################
  /// ####### - that will trigger call - ######
  /// ##########################################
  @override
  Future<call_state> triggerCallState() async {
    var result;
    var completer = Completer<call_state>();
    Timer? timer; // Nullable to ensure we can check if it's been initialized
    StreamSubscription? subscription; // Used to enforce the timeout
    void cleanUp() {
      timer?.cancel(); // Cancel the timer if it's been initialized
      subscription?.cancel(); // Cancel the subscription
    }

    subscription = FirebaseDatabase.instance
        .ref('userCallState')
        .child(meetDetails.receiverId)
        .child('callState')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value == 'calling') {
          result = call_state.calling;
        } else if (event.snapshot.value == 'refused') {
          result = call_state.refused;
        } else if (event.snapshot.value == 'closed') {
          result = call_state.closed;
        } else if (event.snapshot.value == 'oncall') {
          result = call_state.inCall;
        }
        if (!completer.isCompleted &&
            event.snapshot.value != null &&
            event.snapshot.value != 'calling') {
          print('Data changed! Value: ${event.snapshot.value}');
          '${event.snapshot.value}'.logPrint();
          completer.complete(result); // Complete the future when data changes
          cleanUp();
        }
      } else {
        //TODO: First time the user call
        // storeNewInstanceInDatabase();
      }
    });

    // Set up the timer to cancel listening after 30 seconds
    timer = Timer(Duration(seconds: 30), () {
      if (!completer.isCompleted) {
        completer.complete(call_state.timeOut);
        cleanUp();
      }
    });
    // Return the future

    return completer.future;
  }

  // void storeNewInstanceInDatabase() {
  //   // TODO: to be implemented
  // }

  /// ##########################################
  /// ####### - Which one to call  - ######
  /// ####### - USER,CONSULTANT,SUPPORT  - ######
  /// ##########################################
  @override
  Future<MeetStatesEnum> checkUserCallState() async {
    try {
      final res = await ReviewCheckCallState(
              receiverId: meetDetails.receiverId,
              loggedUser: meetDetails.loggedUser,
              callerId: meetDetails.callerId)
          .CheckState();
      if (res['code'] == 101) {
        return MeetStatesEnum.UserInCallState;
      } else if (res['code'] == 102) {
        return MeetStatesEnum.ErrorCreatingState;
      } else if (res['code'] == 404) {
        return MeetStatesEnum.ErrorFindingToken;
      } else if (res['code'] == 200) {
        return MeetStatesEnum.IncomingCall;
      }
      return MeetStatesEnum.nullState;
    } on CustomException catch (e) {
      'Exception is fired $e'.logPrint();
      if ((e).exceptionMsg == 'unavailable') {
        return MeetStatesEnum.connectionError;
      }
      return MeetStatesEnum.ErrorCreatingState;
    } catch (e) {
      return MeetStatesEnum.ErrorCreatingState;
    }
  }

  /// ##########################################
  /// ####### - Which one to call  - ######
  /// ####### - USER,CONSULTANT,SUPPORT  - ######
  /// ##########################################
  @override
  whichCallToStart(Function onEndfunction) async {
    var receiver = meetDetails.receiverId;
    if (context.mounted) {
      ReviewStartCall(
        host: meetDetails.host,
        iscaller: true,
        loggedUser: meetDetails.loggedUser,
        isVideo: true,
        normalCall: false,
        CallerId: FirebaseAuth.instance.currentUser!.uid,
        ReciverId: meetDetails.receiverId,
        context: context,
        onEndFunction: onEndfunction,
      )..startCall();
    }
  }

  //update server with onCall State
  @override
  Future<void> updateServerWithCallState() async {
    await FirebaseDatabase.instance
        .ref('userCallState')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('callState')
        .set('oncall');
  }
}
