
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'package:permission_handler/permission_handler.dart';
import '../config/colorsFile.dart';
import '../localization/localization_methods.dart';
import 'package:wakelock/wakelock.dart';

class InterviewVideoCallScreen extends StatefulWidget {
  final String userId;


   InterviewVideoCallScreen({Key? key, required this.userId}) : super(key: key);


  @override
  _InterviewVideoCallScreenState createState() => _InterviewVideoCallScreenState();
}

class _InterviewVideoCallScreenState extends State<InterviewVideoCallScreen> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false,endingCall=false,join=false,done=true,camera=false,firstTime=false;
  late RtcEngine _engine;
  late Size size;
  int minutes =0,  seconds=0;
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try{
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    Wakelock.enable();
    await _engine.joinChannel(null, widget.userId, null, 0);
    }catch(e){print("agoraError"+e.toString());}
  }

  Future<void> _initAgoraRtcEngine() async {
    await [Permission.microphone].request();
    await [Permission.camera].request();
    _engine = await RtcEngine.create("a043844218f34404911b082cea15c57a");
    await _engine.enableAudio();
    await _engine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print("onJoinChannel");
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        print("ddddd1111111leave");
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        print("ddddd1111111userJoined");
        setState(() {
          final info = 'userJoined: $uid';

          _infoStrings.add(info);
          _users.add(uid);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          _infoStrings.add(info);
        });
      },
    ));
  }
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                onPressed: _onToggleMute,
                child: Icon(
                  muted ?Icons.mic: Icons.mic_off ,
                  color: muted ? Colors.white : Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? Colors.blueAccent : Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
              endingCall?Center(child: CircularProgressIndicator()):RawMaterialButton(
                onPressed: () => _onCallEnd(),
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.redAccent,
                padding: const EdgeInsets.all(15.0),
              ),
              RawMaterialButton(
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              )
            ], ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Scaffold(
      appBar:AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  getTranslated(context, "back"),
                  width: 30,
                  height: 30,
                ),
              ),
              Text(
                getTranslated(context, "interviews"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, "fontFamily"),
                  fontSize: 17.0,
                  color: AppColors.reddark2,
                ),
              ),
             SizedBox()
            ],
          )),
        backgroundColor: Colors.black,
        body:  Center(child:
              Stack(
                children: <Widget>[
                    _viewRows(),
                    Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                            child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _toolbar(),
                              ],
                            ),
                          ),
                      ),
                ],
              ),
          ),
      );
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid,channelId: '',)));
    return list;
  }
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }
  Widget _viewRows() {
    final views = _getRenderViews();
    if(views.length>1)
      setState(() {
        join=true;
      });
    else
      setState(() {
        join=false;
      });

    return views.length==1?Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        )):Container(
         child: Stack( 
          children: <Widget>[
            //_expandedVideoRow([views[0]]),
            Positioned.fill(child: views[1]),
            Positioned(top:0,left: 0,child: Container(height:size.width*.35,width:size.width*.35,child: views[0]))
          ],
        ));

  }



  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });

    _engine.muteLocalAudioStream(muted);
   _engine.setEnableSpeakerphone(muted);

  }
  void _onSwitchCamera() {
    setState(() {
      camera = !camera;
    });
    _engine.switchCamera();
  }
  void _onCallEnd() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    Wakelock.disable();
    Navigator.pop(context);
   }
}