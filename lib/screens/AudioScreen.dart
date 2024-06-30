
import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/timeHelper.dart';
import 'package:grocery_store/models/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/colorsFile.dart';
import '../models/setting.dart';

class AudioScreen extends StatefulWidget {
  final AppAppointments appointment ;
  final GroceryUser user;
  final String appointmentId ;
  final String consultName;


  const AudioScreen({Key? key, required this.appointment, required this.user, required this.appointmentId, required this.consultName}) : super(key: key);
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen>with SingleTickerProviderStateMixin {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false,callStart=false;

  late RtcEngine engine;
  int minutes =0,  seconds=0;
  bool mute=false,speaker=false,done=true,firstTime=false,endingCall=false;
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    initPlatformState();

  }


  @override
  Future<void> dispose() async {
    Wakelock.disable();
    if (widget.user != null && widget.user.userType == "CONSULTANT")
      await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .doc(widget.appointment.appointmentId)
          .set({
        'allowCall': false,
      }, SetOptions(merge: true));
    engine.leaveChannel();
    engine.destroy();
    super.dispose();
  }
  // Init the app
  Future<void> initPlatformState() async {
    await [Permission.microphone].request();
    RtcEngineContext context = RtcEngineContext("c43f829465b64368b158b8d82ffc3110");

    engine = await RtcEngine.createWithContext(context);
    engine.enableAudio();
    engine.disableVideo();
    engine.adjustPlaybackSignalVolume(100);
    engine.muteLocalAudioStream(mute);
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('joinChannelSuccess ${channel} ${uid}');
          setState(() {
            _joined = true;
          });
        }, userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _joined = true;
        callStart=true;
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = 0;
      });
    }));
  await engine.joinChannel(null, widget.appointmentId, null, 0);
  //  await engine.joinChannel("0068777a2b62fb449c39aec15847a8d267aIADxNkxjwo0+eY/oErO+DsxxKAI2AbCyMQsl45PXUA4s/gx+f9gAAAAAEAC5YzmxEPBTYgEAAQAQ8FNi",
     //   "test", null, 0);
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: SafeArea(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: size.height*.10,),
                    Center(
                        child: Container(height: 70,width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: Colors.white,
                            ),
                            child: Image.asset('assets/icons/icon/Mask Group 47.png', fit:BoxFit.fill,height: 70,width: 70)

                        )
                    ),
                    SizedBox(height: 10,),
                    Text(
                      widget.user==null?widget.consultName:widget.appointment.user.name,
                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"), color: AppColors.black,
                          fontSize: 13.0,fontWeight: FontWeight.normal ),
                    ),
                    SizedBox(height: 2),
                    (callStart==false)?Text(getTranslated(context, "waitAgora")+" "+" "+
                        getTranslated(context,"join"),
                      style: TextStyle(fontFamily: getTranslated(context,"fontFamily"), color: AppColors.reddark,
                          fontSize: 11.0,fontWeight: FontWeight.normal ),
                    ): SizedBox(),
                    SizedBox(height: 8),
                  ],
                ),
                callStart?TweenAnimationBuilder<Duration>(
                    duration: Duration(minutes: 15),
                    tween: Tween(begin: Duration(minutes: 15), end: Duration.zero),
                    onEnd: () {
                      print('Timer ended');
                      _disconnectRoom();
                    },
                    builder: (BuildContext context, Duration value, Widget? child) {
                      minutes = value.inMinutes;
                      seconds = value.inSeconds % 60;
                      if(minutes==5&&seconds==0)
                      {
                        firstTime=true;
                      }
                      return Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              Text('$minutes:$seconds',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: minutes < 5
                                          ? Colors.red
                                          : AppColors.gren,
                                      fontSize: 15)),
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
                                  fontFamily: getTranslated(context, "fontFamily"),
                                  fontSize: 11.0,
                                  color: AppColors.red,
                                ),
                              )
                                  : SizedBox(),
                              /* Container(color: Colors.red.withOpacity(0.5),width: size.width*.8,child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                                      Expanded(flex:2,
                                        child: Text( getTranslated(context, "fiveMinutes")+minutes.toString()+getTranslated(context, "minutes"),
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap:true,
                                          style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
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
                                              style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
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
                          ));
                    }):SizedBox(),
                Column( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(heroTag:"mic",
                            backgroundColor: AppColors.gren,
                            child: Icon(mute?Icons.mic_off:Icons.mic,color: Colors.black,),
                            onPressed: () => _toggleMic()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(heroTag:"speaker",
                            backgroundColor: AppColors.pink2,
                            child: Icon(speaker?Icons.volume_up:Icons.volume_off,color: Colors.black,),
                            onPressed: () => _toggleSpeaker()),
                      )
                    ],),
                    SizedBox(height: 5,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: endingCall?Center(child: CircularProgressIndicator()):FloatingActionButton(heroTag:"end",
                            backgroundColor: AppColors.reddark,
                            child: Icon(Icons.call_end),
                            onPressed: () => _disconnectRoom()),
                      ),

                    ],),
                  ],
                ),


              ],
            ),
          ),

        ),
      ),
    );
  }
  _toggleMic(){
    setState(() {
      mute = !mute;
    });
    engine.muteLocalAudioStream(mute);
  }
  _toggleSpeaker(){
    setState(() {
      speaker = !speaker;
    });

    if(speaker)
      engine.adjustPlaybackSignalVolume(400);
    else
      engine.adjustPlaybackSignalVolume(100);
  }
  void _disconnectRoom() {
    if(widget.user.userType=="CONSULTANT")
      confirmEndCallDialog();
    else
      Navigator.pop(context);
  }
  _endMeating() async {
    try{
      setState(() {
        endingCall=true;
      });
      //close appointment
      await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId).set({
        'allowCall':false,
        'appointmentStatus': "closed",
        'closedUtcTime':DateTime.now().toUtc().toString(),
        'closedDate': {
          'day': DateTime.now().toUtc().day,
          'month': DateTime.now().toUtc().month,
          'year': DateTime.now().toUtc().year,
        },
      }, SetOptions(merge: true));
     //close order
      await FirebaseFirestore.instance.collection(Paths.ordersPath).doc(widget.appointment.orderId).set({
        'answeredCallNum': 1,
        'orderStatus':"closed",
        'remainingCallNum':0
      }, SetOptions(merge: true));

      //update consultbalance
      DocumentReference docRef = FirebaseFirestore.instance.collection(Paths.settingPath).doc("pzBqiphy5o2kkzJgWUT7");
      final DocumentSnapshot taxDocumentSnapshot = await docRef.get();
      var taxes= Setting.fromMap(taxDocumentSnapshot.data() as Map).taxes;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(Paths.usersPath).doc(widget.user.uid).get();
      GroceryUser currentUser = GroceryUser.fromMap(documentSnapshot.data() as Map);
      dynamic taxesvalue=(widget.appointment.callPrice*taxes)/100;
      dynamic consultBalance=widget.appointment.callPrice-taxesvalue;
      dynamic payedBalance=consultBalance;
      if(currentUser.payedBalance!=null)
        payedBalance=payedBalance+currentUser.payedBalance;

      if(currentUser.balance!=null)
        consultBalance=consultBalance+currentUser.balance;

      int consultOrdersNumbers=1;
      if(currentUser.ordersNumbers!=null)
        consultOrdersNumbers=1+currentUser.ordersNumbers!;
      await FirebaseFirestore.instance.collection(Paths.usersPath).doc(widget.user.uid).set({
        'balance':consultBalance,
        'payedBalance':payedBalance,
        'ordersNumbers':consultOrdersNumbers
      }, SetOptions(merge: true));
      setState(() {
        endingCall=false;
      });
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (route) => false,
      );
    }catch(e){print("enderror");
    print(e.toString());}

  }
  confirmEndCallDialog() {
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
        content: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Center(
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 60,),
                      Container(height: 70,width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.white,
                          ),
                          child: Image.asset('assets/icons/icon/Group2887.png', fit:BoxFit.contain,height: 70,width: 70)

                      ),


                      IconButton(
                        onPressed: ()
                        {
                          Navigator.pop(context);
                        },
                        icon: Image.asset('assets/icons/icon/Group2888.png',height: 15,width: 15),
                      ),

                    ],
                  )
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                getTranslated(context, "areYouSureCloseAppointment"),
                style: TextStyle(fontFamily: 'fontFamily',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId).set({
                        'allowCall':false,
                      }, SetOptions(merge: true));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 35,
                      width: 50,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:  AppColors.lightPink,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          getTranslated(context, "no"),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                              color: AppColors.pink,
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  endingCall?Center(child: CircularProgressIndicator()):InkWell(
                    onTap: () async {
                      setState(() {
                        endingCall=true;
                      });
                      _endMeating();
                    },
                    child: Container(
                      height: 35,
                      width: 50,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:  AppColors.pink,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          getTranslated(context, "yes"),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                            color: Colors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          );},
        ),
      ), barrierDismissible: false,
      context: context,
    );
  }
}