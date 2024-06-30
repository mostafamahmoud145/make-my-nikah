import 'dart:core';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/screens/bioDetailsScreen.dart';
import 'package:grocery_store/screens/supportMessagesScreen.dart';
import 'package:grocery_store/screens/interviewVideoCallScreen.dart';
import 'package:grocery_store/widget/processing_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/paths.dart';
import '../models/SupportList.dart';
import '../models/userDetails.dart';
import 'package:http/http.dart' as http;

import '../services/call_services.dart';

class InterviewScreen extends StatefulWidget {
  final GroceryUser user;
  final GroceryUser loggedUser;

  const InterviewScreen(
      {Key? key, required this.user, required this.loggedUser})
      : super(key: key);

  @override
  _InterviewScreenState createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  late AccountBloc accountBloc;

  late ScrollController scrollController;
  late List<WorkTimes> workTimes;
  List<dynamic> daysValue = [], dayListValue = [];
  WorkTimes _workTime = new WorkTimes();
  var image;
  File? selectedProfileImage;
  Size? size;
  bool loadingCall = false, loadingChat = false;
  String from = "", to = "", days = "";
  late int localFrom, localTo;
  List<String> dayList = [];

  UserDetail userDetails = UserDetail();
  bool loadData = true;

  void getuserDetails(String userID) async {
    print("p1");
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(Paths.userDetail)
        .doc(userID)
        .get();
    loadData = false;
    setState(() {
      userDetails = UserDetail.fromMap(snapshot.data() as Map);
      print("ffffffffff");
    });
  }

