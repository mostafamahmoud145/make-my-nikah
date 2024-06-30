import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/AppointmentChatScreen.dart';
import 'package:grocery_store/screens/addReviewScreen.dart';
import 'package:grocery_store/screens/generalNotificationScreen.dart';
import 'package:grocery_store/screens/home_screen.dart';
import 'package:grocery_store/screens/payInfoScreen.dart';

import 'package:grocery_store/services/call_kit_service.dart';
import 'package:grocery_store/services/call_services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

dynamic notificationData;
FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://make-my-nikah-d49f5-default-rtdb.europe-west1.firebasedatabase.app');
final realtimeDbRef = database.ref();

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
 BuildContext? _context;
DateTime? lastAccept;
Timer? acceptChance;
final Duration acceptWindow = Duration(seconds: 5);
StreamSubscription<DatabaseEvent>? checkIfSenderCancelListener;

class FirebaseService {
  
 static bool checkInit = false;
  static init(context) async {
    checkInit = true;
    _context = context;
    if (FirebaseAuth.instance.currentUser != null) await updateFirebaseToken();
    initFCM(context);
    onMessage(); //app open
    onBackgroundMsg(); //app background
    onTerminatedMsg(); //app closed
  }

  static Future<void> updateFirebaseToken() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    /// requesting permission for [alert], [badge] & [sound]. Only for iOS
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    firebaseMessaging.getToken().then((token) async {
      if (token != null && token != '') {
        print("token is: $token");
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.uid)
            .update({
          'tokenId': token,
        });
        await FirebaseFirestore.instance
            .collection('NotRegisteredUsers')
            .where('token', isEqualTo: token)
            .get()
            .then((value) {
          if (value.docs.length > 0) {
            FirebaseFirestore.instance
                .collection('NotRegisteredUsers')
                .doc(value.docs[0].data()['userId'])
                .delete();
          }
        });
      }
    });
  }

  static initFCM(context) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      //'This channel is used for important notifications.', // description
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('soundandroid'),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var android = new AndroidInitializationSettings('ic_stat_name');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? langCode = await _prefs.getString('languageCode'); //('grocery');
    var ios = DarwinInitializationSettings(notificationCategories: [
      DarwinNotificationCategory("Call", actions: [
        DarwinNotificationAction.plain(
            'Accept',
            langCode != null && langCode != null && langCode == 'ar'
                ? "متابعه الاتصال"
                : "Continue Call",
            options: {
              DarwinNotificationActionOption.foreground,
            }),
      ])
    ]);
    var initSetting = new InitializationSettings(iOS: ios, android: android);
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onDidReceiveBackgroundNotificationResponse: onSelectNotification,
        onDidReceiveNotificationResponse: onSelectNotification);

    /// need this for ios foregournd notification
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        navigation(
            _context,
            message.data['title'],
            message.data['body'],
            message.data['title_loc_key'],
            message.data['body_loc_key'],
            message.data['specific_consult_id'],
            message.data['specific_screen'],
            message.data['link'],
            message.data['notificationId'],
            message.data['notificationType'],
            message.data['type'],
            "notification");
      }
    });
  }

  static Future<void> onSelectNotification(
      NotificationResponse? payload) async {
    Map<String, dynamic>? data;
    if (payload != null && payload.payload != null) {
      data = json.decode(payload.payload!);
    }
    if (payload!.actionId == 'accept') {
      realtimeDbRef
          .child('userCallState')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('acceptState')
          .set('accepted');
    }
    if (data != null) {
      navigation(
          _context,
          data['title'],
          data['body'],
          data['titleKey'],
          data['bodyKey'],
          data['specific_consult_id'],
          data['specific_screen'],
          data['link'],
          data['notificationId'],
          data['notificationType'],
          data['type'],
          "notification");
    }
  }

  // for receiving message when app is in  foreground
  static Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.data['title']);
      // if (Platform.isAndroid) {
      // if this is available when Platform.isIOS, you'll receive the notification twice
      if (message.data['type'] == 'Call') {
        await Firebase.initializeApp();
        callKitEvents();
        CallKitService.displayIncomingCall(message.data);
      }
      String? title = message.data['title'];
      String? body = message.data['body'];
      String? titleKey = message.data['title_loc_key'];
      String? bodyKey = message.data['body_loc_key'];
      String? specificConsultId = message.data['specific_consult_id'];
      String? specificScreen = message.data['specific_screen'];
      String? link = message.data['link'];
      String? notificationId = message.data['notificationId'];
      String? notificationType = message.data['notificationType'];
      String? type = message.data['type'];
      if (title != null &&
          title != "null" &&
          title != "" &&
          body != null &&
          body != "null" &&
          body != "" &&
          message.data['type'] != 'Call') {
        showNotification(
            title: title,
            body: body,
            titleKey: titleKey,
            bodyKey: bodyKey,
            specificConsultId: specificConsultId,
            specificScreen: specificScreen,
            link: link,
            notificationId: notificationId,
            notificationType: notificationType,
            type: type);
      }
      // }
    });
  }

  static Future<void> onBackgroundMsg() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> onTerminatedMsg() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        navigation(
            _context,
            message.data['title'],
            message.data['body'],
            message.data['title_loc_key'],
            message.data['body_loc_key'],
            message.data['specific_consult_id'],
            message.data['specific_screen'],
            message.data['link'],
            message.data['notificationId'],
            message.data['notificationType'],
            message.data['type'],
            "notification");
      }
    });
  }

  /// check the sender cancel the call.
  static checkIfTheSenderCanceled() async {
    await Firebase.initializeApp();
    checkIfSenderCancelListener = FirebaseDatabase.instance
        .ref('userCallState')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('callState')
        .onValue
        .listen((event) {
      if (event.snapshot.value == 'closed') {
        FlutterCallkitIncoming.endAllCalls();
        //CallKeep.instance.endAllCalls();
      }
    });
  }

  static callKitEvents() {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      'Event ${event?.event} Started'.logPrint();
      switch (event!.event) {
        case Event.actionCallIncoming:
          Future.delayed(
            Duration(seconds: 1),
            () {
              checkIfTheSenderCanceled();
            },
          );

          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallAccept:
          EasyDebounce.debounce(
              'handleActionCallAccept',                 // <-- An ID for this particular debouncer
              Duration(milliseconds: 1000),    // <-- The debounce duration
                  () =>  handleActionCallAccept()                // <-- The target method
          );

          break;
        case Event.actionCallDecline:

          DateTime now = DateTime.now();
          'Action Decline'.logPrint();
          if (now.difference(lastAccept ?? DateTime(2000)) > acceptWindow) {
            'Action Declining'.logPrint();
            acceptChance?.cancel();
            acceptChance = await Timer(
                Duration(
                  milliseconds: 1200,
                ), () async {
              EasyDebounce.debounce(
                  'handleDeclineCall',                 // <-- An ID for this particular debouncer
                  Duration(milliseconds: 1000),    // <-- The debounce duration
                      () async{
                        checkIfSenderCancelListener?.cancel();
                        await Firebase.initializeApp();
                        Map<String, dynamic> data = event.body;
                        FlutterCallkitIncoming.endAllCalls();
                        CallServices.refuseCall(
                            withNavigatorBack: false,
                            state: 'refused',
                            callerId: data['extra']['callerId']);
                      });

            }//<-- The target method
              );

            // Process the decline event here
          } else {
            'Decline event ignored due to recent accept.'.logPrint();
          }

          break;
        case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
          break;
        case Event.actionCallTimeout:
          await Firebase.initializeApp();
          Map<String, dynamic> data = event.body;
          FlutterCallkitIncoming.endAllCalls();
          CallServices.refuseCall(
              withNavigatorBack: false,
              state: 'closed',
              callerId: data['extra']['callerId']);
          checkIfSenderCancelListener?.cancel();
          break;
        case Event.actionCallCallback:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.actionCallToggleHold:
          // TODO: only iOS
          break;
        case Event.actionCallToggleMute:
          // TODO: only iOS
          break;
        case Event.actionCallToggleDmtf:
          // TODO: only iOS
          break;
        case Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
          // TODO: only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: only iOS
          break;
        case Event.actionCallCustom:
          // TODO: for custom action
          break;
      }
    });

    /*FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async{

    switch (event!.event) {
      case Event.actionCallIncoming:
      /// received an incoming call4
      //  await Firebase.initializeApp();
        checkIfTheSenderCanceled();
        break;
      case Event.actionCallStart:
      // TODO: started an outgoing call
      // TODO: show screen calling in Flutter
        break;
      case Event.actionCallAccept:
      /// accepted an incoming call
      /// show screen calling in Flutter
      ///
        mayAppCheckCall();

        break;
      case Event.actionCallDecline:
      /// declined an incoming call

      //  await Firebase.initializeApp();
        Map<String, dynamic> data= event.body;
        FlutterCallkitIncoming.endAllCalls();
        CallServices.refuseCall(withNavigatorBack: false, state: 'refused', callerId: data['extra']['callerId']);

        break;
      case Event.actionCallEnded:
      // TODO: ended an incoming/outgoing call
        break;
      case Event.actionCallTimeout:
      /// missed an incoming call
      ///
       // await Firebase.initializeApp();
        Map<String, dynamic> data= event.body;
        FlutterCallkitIncoming.endAllCalls();
        CallServices.refuseCall(withNavigatorBack: false, state: 'closed', callerId: data['extra']['callerId']);
        break;
      case Event.actionCallCallback:
      // TODO: only Android - click action `Call back` from missed call notification
        break;
      case Event.actionCallToggleHold:
      // TODO: only iOS
        break;
      case Event.actionCallToggleMute:
      // TODO: only iOS
        break;
      case Event.actionCallToggleDmtf:
      // TODO: only iOS
        break;
      case Event.actionCallToggleGroup:
      // TODO: only iOS
        break;
      case Event.actionCallToggleAudioSession:
      // TODO: only iOS
        break;
      case Event.actionDidUpdateDevicePushTokenVoip:
      // TODO: only iOS
        break;
      case Event.actionCallCustom:
      // TODO: for custom action
        break;
    }
  });*/
  }

  static bool _isMayAppCheckCallAllowed = true;

  static void handleActionCallAccept() {
    // Check if mayAppCheckCall is allowed to run
    if (!_isMayAppCheckCallAllowed) {
      return;
    }
    'STARTING NEW CALL'.logPrint();
    // Prevent subsequent calls to mayAppCheckCall for a while
    _isMayAppCheckCallAllowed = false;
    Timer(Duration(seconds: 3), () {
      // Allow subsequent calls to mayAppCheckCall after 60 seconds
      _isMayAppCheckCallAllowed = true;
    });

    'Action Accept'.logPrint();
    lastAccept = DateTime.now();

    if (acceptChance != null) {
      acceptChance?.cancel();
    }
    checkIfSenderCancelListener?.cancel();

    // Call mayAppCheckCall
    mayAppCheckCall(contexts: _context);
  }

  static showNotification(
      {String? title,
      String? body,
      String? titleKey,
      String? bodyKey,
      String? specificConsultId,
      String? specificScreen,
      String? link,
      String? notificationId,
      String? notificationType,
      String? type}) async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var aNdroid = new AndroidNotificationDetails(
      'channelId',
      'channel_name',
      icon: 'ic_stat_name',
      autoCancel: true,
      fullScreenIntent: false,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: null,
    );
    var iOS = new DarwinNotificationDetails(
     // sound: 'jeraston.aiff',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platform = new NotificationDetails(android: aNdroid, iOS: iOS);

    int uniqueNumber = Random().nextInt(100);
    Map<String, dynamic> data = {
      'title': title,
      'body': body,
      'titleKey': titleKey,
      'bodyKey': bodyKey,
      'specific_consult_id': specificConsultId,
      'specific_screen': specificScreen,
      'link': link,
      'notificationId': notificationId,
      'notificationType': notificationType,
      'type': type
    };
    String payload = json.encode(data);
    await flutterLocalNotificationsPlugin!
        .show(uniqueNumber, title, body, platform, payload: payload);
    if (notificationId != null &&
        notificationId != "null" &&
        notificationId.split('').isNotEmpty) {
      await Firebase.initializeApp();
      String platform = Platform.isIOS
          ? "iOS"
          : Platform.isAndroid
              ? "Android"
              : "Web";
      FirebaseFirestore.instance
          .collection(Paths.generalNotificationsPath)
          .doc(notificationId)
          .set({
            "views": {platform: FieldValue.increment(1)}
          }, SetOptions(merge: true))
          .catchError((onError) {
            print("error: $onError");
          });
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("notification BackgroundHandler");
    Map<String, dynamic> data = message.data;
    if (message.notification != null) {
      print("notification BackgroundHandler00000");
      print(message.notification!.title);
    }
    String? title = data['title'];
    String? body = data['body'];
    String? titleKey = data['title_loc_key'];
    String? bodyKey = data['body_loc_key'];
    String? specificConsultId = data['specific_consult_id'];
    String? specificScreen = data['specific_screen'];
    String? link = data['link'];
    String? notificationId = data['notificationId'];
    String? notificationType = data['notificationType'];
    String? type = data['type'];
    if (title != null &&
        title != "null" &&
        title != "" &&
        body != null &&
        body != "null" &&
        body != "" &&
        message.data['type'] != 'Call') {
      showNotification(
          title: title,
          body: body,
          titleKey: titleKey,
          bodyKey: bodyKey,
          specificConsultId: specificConsultId,
          specificScreen: specificScreen,
          link: link,
          notificationId: notificationId,
          notificationType: notificationType,
          type: type);
    }
    if (data != null) {
      switch (data['type']) {
        case "Call":
          await Firebase.initializeApp();
          callKitEvents();
          CallKitService.displayIncomingCall(message.data);
          break;
      }
    }
  }

  @pragma('vm:entry-point')
  static navigation(
      context,
      String? title,
      String? body,
      String? titleKey,
      String? bodyKey,
      String? specificConsultId,
      String? specificScreen,
      String? link,
      String? notificationId,
      String? notificationType,
      String? type,
      String? session) async {
    print("Consultant ID is : ");
     print("coooooooooooooooo111111 $context");
     print("coooooooooooooooo2222 $_context");
     print(titleKey);
     print(bodyKey);
if ((title == "المواعيد" || title == "Appointment") && titleKey == "user") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          notificationPage: 1,
        ),
      ),
    );
  } else if ((title == "المواعيد" || title == "Appointment") &&
      titleKey == "consult") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          notificationPage: 0,
        ),
      ),
    );
  } else if (title == "Nikah") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          notificationPage: 0,
        ),
      ),
    );
  } else if (title == "التقيم" || title == "Review") {
    List<String> dateParts = bodyKey!.split(",");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReviewScreen(
          consultId: dateParts[0],
          userId: titleKey!,
          appointmentId: dateParts[1],
        ),
      ),
    );
  } else if (title == "الدعم الفني" || title == "Technical Support") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          notificationPage: 2,
        ),
      ),
    );
  } else if (title == "رسائل المحادثات" || title == "Chat messages") {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(titleKey);
    final DocumentSnapshot documentSnapshot = await docRef.get();
    var user = GroceryUser.fromMap(documentSnapshot.data() as Map);

    DocumentReference docRef2 = FirebaseFirestore.instance
        .collection(Paths.appAppointments)
        .doc(bodyKey);
    final DocumentSnapshot documentSnapshot2 = await docRef2.get();
    var appointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AppointmentChatScreen(appointment: appointment, user: user),
      ),
    );
  } else if (title == "مقابلة" || title == "InterView") {
    // Navigator.push(
    //   _context!,
    //   MaterialPageRoute(
    //     builder: (context) => InterviewVideoCallScreen(
    //       userId: value!.titleLocKey!,
    //     ),
    //   ),
    // );
  } else if (title == "اتصال" || title == "Calling") {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(Paths.usersPath).doc(titleKey);
    final DocumentSnapshot documentSnapshot = await docRef.get();
    var user = GroceryUser.fromMap(documentSnapshot.data() as Map);

    DocumentReference docRef2 = FirebaseFirestore.instance
        .collection(Paths.appAppointments)
        .doc(bodyKey);
    final DocumentSnapshot documentSnapshot2 = await docRef2.get();
    var appointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AppointmentChatScreen(appointment: appointment, user: user),
      ),
    );
  } else if (title == "الحساب" || title == "Account") {
    /* DocumentReference docRef = FirebaseFirestore.instance.collection(Paths.usersPath).doc(value!.titleLocKey);
      final DocumentSnapshot documentSnapshot = await docRef.get();
      var user= GroceryUser.fromMap(documentSnapshot);

      DocumentReference docRef2 = FirebaseFirestore.instance.collection(Paths.appAppointments).doc(value!.bodyLocKey);
      final DocumentSnapshot documentSnapshot2 = await docRef2.get();
      var appointment = AppAppointments.fromMap(documentSnapshot2);*/
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => payInfoScreen(
          consultUid: titleKey!,
        ),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneralNotificationScreen(
            title: title!, body: body!, image: titleKey, link: body),
      ),
    );
  }
  }

/*   static Future<void> countClicks({id, session}) async {
    String? collectionName;
    if (session == "notification") {
      collectionName = Paths.generalNotificationsPath;
    } else if (session == "dialog") {
      collectionName = Paths.dialogsPath;
    } else if (session == "bottomSheet") {
      collectionName = Paths.bottomSheetsPath;
    }
    String platform = Platform.isIOS
        ? "iOS"
        : Platform.isAndroid
            ? "Android"
            : "Web";
    sessionId = session != "bottomSheet" ? id : sessionId;
    sessionType = session != "bottomSheet" ? session : sessionType;
    FirebaseFirestore.instance
        .collection(collectionName!)
        .doc(id)
        .set({
          "clicks": {platform: FieldValue.increment(1)}
        }, SetOptions(merge: true))
        .then((value) {})
        .catchError((onError) {
          print("error: $onError");
        });
  } */

  static launchURL(String? url) async {
    if (!url!.contains('http')) url = 'https://$url';
    await launchUrl(Uri.parse(url));
  }
}
