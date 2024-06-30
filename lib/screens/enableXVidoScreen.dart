/*

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enx_flutter_plugin/enx_flutter_plugin.dart';
import 'package:enx_flutter_plugin/enx_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'dart:async';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/AppAppointments.dart';
import '../models/setting.dart';
import '../models/user.dart';
import '../widget/reviewDialog.dart';
import 'addReviewScreen.dart';

class MyConfApp extends StatefulWidget {
  final String token;
  AppAppointments appointment;
  final GroceryUser user;

  MyConfApp({required this.token, required this.user, required this.appointment,});

  @override
  Conference createState() => Conference();
}

class Conference extends State<MyConfApp> {
  bool isAudioMuted = false;
  bool isVideoMuted = false;
  bool isScreenShare = false;
  String speaker = "SPEAKER_PHONE";
  bool firstTime = false, join = false, endingCall = false;
  int minutes = 0, seconds = 0, num = 0;
  String? streamId, roomId;
  String? roomID;
  String? clientID;
  Size? size;

  //var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  @override
  void initState() {
    super.initState();
    print('here 1555555500000');
    initEnxRtc();
    if (Platform.isAndroid) disableScreenShots(true);
    _addEnxrtcEventHandlers();
  }

  @override
  void dispose() {
    updateCallCost();
    super.dispose();
  }

  Future<void> updateCallCost() async {
    print("updateCallCost");
    var cost = widget.appointment.callCost + (.024 * (20 - minutes));
    await FirebaseFirestore.instance
        .collection(Paths.appAppointments)
        .doc(widget.appointment.appointmentId)
        .update({
      'callCost': cost,
    });
  }

  disableScreenShots(bool state) async {
    if (state) {
      // this method to user can't take screenshot your application
      // iosSecureScreenShotChannel.invokeMethod("secureiOS");
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      // this method to user can take screenshot your application
      //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }



  Future<void> initEnxRtc() async {
    Map<String, dynamic> map2 = {
      'minWidth': 320,
      'minHeight': 180,
      'maxWidth': 1280,
      'maxHeight': 720
    };
    Map<String, dynamic> map1 = {
      'audio': true,
      'video': widget.appointment.consultType == "video" ? true : false,
      'data': true,
      'framerate': 30,
      'auto_recording': true,
      'maxVideoBW': 1500,
      'minVideoBW': 150,
      'audioMuted': false,
      'videoMuted': widget.appointment.consultType == "video" ? false : true,
      'name': 'flutter',
      'videoSize': map2
    };
    print('here 2');
    Map<String, dynamic> roomInfo = {
      'allow_reconnect': true,
      'number_of_attempts': 3,
      'timeout_interval': 15,
    };
    await EnxRtc.joinRoom(widget.token, map1, roomInfo, []);
    print('here 3');
  }

  void _addEnxrtcEventHandlers() {
    print('here 4');
    EnxRtc.onRoomConnected = (Map<dynamic, dynamic> map) {
      if (mounted)
        setState(() {
          print('onRoomConnectedFlutter' + jsonEncode(map));
        });
      EnxRtc.publish();
    };
    print('here 5');
    EnxRtc.onPublishedStream = (Map<dynamic, dynamic> map) {
      if (mounted)
        setState(() {
          print('onPublishedStream' + jsonEncode(map));
          EnxRtc.setupVideo(0, 0, true, 300, 200);
        });
    };
    print('here 6');
    EnxRtc.onStreamAdded = (Map<dynamic, dynamic> map) {
      print('onStreamAdded' + jsonEncode(map));
      print('onStreamAdded Id' + map['streamId']);
      String streamId = '';
      if (mounted)
        setState(() {
          streamId = map['streamId'];
        });
      EnxRtc.subscribe(streamId);
    };
    print('here 7');
    EnxRtc.onRoomError = (Map<dynamic, dynamic> map) {
      if (mounted)
        setState(() {
          print('onRoomError' + jsonEncode(map));
        });
    };
    EnxRtc.onNotifyDeviceUpdate = (String deviceName) {
      print('onNotifyDeviceUpdate' + deviceName);
    };
    print('here 8');
    EnxRtc.onActiveTalkerList = (Map<dynamic, dynamic> map) {
      print('onActiveTalkerList ' + map.toString());
      print('here 9');
      print(map['streamId']);
      if (map['streamId'] == "2")
        setState(() {
          join = true;
        });
      final items = (map['activeList'] as List)
          .map((i) => new ActiveListModel.fromJson(i));
      if (items != null && items.length > 0) {
        print('here 10');
        if (mounted)
          setState(() {
            for (final item in items) {
              if (!_remoteUsers.contains(item.streamId)) {
                print('_remoteUsers ' + map.toString());
                _remoteUsers.add(item.streamId);
              }
            }
          });
      }
    };
    print('here 11');
    EnxRtc.onEventError = (Map<dynamic, dynamic> map) {
 setState(() {
        print('onEventError' + jsonEncode(map));
      });

    };
    print('here 12');
    EnxRtc.onEventInfo = (Map<dynamic, dynamic> map) {
setState(() {
        print('onEventInfo' + jsonEncode(map));
      });

    };
    print('here 13');
    EnxRtc.onUserConnected = (Map<dynamic, dynamic> map) {
 setState(() {
        print('onUserConnected' + jsonEncode(map));
      });

    };
    EnxRtc.onUserDisConnected = (Map<dynamic, dynamic> map) {
 setState(() {
        print('onUserDisConnected' + jsonEncode(map));
      });

    };
    print('here 14');
    EnxRtc.onRoomDisConnected = (Map<dynamic, dynamic> map) {
      //Navigator.pop(context, '/Conference');
      // setState(() {
      //   print('onRoomDisConnected' + jsonEncode(map));
      //   Navigator.pop(context, '/Conference');
      // });
    };
    print('here 15');
    EnxRtc.onAudioEvent = (Map<dynamic, dynamic> map) {
      print('onAudioEvent' + jsonEncode(map));
      if (mounted)
        setState(() {
          if (map['msg'].toString() == "Audio Off") {
            isAudioMuted = true;
          } else {
            isAudioMuted = false;
          }
        });
    };
    print('here 16');
    EnxRtc.onVideoEvent = (Map<dynamic, dynamic> map) {
      print('onVideoEvent' + jsonEncode(map));
      if (mounted)
        setState(() {
          if (map['msg'].toString() == "Video Off") {
            isVideoMuted = true;
          } else {
            isVideoMuted = false;
          }
        });
    };
    print('here 17');
  }

  void _setMediaDevice(String value) {
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      speaker = value;
    });
    EnxRtc.switchMediaDevice(value);
  }

  createDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Media Devices'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: deviceList != null ? deviceList!.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(deviceList![index].toString()),
                          onTap: () =>
                              _setMediaDevice(deviceList![index].toString()),
                        );
                      },
                    ),
                  )
                ],
              ));
        });
  }

  Future<void> _disconnectRoom() async {
    EnxRtc.disconnect();
    if (!(Platform.isIOS)) disableScreenShots(false);
    if (widget.user.userType == "CONSULTANT")
      confirmEndCallDialog(size!);
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

  showAddAppointmentDialog() async {
    bool isProceeded = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ReviewDialog(
            consultId: widget.appointment.consult.uid,
            userId: widget.appointment.user.uid,
            appointmentId: widget.appointment.appointmentId);
      },
    );
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
          .doc(widget.user.uid)
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
          .doc(widget.user.uid)
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
                            child: Image.asset('assets/icons/icon/Group2887.png',
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
                                  color: AppColors.pink,
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
                            color: AppColors.pink,
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

  speakerDialog(Size size) {
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: deviceList != null ? deviceList!.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(deviceList![index].toString()),
                        onTap: () =>
                            _setMediaDevice(deviceList![index].toString()),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  void _toggleAudio() {
    // EnxRtc.captureScreenShot(streamId);
    if (isAudioMuted) {
      EnxRtc.muteSelfAudio(false);
    } else {
      EnxRtc.muteSelfAudio(true);
    }
  }

  void _toggleVideo() {
    if (isVideoMuted) {
      EnxRtc.muteSelfVideo(false);
    } else {
      EnxRtc.muteSelfVideo(true);
    }
  }

  void _toggleSpeaker() async {
    if (speaker == "SPEAKER_PHONE")
      setState(() {
        speaker = "EARPIECE";
      });
    else
      setState(() {
        speaker = "SPEAKER_PHONE";
      });
    EnxRtc.switchMediaDevice(speaker);
   List<dynamic> list = await EnxRtc.getDevices();
    setState(() {
      deviceList = list;
    });
    print('deviceList');
    print(deviceList);
    speakerDialog(size!);

  }

  void _toggleCamera() {
    EnxRtc.switchCamera();
  }

  int remoteView = -1;
  List<dynamic>? deviceList;

  Widget _viewRows() {
    return Column(
      children: <Widget>[
        for (final widget in _renderWidget)
          Expanded(
            child: Container(
              child: widget,
            ),
          )
      ],
    );
  }

  Iterable<Widget> get _renderWidget sync* {
    for (final streamId in _remoteUsers) {
      double width = MediaQuery.of(context).size.width;
      yield EnxPlayerWidget(streamId,
          local: false,
          width: width.toInt(),
          height: MediaQuery.of(context).size.height.toInt()); //380);
    }
  }

  final _remoteUsers = <int>[];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.appointment.consultType == "video"
          ? Colors.black
          : AppColors.lightGrey,
      body:
      widget.appointment.consultType == "video" ? videoCall() : audioCall(),
    );
  }

  Widget videoCall() {
    return Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Card(
              color: AppColors.black,
              child: Container(
                height: MediaQuery.of(context).size!.height,
                width: MediaQuery.of(context).size!.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(child: _viewRows()),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            boxShadow: [BoxShadow()],
                            //border: Border.all(color: AppColors.lightGrey,width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 120,
                          width: 100,
                          child: EnxPlayerWidget(0,
                              local: true, width: 100, height: 120),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.user.userType == "CONSULTANT"
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
                        _disconnectRoom();
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            endingCall
                                ? Center(child: CircularProgressIndicator())
                                : InkWell(
                              onTap: () {
                                _disconnectRoom();
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.red,
                                  ),
                                  child: Icon(
                                    Icons.call_end_rounded,
                                    color: AppColors.white,
                                    size: 20,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                _toggleSpeaker();
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.gren,
                                  ),
                                  child: Icon(
                                    speaker == "EARPIECE"
                                        ? Icons.volume_off
                                        : Icons.volume_up_rounded,
                                    color: AppColors.balck,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _toggleAudio();
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.pink,
                              ),
                              child: Icon(
                                isAudioMuted ? Icons.mic_off : Icons.mic,
                                color: AppColors.black,
                                size: 20,
                              )),
                        ),
 Row(mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            InkWell(onTap:(){_toggleAudio();},
                              child: Container(width:40,height: 40,
                                  padding:EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.pink,),
                                  child:
                                  Icon(isAudioMuted? Icons.mic_off:Icons.mic,color:AppColors.black,size: 20, )),
                            ),
                            SizedBox(width: 10,),
                            InkWell(onTap:(){_toggleVideo();},
                              child: Container(width:40,height: 40,
                                  padding:EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.green,),
                                  child:
                                  Icon(isVideoMuted? Icons.visibility_off:Icons.remove_red_eye,color:AppColors.black,size: 20, )),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget audioCall() {
    size = MediaQuery.of(context).size;
    return Container(
        color: AppColors.black,
        child: Stack(
          children: <Widget>[
            Card(
              color: AppColors.black,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: AppColors.black,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(child: _viewRows()),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: size!.height * .15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.white,
                          ),
                          child: Image.asset('assets/icons/icon/Mask Group 47.png',
                              fit: BoxFit.fill, height: 70, width: 70))),
                  Text(
                    widget.user.userType == "CONSULTANT"
                        ? widget.appointment.user.name
                        : widget.appointment.consult.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.gren,
                      fontSize: 15.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                height: 0,
                width: 0,
                color: Colors.transparent,
                child: EnxPlayerWidget(0, local: true, width: 0, height: 0),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<Duration>(
                      duration: Duration(minutes: 20),
                      tween: Tween(
                          begin: Duration(minutes: 20), end: Duration.zero),
                      onEnd: () {
                        _disconnectRoom();
                      },
                      builder:
                          (BuildContext context, Duration value, Widget? child) {
                        minutes = value.inMinutes;
                        seconds = value.inSeconds % 60;
                        return Text('$minutes:$seconds',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                minutes < 5 ? Colors.red : AppColors.gren,
                                fontSize: 15));
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                _toggleAudio();
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.pink,
                                  ),
                                  child: Icon(
                                    isAudioMuted ? Icons.mic_off : Icons.mic,
                                    color: AppColors.black,
                                    size: 20,
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                _toggleSpeaker();
                              },
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.gren,
                                  ),
                                  child: Icon(
                                    speaker == "EARPIECE"
                                        ? Icons.volume_off
                                        : Icons.volume_up_rounded,
                                    color: AppColors.balck,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                        endingCall
                            ? Center(child: CircularProgressIndicator())
                            : InkWell(
                          onTap: () {
                            _disconnectRoom();
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.red,
                              ),
                              child: Icon(
                                Icons.call_end_rounded,
                                color: AppColors.white,
                                size: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget audioCall2(Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: size!.height * .10,
                ),
                Center(
                    child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.white,
                        ),
                        child: Image.asset('assets/icons/icon/Mask Group 47.png',
                            fit: BoxFit.fill, height: 70, width: 70))),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user == null
                      ? widget.appointment.consult.name
                      : widget.appointment.user.name,
                  style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 2),
              ],
            ),
            TweenAnimationBuilder<Duration>(
                duration: Duration(minutes: 20),
                tween: Tween(begin: Duration(minutes: 20), end: Duration.zero),
                onEnd: () {
                  _disconnectRoom();
                },
                builder: (BuildContext context, Duration value, Widget? child) {
                  minutes = value.inMinutes;
                  seconds = value.inSeconds % 60;
                  return Text('$minutes:$seconds',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: minutes < 5 ? Colors.red : AppColors.gren,
                          fontSize: 15));
                }),
 TweenAnimationBuilder<Duration>(
                duration: Duration(minutes: 20),
                tween: Tween(begin: Duration(minutes: 20), end: Duration.zero),
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

                        ],
                      ));
                }),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                          heroTag: "mic",
                          backgroundColor: AppColors.gren,
                          child: Icon(
                            isAudioMuted ? Icons.mic_off : Icons.mic,
                            color: Colors.black,
                          ),
                          onPressed: () => _toggleAudio()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                          heroTag: "speaker",
                          backgroundColor: AppColors.pink2,
                          child: Icon(
                            speaker == "EARPIECE"
                                ? Icons.volume_off
                                : Icons.volume_up_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () => _toggleSpeaker()),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: endingCall
                          ? Center(child: CircularProgressIndicator())
                          : FloatingActionButton(
                          heroTag: "end",
                          backgroundColor: AppColors.reddark,
                          child: Icon(Icons.call_end),
                          onPressed: () => _disconnectRoom()),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveList {
  bool active;
  List<ActiveListModel> activeList = [];
  String event;

  ActiveList(this.active, this.activeList, this.event);

  factory ActiveList.fromJson(Map<dynamic, dynamic> json) {
    return ActiveList(
      json['active'] as bool,
      (json['activeList'] as List).map((i) {
        return ActiveListModel.fromJson(i);
      }).toList(),
      json['event'] as String,
    );
  }
}

class ActiveListModel {
  String name;
  int streamId;
  String clientId;
  String videoaspectratio;
  String mediatype;
  bool videomuted;

  ActiveListModel(this.name, this.streamId, this.clientId,
      this.videoaspectratio, this.mediatype, this.videomuted);

  // convert Json to an exercise object
  factory ActiveListModel.fromJson(Map<dynamic, dynamic> json) {
    int sId = int.parse(json['streamId'].toString());
    return ActiveListModel(
      json['name'] as String,
      sId,
//      json['streamId'] as int,
      json['clientId'] as String,
      json['videoaspectratio'] as String,
      json['mediatype'] as String,
      json['videomuted'] as bool,
    );
  }
}
*/
