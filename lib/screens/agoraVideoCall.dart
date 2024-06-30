/*

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/timeHelper.dart';
import 'package:grocery_store/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class AgoraVideoCall extends StatefulWidget {
  final AppAppointments appointment ;
  final GroceryUser user;
  final String appointmentId;
  final String consultName;
  const AgoraVideoCall({Key key, this.appointment, this.user, this.appointmentId, this.consultName}) : super(key: key);
  @override
  _AgoraVideoCallState createState() => _AgoraVideoCallState();
}

class _AgoraVideoCallState extends State<AgoraVideoCall>with SingleTickerProviderStateMixin {
  final Dependencies dependencies = new Dependencies();
  int _timer=0;  Timer timer; bool mic=true;
   AgoraClient client ;
  bool muted = false,endingCall=false,meetingStart=false,handfree=false,join=false,done=true,camera=false,firstTime=false;
  int minutes =0,  seconds=0;
  AppAppointments _appointment;
  @override
  void initState() {
    super.initState();
    dependencies.stopwatch.start();
    startTimer();
    getAppointment();
    client= AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "c43f829465b64368b158b8d82ffc3110",
      channelName:widget.appointmentId ,
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
);
    initAgora();
  }
  void startTimer() {
    _timer = 0;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(mounted){
        setState(() {
          _timer++;
        });
      if(_timer==600)
       {  print("ttttt");
         _endMeating(context);}
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
  void initAgora() async {
    await client.initialize();

  }
  getAppointment()async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointmentId).get();
    setState(() {
      _appointment = AppAppointments.fromMap(documentSnapshot);
    });
    print("aaallll");
    print(_appointment.lessonTime);
  }
  @override
  Widget build(BuildContext context) {
    print("aaa0");
    if(client.users.length>1)
      {setState(() {
        join=true;
        print("yarab11111");
      });}
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar:AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.6),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        width: 38.0,
                        height: 35.0,
                        child: Icon(
                          Icons.arrow_back,
                          color:Colors.white,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(widget.user==null?widget.consultName:widget.appointment.user.name),
                //client.users.length>1? Text("222"):Text("0000"),
                _appointment==null?CircularProgressIndicator():(join&&_appointment!=null)?TweenAnimationBuilder<Duration>(
                    duration: Duration(minutes: _appointment.lessonTime),
                    tween: Tween(begin: Duration(minutes: _appointment.lessonTime), end: Duration.zero),
                    onEnd: () {
                      print('Timer ended');
                     // _onCallEnd();
                    },
                    builder: (BuildContext context, Duration value, Widget child) {
                      minutes = value.inMinutes;
                      seconds = value.inSeconds % 60;
                      if(minutes==5&&seconds==0)
                      {
                        setState(() {
                          firstTime=true;
                        });
                      }
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('$minutes:$seconds',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: minutes<5?Colors.red:Colors.white,
                                  fontSize: 15)));
                    }):TimerText(dependencies: dependencies),
              ],
            )),
        backgroundColor: Colors.black,

        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
              layoutType: Layout.floating,
                showAVState: true,
                showNumberOfUsers: true,
                disabledVideoWidget: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset('assets/icons/icon/Mask Group 47.png'
                    )
                  ),
                ),
              ),
              AgoraVideoButtons(
                client: client,
              ),
 Center(
                child: AgoraVideoButtons(
                  client: client,
                  extraButtons: [
                  ],
                  enabledButtons: [
                    BuiltInButtons.toggleMic,
                    BuiltInButtons.switchCamera,
                    BuiltInButtons.toggleCamera
                  ],
                ),
              ),
              Center(
                child: AgoraVideoButtons(
                  client: client,
                  extraButtons: [
                    FloatingActionButton(heroTag:"end",
                          backgroundColor: Colors.red,
                          child: Icon(Icons.call_end),
                          onPressed: () => _endMeating(context)),
                  ],
                  enabledButtons: [

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget build2(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF9D3A82),
        body: SafeArea(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      widget.user.userType=="CONSULTANT"?widget.appointment.user.name:widget.appointment.consult.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                TimerText(dependencies: dependencies),
                Stack(
                  children: [
                    AgoraVideoViewer(
                      client: client,
                    ),
                    AgoraVideoButtons(
                      client: client,
                    ),
                  ],
                ),
              AgoraVideoButtons(
                  client: client,
                  extraButtons: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(heroTag:"end",
                          backgroundColor: Colors.red,
                          child: Icon(Icons.call_end),
                          onPressed: () => _endMeating(context)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(heroTag:"mic",
                          backgroundColor: Colors.white,
                          child: Icon(mic?Icons.mic:Icons.mic_off,color: Colors.blue,),
                          onPressed: () => _toggleMic(context)),
                    )
                  ],
                  enabledButtons: [
                   // BuiltInButtons.toggleMic
                  ],
                ),

              ],
            ),
          ),

        ),
      ),
    );
  }
  _endMeating(BuildContext context) async {
    if(widget.user!=null)
      {
        await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId).set({
          'allowCall': false,
        }, SetOptions(merge: true));
        await client.sessionController.endCall();
        Navigator.pop(context);
      }
    await client.sessionController.endCall();
    Navigator.pop(context);
  }
  _toggleMic(BuildContext context) async {
    setState(() {
      mic=!mic;
    });
    await client.sessionController.toggleMute();
    //Navigator.pop(context);

  }
}
*/
