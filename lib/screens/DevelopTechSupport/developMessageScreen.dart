
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'package:auto_direction/auto_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/widget/AutoDirection.dart';
import '../../FireStorePagnation/paginate_firestore.dart';
import '../../blocs/account_bloc/account_bloc.dart';
import '../../config/paths.dart';
import '../../localization/language_constants.dart';
import '../../localization/localization_methods.dart';
import '../../models/AppAppointments.dart';
import '../../models/DevelopTechSupport.dart';
import '../../models/SupportMessage.dart';
import '../../models/developMessage.dart';
import '../../models/order.dart';
import '../../models/setting.dart';
import '../../models/user.dart';
import '../../widget/AppointChatMessageItem.dart';
import '../../widget/developItem.dart';
import '../../widget/messageItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widget/processing_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../widget/rocordingWidget.dart';
var image;
File? selectedProfileImage;
typedef _Fn = void Function();
class DevelopMessageScreen extends StatefulWidget {
  final DevelopTechSupport develop ;
  final GroceryUser user;

  const DevelopMessageScreen({required this.develop, required this.user});

  @override
  _DevelopMessageScreenState createState() => _DevelopMessageScreenState();
}

class _DevelopMessageScreenState extends State<DevelopMessageScreen> {
  bool loading=false;
  late bool isShowSticker,answered=false,loadStatus=false;
  late String imageUrl;
  var stCollection = 'messages',theme;
  String text = "";
  late Size size;
  late AccountBloc accountBloc;
  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  String? dropdownTypeValue;
  final FocusNode focusNode = new FocusNode();
  bool recording = false,uploadingRecord=false;
  late String recordFilePath;int i=0;
  List<KeyValueModel> _typeArray = [
    KeyValueModel(key: "new", value: "New"),
    KeyValueModel(key: "open", value: "Open"),
    KeyValueModel(key: "done", value: "Done"),
    KeyValueModel(key: "closed", value: "Closed"),
  ];
  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    accountBloc = BlocProvider.of<AccountBloc>(context);

  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    getThemeName().then((theme) {
      setState(() {
        this.theme = theme;
      });
    });
    super.didChangeDependencies();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding( padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                        Expanded(
                          child: Text(
                            widget.develop.userName,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                              color: theme=="light"?Colors.black:Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ))),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text(
                getTranslated(context, "selectStatus"),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                  color:Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                  height: 40.0,width: size.width*.5,
                  decoration: BoxDecoration(
                      color: theme=="light"?Colors.white:Colors.transparent,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButton<String>(
                      hint: Text(
                        getTranslated(context, "selectStatus"),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                          //color: Colors.black,
                          fontSize: 15.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                      underline: Container(),
                      isExpanded: true,
                      value: dropdownTypeValue,
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: Colors.black),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                        color: Color(0xFF3b98e1),
                        fontSize: 13.0,
                        letterSpacing: 0.5,
                      ),
                      items: _typeArray
                          .map((data) => DropdownMenuItem<String>(
                          child: Text(
                            data.value.toString(),
                            style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                              color: Colors.black,
                              fontSize: 15.0,
                              letterSpacing: 0.5,
                            ),
                          ),
                          value: data.key.toString() //data.key,
                      ))
                          .toList(),
                      onChanged: (String? value) {
                        print(value);
                        setState(() {
                          dropdownTypeValue = value!;

                        });
                      },
                    ),
                  )),
            ],),
          ),
          loadStatus
              ? Center(child: CircularProgressIndicator())
              : Container(
            height: 45.0,
            width: size.width*.5,
            padding:
            const EdgeInsets.symmetric(horizontal: 0.0),
            child: MaterialButton(
              onPressed: () {
                //add notificationMap
                changeStatus(dropdownTypeValue!);
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                getTranslated(
                    context, "save"),
                style: GoogleFonts.poppins(
                  color: theme=="light"?Colors.white:Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          Expanded(
            child: PaginateFirestore(
              scrollController: listScrollController,
              reverse: true,
              itemBuilderType: PaginateBuilderType.listView,
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),//Change types accordingly
              itemBuilder: ( context, documentSnapshot,index) {
                return  DevelopItem(
                    message: DevelopMessage.fromMap(documentSnapshot[index].data() as Map),
                    user:widget.user
                );

              },
              query: FirebaseFirestore.instance.collection(Paths.dvelopChat)
                  .where('developTechSupportId', isEqualTo: widget.develop.developTechSupportId)
                  .orderBy('messageTime', descending: true),
              isLive: true,
            ),
          ),
          buildInput(size),
        ],
      ),
    );
  }
  Widget buildInput(Size size) {
    return Container(
      child: Row(
        children: <Widget>[
          // image Button
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: () =>cropImage(context),
                color: theme=="light"?Theme.of(context).primaryColor:Colors.black,
              ),
            ),
            color: Colors.white,
          ),
          //record button
          AudioRecorder(
              onSendMessage: onSendMessage,
              focusNode: focusNode,
              loggedId:widget.user.uid.toString()
          ),

          // Edit text
          Flexible(
            child: Container(
              child:AutoDirection(
                text: text,
                child: TextField( enableInteractiveSelection: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(color: theme=="light"?Theme.of(context).primaryColor:Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: getTranslated(context, "typeMessage"),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  focusNode: focusNode,
                  onChanged: (str){
                    setState(() {
                      text = str;
                    });
                  },
                ),
              ),
            ),
          ),
          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: loading?Center(child: CircularProgressIndicator()): Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme=="light"?Theme.of(context).primaryColor:Colors.black,
                ),
                child: Center(
                  child: new IconButton(
                    icon: new Icon(Icons.send,color:Colors.white,size: 15,),
                    onPressed: () => onSendMessage(textEditingController.text, "text",size),
                    color: theme=="light"?Theme.of(context).primaryColor:Colors.black,
                  ),
                ),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
          new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }
  Future<void> changeStatus(String status) async {
    //update appointment
    await FirebaseFirestore.instance.collection(Paths.developTechSupportPath).doc(widget.develop.developTechSupportId).set({
      'status': status,
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  Future<void> onSendMessage(String content, String type,Size size) async {
    if (content.trim() != '') {
      textEditingController.clear();
      String messageId=Uuid().v4();
      String data=getTranslated(context, "attatchment");
      if(type=="text")
        data=content;
      await FirebaseFirestore.instance.collection(Paths.dvelopChat).doc(messageId).set({
        'type': type,
        'owner': widget.user.userType,
        'message': content,
        'messageTime': FieldValue.serverTimestamp(),
        'messageTimeUtc':DateTime.now().toUtc().toString(),
        'ownerName': widget.user.name,
        'userUid': widget.user.uid,
        'developTechSupportId': widget.develop.developTechSupportId,

      });


      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() {
        loading = false;
      });
      if(type=="voice")
      {
        setState(() {
          uploadingRecord=false;
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DevelopMessageScreen(
              develop: widget.develop,
              user:widget.user,
            ),
          ),
        );
      }

    } else {
      // Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: getTranslated(context, "loading"),
        );
      },
    );
  }
  Future cropImage(context) async{
    setState(() {
      loading = true;
    });

    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = File(image.path);

    if (croppedFile != null) {
      uploadImage(croppedFile);
      setState(() {
        selectedProfileImage = croppedFile;
      });
    }
  }

  Future uploadImage(File image) async {

    Size size = MediaQuery
        .of(context)
        .size;

    var uuid = Uuid().v4();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('profileImages/$uuid');
    await storageReference.putFile(image);

    var url = await storageReference.getDownloadURL();
    onSendMessage(url, "image",size);
  }

//======================
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
      ////statusText = "Recording...";
      recordFilePath = await getFilePath();
      //isComplete = false;
      setState(() {
        recording=true;
      });
      RecordMp3.instance.start(recordFilePath, (type) {
        //statusText = "Record error--->$type";

      });
    } else {
      print("startRecord11vvvvv");
      //statusText = "No microphone permission";
    }

  }
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test1111_${i++}.mp3";
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
    print("permission uploadRecord1");
    var uuid = Uuid().v4();
    Reference storageReference =firebase_storage.FirebaseStorage.instance.ref().child('audio/$uuid');
    await storageReference.putFile(voice);
    var url = await storageReference.getDownloadURL();
    print("recording file222");
    print(url);
    onSendMessage(url,"voice",size);
    print("recording file222000000000");
    setState(() {
      uploadingRecord=false;
    });
  }
}
