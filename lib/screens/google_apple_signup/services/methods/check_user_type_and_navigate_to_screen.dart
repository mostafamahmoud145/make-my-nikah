import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/consultRules.dart';
import 'package:grocery_store/screens/google_apple_signup/services/enum/authentication_type.dart';
import 'package:grocery_store/screens/google_apple_signup/services/methods/get_device_type.dart';
import 'package:grocery_store/screens/google_apple_signup/services/methods/navigation_method.dart';


/// check the user type.
/// after signing in, [checkUserTypeAndNavigateToScreens] method is called,
/// to check if the user is new user or old user,
/// if new user => create initial data to him in firebase,
/// and navigate to his profile to complete his information.
///
/// if old user => navigate to home screen.
/// if the user blocked => logout.
///

Future<String?> checkUserTypeAndNavigateToScreens({
  String? phoneNumber,
  required String userType,
  required String uid,
  required BuildContext context,
  String? countryCode,
  String? isoCode,
  String? email,
  required SignInType signInType,
  required Function onError,
  required Function onNavigate,
}) async {
  try {
    QuerySnapshot<Map<String, dynamic>> users;

    if (signInType == SignInType.google) {
      users = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .where('email', isEqualTo: email)
          .get();
    } else if (signInType == SignInType.mobile) {
      users = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
    } else {
      users = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .where('uid', isEqualTo: uid)
          .get();
    }
    if (users.docs.length > 0) {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(uid)
          .set({
        // 'countryCode': countryCode,
        // 'countryISOCode': isoCode,
        'deviceType': kIsWeb ? "web" : await getDeviceType()
      }, SetOptions(merge: true));
      // accountBloc.add(GetLoggedUserEvent());
      String eventName = "af_login";
      Map eventValues = {};
      addEvent(eventName, eventValues);
      Map<String, dynamic> data = users.docs[0].data();
      Map<String, dynamic>? data2 = users.docs[0].data();
      if (data['isBlocked'] != null && data['isBlocked']) {
        //AppFlyerService().clear();
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
        onNavigate();
      } else if (data['profileCompleted'] != null && data['profileCompleted']) {
        //await AppFlyerService() .initAppFlyerUser(FirebaseAuth.instance.currentUser!.uid);
        var user = GroceryUser.fromMap(data2);

        onNavigate();
        /* navigateWithoutBack(
          context,
          ()=>   VerificationSuccessScreen(
            loggedUser: user,
          ),
        ); */
      } else {
        DocumentReference docRef =
            FirebaseFirestore.instance.collection(Paths.usersPath).doc(uid);
        final DocumentSnapshot documentSnapshot = await docRef.get();
        var user = GroceryUser.fromMap(documentSnapshot.data() as Map);
        if (user.userType == "CONSULTANT") {
          onNavigate();
          navigateTo(
              context,
              consultRuleScreen(
                user: user,
              ));
        } else {
         // await AppFlyerService() .initAppFlyerUser(FirebaseAuth.instance.currentUser!.uid);

          onNavigate();
/*            navigateTo(
              context,
              VerificationSuccessScreen(
                loggedUser: user,
              ));  */
        }
      }
    } else {
      //user nit found-create user and save it
      String eventName = "af_complete_registration";
      Map eventValues = {
        "af_registration_method": "phone number",
      };
      addEvent(eventName, eventValues);
      DocumentReference ref =
          FirebaseFirestore.instance.collection(Paths.usersPath).doc(uid);
      var data = {
        'accountStatus': 'NotActive',
        'userLang': 'ar',
        'profileCompleted': false,
        'isBlocked': false,
        'uid': uid,
        'name': "",
        'email': email,
        'phoneNumber': phoneNumber,
        'photoUrl': '',
        'tokenId': "",
        'loggedInVia': "mobile",
        "userType": userType,
        'deviceType':defaultTargetPlatform == TargetPlatform.android ? 'Android'
            :defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : kIsWeb ? 'web' : 'Unknown',
        "languages": [],
        "countryCode": countryCode,
        "countryISOCode": isoCode,
        "isApple": signInType == SignInType.apple ? true : false,
        "isPhoneMain": signInType == SignInType.mobile ? true : false,
        "createdDate": Timestamp.now(),
        'utcTime': DateTime.now().toUtc().toString(),
        'date': {
          'day': DateTime.now().day,
          'month': DateTime.now().month,
          'year': DateTime.now().year,
        },
        "createdDateValue": DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .millisecondsSinceEpoch,
      };
      ref.set(data, SetOptions(merge: true));
      final DocumentSnapshot currentDoc = await ref.get();
      var user = GroceryUser.fromMap(currentDoc.data() as Map);

      if (user.userType == "CONSULTANT") {
        onNavigate();
       // navigateTo(context, consultRuleScreen(user: user, video: video));
      } else {
        /**
         * DEEP LINK LOGIC
         */
        //await AppFlyerService().updateCurrentUserDeepLinkDataAtRegistration(uid);
        //await AppFlyerService() .initAppFlyerUser(FirebaseAuth.instance.currentUser!.uid);

        onNavigate();
        /* navigateTo(
            context,
            VerificationSuccessScreen(
              loggedUser: user,
            )); */
      }
    }
  } catch (e) {
    onError();
    return null;
  }
  return null;
}

addEvent(String eventName, Map eventValues) async {
  if (eventName == "af_login")
    await FirebaseAnalytics.instance.logLogin(
      loginMethod: "phone",
    );
  else
    await FirebaseAnalytics.instance.logSignUp(
      signUpMethod: "phone",
    );
}
