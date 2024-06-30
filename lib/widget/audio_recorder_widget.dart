/*
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

typedef _Fn = void Function();
Future<String> _getTempPath(String path) async {
  var tempDir = await getTemporaryDirectory();
  var tempPath = tempDir.path;
  return tempPath + '/' + path;
}

class AudioRecorder extends StatefulWidget {
  final onSendMessage;
  final focusNode;
  final String theme;
  const AudioRecorder(
      {required this.onSendMessage,
        required this.theme,
        required this.focusNode});
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String _mPathAAC = '';
  String _mPathMP3 = '';
  bool isShowSticker = false;
  bool uploadingRecord = false;

  @override
  void initState() {
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    widget.focusNode.addListener(onFocusChange);
    super.initState();
  }

  void onFocusChange() {
    if (widget.focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("uploadingRecord: $uploadingRecord");
    return uploadingRecord
        ? Center(child: CircularProgressIndicator())
        : ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: getRecorderFn(),
      child: _mRecorder.isRecording
          ? Icon(Icons.pause_outlined, color: Colors.red)
          : Icon(
        Icons.mic,
        color: widget.theme == "light"
            ? Theme.of(context).primaryColor
            : Colors.black,
      ),
    );
  }

  ////===============
  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mRecorder.closeAudioSession();
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    _mPathAAC = await _getTempPath('flutter_sound_example.aac');
    _mPathMP3 = await _getTempPath('flutter_sound_example.mp3');

    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording, convertFile(), and playback -------

  void record() {
    _mRecorder
        .startRecorder(
      toFile: _mPathAAC,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    if (_mRecorder != null)
      await _mRecorder.stopRecorder().then((value) {
        setState(() {
          uploadingRecord = true;
          _mplaybackReady = true;
        });
        sendVoice();
      });
  }

  Future<void> play() async {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);

    await FlutterSoundHelper()
        .convertFile(_mPathAAC, Codec.aacADTS, _mPathMP3, Codec.mp3);
    await _mPlayer.startPlayer(
        codec: Codec.mp3,
        fromURI: _mPathMP3,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }

  void stopPlayer() {
    if (_mPlayer != null)
      _mPlayer.stopPlayer().then((value) {
        setState(() {});
      });
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return () {};
    }
    return _mRecorder.isStopped ? record : stopRecorder;
  }

  _Fn getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      return () {};
    }
    return _mPlayer.isStopped ? play : stopPlayer;
  }

  Future<void> sendVoice() async {
    await FlutterSoundHelper()
        .convertFile(_mPathAAC, Codec.aacADTS, _mPathMP3, Codec.mp3);
    File recordFile = new File(_mPathMP3);
    uploadRecord(recordFile);
    */
/*  await _mPlayer.startPlayer(codec: Codec.mp3, fromURI: _mPathMP3,  whenFinished: () {
        setState(() {});
        });*//*

  }

  Future uploadRecord(File voice) async {
    Size size = MediaQuery.of(context).size;

    var uuid = Uuid().v4();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('profileImages/$uuid');
    await storageReference.putFile(voice);

    var url = await storageReference.getDownloadURL();
    print("recording file222");
    print(url);
    widget.onSendMessage(url, "voice", size);
    setState(() {
      uploadingRecord = false;
    });
  }
}
*/
