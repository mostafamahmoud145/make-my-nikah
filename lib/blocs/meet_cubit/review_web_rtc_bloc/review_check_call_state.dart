import "dart:async";
import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dio/dio.dart";
import "package:firebase_database/firebase_database.dart";
import "package:grocery_store/Utils/exception.dart";
import "package:grocery_store/config/app_constat.dart";
import "package:grocery_store/config/paths.dart";

import 'package:http/http.dart' as http;

import '../../../models/user.dart';

class ReviewCheckCallState {
  String callerId = "";
  String receiverId = "";
  GroceryUser? loggedUser;

  ReviewCheckCallState({
    required this.callerId,
    required this.receiverId,
    required this.loggedUser,
  });

  final FirebaseDatabase db = FirebaseDatabase.instance;

  /// check call state first and then create new call
  Future<Map<String, dynamic>> CheckState() async {
    final receiverState = await db
        .ref(Paths.userCallState)
        .child(receiverId)
        .child("callState")
        .once()
        .timeout(Duration(seconds: 10), onTimeout: () {
      // Handle timeout
      throw CustomException('unavailable');
    });
    // check call exists
    if (receiverState != null && receiverState.snapshot.exists) {
      print("checkCall2");
      // check call state
      if (receiverState.snapshot.value == "calling" ||
          receiverState.snapshot.value == "oncall") {
        return {
          "code": 101,
          "message": "Error cant call this person right now ",
          "data": "person in another call",
        };
      }

      print("checkCall3");

      var createNewCallState = await CreateNewCall();
      print("checkCall4");

      if (createNewCallState == "success") {
        return {
          "code": 200,
          "message": "waiting for response ",
          "data": "incoming Call",
        };
      } else if (createNewCallState == "failed-token") {
        return {
          "code": 404,
          "message": "token not found ",
          "data": "missing token",
        };
      } else {
        return {
          "code": 102,
          "message": "error create call",
          "data": "error create call",
        };
      }
    } else {
      // await db.ref(Paths.signaling).child(appointmentId).child("message").remove();
      var createNewCallState = await CreateNewCall();
      if (createNewCallState == "success") {
        return {
          "code": 200,
          "message": "waiting for response ",
          "data": "incoming Call",
        };
      } else if (createNewCallState == "failed-token") {
        return {
          "code": 404,
          "message": "token not found ",
          "data": "missing token",
        };
      } else {
        return {
          "code": 102,
          "message": "error create call",
          "data": "error create call",
        };
      }
    }
  }

  /// create new call
  Future<String> CreateNewCall() async {
    print("11");
    var notificationState = await SendCallNotification();
    if (notificationState == "success") {
      // create new collection in firebase realtime for caller
      await db.ref(Paths.userCallState).child(receiverId).set({
        "callState": "calling",
        "timeStamp": Timestamp.fromDate(DateTime.now()).toDate().toString(),
        "callerID": callerId,
        "reciverId": receiverId
      });
      print("12");

      // create new collection in firebase realtime for receiver
      await db.ref(Paths.userCallState).child(callerId).set({
        "callState": "calling",
        "timeStamp": Timestamp.fromDate(DateTime.now()).toDate().toString(),
        "callerID": callerId,
        "reciverId": receiverId
      });
      print("13");

      return "success";
    } else if (notificationState == "failed-token") {
      return notificationState;
    } else {
      print("///////////CreateNewCall failed");
      return "failed";
    }
  }

  final Dio dio = Dio();

  /// send notification to another person by firebase messaging
  Future<String> SendCallNotification() async {
    print("1");

    // await FirebaseDatabase.instance
    //     .ref('callNotifications')
    //     .child(appointmentId)
    //     .child('notificationState')
    //     .set('binding');

    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshotUser =
          await FirebaseFirestore.instance
              .collection(Paths.usersPath)
              .doc(receiverId)
              .get();
      GroceryUser user = await GroceryUser.fromMap(
          documentSnapshotUser.data() as Map<dynamic, dynamic>);
      print("2");

      var requestData = {
        "reciverId": receiverId,
        "callerId": callerId,
        "callerName": loggedUser!.name,
        "appointmentId": AppConstants.inteview,
        "title": user.userLang == "ar" ? "مكالمة جديدة" : "new Call",
        "message": user.userLang == "ar"
            ? "مكالمة من ${loggedUser!.userType == "CONSULTANT" ? loggedUser!.name : loggedUser!.name}"
            : "Call from ${loggedUser!.userType == "CONSULTANT" ? loggedUser?.name : user.name}",
      };

      var response = await http.post(
        Uri.parse(
            'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendCallNotification'),
        body: jsonEncode(requestData),
        headers: {
          'Content-Type': 'application/json'
        }, // تأكد من تعيين رأس المحتوى إلى نوع التطبيق/JSON
      );
      String responseBody = response.body;
      var res = json.decode(responseBody);
      print("///////////");
      print(res);
      print(responseBody);
      if (res == 200 || res['message'] == "Success") {
        return "success";
      }
      if (res['message']['code'] == "messaging/invalid-argument") {
        //"{"message":{"code":"messaging/registration-token-not-registered","message":"Requested entity was not found."}}"
        return "failed-token";
      } else {
        return "failed";
      }
    } catch (e) {
      print("error send notifications : $e");
      return "failed";
    }
  }
}