  void showSnack(String text, BuildContext context, bool status) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: BorderRadius.circular(10),
      backgroundColor:
          status ? Theme.of(context).primaryColor : Colors.red.shade500,
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
        style: TextStyle(
          fontFamily: getTranslated(context, "fontFamily"),
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
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
    image = await ImagePicker().getImage(source: ImageSource.gallery);

    File croppedFile = File(image.path);

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      setState(() {
        selectedProfileImage = croppedFile;
      });
      // signupBloc.add(PickedProfilePictureEvent(file: croppedFile));
    } else {
      //not croppped
    }
  }

  @override
  void initState() {
    getuserDetails(widget.user.uid!);
    print('p2');
    localFrom = DateTime.parse(widget.user.fromUtc!).toLocal().hour;
    localTo = DateTime.parse(widget.user.toUtc!).toLocal().hour;
    if (localTo == 0) localTo = 24;

    if (widget.user.workTimes!.length > 0) {
      if (localFrom == 12)
        from = "12 PM";
      else if (localFrom == 0)
        from = "12 AM";
      else if (localFrom > 12)
        from = ((localFrom) - 12).toString() + " PM";
      else
        from = (localFrom).toString() + " AM";
    }
    if (widget.user.workTimes!.length > 0) {
      if (localTo == 12)
        to = "12 PM";
      else if (localTo == 0 || localTo == 24)
        to = "12 AM";
      else if (localTo > 12)
        to = ((localTo) - 12).toString() + " PM";
      else
        to = (localTo).toString() + " AM";
    }
    print('p3');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.user.workDays!.length > 0) {
      dayList = [];
      if (widget.user.workDays!.contains("1"))
        dayList.add(getTranslated(context, "monday"));
      if (widget.user.workDays!.contains("2"))
        dayList.add(getTranslated(context, "tuesday"));
      if (widget.user.workDays!.contains("3"))
        dayList.add(getTranslated(context, "wednesday"));
      if (widget.user.workDays!.contains("4"))
        dayList.add(getTranslated(context, "thursday"));
      if (widget.user.workDays!.contains("5"))
        dayList.add(getTranslated(context, "friday"));
      if (widget.user.workDays!.contains("6"))
        dayList.add(getTranslated(context, "saturday"));
      if (widget.user.workDays!.contains("7"))
        dayList.add(getTranslated(context, "sunday"));
      print('p4');
      setState(() {
        dayListValue = dayList;
      });
    }
    print('p5');
    for (int x = 0; x < dayListValue.length; x++) {
      days = days + dayListValue[x] + " - ";
    }
    super.didChangeDependencies();
  }

  StartChat() async {
    setState(() {
      loadingChat = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("SupportList")
        .where(
          'userUid',
          isEqualTo: widget.user.uid,
        )
        .limit(1)
        .get();
    if (querySnapshot.docs.length != 0) {
      var item = SupportList.fromMap(querySnapshot.docs[0].data() as Map);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SupportMessageScreen(item: item, user: widget.loggedUser),
        ),
      );
      setState(() {
        loadingChat = false;
      });
    } else {
      setState(() {
        loadingChat = false;
      });
    }
  }

  agoraCall() async {
    try {
      print("yarb11");
      setState(() {
        loadingCall = true;
      });
      Map notifMap = Map();
      notifMap.putIfAbsent('userId', () => widget.user.uid);
      notifMap.putIfAbsent('type', () => "interview");
      var refundRes = await http.post(
        Uri.parse(
            'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/sendInterviewNotification'),
        body: notifMap,
      );
      print("ref");
      print(refundRes.body);
     
      CallServices.startInterviewCall(
          context: context,
          loggedUser: widget.loggedUser,
          receiverId: widget.user.uid!);
     
      setState(() {
        loadingCall = false;
      });
    } catch (e) {
      print("sendnotification111  " + e.toString());
      //showSnack(getTranslated(context, "error"), context);
      setState(() {
        loadingCall = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: size!.width,
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 0.0, bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    Text(
                      getTranslated(context, "interviews"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 17.0,
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: size!.width * 0.1,
                    ),
                    loadingCall
                        ? CircularProgressIndicator()
                        : Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () {
                                agoraCall();
                              },
                              icon: Image.asset(
                                "assets/icons/icon/outline-phone-24px.png",
                                width: 30,
                                height: 30,
                                color: AppColors.reddark,
                              ),
                            ),
                          ),
                    loadingChat
                        ? CircularProgressIndicator()
                        : Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              onPressed: () {
                                StartChat();
                              },
                              icon: Image.asset(
                                "assets/icons/icon/Group2822.png",
                                width: 20,
                                height: 20,
                                color: AppColors.reddark,
                              ),
                            ),
                          ),
                  ],
                ),
              ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size!.width)),
          loadData
              ? CircularProgressIndicator()
              : Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // padding: EdgeInsets.all(20),
                        children: [
                          SizedBox(
                            height: size!.height * 0.06,
                          ),
                          getTitle(getTranslated(context, "name")),
                          widget.user.name != null
                              ? getText(widget.user.name!)
                              : getText('...'),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),
                          getTitle(getTranslated(context, "phoneNumber")),
                          getText(widget.user.phoneNumber == null
                              ? ""
                              : widget.user.phoneNumber!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),
                          getTitle(getTranslated(context, "country")),
                          getText(widget.user.country == null
                              ? ""
                              : widget.user.country!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "age")),
                          getText(widget.user.age == null
                              ? ""
                              : widget.user.age.toString()),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "height")),
                          getText(widget.user.length.toString() == null
                              ? ""
                              : widget.user.length.toString()),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "weight")),
                          getText(widget.user.weight.toString() == null
                              ? ""
                              : widget.user.weight.toString()),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "maritalStatus")),
                          getText(widget.user.maritalStatus == null
                              ? ""
                              : widget.user.maritalStatus!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "education")),
                          getText(widget.user.education == null
                              ? ""
                              : widget.user.education!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "skincolor")),
                          getText(widget.user.color == null
                              ? ""
                              : widget.user.color!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "employmentStatus")),
                          getText(widget.user.employment == null
                              ? ""
                              : widget.user.employment!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "childrenNum")),
                          getText(widget.user.childrenNum.toString() == null
                              ? ""
                              : widget.user.childrenNum.toString()),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "marriageType")),
                          getText(widget.user.marriage == null
                              ? ""
                              : widget.user.marriage!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "hijab")),
                          getText(widget.user.hijab == null
                              ? ""
                              : widget.user.hijab!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "livingStander")),
                          getText(widget.user.living == null
                              ? ""
                              : widget.user.living!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          // getTitle(getTranslated(context, "tribal")),
                          // getText(widget.user.tribal == null ? "" : widget.user.tribal),
                          // SizedBox(height: size!.height * 0.06,),

                          getTitle(getTranslated(context, "Smoking")),
                          getText(widget.user.smooking == null
                              ? ""
                              : widget.user.smooking!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),
                          getTitle(getTranslated(context, "tribal")),
                          getText(widget.user.tribal == null
                              ? ""
                              : widget.user.tribal!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "religion")),
                          getText(widget.user.origin == null
                              ? ""
                              : widget.user.origin!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "nature")),
                          getText(userDetails.characterNature == null
                              ? ""
                              : userDetails.characterNature!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "values")),
                          getText(userDetails.values == null
                              ? ""
                              : userDetails.values!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "habits")),
                          getText(userDetails.habbits == null
                              ? ""
                              : userDetails.habbits!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "hobbies")),
                          getText(userDetails.hobbies == null
                              ? ""
                              : userDetails.hobbies!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "life")),
                          getText(userDetails.priorties == null
                              ? ""
                              : userDetails.priorties!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "positive")),
                          getText(userDetails.positivePoints == null
                              ? ""
                              : userDetails.positivePoints!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "negative")),
                          getText(userDetails.negativePoints == null
                              ? ""
                              : userDetails.negativePoints!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "like")),
                          getText(userDetails.lovableThings == null
                              ? ""
                              : userDetails.lovableThings!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "disLike")),
                          getText(userDetails.hatefulThings == null
                              ? ""
                              : userDetails.hatefulThings!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "fiveYears")),
                          getText(userDetails.marriageYears == null
                              ? ""
                              : userDetails.marriageYears!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "quran")),
                          getText(userDetails.quranLevel == null
                              ? ""
                              : userDetails.quranLevel!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "sciences")),
                          getText(userDetails.religionLevel == null
                              ? ""
                              : userDetails.religionLevel!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "healthConditions")),
                          getText(userDetails.healthCondition == null
                              ? ""
                              : userDetails.healthCondition!),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "workTime")),
                          getText(days),
                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    getTranslated(context, "from") + ":  ",
                                    style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 10,
                                    ),
                                  ),
                                  getText(from)
                                ],
                              ),
                              SizedBox(
                                width: size!.width * 0.085,
                              ),
                              Row(
                                children: [
                                  Text(
                                    getTranslated(context, "to") + ":  ",
                                    style: TextStyle(
                                      color: AppColors.reddark2,
                                      fontSize: 10,
                                    ),
                                  ),
                                  getText(to)
                                ],
                              ),
                            ],
                          ),

                          SizedBox(
                            height: size!.height * 0.06,
                          ),

                          getTitle(getTranslated(context, "personalPhotoId")),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                                width: size!.width * 0.65,
                                height: size!.height * 0.17,
                                decoration: BoxDecoration(
                                  color: widget.user.photoUrl != null &&
                                          widget.user.photoUrl != ""
                                      ? Colors.transparent
                                      : AppColors.black2,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppColors.black2),
                                ),
                                child: widget.user.photoUrl != null &&
                                        widget.user.photoUrl != ""
                                    ? Container(
                                        color: Colors.white,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(AppColors.white),
                                          ),
                                          child: Image.network(
                                              widget.user.photoUrl!),
                                          onPressed: () async {
                                            // launchURL(chatContent);
                                            var url = widget.user.photoUrl;
                                            if (!url!.contains('http')) {
                                              url = 'https://$url';
                                            }
                                            await launch(url);
                                          },
                                        ),
                                      )
                                    : SizedBox()),
                          ),
                          SizedBox(
                            height: size!.height * 0.045,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection(Paths.usersPath)
                                        .doc(widget.user.uid)
                                        .set({
                                      'accountStatus': 'NotActive',
                                      'order': widget.user.order == null
                                          ? 0
                                          : widget.user.order
                                    }, SetOptions(merge: true)).then(
                                            (value) => Navigator.pop(context));
                                  },
                                  child: Container(
                                    width: size!.width * 0.25,
                                    height: size!.height * 0.035,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.reddark),
                                    child: Center(
                                      child: Text(
                                        getTranslated(context, "refuse1"),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.white,
                                            fontFamily: getTranslated(
                                                context, "fontFamily")),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection(Paths.usersPath)
                                        .doc(widget.user.uid)
                                        .set({
                                      'accountStatus': 'Active',
                                      'order': widget.user.order == null
                                          ? 0
                                          : widget.user.order
                                    }, SetOptions(merge: true)).then(
                                            (value) => Navigator.pop(context));
                                  },
                                  child: Container(
                                    width: size!.width * 0.25,
                                    height: size!.height * 0.035,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.brown),
                                    child: Center(
                                      child: Text(
                                        getTranslated(context, "accept1"),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.white,
                                            fontFamily: getTranslated(
                                                context, "fontFamily")),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size!.height * 0.1,
                          ),
                          Center(
                            child: Container(
                              width: size!.width * 0.7,
                              height: size!.height * 0.054,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.reddark2,
                                      AppColors.reddark2,
                                    ],
                                  )),
                              child: MaterialButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BioDetailsScreen(
                                        consult: widget.user,
                                        loggedUser: widget.loggedUser,
                                        consultDetails: this.userDetails,
                                        screen: 2,
                                        //loggedUser:loggedUser,
                                      ),
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  getTranslated(
                                      context, "partnerSpecification"),
                                  style: TextStyle(
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size!.height * 0.1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget getTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: getTranslated(context, "fontFamily"),
            fontSize: 17.0,
            color: AppColors.reddark,
            fontWeight: FontWeight.normal),
      ),
      // ),
      // ),
      // ),
    );
  }

  Widget getText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: getTranslated(context, "fontFamily"),
            fontSize: 13.0,
            color: AppColors.black2,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
