
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_store/methodes/bickFile.dart';
import 'package:grocery_store/screens/sendScreen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../FireStorePagnation/bloc/pagination_listeners.dart';
import '../FireStorePagnation/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/SupportList.dart';
import 'package:grocery_store/models/SupportMessage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/providers/user_data_provider.dart';
import 'package:grocery_store/widget/AppointChatMessageItem.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:intl/intl.dart' as intl;
import 'package:video_thumbnail/video_thumbnail.dart';

import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../methodes/pt_to_px.dart';
import '../widget/IconButton.dart';
import '../widget/rocordingWidget.dart';

var image;
File? selectedProfileImage;


class SupportMessageScreen extends StatefulWidget {
  final SupportList item;
  final GroceryUser user;

  const SupportMessageScreen({required this.item, required this.user});

  @override
  _SupportMessageScreenState createState() => _SupportMessageScreenState();
}

class _SupportMessageScreenState extends State<SupportMessageScreen> {
  PaginateRefreshedChangeListener refreshChangeListener =
  PaginateRefreshedChangeListener();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool loadingCall = false;
  late String imageUrl;
  var stCollection = 'messages', theme="light";
  ValueNotifier<String> text = ValueNotifier("");
  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  bool answered = false, done = true, endingCall = false;
  bool checkAgora = false;
  final FocusNode focusNode = new FocusNode();
  // ValueNotifier<bool> uploadingRecord = ValueNotifier(false);
  String mobileNumber = '..';
  bool isRTL = false,uploadVideo=false,uploadingImage=false;
    SupportMessage? newMessage;
  double prgressnewMessage = 0;
    List<SupportMessage> supportMessagesList = [];
  late Size size;
  @override
  void initState() {
    super.initState();
    loading = false;
    getUserMobileNumber();
    userReadHisMessage(widget.user.userType!);
  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  getUserMobileNumber() async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.item.userUid);
    final DocumentSnapshot userSnapshot = await userRef.get();
    var phone = GroceryUser.fromMap(userSnapshot.data() as Map).phoneNumber;
    setState(() {
      mobileNumber = phone!;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final lang = getTranslated(context, "lang");
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return WillPopScope(
      onWillPop: endSupport,
      child: Scaffold(
        //backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
                width: size.width,
                child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /*IconButton(
                            onPressed: () {
                              endSupport();
                            },
                            icon: Image.asset(
                              getTranslated(context, "back"),
                              width: 30,
                              height: 30,
                            ),
                          ),*/
                          IconButton1(onPress:() {
                            endSupport();
                          }, Width: AppSize.w53_3.w, Height: AppSize.h53_3.h,ButtonBackground: AppColors.white,BoxShape1: BoxShape.circle,Icon:lang=="ar"?AssetsManager.blackIosArrowRightIconPath.toString() :AssetsManager.blackIosArrowLeftIconPath.toString(),IconWidth: AppSize.w28_4.w,IconHeight: AppSize.h28_4.h,IconColor: AppColors.black,)
                          ,
                          widget.user.userType != "SUPPORT"?Text( getTranslated(context, "tecSupport"),
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2,fontWeight: FontWeight.w300),
                          ): Column(
                            children: [
                              Text(
                                widget.user.userType == "SUPPORT"
                                    ? widget.item.userName == null
                                    ? " "
                                    : widget.item.userName
                                    : getTranslated(context, "tecSupport"),
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2,fontWeight: FontWeight.w300),
                              ),
                              Text(
                                mobileNumber,
                                style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),fontSize: 17.0,color:AppColors.balck2,fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                          widget.user.userType == "SUPPORT"?Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.white.withOpacity(0.6),
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: mobileNumber));
                                      showSnack(getTranslated(context, "copyDone"),context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      width: 38.0,
                                      height: 35.0,
                                      child: Icon(
                                        Icons.copy,
                                        color: AppColors.pink,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                             /* ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.white.withOpacity(0.6),
                                    onTap: () {
                                      twilioCall();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      width: 38.0,
                                      height: 35.0,
                                      child: Icon(
                                        Icons.wifi_calling,
                                        color: AppColors.pink,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),*/
                            ],
                          ):SizedBox(),
                        ],
                      ),
                    ))),
            Center(
                child: Container(
                    color: AppColors.white3,
                    height: 1,
                    width: size.width )),
            widget.user.userType == "SUPPORT"
                ? Padding(
              padding: const EdgeInsets.only(
                  right: 30, left: 30, top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: answered,
                    onChanged: (value) {
                      setState(() {
                        answered = !answered;
                        callAnswered();
                      });
                    },
                  ),
                  Text(
                    getTranslated(context, "answered"),
                    style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontSize: 14.0,
                        color:Color.fromRGBO(167, 165, 165,1.0), fontWeight: FontWeight.w300),

                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.only(
                  right: 30, left: 30, top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/icon/Group 3651.png',
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: convertPtToPx(12).w,
                  ),
                  Text(
                    getTranslated(context, "helpText"),
                    style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),fontSize: convertPtToPx(20).sp,
                        color:AppColors.pink2, fontWeight: FontWeight.w500),

                  )
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  refreshChangeListener.refreshed = true;
                },
                child: StreamBuilder(
                  stream:  UserDataProvider.realtimeDbRef
                      .child('/SupportMessage/${widget.item.supportListId}')
                      .orderByChild('messageTime')
                      .onValue,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data == null || !snapshot.hasData) {
                      return Center(
                        child: Text(getTranslated(context, "sendFirstMessage")),
                      );
                    } else if ((snapshot.data!).snapshot.value == null) {
                      return Center(
                        child: Text(getTranslated(context, "sendFirstMessage")),
                      );
                    } else {
                      List<dynamic> messages = Map<String, dynamic>.from(
                          (snapshot.data!).snapshot.value
                          as Map<dynamic, dynamic>)
                          .values
                          .toList()
                        ..sort((a, b) => a['messageTime'].compareTo(b['messageTime']));
                       supportMessagesList.clear();
                      messages=messages.reversed.toList();
                      supportMessagesList = messages
                            .map((message) => SupportMessage.fromDatabase(
                                Map<String, dynamic>.from(message)))
                            .toList();
                        if (newMessage != null) {
                          // newMessage!.prgress = 25;
                          supportMessagesList.insert(0, newMessage!);
                        }
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        padding: EdgeInsets.zero,
                        controller: listScrollController,
                        itemCount:  supportMessagesList.length,
                        itemBuilder: (ctx, index) => AppointChatMessageItem(
                            message:  supportMessagesList[index],
                            user: widget.user
                        ),
                      );
                    }
                  },
                ),
              ),),
          //  buildInput(size),
            buildInputCoach(size),
          ],
        ),
      ),
    );
  }
    Widget buildInputCoach(Size size) {
    return Container(
       padding: EdgeInsets.only(
        left: AppPadding.p32.w,
        right: AppPadding.p32.w,
      ), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: convertPtToPx(258).w,
            height: convertPtToPx(38).h,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.lightGrey6,
                  style: BorderStyle.solid,
                  width: convertPtToPx(.5),
                ),
                borderRadius: BorderRadius.circular(convertPtToPx(19).r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                    child: loading
                        ? Container(
                   height: convertPtToPx(20).h,
                      width: convertPtToPx(20).w,
                  child: Center(
                      child: CircularProgressIndicator(
                      color: AppColors.reddark2,
                    )),
                )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p21_3.w),
                            child: InkWell(
                              child: getTranslated(context, "ar") == "ar"
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..scale(-1.0, 1.0, 1.0),
                                      child: SvgPicture.asset(
                                        AssetsManager.sendSvgIcon,
                                        height: convertPtToPx(16.5).h,
                                        width: convertPtToPx(16.5).w,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      AssetsManager.sendSvgIcon,
                                      height: convertPtToPx(16.5).h,
                                      width: convertPtToPx(16.5).w,
                                    ),
                              onTap: () => onSendMessage(
                                textEditingController.text,
                                "text",
                                size,
                              ),
                            ),
                          )),
                Flexible(
                  child: Container(
                    child: ValueListenableBuilder<String>(
                      valueListenable: text,
                      builder: (context, value, child) => Directionality(
                        textDirection: getTranslated(context, "ar") == "ar"
                            ? intl.Bidi.detectRtlDirectionality(text.value)
                                ? TextDirection.ltr
                                : TextDirection.rtl
                            : intl.Bidi.detectRtlDirectionality(text.value)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                        child: TextField(
                          enableInteractiveSelection: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                          controller: textEditingController,
                          decoration: InputDecoration.collapsed(
                            hintText: getTranslated(context, "typeMessage"),
                            hintStyle: TextStyle(
                                color: AppColors.greyFontColor,
                                fontSize: convertPtToPx(12),
                                fontFamily: getTranslated(
                                    context, "Montserratregular")),
                          ),
                          focusNode: focusNode,
                          onChanged: (str) {
                            text.value = str;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Material(
            child: uploadVideo
                ? Container(
                   height: convertPtToPx(20).h,
                      width: convertPtToPx(20).w,
                  child: Center(
                      child: CircularProgressIndicator(
                      color: AppColors.reddark2,
                    )),
                )
                : InkWell(
                    child: Image.asset(
                      "assets/icons/icon/Group 3657.png",
                      height: convertPtToPx(20).h,
                      width: convertPtToPx(20).w,
                    ),
                    onTap: () => uploadToStorage(context),
                  ),
          ),
          Material(
            child: uploadingImage
                ? Container(
                   height: convertPtToPx(20).h,
                      width: convertPtToPx(20).w,
                  child: Center(
                      child: CircularProgressIndicator(
                      color: AppColors.reddark2,
                    )),
                )
                :InkWell(
              child: Image.asset(
                "assets/icons/icon/Group 3656.png",
                height: convertPtToPx(20).h,
                width: convertPtToPx(20).w,
              ),
              onTap: () => cropImage(context),
            ),
          ),
          AudioRecorder(
            loggedId: widget.user.uid!,
            onSendMessage: onSendMessage,
            focusNode: focusNode,
          ),
        ],
      ),
      width: double.infinity,
      height: convertPtToPx(60).h,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: AppColors.white3, width: 0.5)),
          color: Colors.transparent),
    );
  }
  Widget inputMessage(Size size) {
    final lang = getTranslated(context, "lang");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget> [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(50.r)),
              width: convertPtToPx(319).w,
              height: convertPtToPx(49).h,
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      AssetsManager.videoCallIcon,
                      width: convertPtToPx(28).w,
                      height: convertPtToPx(28).h,
                    ),

                      onPressed: () async {
                        try {
                          final _selectedVedio = await pickVideo();
                          if (_selectedVedio != null)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendFileScreen(
                                    onSendMessage: send,
                                    type: "video",
                                    filee: _selectedVedio,
                                    // filePickerFuture: _filePickerFuture,
                                  ),
                                ));
                        } catch (e) {}
                      }
                  ),

                  IconButton(
                    icon: Image.asset(
                      AssetsManager.photoIcon,
                      width: convertPtToPx(20).w,
                      height: convertPtToPx(20).h,
                    ),
                      onPressed: () async {
                        final _selectedImage = await pickImage();
                        if(_selectedImage != null)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendFileScreen(
                                filee: _selectedImage,
                                onSendMessage: send,
                                type: "image",
                              ),
                            ),
                          );
                      }
                  ),

                  SizedBox(
                    child: TextField(
                      enableInteractiveSelection: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: getTranslated(context, "writeAMessage"),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      focusNode: focusNode,
                      onChanged: (str) {
                        text.value = str;
                      },
                    ),
                    width: convertPtToPx(135).w,
                    height: convertPtToPx(30).h,
                  ),SizedBox(width: 20.w,),
                 IconButton(
                    icon:lang =="ar"?Image.asset(
    AssetsManager.sendArIcon,
    width: 25.8,
    height: 28.3,
    ) :Image.asset(
                      AssetsManager.sendfIcon,
                      width: 25.8,
                      height: 28.3,
                    ),
                    onPressed: () => onSendMessage(
                      textEditingController.text,
                      "text",
                      size,
                    ),
                  )
                ],
              ),
            ),
            CircleAvatar(child:   AudioRecorder(
              loggedId: widget.user.uid!,
              onSendMessage: onSendMessage,
              focusNode: focusNode,
            ),radius: convertPtToPx(25).r,)
          ],
        ),
        SizedBox(height: convertPtToPx(12).h,)],
    );
  }
  _scrollToBottom(){
    FirebaseDatabase.instance.ref().child('/SupportMessage/${widget.item.supportListId}').onValue.listen((event) {
      if (listScrollController.hasClients)
        listScrollController.animateTo(listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

    });
  }
  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }

  Widget buildInput(Size size) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              //color: Colors.white,
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                child: loading
                    ? Center(child: CircularProgressIndicator(color: AppColors.reddark2,))
                    : IconButton(
                  icon: Image.asset(
                    "assets/icons/icon/Group 3659.png",
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () =>
                      onSendMessage(
                        textEditingController.text,
                        "text",
                        size,
                      ),
                )
            ),
          ),
          Flexible(
            child: Container(
              child: ValueListenableBuilder<String>(
                valueListenable: text,
                builder: (context, value, child) => Directionality(
                  textDirection: intl.Bidi.detectRtlDirectionality(text.value)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: TextField(
                    enableInteractiveSelection: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                        color:  Colors.black,
                        fontSize: 15.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: getTranslated(context, "typeMessage"),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    focusNode: focusNode,
                    onChanged: (str) {
                      text.value = str;
                    },
                  ),
                ),
              ),
            ),
          ),
          AudioRecorder(
            loggedId: widget.user.uid!,
            onSendMessage: onSendMessage,
            focusNode: focusNode,
          ),
          uploadVideo? Container(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(color: AppColors.reddark2,),
          ) : Material(
            child: new Container(
              color: Colors.transparent,
              // margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: Image.asset(
                  "assets/icons/icon/Group 3657.png",
                  width: 25,
                  height: 25,
                ),
                onPressed: () async {
                  try {
                    final _selectedVedio = await pickVideo();
                    if (_selectedVedio != null)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendFileScreen(
                              onSendMessage: send,
                              type: "video",
                              filee: _selectedVedio,
                              // filePickerFuture: _filePickerFuture,
                            ),
                          ));
                  } catch (e) {}
                }
                //  uploadToStorage(context),
              ),
            ),
          ),
          Material(
            child: new Container(
              color: Colors.transparent,
              //margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: Image.asset(
                  "assets/icons/icon/Group 3656.png",
                  width: 25,
                  height: 25,
                ),
                onPressed: () async {
                   final _selectedImage = await pickImage();
                   if(_selectedImage != null)
                   Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendFileScreen(
                                    filee: _selectedImage,
                                    onSendMessage: send,
                                    type: "image",
                                  ),
                                ),
                              );
                }
                //  cropImage(context),
              ),
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.transparent
      ),
    );
  }

  Future uploadToStorage(context) async {
    try {
      setState(() {
        uploadVideo=true;
      });
      final pickedFile = await ImagePicker.platform.pickVideo(source: ImageSource.gallery);
      final file = File(pickedFile!.path);
      var uuid = Uuid().v4();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('files/$uuid');
      await storageReference.putFile(file);
      var url = await storageReference.getDownloadURL();

      onSendMessage(url, "video", size);
    } catch (error) {
      print(error);
    }
  }

  Future<File> getVideoThumbnail (String url) async {

    var thumbTempPath = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75, // you can change the thumbnail quality here
    );
    return File(thumbTempPath!);
  }
  Future<void> onSendMessage(String content, String type, Size size) async {
    FocusScope.of(context).unfocus();
    if ((content.trim() != '' && type == "text") || type != "text") {
      textEditingController.clear();
      if (widget.user.userType == "SUPPORT") {
        await FirebaseFirestore.instance
            .collection("SupportList")
            .doc(widget.item.supportListId)
            .set({
          'userMessageNum': FieldValue.increment(1),
          'messageTime': FieldValue.serverTimestamp(),
          'lastMessage': type == "text"
              ? content
              : type == "image"
              ? "imageFile"
              : "voiceFile",
        }, SetOptions(merge: true));
      } else
        await FirebaseFirestore.instance
            .collection("SupportList")
            .doc(widget.item.supportListId)
            .set({
          'supportMessageNum': FieldValue.increment(1),
          'supportListStatus': false,
          'userName': widget.user.name,
          'messageTime': FieldValue.serverTimestamp(),
          'lastMessage': type == "text"
              ? content
              : type == "image"
              ? "imageFile"
              : "voiceFile",
        }, SetOptions(merge: true));
      String messageId = Uuid().v4();

      await UserDataProvider.realtimeDbRef
          .child("SupportMessage/${widget.item.supportListId}/$messageId")
          .set({
        'type': type,
        'owner': widget.user.userType,
        'message': content,
        'messageTime': ServerValue.timestamp,
        'messageTimeUtc': DateTime.now().toUtc().toString(),
        'ownerName': widget.user.name,
        'userUid': widget.user.uid,
        'supportId': widget.item.supportListId,
      });
      if (newMessage != null) {
        newMessage!.prgress = 100;
        newMessage = null;
      }

      //listScrollController.animateTo(0.0,  duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() {
        loading = false;
        uploadVideo=false;
        uploadingImage=false;
      });

    }
  }

  Future<void> callAnswered() async {
    showUpdatingDialog();
    await FirebaseFirestore.instance
        .collection("SupportList")
        .doc(widget.item.supportListId)
        .set({
      'supportListStatus': false,
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection("SupportList")
        .doc(widget.item.supportListId)
        .set({
      'supportListStatus': true,
      'openingStatus': false,
      'supportMessageNum': 0,
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.user.uid)
        .set({
      'answeredSupportNum':
      int.parse(widget.user.answeredSupportNum.toString()) + 1,
    }, SetOptions(merge: true));
    var date = DateTime.now();
    await FirebaseFirestore.instance
        .collection(Paths.supportAnalysisPath)
        .doc(Uuid().v4())
        .set({
      'time': DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
      'techSupportUser': widget.user.uid,
    }, SetOptions(merge: true));
    Navigator.pop(context);
  }

  Future<void> userReadHisMessage(String type) async {
    try {
      if (type == "SUPPORT")
        await FirebaseFirestore.instance
            .collection("SupportList")
            .doc(widget.item.supportListId)
            .set({
          //'supportMessageNum': 0,
          'openingStatus': true,
        }, SetOptions(merge: true));
      else
        await FirebaseFirestore.instance
            .collection("SupportList")
            .doc(widget.item.supportListId)
            .set({
          'userMessageNum': 0,
        }, SetOptions(merge: true));
    } catch (e) {

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
      uploadingImage = true;
    });
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File croppedFile =File(image.path);
    if (croppedFile != null) {
      uploadImage(croppedFile);
      setState(() {
        selectedProfileImage = croppedFile;
      });
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
  ////===============

  Future<bool>endSupport() async {
    try {
      if (widget.user.userType == "SUPPORT")
        await FirebaseFirestore.instance
            .collection("SupportList")
            .doc(widget.item.supportListId)
            .set({
          'openingStatus': false,
        }, SetOptions(merge: true));
      else
        await FirebaseFirestore.instance
            .collection("SupportList")
            .doc(widget.item.supportListId)
            .set({
          'userMessageNum': 0,
        }, SetOptions(merge: true));
      Navigator.of(context).pop(true);
      return Future.value(true);

    } catch (e) {
      return Future.value(true);
    }
  }
  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(7),
      backgroundColor: Colors.green.shade500,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }
  Future uploadRecord(File voice) async {
    Size size = MediaQuery.of(context).size;

    var uuid = Uuid().v4();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('profileImages/$uuid');
    await storageReference.putFile(voice);

    var url = await storageReference.getDownloadURL();
    onSendMessage(url, "voice", size);
  }
  
  sendImage(file, result) async {
    final String? filePath = result;
    // Size size = MediaQuery.of(context).size;
    newMessage = SupportMessage(
      prgress: prgressnewMessage,
      message: filePath!,
      messageTimeUtc: DateTime.now().toUtc().toString(),
      type: "image",
      owner: widget.user.userType,
      userUid: widget.user.uid!,
      ownerName: widget.user.name!,
       messageTime:Timestamp.now() ,
    );
    setState(() {
      // load = true;
    });
    var uuid = Uuid().v4();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('profileImages/$uuid');
      final Uploadfile = storageReference.putFile(file);
      Uploadfile.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            prgressnewMessage =
                100 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            newMessage = SupportMessage(
              prgress: prgressnewMessage,
              message: filePath,
              messageTimeUtc: DateTime.now().toUtc().toString(),
              type: "image",
              owner: widget.user.userType,
              userUid: widget.user.uid!,
              ownerName: widget.user.name!,
              messageTime:Timestamp.now(),
            );
            setState(() {});
            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
          case TaskState.success:
            break;
        }
      });
      Uploadfile.then((p0) {
        storageReference.getDownloadURL().then((value) {
          onSendMessage(value, "image", size);
        });
      });
    setState(() {
    });
  }
  
  sendFile(type, file, result, {extension}) async {
    Size size = MediaQuery.of(context).size;
    String url = "";
    final String? filePath = result;
            newMessage = SupportMessage(
              prgress: prgressnewMessage,
              message: type == "video" ? filePath! : "",
              messageTimeUtc: DateTime.now().toUtc().toString(),
              type: type,
              owner: widget.user.userType,
              userUid: widget.user.uid!,
              ownerName: widget.user.name!,
              messageTime: Timestamp.now()
            );
    setState(() {
      // load = true;
    });
    var uuid = Uuid().v4();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('files/$uuid');
      SettableMetadata metadata = SettableMetadata(
        contentType: extension == ".docx" ? 'application/docx' : extension == ".doc" ? 'application/doc' : extension == ".pdf" ? 'application/pdf' : extension == "._pdf" ? 'application/_pdf' : extension == ".pages" ? 'application/pages' : 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      );
      final Uploadfile = storageReference.putFile(file, metadata);
      Uploadfile.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final prgressnewMessage =
                100 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            newMessage = SupportMessage(
              prgress: prgressnewMessage,
              message: type == "video" ? filePath! : "",
              messageTimeUtc: DateTime.now().toUtc().toString(),
              type: type,
              owner: widget.user.userType,
              userUid: widget.user.uid!,
              ownerName: widget.user.name!,
              messageTime: Timestamp.now()
            );
            print("prgressnewMessage :$prgressnewMessage");
            setState(() {});
            break;
          case TaskState.paused:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
          case TaskState.success:
            newMessage = null;
            break;
        }
      });
      Uploadfile.then((p0) {
        storageReference.getDownloadURL().then((value) {
          onSendMessage(value, type, size);
        });
      });
    
    setState(() {
      // load = false;
    });
  }

   send(type, file, result, {extension}) {
    print("type $type, file $file, result $result, ");
    // (url, "voice", size)
    if (type == "text" || (file == "text" && type.runtimeType == String)) {
      // onSendMessage(type, file, size);
    } else if (type == "image") {
      sendImage(file, result);
    } else if (type == "video") {
      sendFile(type, file, result);
    }
    else
    if (type == "voice") {
      // onSendMessage(file, type, size);
    }
    // else
      // sendFile(type, file, result, extension: extension);
  }
  

}