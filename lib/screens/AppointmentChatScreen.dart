import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/FireStorePagnation/bloc/pagination_listeners.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/SupportMessage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/providers/user_data_provider.dart';
import 'package:grocery_store/screens/beautVideoCallScreen.dart';
import 'package:grocery_store/screens/twCallScreen.dart';
import 'package:grocery_store/services/call_services.dart';
import 'package:grocery_store/widget/AppointChatMessageItem.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:twilio_voice/twilio_voice.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../blocs/meet_cubit/jitsi_meet_rining_screeen.dart';
import '../blocs/meet_cubit/jitsi_service/meet_service_impl.dart';
import '../blocs/meet_cubit/meet_cubit.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../models/meet_model.dart';
import '../models/room.dart';
import '../widget/IconButton.dart';
import '../widget/app_bar_widget.dart';
import '../widget/rocordingWidget.dart';
import 'package:intl/intl.dart' as intl;

var image;
File? selectedProfileImage;

class AppointmentChatScreen extends StatefulWidget {
  final AppAppointments appointment;
  final GroceryUser user;
  const AppointmentChatScreen({required this.appointment, required this.user});

  @override
  _AppointmentChatScreenState createState() => _AppointmentChatScreenState();
}

class _AppointmentChatScreenState extends State<AppointmentChatScreen> {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false, checkCall = false, uploadVideo = false,uploadingImage=false;
  bool loadingCall = false, joinMeeting = false;
  String? imageUrl;
  var stCollection = 'messages', theme = "light";
  ValueNotifier<String> text = ValueNotifier("");
  late AccountBloc accountBloc;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  bool answered = false, done = true, endingCall = false;
  bool checkAgora = false;
  final FocusNode focusNode = new FocusNode();
  Size? size;
  late DocumentReference reference;
  int selectedCard = -1;
  List<String> chatUserList = [];
  String lang = "";

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
    chatUserList = [
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
      if (mounted)
        setState(() {
          checkCall = querySnapshot.get("allowCall");
        });
      print("fffffcheckCall");
      print(checkCall);
    });
  }

  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ///---------------------AppBar Widget-----------------------///
            Container(
              width: size!.width,
              padding: EdgeInsets.only(bottom: AppPadding.p21_3.h),
              child: AppBarWidget2(
                text: widget.user.userType == "CONSULTANT"
                    ? widget.appointment.consultType == "coach"
                        ? widget.appointment.consult.name
                        : widget.appointment.user.name
                    : widget.user.userType == "USER"
                        ? widget.appointment.consult.name
                        : widget.appointment.user.name,
              ),
            ),
            Center(
                child: Container(
                    color: AppColors.white3,
                    height: convertPtToPx(AppSize.h1.h),
                    width: size!.width)),
            SizedBox(
              height: convertPtToPx(AppSize.h24.h),
            ),
            //p d
            /*
            TextButton1(onPress: () async {
              if(widget.appointment.consultType=="coach")
                twilioCall();
              else
                agoraCall();
            },Width: size!.width*0.70,Height: 40.h, Title: getTranslated(context, "addBalance"), ButtonRadius: AppRadius.r10_6.r, TextSize: AppFontsSizeManager.s21_3.sp,ButtonBackground: Color.fromRGBO(207, 0, 54, 1), TextFont: getTranslated(context, "fontFamily"), TextColor: AppColors.white),

            */
            (widget.appointment.appointmentStatus == "closed" ||
                    (widget.appointment.consultType == "coach" &&
                        widget.user.userType != "COACH"))
                ? SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.only(bottom: convertPtToPx(AppSize.h12.h)),
                    child: Center(
                        child: loadingCall
                            ? CircularProgressIndicator(
                                color: AppColors.reddark2,
                              )
                            : Container(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppPadding.p32.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(
                                              context, "createAudioRoom"),
                                          // (widget.user.userType == "COACH" &&
                                          //         widget.appointment.consultType ==
                                          //             'coach')
                                          //     ? getTranslated(context, "TypeAMessage")
                                          //     : widget.user.userType == "CONSULTANT"
                                          //         ? widget.appointment
                                          //                     .consultType ==
                                          //                 "video"
                                          //             ? getTranslated(context,
                                          //                 "createVideoRoom")
                                          //             : getTranslated(context,
                                          //                 "createAudioRoom")
                                          //         : widget.appointment
                                          //                     .consultType ==
                                          //                 "video"
                                          //             ? getTranslated(
                                          //                 context, "joinVideoRoom")
                                          //             : getTranslated(
                                          //                 context, "joinAudioRoom"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: getTranslated(
                                                context, "Montserratsemibold"),
                                            color: AppColors.black,
                                            fontSize:
                                                AppFontsSizeManager.s24.sp,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // checkCall
                                        //     ?
                                        IconButton1(
                                          onPress: () async {
                                            if (widget
                                                    .appointment.consultType ==
                                                "coach")
                                              twilioCall();
                                            else
                                              agoraCall();
                                          },
                                          Width: AppSize.w66_6.r,
                                          Height: AppSize.h66_6.r,
                                          ButtonBackground:
                                              AppColors.lightPink2,
                                          BoxShape1: BoxShape.circle,
                                          Icon: AssetsManager
                                              .addCallPlusIconPath
                                              .toString(),
                                          IconWidth: AppSize.w30_1.r,
                                          IconHeight: AppSize.h30_1.r,
                                        )
                                        // : IconButton1(
                                        //     onPress: () async {
                                        //       if (widget.appointment
                                        //               .consultType ==
                                        //           "coach")
                                        //         twilioCall();
                                        //       else
                                        //         agoraCall();
                                        //     },
                                        //     Width: AppSize.w66_6.r,
                                        //     Height: AppSize.h66_6.r,
                                        //     ButtonBackground: AppColors.lightPink2,
                                        //     BoxShape1: BoxShape.circle,
                                        //     Icon: AssetsManager.addVideoIconPath
                                        //         .toString(),
                                        //     IconWidth: AppSize.w35.w,
                                        //     IconHeight: AppSize.h24.h,
                                        //   ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                  ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  refreshChangeListener.refreshed = true;
                },
                child: StreamBuilder(
                  stream: UserDataProvider.realtimeDbRef
                      .child(
                          'appointmentsChatMessage/${widget.appointment.appointmentId}')
                      .orderByChild('messageTime')
                      .onValue,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data == null || !snapshot.hasData) {
                      return Center(
                        child: Text(
                          widget.appointment.appointmentStatus=="open"?
                          getTranslated(context, "sendFirstMessage"):" ",
                          style: TextStyle(
                            color: AppColors.black32,
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s24.sp,
                          ),
                        ),
                      );
                    } else if ((snapshot.data!).snapshot.value == null) {
                      return Center(
                        child: Text(
                          widget.appointment.appointmentStatus=="open"?
                          getTranslated(context, "sendFirstMessage"):" ",
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratmedium"),
                            fontSize: AppFontsSizeManager.s24.sp,
                          ),
                        ),
                      );
                    } else {
                      List<dynamic> messages = Map<String, dynamic>.from(
                              (snapshot.data!).snapshot.value
                                  as Map<dynamic, dynamic>)
                          .values
                          .toList()
                        ..sort((a, b) =>
                            a['messageTime'].compareTo(b['messageTime']));

                      messages = messages.reversed.toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        padding: EdgeInsets.zero,
                        controller: listScrollController,
                        itemCount: messages.length,
                        itemBuilder: (ctx, index) => AppointChatMessageItem(
                            message: SupportMessage.fromDatabase(
                              Map<String, dynamic>.from(messages[index]),
                            ),
                            user: widget.user),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: AppSize.h6.h,
            ),
            SizedBox(
              height: AppSize.h6.h,
            ),

            (widget.appointment.appointmentStatus != "closed" &&
                    widget.appointment.consultType == "coach")
                ? buildInputCoach(size!)
                : (widget.appointment.appointmentStatus != "closed")
                    ? buildInput(size!)
                    : SizedBox(),
            SizedBox(
              height: AppSize.h6.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget inputMessage(Size size) {
    lang = getTranslated(context, "lang");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
                    onPressed: () => uploadToStorage(context, size),
                  ),
                  IconButton(
                    icon: Image.asset(
                      AssetsManager.photoIcon,
                      width: convertPtToPx(20).w,
                      height: convertPtToPx(20).h,
                    ),
                    onPressed: () => cropImage(context),
                  ),
                  SizedBox(
                    child: TextField(
                      enableInteractiveSelection: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: getTranslated(context, "TypeAMessage"),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      focusNode: focusNode,
                      onChanged: (str) {
                        text.value = str;
                      },
                    ),
                    width: convertPtToPx(135).w,
                    height: convertPtToPx(30).h,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  IconButton(
                    icon: lang == 'ar'
                        ? Image.asset(
                            AssetsManager.sendArIcon,
                            width: 25.8,
                            height: 28.3,
                          )
                        : Image.asset(
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
            CircleAvatar(
              child: AudioRecorder(
                loggedId: widget.user.uid!,
                onSendMessage: onSendMessage,
                focusNode: focusNode,
              ),
              radius: convertPtToPx(25).r,
            )
          ],
        ),
        SizedBox(
          height: convertPtToPx(39).h,
        )
      ],
    );
  }

  Widget buildInputCoach(Size size) {
    return Container(
       padding: EdgeInsets.only(
        left: AppPadding.p21_3.w,
        right: AppPadding.p21_3.w,
      ), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: convertPtToPx(340).w,
            height: convertPtToPx(53).h,
            decoration: BoxDecoration(
                color: AppColors.time,
                borderRadius: BorderRadius.circular(convertPtToPx(50).r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                    loading
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
                            child: Row(
                              children: [
                                uploadVideo
                                    ? Container(
                                  height: convertPtToPx(28).h,
                                  width: convertPtToPx(28).w,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.reddark2,
                                      )),
                                )
                                    : InkWell(
                                  child: SvgPicture.asset(
                                    AssetsManager.uploadVideo,
                                    height: convertPtToPx(20).h,
                                    width: convertPtToPx(20).w,
                                    color: AppColors.pink2,

                                  ),
                                  onTap: () => uploadToStorage(context, size),
                                ),
                                uploadingImage
                                    ? Container(
                                  height: convertPtToPx(20).h,
                                  width: convertPtToPx(20).w,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.reddark2,
                                      )),
                                )
                                    :InkWell(
                                  child: SvgPicture.asset(
                                    AssetsManager.uploadImage,
                                    height: convertPtToPx(20).h,
                                    width: convertPtToPx(20).w,
                                    color: AppColors.pink2,
                                  ),
                                  onTap: () => cropImage(context),
                                ),
                              ],
                            ),
                          ),
                Flexible(
                  child: Container(
                    child: ValueListenableBuilder<String>(
                      valueListenable: text,
                      builder: (context, value, child) => Directionality(
                        textDirection: lang == "ar"
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
                                fontSize: convertPtToPx(AppFontsSizeManager.s12.sp),
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
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: AppPadding.p17_3.w),
                  child: InkWell(
                    child: lang == "ar"
                        ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(-1.0, 1.0, 1.0),
                      child: SvgPicture.asset(
                        AssetsManager.sendFilled,
                        height: convertPtToPx(AppSize.h28_4).h,
                        width: convertPtToPx(AppSize.w25_3).w,
                        color: AppColors.pink2,

                      ),
                    )
                        : RotationTransition(
                      turns:
                      new AlwaysStoppedAnimation(180 / 360),
                          child: SvgPicture.asset(
                                              AssetsManager.sendFilled,
                            height: convertPtToPx(AppSize.h28_4).h,
                            width: convertPtToPx(AppSize.w25_3).w,
                            color: AppColors.pink2,

                          ),
                        ),
                    onTap: () => onSendMessage(
                      textEditingController.text,
                      "text",
                      size,
                    ),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(width: AppSize.w10.w,),

          AudioRecorder(
            loggedId: widget.user.uid!,
            onSendMessage: onSendMessage,
            focusNode: focusNode,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: AppColors.white3, width: 0.5)),
          color: Colors.transparent),
    );
  }

  Future uploadToStorage(context, Size size) async {
    try {
      setState(() {
        uploadVideo = true;
      });
      final pickedFile =
          await ImagePicker.platform.pickVideo(source: ImageSource.gallery);
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

  _scrollToBottom() {
    FirebaseDatabase.instance
        .ref()
        .child('appointmentsChatMessage/${widget.appointment.appointmentId}')
        .onValue
        .listen((event) {
      if (listScrollController.hasClients)
        listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
    });
  }

  Widget buildInput(Size size) {
    return Column(
      children: [
        Container(
          width: size.width,
          height: AppSize.h1.h,
          color: AppColors.lightGray,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSize.h32.h),
              Text(
                getTranslated(context, "selectMessageToSend"),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    color: AppColors.pink2,
                    fontSize: convertPtToPx(AppFontsSizeManager.s16.sp),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: AppSize.h37_3.h),
              GridView.count(
                shrinkWrap: true,
                crossAxisSpacing: AppSize.w21_3.w,
                mainAxisSpacing: AppSize.h21_3.h,
                childAspectRatio: (1 / .2),
                physics: ScrollPhysics(),
                crossAxisCount: 2,
                children:
                    new List<Widget>.generate(chatUserList.length, (index) {
                  return InkWell(
                    splashColor: Colors.purple.withOpacity(0.5),
                    onTap: () async {
                      setState(() {
                        selectedCard = index;
                      });
                      onSendMessage(chatUserList[index], "text", size);
                      //chatUserList
                    },
                    child: selectedCard == index
                        ? Center(
                            child: CircularProgressIndicator(
                            color: AppColors.reddark2,
                          ))
                        : cell(size, chatUserList[index]),
                  );
                }),
              ),
              SizedBox(
                height: convertPtToPx(AppSize.h24.h),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget cell(Size size, String name) {
    String lang = "";
    lang = getTranslated(context, "lang");
    return Container(
      height: convertPtToPx(AppSize.h37.h),
      width: convertPtToPx(AppSize.w182.w),
      padding: EdgeInsets.only(
        left: convertPtToPx(AppPadding.p12.r),
        right: convertPtToPx(AppPadding.p12.r),
      ),
      decoration: BoxDecoration(
        color: AppColors.time,
        borderRadius: BorderRadius.circular(convertPtToPx(AppRadius.r4.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              name,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
              style: TextStyle(
                fontFamily: getTranslated(context, "Montserratmedium"),
                color: Colors.black,
                fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
              ),
            ),
          ),
          lang == "ar"
              ? SvgPicture.asset(
                  AssetsManager.sendIconPath,
                  width: convertPtToPx(AppSize.w16.w),
                  height: convertPtToPx(AppSize.h14.h),
                )
              : RotationTransition(
                  turns: AlwaysStoppedAnimation(180 / 360),
                  child: SvgPicture.asset(
                    AssetsManager.sendIconPath,
                    width: convertPtToPx(AppSize.w16.w),
                    height: convertPtToPx(AppSize.h14.h),
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
          .child(
              "appointmentsChatMessage/${widget.appointment.appointmentId}/$messageId")
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
      // if (widget.user.userType == "CONSULTANT"||widget.user.userType == "COACH") {
      if (widget.appointment.consult.uid == widget.user.uid) {
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
        uploadingImage=false;
        selectedCard = -1;
      });
    }
  }

  Future<void> sendNotification(String userId, String text) async {
    try {
      Map notifMap = Map();
      notifMap.putIfAbsent('title', () => "Chat");
      notifMap.putIfAbsent('body', () => text);
      notifMap.putIfAbsent('userId', () => userId);
      notifMap.putIfAbsent(
          'appointmentId', () => widget.appointment.appointmentId);
      await http.post(
        Uri.parse(
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
      uploadingImage = true;
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

  twilioCall() async {
    if (widget.user.userType == AppConstants.coach ||
        widget.user.userType == AppConstants.consultant) {
      var user = await CallServices.getUserFromFirebase(
          userId: FirebaseAuth.instance.currentUser!.uid);
      CallServices.startJisiCall(
          appointment: widget.appointment,
          loggedUser: user!,
          context: context,
          receiverId: widget.appointment.user.uid);
    } else
      Fluttertoast.showToast(
          msg: getTranslated(context, "callNotStart"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
  }

  agoraCall() async {
    try {
      setState(() {
        loadingCall = true;
      });
      if (widget.user.userType == "CONSULTANT") {
        await FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .doc(widget.appointment.appointmentId)
            .set({
          'allowCall': true,
        }, SetOptions(merge: true));

        var user = await CallServices.getUserFromFirebase(
            userId: FirebaseAuth.instance.currentUser!.uid);
        CallServices.startJisiCall(
            appointment: widget.appointment,
            loggedUser: user!,
            context: context,
            receiverId: widget.appointment.user.uid);
      } else {
        DocumentReference docRef2 = FirebaseFirestore.instance
            .collection(Paths.appAppointments)
            .doc(widget.appointment.appointmentId);
        final DocumentSnapshot documentSnapshot2 = await docRef2.get();
        var currentAppointment =
            AppAppointments.fromMap(documentSnapshot2.data() as Map);
        if (currentAppointment.allowCall == false) {
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
        } else {
          setState(() {
            loadingCall = false;
          });
          var user = await CallServices.getUserFromFirebase(
              userId: FirebaseAuth.instance.currentUser!.uid);
          CallServices.startJisiCall(
              appointment: widget.appointment,
              loggedUser: user!,
              context: context,
              receiverId: widget.appointment.consult.uid);
        }
      }
    } catch (e) {
      setState(() {
        loadingCall = false;
      });
    }
  }

  Future<void> sendCallNotification(String consultName, String userId,
      String appointmentId, String roomId) async {
    try {
      print("sendnot111");
      Map notifMap = Map();
      notifMap.putIfAbsent('consultName', () => consultName);
      notifMap.putIfAbsent('userId', () => userId);
      notifMap.putIfAbsent('appointmentId', () => appointmentId);
      notifMap.putIfAbsent('type', () => widget.appointment.consultType);
      notifMap.putIfAbsent('roomId', () => roomId);
      var refundRes = await http.post(
        Uri.parse(
            'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendCallNotification'),
        body: notifMap,
      );
      /*   print("sendnot11122");
      var refund = jsonDecode(refundRes.body);
      if (refund['message'] != 'Success') {
        print("sendnotification111  error");
      }
      else
      { print("sendnotification1111 success");}*/
    } catch (e) {
      print("sendnotification111  " + e.toString());
    }
  }
}
