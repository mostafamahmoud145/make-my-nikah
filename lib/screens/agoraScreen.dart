/*

import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/timeHelper.dart';
import 'package:grocery_store/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class AgoraScreen extends StatefulWidget {
  final AppAppointments appointment ;
  final GroceryUser user;

  const AgoraScreen({Key key, this.appointment, this.user}) : super(key: key);
  @override
  _AgoraScreenState createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen>with SingleTickerProviderStateMixin {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false,callStart=false;

  RtcEngine engine;
  final Dependencies dependencies = new Dependencies();
  int _timer=0;  Timer timer; bool mute=false,speaker=false;
  AgoraClient client ;
  @override
  void initState() {
    super.initState();
    initPlatformState();

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
        //_endMeating(context);
        }

      }
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    if(timer!=null)
    timer.cancel();
    if(widget.user!=null&&widget.user.userType=="CONSULTANT")
      await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId).set({
        'allowCall':false,
      }, SetOptions(merge: true));
    engine.leaveChannel();
    engine.destroy();
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
      dependencies.stopwatch.start();
      startTimer();
      setState(() {
         callStart=true;
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = 0;
      });
    }));
    await engine.joinChannel(null, widget.appointment.appointmentId, null, 0);
  }

  @override
  Widget build(BuildContext context) {

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
                      ( widget.user.uid==widget.appointment.consult.uid)?widget.appointment.user.name:widget.appointment.consult.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 2),
                    ( widget.user.uid==widget.appointment.consult.uid&&callStart==false)?Text(getTranslated(context, "waitAgora")+" "+" "+
                          getTranslated(context,"join"),
                      style: Theme.of(context).textTheme.headlineSmall
                          .copyWith(color: Colors.white),
                    ): SizedBox(),
                    SizedBox(height: 8),
                  ],
                ),
                TimerText(dependencies: dependencies),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(heroTag:"mic",
                      backgroundColor: Colors.white,
                      child: Icon(mute?Icons.mic_off:Icons.mic,color: Colors.blue,),
                      onPressed: () => _toggleMic()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(heroTag:"speaker",
                      backgroundColor: Colors.white,
                      child: Icon(speaker?Icons.volume_up:Icons.volume_off,color: Colors.blue,),
                      onPressed: () => _toggleSpeaker()),
                )
              ],),
              SizedBox(height: 5,),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(heroTag:"end",
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end),
                      onPressed: () => _endMeating()),
                ),

              ],)

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
  _endMeating() async {
    if(widget.user!=null&&widget.user.userType=="CONSULTANT")
      await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId).set({
        'allowCall':false,
      }, SetOptions(merge: true)).then((value) =>  Navigator.pop(context));
    else
    Navigator.pop(context);
  }
}*/
