
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/FireStorePagnation/bloc/pagination_listeners.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/SupportMessage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/providers/user_data_provider.dart';
import 'package:grocery_store/screens/twCallScreen.dart';
import 'package:grocery_store/widget/AppointChatMessageItem.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_voice/twilio_voice.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/colorsFile.dart';
import 'AudioScreen.dart';
import 'enableXVidoScreen.dart';

var image;
File? selectedProfileImage;


class oldAppointmentChatScreen extends StatefulWidget {
  final AppAppointments appointment;
  final GroceryUser user;

  const oldAppointmentChatScreen({required this.appointment, required this.user});

  @override
  _oldAppointmentChatScreenState createState() => _oldAppointmentChatScreenState();
}

class _oldAppointmentChatScreenState extends State<oldAppointmentChatScreen> {
  PaginateRefreshedChangeListener refreshChangeListener =PaginateRefreshedChangeListener();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false,checkCall=false;
  bool loadingCall = false,joinMeeting=false;
  String? imageUrl;
  var stCollection = 'messages', theme="light";
  ValueNotifier<String> text = ValueNotifier("");
  late AccountBloc accountBloc;
  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  bool answered = false, done = true, endingCall = false;
  bool checkAgora = false;
  final FocusNode focusNode = new FocusNode();
  Size? size;
  static final String kBaseURL = "https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/";//"https://demo.enablex.io/";
  static bool kTry = false;
  static final String kAppId = "62bfe73d92fbbd38c548eb99";//6249488ec8590f2f6a21c857
  static final String kAppkey = "nyZaEuDyDeGuuyAaWuMytayyWyUutyGuQuDy";//yJu9yVuzuPe9aHaWaTetaduXuvaGameZeJeu
  late DocumentReference reference;
  var header = (kTry)
      ? {
    "x-app-id": kAppId,
    "x-app-key": kAppkey,
    "Content-Type": "application/json"
  }
      : {"Content-Type": "application/json"};
  static String token = "",roomId="";
  int selectedCard=-1;
  List<String>chatUserList=[];
  @override
  void initState() {
    super.initState();
    loading = false;
    accountBloc = BlocProvider.of<AccountBloc>(context);
    userReadHisMessage(widget.user.userType!);
    reference = FirebaseFirestore.instance
        .collection('AppAppointments')
        .doc(widget.appointment.appointmentId);
    checkStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    //widget.user.userType=="CONSULTANT"?[getTranslated(context, "canCall"),getTranslated(context, "availableNow")]:
    chatUserList= [
      getTranslated(context, "callNow"),
      getTranslated(context, "availableNow"),
      getTranslated(context, "busyNow"),
      getTranslated(context, "after5Min"),
      getTranslated(context, "after10Min"),
      getTranslated(context, "afterHour")
    ];
    super.didChangeDependencies();
  }
  Future<void> userReadHisMessage(String type) async {
    try {
      if (type == "CONSULTANT")
        await FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .doc(widget.appointment.appointmentId)
            .set({
          'userChat': 0,
        }, SetOptions(merge: true));
      else
        await FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .doc(widget.appointment.appointmentId)
            .set({
          'consultChat': 0,
        }, SetOptions(merge: true));
    } catch (e) {
      print("cccccc" + e.toString());
    }
  }
  Future<void> checkStatus() async {
    reference.snapshots().listen((querySnapshot) {
      setState(() {
        checkCall = querySnapshot.get("allowCall");
      });
      print("fffffcheckCall");
      print(checkCall);
    });
  }
  @override
  Widget build(BuildContext context) {
    size= MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      body:
      Column(
        children: <Widget>[
          Container(
            width: size!.width,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        getTranslated(context, "back"),
                        width: 20,
                        height: 15,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.user.userType == "USER"
                            ? widget.appointment.consult.name
                            : widget.appointment.user.name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2,fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size!.width)),
          SizedBox(
            height: 10,
          ),
          widget.appointment.appointmentStatus=="closed"?SizedBox():
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child:loadingCall? CircularProgressIndicator():InkWell(
              onTap: () async {
                if(widget.appointment.consultType=="coach")
                  twilioCall();
                else
                  enableXCall();
              },
              child: Container(
                height: 40,
                width: size!.width*0.70,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:  AppColors.white1,
                  boxShadow: [
                    BoxShadow()
                  ],
                  border: Border.all(color: AppColors.grey3,width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      checkCall
                          ? Image.asset(
                        'assets/icons/icon/call_1.gif',width: 60,height: 60,)
                          :Icon(widget.appointment.consultType=="video"?Icons.video_call_outlined:Icons.wifi_calling_rounded,
                        color: AppColors.reddark2,
                        size: 20,
                      ),
                      SizedBox(width: 3,),
                      Text(
                        widget.user.userType=="CONSULTANT"?
                        widget.appointment.consultType=="video"?getTranslated(context, "createVideoRoom"):getTranslated(context, "createAudioRoom")
                            :widget.appointment.consultType=="video"?getTranslated(context, "joinVideoRoom"):getTranslated(context, "joinAudioRoom"),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                          color: AppColors.black2,
                          fontSize: 15.0,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              padding: const EdgeInsets.all(0),
              controller: listScrollController,
              query: FirebaseDatabase.instance .ref() .child(
                  'appointmentsChatMessage/${widget.appointment.appointmentId}')
                  .orderByChild('messageTime'),
              shrinkWrap: true,
              itemBuilder:(context, snapshot, animation, index) {
                final data =  snapshot.value as Map;
                return AppointChatMessageItem(
                    message: SupportMessage.fromDatabase(
                        Map<String, dynamic>.from(data)),
                    user: widget.user);
              },
            ),
          ),
          /* Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                refreshChangeListener.refreshed = true;
              },
              child: StreamBuilder(
                stream: UserDataProvider.realtimeDbRef
                    .child(
                    '/appointmentsChatMessage/${widget.appointment.appointmentId}')
                    .orderByChild('messageTime')
                    .onValue,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data == null || !snapshot.hasData) {
                    return Center(
                      child: Text('Send your first message'),
                    );
                  } else if ((snapshot.data as DatabaseEvent).snapshot.value ==
                      null) {
                    return Center(
                      child: Text('Send your first message'),
                    );
                  } else {
                    final List<dynamic> messages = Map<String, dynamic>.from(
                        (snapshot.data as DatabaseEvent).snapshot.value
                        as Map<dynamic, dynamic>)
                        .values
                        .toList()
                        .reversed
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      padding: EdgeInsets.zero,
                      controller: listScrollController,
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) => AppointChatMessageItem(
                          message: SupportMessage.fromDatabase(
                              Map<String, dynamic>.from(messages[index])),
                          user: widget.user),
                    );
                  }
                },
              ),
            ),
          ),*/
          widget.appointment.appointmentStatus != "closed"
              ? buildInput(size!)
              : SizedBox(),
        ],
      ),

    );
  }
  _scrollToBottom(){
    FirebaseDatabase.instance.ref().child( 'appointmentsChatMessage/${widget.appointment.appointmentId}').onValue.listen((event) {
      if (listScrollController.hasClients)
        listScrollController.animateTo(listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

    });
  }
  Widget buildInput(Size size){
    return
      Container(padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              getTranslated(context, "selectMessageToSend"),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
              style: TextStyle(
                fontFamily: getTranslated(context, "fontFamily"),
                color: Colors.black,
                fontSize: 12.0,
              ),
            ),
            GridView.count(
              shrinkWrap: true,crossAxisSpacing: 5,mainAxisSpacing: 5,
              childAspectRatio:(1 / .2),
              physics: ScrollPhysics(),
              crossAxisCount: 2,
              children: new List<Widget>.generate(chatUserList.length, (index) {
                return   InkWell(
                  splashColor: Colors.purple.withOpacity(0.5),
                  onTap: () async {
                    setState(() {
                      selectedCard=index;
                    });
                    onSendMessage(chatUserList[index], "text", size);
                    //chatUserList
                  },
                  child: selectedCard == index?Center(child: CircularProgressIndicator()):cell(size,chatUserList[index]),
                );
              }), ),
            SizedBox(height: 5,)
          ],
        ),
      );

  }
  Widget cell(Size size,String name){
    return Container(height: 30,
      padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
      decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(10.0), border: Border.all(color: AppColors.pink)
      ),
      child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            getTranslated(context, "send"),
            width: 15,
            height: 15,
          ),
          Flexible(
            child: Text(
              name,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
              style: TextStyle(
                fontFamily: getTranslated(context, "fontFamily"),
                color: Colors.black,
                fontSize: 8.0,
              ),
            ),
          ),

        ],
      ),
    );
  }


  Future<void> onSendMessage(String content, String type, Size size) async {
    if (content.trim() != '') {
      textEditingController.clear();
      String messageId = Uuid().v4();

      await UserDataProvider.realtimeDbRef
          .child("appointmentsChatMessage/${widget.appointment.appointmentId}/$messageId")
          .set({
        'type': type,
        'owner': widget.user.userType,
        'message': content,
        'messageTime': ServerValue.timestamp,
        'messageTimeUtc': DateTime.now().toUtc().toString(),
        'ownerName': widget.user.name,
        'userUid': widget.user.uid,
        'appointmentId': widget.appointment.appointmentId,
      });

      String data = getTranslated(context, "attatchment");
      if (type == "text") data = content;
      if (widget.user.userType == "CONSULTANT") {
        await FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .doc(widget.appointment.appointmentId)
            .set({
          'consultChat': FieldValue.increment(1),
        }, SetOptions(merge: true));
        sendNotification(widget.appointment.user.uid, data);
      } else {
        await FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .doc(widget.appointment.appointmentId)
            .set({
          'userChat': FieldValue.increment(1),
        }, SetOptions(merge: true));
        sendNotification(widget.appointment.consult.uid, data);
      }
      setState(() {
        loading = false;
        selectedCard=-1;
      });
    }
  }

  Future<void> sendNotification(String userId, String text) async {
    try {
      Map notifMap = Map();
      notifMap.putIfAbsent('title', () => "Chat");
      notifMap.putIfAbsent('body', () => text);
      notifMap.putIfAbsent('userId', () => userId);
      notifMap.putIfAbsent( 'appointmentId', () => widget.appointment.appointmentId);
      await http.post( Uri.parse(
          'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendChatNotification'),
        body: notifMap,
      );

    } catch (e) {
      print("sendnotification111  " + e.toString());
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

  Future cropImage(context) async {
    setState(() {
      loading = true;
    });
    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = File(image.path);

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      uploadImage(croppedFile);
      setState(() {
        selectedProfileImage = croppedFile;
      });
      // signupBloc.add(PickedProfilePictureEvent(file: croppedFile));
    } else {
      //not croppped

    }
  }

  Future uploadImage(File image) async {
    Size size = MediaQuery.of(context).size;

    var uuid = Uuid().v4();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('profileImages/$uuid');
    await storageReference.putFile(image);

    var url = await storageReference.getDownloadURL();
    onSendMessage(url, "image", size);
  }
  enableXCall() async {
    setState(() {
      loadingCall = true;
    });

    await permissionAccess();
    if (await Permission.camera.request().isGranted&&
        await Permission.microphone.request().isGranted&&
        await Permission.storage.request().isGranted)
    {
      print("permmmmmmm");
      print(await Permission.camera.request().isGranted);
      print(await Permission.microphone.request().isGranted);
      print(await Permission.storage.request().isGranted);
      if(widget.user.userType=="CONSULTANT")
      {
        await createRoom();
        await createToken();
      }
      else
      {
        DocumentReference docRef2 = FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId);
        final DocumentSnapshot documentSnapshot2 = await docRef2.get();
        var currentAppointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
        if(currentAppointment.allowCall&&currentAppointment.roomId!=null)
        {
          setState(() { roomId=currentAppointment.roomId!; });
          await createToken();
        }
        else
        {
          Fluttertoast.showToast(
              msg: getTranslated(context, "callNotStart"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            loadingCall = false;
          });
        }
      }
    }
    else
    {
      setState(() {
        loadingCall = false;
      });
      Fluttertoast.showToast(
          msg: "Plermission denied",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      loadingCall = false;
    });
  }
  twilioCall() async {
    if(widget.user.userType=="COACH"){
      setState(() {
        loadingCall = true;
      });
      if (!await (TwilioVoice.instance.hasMicAccess())) {
        print("request mic access");
        TwilioVoice.instance.requestMicAccess();
        setState(() {
          loadingCall = false;
        });
        return;
      }
      print("ggggg5555222");
      print(widget.appointment.user.uid);
      print(widget.appointment.consult.uid);
      TwilioVoice.instance.call.place(to: widget.appointment.user.uid, from: widget.appointment.consult.uid);
      setState(() {
        loadingCall = false;
      });
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => VoiceCallScreen(
              loggedUser: widget.user,
              appointment: widget.appointment)));
    }
    else
      Fluttertoast.showToast(
          msg: getTranslated(context, "callNotStart"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
  }
  Future<void> permissionAccess() async {

    await [Permission.microphone].request();
    await [Permission.storage].request();
    await [Permission.camera].request();

  }

  Future<String> createRoom() async {
    var response = await http.post( Uri.parse(kBaseURL + "createRoom"), headers: header);
    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body);
      Map<String, dynamic> room = user['room'];
      setState(() => roomId = room['room_id'].toString());
      print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> createToken() async {
    var value = {
      'user_ref': "2236",
      "roomId": roomId,
      "role": "participant",
      "name":widget.user.userType=="CONSULTANT"? widget.appointment.consult.name:widget.appointment.user.name
    };
    print("createToken0");
    print(jsonEncode(value));
    var response = await http.post(Uri.parse( kBaseURL + "createRoomToken"), headers: header, body: jsonEncode(value));
    print("createToken1");
    if (response.statusCode == 200) {
      print("createToken2");
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      if(mounted)setState(() {
        token = user['token'].toString();
        widget.appointment.roomList!.add(roomId);
        widget.appointment.roomId=roomId;
      });
      if(widget.user.userType=="CONSULTANT")
        await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(widget.appointment.appointmentId).set({
          'allowCall':true,
          'roomId':roomId,
          'roomList':widget.appointment.roomList,
        }, SetOptions(merge: true));
      if(mounted)setState(() {
        loadingCall = false;
      });

      await sendCallNotification(widget.appointment.consult.name,widget.appointment.user.uid,widget.appointment.appointmentId,roomId);

      //return response.body;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<void> sendCallNotification(String consultName,String userId,String appointmentId,String roomId) async {
    try{
      print("sendnot111");
      Map notifMap = Map();
      notifMap.putIfAbsent('consultName', () => consultName);
      notifMap.putIfAbsent('userId', () => userId);
      notifMap.putIfAbsent('appointmentId', () => appointmentId);
      notifMap.putIfAbsent('type', () => widget.appointment.consultType);
      notifMap.putIfAbsent('roomId', () => roomId);
      var refundRes= await http.post( Uri.parse('https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendCallNotification'),
        body: notifMap,
      );
      /*   print("sendnot11122");
      var refund = jsonDecode(refundRes.body);
      if (refund['message'] != 'Success') {
        print("sendnotification111  error");
      }
      else
      { print("sendnotification1111 success");}*/
    }catch(e){
      print("sendnotification111  "+e.toString());
    }


  }

}
