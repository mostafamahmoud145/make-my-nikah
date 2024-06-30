
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../config/app_values.dart';

typedef _Fn = void Function();
Future<String> _getTempPath(String path) async {
  var tempDir = await getTemporaryDirectory();
  var tempPath = tempDir.path;
  return tempPath + '/' + path;
}

class AudioRecorder extends StatefulWidget {
  final onSendMessage;
  final focusNode;
  final String loggedId;
  const AudioRecorder(
      { this.onSendMessage,
        required this.loggedId,
        this.focusNode});
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  String statusText="";
  bool isComplete = false;
  bool isShowSticker = false;
  bool uploadingRecord = false,recording=false;
  late String recordFilePath;int i=0;
  @override
  void initState() {
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
    return  Material(
            child: uploadingRecord
                ? Container(
                   height: convertPtToPx(20).h,
                      width: convertPtToPx(20).w,
                  child: Center(
                      child: CircularProgressIndicator(
                      color: AppColors.reddark2,
                    )),
                )
                : Container(
              width: AppSize.w65.w,
              height: AppSize.h65.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO( 207, 0, 54,1),
                      Color.fromRGBO( 255, 47, 101,1)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,

                  )
              ),
                  child: InkWell(
                      child:  recording
                  ? Icon(Icons.pause_outlined,size: convertPtToPx(18.6), color: Colors.red)
                  : Padding(
                    padding:  EdgeInsets.all(AppPadding.p12.w),
                    child: SvgPicture.asset(
                                              AssetsManager.microphoneIconPath,
                          height: convertPtToPx(25.3).h,
                          width: convertPtToPx(16).w,
                          color: AppColors.white,
                        ),
                  ),
                      onTap: () =>recording?stopRecord():startRecord(),
                    ),
                ),
          );
   

  }
  @override
  void dispose() {
    super.dispose();
  }
  _Fn getRecorderFn() {
    /* if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return () {};
    }*/
    return recording ? stopRecord : startRecord;
  }
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  startRecord() async {
    print("startRecord11");
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      print("startRecord11qqq");
      recordFilePath = await getFilePath();
      //isComplete = false;
      setState(() {
        recording=true;
      });
      RecordMp3.instance.start(recordFilePath, (type) {
      });
    } else {
      print("startRecord11vvvvv");
    }

  }
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test1111_${DateTime.now().millisecondsSinceEpoch.toString()+widget.loggedId}.mp3";
  }
  stopRecord() async {
    print("startRecord11");
    setState(() {
      recording=false;
      uploadingRecord=true;
    });
    bool s = RecordMp3.instance.stop();
    if (s) {
      //statusText = "Record complete";
      //isComplete = true;
      setState(() {});
      if (recordFilePath != null && File(recordFilePath).existsSync()) {
        print("stopRecord000");
        File recordFile = new File(recordFilePath);
        uploadRecord(recordFile);
      }
      else
      {
        print("stopRecord111");
      }
    }
  }
  Future uploadRecord(File voice) async {
    Size size = MediaQuery.of(context).size;
    print("permission uploadRecord1");
    var uuid = Uuid().v4();
    Reference storageReference =firebase_storage.FirebaseStorage.instance.ref().child('audio/$uuid');
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
