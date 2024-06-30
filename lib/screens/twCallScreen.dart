import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/order.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:grocery_store/models/timeHelper.dart';
import 'package:grocery_store/models/user.dart';
import 'package:twilio_voice/twilio_voice.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock/wakelock.dart';
import 'package:http/http.dart' as http;
class VoiceCallScreen extends StatefulWidget {
  final GroceryUser? loggedUser;
  final AppAppointments? appointment;

  final String? from;

  const VoiceCallScreen({this.loggedUser, this.appointment, this.from});

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

//creete push notification
//https://githubmemory.com/repo/diegogarciar/twilio_voice/issues/39
//https://console.twilio.com/us1/develop/notify/try-it-out?frameUrl=%2Fconsole%2Fnotify%2Fcredentials%2FCR864c85133906feaf674f16b7e7a38b0b%3F__override_layout__%3Dembed%26bifrost%3Dtrue%26x-target-region%3Dus1
class _VoiceCallScreenState extends State<VoiceCallScreen> {
  var speaker = false;
  var mute = false;
  String callId="";
  var isEnded = false;
  bool ending = false, done = true, firstTime = false;
  bool endingCall = false;
  late AccountBloc accountBloc;
  String? message = "Connecting...";
  bool firstStateEnabled = false;
  bool showTimer = true;
  int minutes = 0, seconds = 0;
  late StreamSubscription<CallEvent> callStateListener;
  bool logFound = false;

  void listenCall() {
    callStateListener =
        TwilioVoice.instance.callEventsListener.listen((event) async {
          print("voip-onCallStateChanged $event");
          switch (event) {
            case CallEvent.callEnded:
              print("close1111");
              print(callId);
              print("close1111222");
              if (!isEnded) {
                isEnded = true;
                if (widget.loggedUser != null &&
                    widget.loggedUser!.userType == "COACH" &&
                    widget.appointment != null &&
                    widget.appointment!.appointmentStatus != "closed") {
                  endCallDialog(MediaQuery.of(context).size);
                } else if (widget.loggedUser != null &&
                    widget.loggedUser!.userType == "COACH" &&
                    widget.appointment != null &&
                    widget.appointment!.appointmentStatus == "closed") {
                  setState(() {
                    endingCall=true;
                  });
                  Navigator.of(context).pop();
                } else {
                  if (minutes > 20)
                    endUserCallDialog(MediaQuery.of(context).size);
                  else
                    Navigator.of(context).pop();
                }
              }
              break;
            case CallEvent.log:
              print(CallEvent.log);
              if (widget.loggedUser != null &&
                  widget.loggedUser!.userType == "COACH" &&
                  widget.appointment != null) {
                showNoNotifSnack(getTranslated(context, "notAvalaible"));
              }

              break;
            case CallEvent.mute:
              print("received mute");
              if (mounted)
                setState(() {
                  mute = true;
                });
              break;
            case CallEvent.unmute:
              print("received unmute");
              if (mounted)
                setState(() {
                  mute = false;
                });
              break;
            case CallEvent.speakerOn:
              print("received speakerOn");
              if (mounted)
                setState(() {
                  speaker = true;
                });
              break;
            case CallEvent.speakerOff:
              print("received speakerOf");
              if (mounted)
                setState(() {
                  speaker = false;
                });
              break;
            case CallEvent.ringing:
              print("twiliocallstatus ringing");
              if (mounted)
                setState(() {
                  message = "Ringing...";
                });
              break;
            case CallEvent.answer:
              print("twiliocallstatus answer");

              if (mounted)
                setState(() {
                  message = "Answer...";
                });
              break;
            case CallEvent.connected:
              if (mounted)
                setState(() async {
                  message = "Connected...";
                  //callId = (await TwilioVoice.instance.call.getSid())!;
                });
              print("call dat1111111166666");
              print(callId);
              break;

            case CallEvent.hold:
            //case CallEvent.log:
            case CallEvent.unhold:
              break;
            default:
              break;
          }
        });
  }

  late String caller, callerImage;
  Future<void> updateCallCost() async {
    try{
     if(widget.loggedUser!=null&&widget.loggedUser!.userType=="COACH")
       {
         var cost=minutes*2*.004;
         var finalCost=widget.appointment!.callCost+cost;
         //closeAppointment
         await FirebaseFirestore.instance
             .collection(Paths.appAppointments)
             .doc(widget.appointment!.appointmentId)
             .update({
               'callCost': finalCost,
         });
       }
    }catch(e){
      print("close111122211111111 error");
      print(e.toString());
    }
  }
  void showNoNotifSnack(String text) {
    print("mmm12333333");
  }

