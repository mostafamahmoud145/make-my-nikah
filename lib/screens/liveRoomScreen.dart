/*
import 'dart:developer';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/media_recorder.dart' as media_recorder;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const appId = "dae8f567dd334c49ac1e82c2ff0d2c43";

class LiveStream extends StatefulWidget {
  const LiveStream({Key? key}) : super(key: key);

  @override
  State<LiveStream> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  media_recorder.MediaRecorder? _mediaRecorder;

  bool isJoined = false, switchCamera = true, switchRender = true;
  List<int> remoteUid = [];
  bool _isStartedMediaRecording = false;
  String _recordingFileStoragePath = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RtcLocalView.SurfaceView(),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () async {
              await _engine.disableVideo();
              await _engine.disableAudio();
              await _dispose();
              Get.back();
            },
            child: Icon(
              Icons.back_hand,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _dispose() async {
    await _stopMediaRecording();
    await _mediaRecorder?.releaseRecorder();
    await _engine.destroy();
  }

  Future<void> _stopMediaRecording() async {
    await _mediaRecorder?.stopRecording();
    setState(() {
      _recordingFileStoragePath = '';
      _isStartedMediaRecording = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera, Permission.storage]
        .request();

    //create the engine
    _engine = await RtcEngine.create(appId);
    _engine.leaveChannel();

    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    await _joinChannel();
  }

  Future<void> _startMediaRecording() async {
    media_recorder.MediaRecorderObserver observer =
    media_recorder.MediaRecorderObserver(
      onRecorderStateChanged: (RecorderState state, RecorderErrorCode error) {
        log('onRecorderStateChanged state: $state, error: $error');
      },
      onRecorderInfoUpdated: (RecorderInfo info) {
        log('onRecorderInfoUpdated info: ${info.toJson()}');
        GallerySaver.saveVideo(info.fileName).then((value) {
          print("done");
        });
      },
    );
    _mediaRecorder = media_recorder.MediaRecorder.getMediaRecorder(
      _engine,
      callback: observer,
    );

    Directory appDocDir = Platform.isAndroid
        ? (await getExternalStorageDirectory())!
        : await getApplicationDocumentsDirectory();
    String p = path.join(appDocDir.path, 'testing.mp4');

    await _mediaRecorder?.startRecording(MediaRecorderConfiguration(
        storagePath: p, containerFormat: MediaRecorderContainerFormat.MP4));

    setState(() {
      _recordingFileStoragePath = 'Recording file storage path: $p';
      _isStartedMediaRecording = true;
    });
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

    await _engine
        .joinChannel("", "testing".toString(), "", 0)
        .catchError((onError) {
      print('error ${onError.toString()}');
    });

    await _engine.enableVideo();
    await _engine.enableAudio();
    _startMediaRecording();
  }
}*/
