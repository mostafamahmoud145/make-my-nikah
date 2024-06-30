
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'package:permission_handler/permission_handler.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import 'package:wakelock/wakelock.dart';

import '../models/AppAppointments.dart';
import '../models/setting.dart';
import '../models/user.dart';
import 'addReviewScreen.dart';

class BeautVideoCallScreen extends StatefulWidget {
  final AppAppointments appointment;
  final GroceryUser loggedUser;

  BeautVideoCallScreen({Key? key, required this.appointment, required this.loggedUser,}) : super(key: key);


  @override
  _BeautVideoCallScreenState createState() => _BeautVideoCallScreenState();
}

class _BeautVideoCallScreenState extends State<BeautVideoCallScreen> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false,endingCall=false,join=false,done=true,camera=false,firstTime=false,callStart=false,speaker = false;
  late RtcEngine _engine;
  late Size size;
  int minutes =0,  seconds=0;
  String? image,name;
  String appId="680d9b31416c46b3850f1709f2a54d9e",uidCloud="",sid="",resourceId='';
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    if (widget.loggedUser == null) {
    } else if (widget.loggedUser.uid == widget.appointment.consult.uid) {
      image = widget.appointment.user.image;
      name = widget.appointment.user.name;
    } else {
      image = widget.appointment.consult.image;
      name = widget.appointment.consult.name;

    }
    initialize();
  }

  Future<void> initialize() async {
    try{
      print("gggggginitialize");
      print(widget.appointment.appointmentId);
      await _initAgoraRtcEngine();
      _addAgoraEventHandlers();
      Wakelock.enable();
      await _engine.joinChannel(null, widget.appointment.appointmentId, null, 0);
    }catch(e){print("agoraError"+e.toString());}
  }

  Future<void> _initAgoraRtcEngine() async {
    await [Permission.microphone].request();
    await [Permission.camera].request();
    _engine = await RtcEngine.create(appId);
    await _engine.enableAudio();
    if(widget.appointment.consultType=="video")
       await _engine.enableVideo();
    else
      await _engine.disableVideo();
    _engine.adjustPlaybackSignalVolume(400);
    _engine.muteLocalAudioStream(muted);
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
        print("onJoinChannel111");
        print(uid);
        print(widget.appointment.appointmentId);
        print(channel);
        setState(() {
          uidCloud=uid.toString();
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
        /*if(widget.loggedUser.userType=="CONSULTANT") {
          acquire();
        }*/
        acquire();
      },
      leaveChannel: (stats) {
        print("ddddd1111111leave");
        Fluttertoast.showToast(
            msg: "You are alone now",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        print("ddddd1111111userJoined");

        setState(() {
          final info = 'userJoined: $uid';
           callStart=true;
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
                onPressed: _onTogglemuted,
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
      backgroundColor: Colors.black,
      body:  widget.appointment.consultType=="video"?videoCallWidget():audioCallWidget()
    );
  }
  Widget videoCallWidget(){
    return Center(child:
    Stack(
      children: <Widget>[
        _viewRows(),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.loggedUser.userType == "CONSULTANT"
                      ? widget.appointment.user.name
                      : widget.appointment.consult.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    color: AppColors.white,
                    fontSize: 15.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TweenAnimationBuilder<Duration>(
                    duration: Duration(minutes: 20),
                    tween: Tween(
                        begin: Duration(minutes: 20), end: Duration.zero),
                    onEnd: () {
                      _onCallEnd();
                    },
                    builder:
                        (BuildContext context, Duration value, Widget? child) {
                      minutes = value.inMinutes;
                      seconds = value.inSeconds % 60;
                      return Text('$minutes:$seconds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: minutes < 5 ? Colors.red : Colors.white,
                              fontSize: 15));
                    }),
                SizedBox(
                  height: 10,
                ),
                _toolbar(),
              ],
            ),
          ),
        ),

      ],
    ),
    );
  }
  Widget audioCallWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 30,),
              Center(
                child: Container(
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    // border: Border.all(color: AppColors.grey, width: 1),
                    shape: BoxShape.circle,
                    //color: AppColors.grey,
                  ),
                  child: image!.isEmpty && image != null
                      ? Image.asset(
                    'assets/icons/icon/Mask Group 47.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/icons/icon/load.gif',
                      placeholderScale: 0.5,
                      imageErrorBuilder: (context, error,
                          stackTrace) =>
                          Image.asset(
                              'assets/icons/icon/Mask Group 47.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.fill),
                      image: image!,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 250),
                      fadeInCurve: Curves.easeInOut,
                      fadeOutDuration:
                      Duration(milliseconds: 150),
                      fadeOutCurve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                name! == null ? " " : name!,
                style: TextStyle(
                  fontFamily: 'Ithra',
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 2),
              (callStart == false)
                  ? Text(
                getTranslated(context, "waitAgora") +
                    " " +
                    " " +
                    getTranslated(context, "join"),
                style: TextStyle(
                  fontFamily: 'Ithra',
                  fontSize: 10.0,
                  fontWeight: FontWeight.normal,
                  color: AppColors.pink,
                ),
              )
                  : SizedBox(),
              SizedBox(height: 8),
              callStart
                  ? TweenAnimationBuilder<Duration>(
                  duration: Duration(minutes: 20),
                  tween: Tween(
                      begin: Duration(minutes: 20),
                      end: Duration.zero),
                  onEnd: () {
                    print('Timer ended');
                    _onCallEnd();
                  },
                  builder: (BuildContext context2, Duration value,
                      Widget? child) {
                    minutes = value.inMinutes;
                    seconds = value.inSeconds % 60;
                    if (minutes == 5 && seconds == 0) {
                      firstTime = true;
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
                                        : AppColors.white,
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
                                fontFamily: 'Ithra',
                                fontSize: 11.0,
                                color: AppColors.red,
                              ),
                            )
                                : SizedBox(),

                          ],
                        ));
                  })
                  :  Text('0:0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color:  AppColors.white,
                      fontSize: 15)),
            ],
          ),
          SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      heroTag: "mic",
                      backgroundColor: Colors.black,
                      child: Icon(
                        muted ?Icons.mic_off: Icons.mic,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () => _onTogglemuted()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FloatingActionButton(
                          heroTag: "end",
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.call_end,
                            size: 20,color: Colors.white,
                          ),
                          onPressed: () => _onCallEnd()),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      heroTag: "speaker",
                      backgroundColor: Colors.black,
                      child: Icon(
                        speaker ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () => _toggleSpeaker()),
                )
              ],
            ),
          ),
        ],
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
            Positioned(top:0,left: 0,child: Container(height:size.width*.40,width:size.width*.35,child: views[0]))
          ],
        ));

  }


  _toggleSpeaker() {
    setState(() {
      speaker = !speaker;
    });

    if (speaker)
      _engine.adjustPlaybackSignalVolume(400);
    else
      _engine.adjustPlaybackSignalVolume(100);
  }
  void _onTogglemuted() {
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
  Future<void> _onCallEnd() async {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    Wakelock.disable();
    stopRecording();
    if (widget.loggedUser.userType == "CONSULTANT")
     {
       confirmEndCallDialog(size);
     }
    else {
      setState(() {
        endingCall = true;
      });
      DocumentReference docRef2 = FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .doc(widget.appointment.appointmentId);
      final DocumentSnapshot documentSnapshot2 = await docRef2.get();
      var appointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
      Navigator.pop(context); //pop enableX screen
      if (appointment.appointmentStatus == "closed")
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddReviewScreen(
                consultId: widget.appointment.consult.uid,
                userId: widget.appointment.user.uid,
                appointmentId: widget.appointment.appointmentId),
          ),
        );
    }

  }
  _endMeating() async {
    try {
      setState(() {
        endingCall = true;
      });
      //close appointment
      await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .doc(widget.appointment.appointmentId)
          .set({
        'allowCall': false,
        'appointmentStatus': "closed",
        'closedUtcTime': DateTime.now().toUtc().toString(),
        'closedDate': {
          'day': DateTime.now().toUtc().day,
          'month': DateTime.now().toUtc().month,
          'year': DateTime.now().toUtc().year,
        },
      }, SetOptions(merge: true));
      //close order
      await FirebaseFirestore.instance
          .collection(Paths.ordersPath)
          .doc(widget.appointment.orderId)
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
      var taxes = Setting.fromMap(taxDocumentSnapshot.data() as Map).taxes;
      print("endmeeting2");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.loggedUser.uid)
          .get();
      GroceryUser currentUser = GroceryUser.fromMap(documentSnapshot.data() as Map);
      dynamic taxesvalue = (widget.appointment.callPrice * taxes) / 100;
      dynamic consultBalance = widget.appointment.callPrice - taxesvalue;
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
          .doc(widget.loggedUser.uid)
          .set({
        'balance': consultBalance,
        'payedBalance': payedBalance,
        'ordersNumbers': consultOrdersNumbers
      }, SetOptions(merge: true));
      setState(() {
        endingCall = false;
      });
      print("endmeeting4");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      //Navigator.pushNamed(context, "/");
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (route) => false,
      );

    } catch (e) {
      print("enderror");
      print(e.toString());
    }
  }
  confirmEndCallDialog(Size size) {
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
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 60,
                        ),
                        Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: Colors.white,
                            ),
                            child: Image.asset('assets/icons/icon/Union.png',
                                fit: BoxFit.contain, height: 70, width: 70)),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset('assets/icons/icon/Group2888.png',
                              height: 15, width: 15),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  getTranslated(context, "areYouSureCloseAppointment"),
                  style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection(Paths.appAppointments)
                              .doc(widget.appointment.appointmentId)
                              .set({
                            'allowCall': false,
                          }, SetOptions(merge: true));
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 35,
                          width: 50,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.lightPink,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              getTranslated(context, "no"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: getTranslated(context, "fontFamily"),
                                  color: AppColors.reddark2,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                      endingCall
                          ? Center(child: CircularProgressIndicator())
                          : InkWell(
                        onTap: () async {
                          setState(() {
                            endingCall = true;
                          });
                          _endMeating();
                        },
                        child: Container(
                          height: 35,
                          width: 50,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.reddark2,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              getTranslated(context, "yes"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: getTranslated(context, "fontFamily"),
                                color: Colors.white,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  //----------cloudrecording

  acquire() async {
    try{
      print("acquire0");
      var auth = 'Basic '+base64Encode(utf8.encode('64f81bc3dfd342be85288ee9804654f8:b32fe291b54a4b648466f3de02d8c513'));

      final uri = Uri.parse('https://api.agora.io/v1/apps/'+appId+'/cloud_recording/acquire');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':auth,
        'Connection':'keep-alive',
        'Accept-Encoding':'gzip, deflate, br'
      };
      print("acquire1");
      Map<String, dynamic> body ={
        "cname": widget.appointment.appointmentId,
        "uid": uidCloud,
        "clientRequest": {}
      };
      print("acquire2");
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      var response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      String responseBody = response.body;
      print("acquire3");
      print(responseBody);
      var res = json.decode(responseBody);
      String _resourceId = res['resourceId'];
      if(mounted)setState(() {
        resourceId=_resourceId;
      });
      startRecording();

    }catch(e){
      print("acquireerror"+e.toString());

    }

  }
  startRecording() async {
    try{
      print("startRecording0");
      var auth = 'Basic '+base64Encode(utf8.encode('64f81bc3dfd342be85288ee9804654f8:b32fe291b54a4b648466f3de02d8c513'));

      final uri = Uri.parse('https://api.agora.io/v1/apps/'+appId+'/cloud_recording/resourceid/'+resourceId+'/mode/mix/start');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':auth,
        'Connection':'keep-alive',
        'Accept-Encoding':'gzip, deflate, br'
      };
      print("startRecording1");
      Map<String, dynamic> body2 ={
        "cname": widget.appointment.appointmentId,
        "uid": uidCloud,
        "clientRequest": {
          "token": "",
         /* "recordingConfig": {
            "maxIdleTime": 30,
            "streamMode": "default",
            "streamTypes": 2,
            "channelType": 0,
            "transcodingConfig": {
              "height": 640,
              "width": 360,
              "bitrate": 500,
              "fps": 15,
              "mixedVideoLayout": 1,
              "backgroundColor": "#FF0000"
            },
            "subscribeVideoUids": [
              "123",
              "456"
            ],
            "subscribeAudioUids": [
              "123",
              "456"
            ],
            "subscribeUidGroup": 0
          },
          "recordingFileConfig": {
            "avFileType": [
              "hls",
              "mp4"
            ]
          },*/
          "recordingConfig":{
            "channelType":0,
            "streamTypes":2,
            "audioProfile":1,
            "videoStreamType":0,
            "maxIdleTime":120,
            "transcodingConfig":{
              "width":360,
              "height":640,
              "fps":30,
              "bitrate":600,
              "maxResolutionUid":"1",
              "mixedVideoLayout":1
            }
          },
          "recordingFileConfig": {
            "avFileType": [
             "hls",
              "mp4"
            ]
          },
          "storageConfig": {
            "accessKey": "AKIAZHB3Y2IYF2YVWUE3",
            "region": 0,
            "bucket": "bucket-beaut-recording",
            "secretKey": "IRilLNeUYnCGq0CNeXIA4O+RfUR5odR+bKLz3/5c",
            "vendor": 1,
            /*"fileNamePrefix": [
              "directory1",
              "directory2"
             // widget.appointment.appointmentId,
              // DateTime.now().year.toString()+'-'+DateTime.now().month.toString()+'-'+DateTime.now().day.toString()
            ]*/
          }
        }
      };
      Map<String, dynamic> body ={
        "cname": widget.appointment.appointmentId,
        "uid": uidCloud,
        "clientRequest":{
          "token": "",
          "recordingConfig":{
            "channelType":0,
            "streamTypes":2,
            "audioProfile":1,
            "videoStreamType":0,
            "maxIdleTime":120,
            "transcodingConfig":{
              "width":360,
              "height":640,
              "fps":30,
              "bitrate":600,
              "maxResolutionUid":"1",
              "mixedVideoLayout":1
            }
          },
          "recordingFileConfig": {
            "avFileType": [
              "hls",
              "mp4"
            ]
          },
          "storageConfig":{
            "accessKey": "AKIAZHB3Y2IYF2YVWUE3",
            "region": 0,
            "bucket": "bucket-beaut-recording",
            "secretKey": "IRilLNeUYnCGq0CNeXIA4O+RfUR5odR+bKLz3/5c",
            "vendor": 1,
          }
        }};
      print("startRecording2");
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      var response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      String responseBody = response.body;
      print("startRecording3");
      print(responseBody);
      var res = json.decode(responseBody);
      String _sid = res['sid'];
      if(mounted)setState(() {
        sid=_sid;
      });

    }catch(e){
      print("startRecordingerror"+e.toString());

    }

  }
  stopRecording() async {
    try{
      print("stopRecording0");
      var auth = 'Basic '+base64Encode(utf8.encode('64f81bc3dfd342be85288ee9804654f8:b32fe291b54a4b648466f3de02d8c513'));

      final uri = Uri.parse('http://api.agora.io/v1/apps/'+appId+'/cloud_recording/resourceid/'+resourceId+'/sid/'+sid+'/mode/mix/stop');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':auth,
        'Connection':'keep-alive',
        'Accept-Encoding':'gzip, deflate, br'
      };
      print("stopRecording1");
      Map<String, dynamic> body ={
        "cname": widget.appointment.appointmentId,
        "uid": uidCloud,
        "clientRequest": {}
      };
      print("stopRecording2");
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      var response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      String responseBody = response.body;
      print("stopRecording3");
      print(responseBody);
      if(responseBody.contains("fileList")){
        print("stopRecording4");
        var res = json.decode(responseBody);
        var records=res['serverResponse']['fileList'][0]['fileName'];
        print(records);
        String amazonUrl="https://bucket-beaut-recording.s3.amazonaws.com/";
        DocumentReference docRef2 = FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId);
        final DocumentSnapshot documentSnapshot2 = await docRef2.get();
        var currentAppointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
        currentAppointment.roomList!.add(amazonUrl+records);
        print("stopRecording4");
        print( currentAppointment.roomList);
        await FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .doc(widget.appointment.appointmentId)
            .set({
          'roomList': currentAppointment.roomList,
        }, SetOptions(merge: true));
      }



    }catch(e){
      print("stopRecording"+e.toString());

    }

  }
}