  String getCaller() {
    if (widget.loggedUser != null &&
        widget.loggedUser!.userType == "COACH" &&
        widget.appointment != null)
      return widget.appointment!.user.name;
    else if (widget.loggedUser != null &&
        widget.loggedUser!.userType != "COACH" &&
        widget.appointment != null)
      return widget.appointment!.consult.name;
    else
      return "Nikah App";
  }

  String getCallerImage() {
    if (widget.loggedUser != null &&
        widget.loggedUser!.userType == "COACH" &&
        widget.appointment != null)
      return widget.appointment!.user.image!;
    else if (widget.loggedUser != null &&
        widget.loggedUser!.userType != "COACH" &&
        widget.appointment != null)
      return widget.appointment!.consult.image!;
    else
      return " ";
  }

  @override
  void initState() {
    accountBloc = BlocProvider.of<AccountBloc>(context);
    speaker = false;
    mute = false;
    listenCall();
    Wakelock.enable();
    super.initState();
    caller = getCaller();
    callerImage = getCallerImage();
  }

  @override
  void dispose() {
    super.dispose();
    updateCallCost();
    Wakelock.disable();
    callStateListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff000000),
        body: Container(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: callerImage.isEmpty
                            ? Image.asset('assets/icons/icon/Mask Group 47.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/icons/icon/load2.gif',
                            placeholderScale: 0.5,
                            imageErrorBuilder: (context, error,
                                stackTrace) =>
                                Image.asset('assets/icons/icon/Mask Group 47.png',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fill),
                            image: callerImage,
                            fit: BoxFit.cover,
                            fadeInDuration: Duration(milliseconds: 250),
                            fadeInCurve: Curves.easeInOut,
                            fadeOutDuration:
                            Duration(milliseconds: 150),
                            fadeOutCurve: Curves.easeInOut,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        caller == null ? " " : caller,
                        style: TextStyle(
                          fontFamily: 'Ithra',
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      message != null
                          ? Text(
                        message!,
                        style: TextStyle(
                          fontFamily: 'Ithra',
                          fontSize: 10.0,
                          fontWeight: FontWeight.normal,
                          color: AppColors.pink,
                        ),
                      )
                          : SizedBox(),
                      SizedBox(height: 8),
                      showTimer
                          ? TweenAnimationBuilder<Duration>(
                          duration: Duration(minutes: 20),
                          tween: Tween(
                              begin: Duration(minutes: 20),
                              end: Duration.zero),
                          onEnd: () {
                            print('Timer ended');
                            // _onCallEnd();
                          },
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            minutes = value.inMinutes;
                            seconds = value.inSeconds % 60;
                            if (minutes == 5 && seconds == 0) {
                              firstTime = true;
                            }
                            return Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5),
                                    child: Text('$minutes:$seconds',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: minutes <= 5
                                                ? Colors.red
                                                : Colors.white,
                                            fontSize: 15))),
                                firstTime
                                    ? Text(
                                  getTranslated(
                                      context, "fiveMinutes") +
                                      minutes.toString() +
                                      getTranslated(
                                          context, "minutes"),
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: 'Ithra',
                                    fontSize: 11.0,
                                    color: AppColors.red,
                                  ),
                                )
                                    : SizedBox(),
                              ],
                            );
                          })
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            type: MaterialType.transparency,
                            //Makes it usable on any background color, thanks @IanSmith
                            child: Ink(
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.white, width: 1.0),
                                color: Colors.black,
                                // speaker ?AppColors.green : Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                //This keeps the splash effect within the circle
                                borderRadius: BorderRadius.circular(100.0),
                                //Something large to ensure a circle
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    speaker
                                        ? Icons.volume_up
                                        : Icons.volume_off,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    speaker = !speaker;
                                  });

                                  TwilioVoice.instance.call
                                      .toggleSpeaker(speaker);
                                },
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              RawMaterialButton(
                                elevation: 2.0,
                                fillColor: Colors.red,
                                child: Icon(
                                  Icons.call_end,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                                onPressed: () async {
                                  // final isOnCall = await TwilioVoice.instance.call.isOnCall();
                                  if (widget.loggedUser != null && widget.loggedUser!.userType == "COACH") {
                                    TwilioVoice.instance.call.hangUp();
                                  } else
                                    Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                          Material(
                            type: MaterialType.transparency,
                            //Makes it usable on any background color, thanks @IanSmith
                            child: Ink(
                              decoration: BoxDecoration(
                                // border:  Border.all(color: Colors.white, width: 1.0),
                                color: Colors.black,
                                // mute? AppColors.green: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                //This keeps the splash effect within the circle
                                borderRadius: BorderRadius.circular(100.0),
                                //Something large to ensure a circle
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    mute ? Icons.mic_off : Icons.mic,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  print("mute!");
                                  setState(() {
                                    mute = !mute;
                                  });
                                  TwilioVoice.instance.call.toggleMute(mute);
                                  // setState(() {
                                  //   mute = !mute;
                                  // });
                                },
                              ),
                            ),
                          )
                        ]),
                  ),

                  /*  firstTime? Container(color: Colors.red,width: size.width,child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                      Expanded(flex:2,
                        child: Text( getTranslated(context, "fiveMinutes")+minutes.toString()+getTranslated(context, "minutes"),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          softWrap:true,
                          style: TextStyle(fontFamily: 'Ithra',
                            fontSize: 14.0,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 25,
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                firstTime=false;
                              });
                            },
                            color: Colors.black.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Text(
                              getTranslated(context, "Ok"),
                              style: TextStyle(fontFamily: 'Ithra',
                                color: AppColors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],),
                  ),):SizedBox()*/
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> callDone() async {
    try {
      setState(() {
        endingCall = true;
      });
      //closeAppointment
      await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .doc(widget.appointment!.appointmentId)
          .update({
        'appointmentStatus': "closed",
        'allowCall': false,
        'closedUtcTime': DateTime.now().toUtc().toString(),
        'closedDate': {
          'day': DateTime.now().day,
          'month': DateTime.now().month,
          'year': DateTime.now().year,
        },
      });

      //close order
      await FirebaseFirestore.instance
          .collection(Paths.ordersPath)
          .doc(widget.appointment!.orderId)
          .set({
        'answeredCallNum': 1,
        'orderStatus': "closed",
        'remainingCallNum': 0
      }, SetOptions(merge: true));

      //update consultbalance
      print("endmeeting1");
      DocumentReference docRef = FirebaseFirestore.instance
          .collection(Paths.settingPath)
          .doc("pzBqiphy5o2kkzJgWUT7");
      final DocumentSnapshot taxDocumentSnapshot = await docRef.get();
      var taxes = Setting.fromMap(taxDocumentSnapshot.data() as Map).coachTaxes;
      print("endmeeting2");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.loggedUser!.uid)
          .get();
      GroceryUser currentUser = GroceryUser.fromMap(documentSnapshot.data() as Map);
      dynamic taxesvalue = (widget.appointment!.callPrice * taxes) / 100;
      dynamic consultBalance = widget.appointment!.callPrice - taxesvalue;
      dynamic payedBalance = consultBalance;
      if (currentUser.payedBalance != null)
        payedBalance = payedBalance + currentUser.payedBalance;
      print("endmeeting3");
      if (currentUser.balance != null)
        consultBalance = consultBalance + currentUser.balance;
      print("endmeeting4");
      int? consultOrdersNumbers = 1;
      if (currentUser.ordersNumbers != null)
        consultOrdersNumbers = 1 + currentUser.ordersNumbers!;
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.loggedUser!.uid)
          .set({
        'balance': consultBalance,
        'payedBalance': payedBalance,
        'ordersNumbers': consultOrdersNumbers
      }, SetOptions(merge: true));
      setState(() {
        endingCall = false;
      });

      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (route) => false,
      );


    } catch (e) {
      print("eeeeee" + e.toString());
      errorLog("callDone", e.toString());
    }
  }

  errorLog(String function, String error) async {
    String id = Uuid().v4();
    await FirebaseFirestore.instance
        .collection(Paths.errorLogPath)
        .doc(id)
        .set({
      'timestamp': Timestamp.now(),
      'id': id,
      'seen': false,
      'desc': error,
      'phone': widget.loggedUser == null ? " " : widget.loggedUser?.phoneNumber,
      'screen': "twCallScreen",
      'function': function,
    });
  }

  endCallDialog(Size size) {
    setState(() {
      showTimer = false;
    });
    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  getTranslated(context, "areYouSureCloseAppointment"),
                  style: TextStyle(
                    fontFamily: 'Ithra',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            endingCall = true;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          getTranslated(context, 'no'),
                          style: TextStyle(
                            fontFamily: 'Ithra',
                            color: Colors.black87,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    endingCall
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                      width: 50.0,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          //Navigator.pop(context);
                          setState(() {
                            endingCall = true;
                          });
                          if (widget.loggedUser != null && widget.loggedUser!.userType == "COACH" &&widget.appointment != null)
                            callDone();
                        },
                        child: Text(
                          getTranslated(context, 'yes'),
                          style: TextStyle(
                            fontFamily: 'Ithra',
                            color: Colors.red.shade700,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  endUserCallDialog(Size size) {
    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Text(
              getTranslated(context, "callTimeEnd"),
              style: TextStyle(
                fontFamily: 'Ithra',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      getTranslated(context, 'Ok'),
                      style: TextStyle(
                        fontFamily: 'Ithra',
                        color: Colors.black87,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }
}
