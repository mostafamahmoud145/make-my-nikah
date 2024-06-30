

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/supportMessagesScreen.dart';
import 'package:grocery_store/screens/interviewVideoCallScreen.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/AppAppointments.dart';
import '../models/SupportList.dart';
import '../models/report.dart';
import 'package:http/http.dart' as http;

class ReportDetail extends StatefulWidget {
  final Report report;
  final GroceryUser loogedUser;

  const ReportDetail({Key? key, required this.report, required this.loogedUser}) : super(key: key);

  @override
  State<ReportDetail> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportDetail> {
  static final String kBaseURL =
      "https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/";
  List<dynamic>? recordList = [];
  String theme = "light";
  bool block = false,
      refund = false,
      solved = false,
      order = false,
      submit = false,
      saving = false,first=true;
  late String dropdownvalue;
  late Query query;
  var header = {"Content-Type": "application/json"};
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GroceryUser user;
  bool adding = false, load = true, loading = false;
  late String reportReason;
  bool loadingCall = false, loadingChat = false;
  final TextEditingController orderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.report.appointmentId!="")
    getRecordsFun();
    query = FirebaseFirestore.instance
        .collection(Paths.complaintsPath)
        .where('status', isEqualTo: "new")
        .orderBy('complaintTime', descending: true);

    FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.report.consultUid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      orderController.text = data["order"].toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    orderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Container(
              width: size.width,
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      getTranslated(context, "reportDetail"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 17.0,
                          color: AppColors.balck2,
                          fontWeight: FontWeight.w300),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: "appointment: " +
                                widget.report.appointmentId! +
                                "\n" +
                                "reportId: " +
                                widget.report.id! +
                                "\n" +
                                "consultName: " +
                                widget.report.consultName! +
                                "\n" +
                                "consultPhone: " +
                                widget.report.consultPhone! +
                                "\n" +
                                "ClientName: " +
                                widget.report.name! +
                                "\n" +
                                "ClientPhone: " +
                                widget.report.phone! +
                                "\n"));
                        Fluttertoast.showToast(
                            msg: getTranslated(context, "textCopy"),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: Icon(
                        Icons.copy,
                        size: 18,
                        color: AppColors.reddark2,
                      ),
                    ),
                  ],
                ),
              ))),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),

          // change from here this is body of screen
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    width: size.width * 0.85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [shadow()]),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    getTranslated(
                                      context,
                                      "leftrose1",
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    getTranslated(context, "Details"),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      color: AppColors.reddark2,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Image.asset(
                                    getTranslated(context, "rightrose1"),
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              )),
                          /* Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(width:size.width*0.3,
                                child: Text(getTranslated(context, "complaintfrom"),textAlign: TextAlign.start,
                                  style: TextStyle(
                                  color: AppColors.reddark2, fontFamily: getTranslated(context, "fontFamily"), fontSize: 12,
                                ),),
                              ),
                              Text(widget.report.name,textAlign: TextAlign.start, maxLines:1,style: TextStyle(
                                color: AppColors.black, fontFamily: getTranslated(context, "fontFamily"), fontSize: 12,
                              ))
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(width:size.width*0.3,
                                child: Text(getTranslated(context, "phone."),textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2, fontFamily: getTranslated(context, "fontFamily"), fontSize: 12,
                                  ),),
                              ),
                              Text(widget.report.phone,textAlign: TextAlign.start, maxLines:1,style: TextStyle(
                                color: AppColors.black, fontFamily: getTranslated(context, "fontFamily"), fontSize: 12,
                              ))
                            ],
                          ),*/
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: Text(
                                  getTranslated(context, "date"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                  widget.report.complaintTime!
                                          .toDate()
                                          .year
                                          .toString() +
                                      "- " +
                                      widget.report.complaintTime!
                                          .toDate()
                                          .month
                                          .toString() +
                                      "- " +
                                      widget.report.complaintTime!
                                          .toDate()
                                          .day
                                          .toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: Text(
                                  getTranslated(context, "complainttext"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(),
                              SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              widget.report.other!
                                  ? widget.report.complaints
                                  : getTranslated(
                                      context, widget.report.complaints!),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: TextStyle(
                                color: AppColors.black,
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontSize: 12,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                         widget.report.appointmentId!=""? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: Text(
                                  getTranslated(context, "callrecording"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(),
                              SizedBox(),
                            ],
                          ):SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                          widget.report.appointmentId==""?SizedBox():load
                              ? CircularProgressIndicator()
                              : recordList!.length > 0
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        for (int x = 0;
                                            x < recordList!.length;
                                            x++)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text:
                                                            recordList![x]));
                                                    Fluttertoast.showToast(
                                                        msg: getTranslated(
                                                            context,
                                                            "textCopy"),
                                                        toastLength:
                                                        Toast.LENGTH_SHORT,
                                                        gravity:
                                                        ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                        Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  },
                                                  child: Icon(
                                                    Icons.copy,
                                                    size: 18,
                                                    color: AppColors.greendark,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  "record_"+x.toString(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: AppColors.black,
                                                    fontFamily: getTranslated(
                                                        context, "fontFamily"),
                                                    fontSize: 12,
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                      ],
                                    )
                                  : Text(
                                      getTranslated(context, "noRecords"),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontFamily: getTranslated(
                                            context, "fontFamily"),
                                        fontSize: 12,
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: size.width * 0.85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [shadow()]),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    getTranslated(
                                      context,
                                      "leftrose1",
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    getTranslated(context, "clientDetails"),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      color: AppColors.reddark2,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Image.asset(
                                    getTranslated(context, "rightrose1"),
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.25,
                                child: Text(
                                  getTranslated(context, "name"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.35,
                                child: Text(widget.report.consultName!,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: Text(
                                  getTranslated(context, "phone."),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(widget.report.consultPhone!,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: loadingChat
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: () {
                                      StartChat(widget.report.consultUid!);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.reddark)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/icon/Group2822.png",
                                            width: 15,
                                            height: 15,
                                            color: AppColors.reddark,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            getTranslated(context, "message"),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: getTranslated(
                                                  context, "fontFamily"),
                                              color: AppColors.black3,
                                              fontSize: 11.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width * 0.85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [shadow()]),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    getTranslated(
                                      context,
                                      "leftrose1",
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    getTranslated(context, "consultDetails"),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      color: AppColors.reddark2,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Image.asset(
                                    getTranslated(context, "rightrose1"),
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.25,
                                child: Text(
                                  getTranslated(context, "name"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.35,
                                child: Text(widget.report.name!,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: Text(
                                  getTranslated(context, "phone."),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColors.reddark2,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(widget.report.phone!,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontSize: 12,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: loadingChat
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: () {
                                      StartChat(widget.report.uid!);
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.reddark)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/icon/Group2822.png",
                                            width: 15,
                                            height: 15,
                                            color: AppColors.reddark,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            getTranslated(context, "message"),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: getTranslated(
                                                  context, "fontFamily"),
                                              color: AppColors.black3,
                                              fontSize: 11.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  widget.report.status=="new"?Center(
                    child: InkWell(
                      onTap: () {
                        _show(context, size);
                      },
                      child: Container(
                        width: size.width * .6,
                        height: 45.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.pink2,
                                AppColors.red1,
                              ],
                            )),
                        child: Center(
                          child: Text(
                            "take Action",
                            style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                color: AppColors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

   getRecordsFun() async {
    DocumentReference docRef2 = FirebaseFirestore.instance
        .collection(Paths.appAppointments)
        .doc(widget.report.appointmentId);
    final DocumentSnapshot documentSnapshot2 = await docRef2.get();
    var currentAppointment = AppAppointments.fromMap(documentSnapshot2.data() as Map);
    if (currentAppointment.roomList!.length > 0) {
      setState(() {
        recordList = currentAppointment.roomList;
        load = false;
      });
    } else {
      setState(() {
        load = false;
      });
    }
  }

  takeAction() async {
    setState(() {
      submit = true;
    });
    if (order == true) {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.report.consultUid)
          .set({
        'order': int.parse(
          orderController.text.toString(),
        ),
      }, SetOptions(merge: true));
      //print("order in if ===${order}");
    }
    if (refund == true) {
      //refund
      print("refunddddd");
      dynamic payedBalance = 0, userbalance = 0, consultBalance = 0;
      //1: get taxes
      DocumentReference docRef = FirebaseFirestore.instance
          .collection(Paths.settingPath)
          .doc("pzBqiphy5o2kkzJgWUT7");
      final DocumentSnapshot taxDocumentSnapshot = await docRef.get();
      var taxes = Setting.fromMap(taxDocumentSnapshot.data() as Map).taxes;
      dynamic taxesvalue = (30 * taxes) / 100;
      dynamic discount = 30 - taxesvalue;
      var refundFees=((30*1.14)/100)+.27;
      print("kkkkkk");
      print(refundFees);
      print(discount);
      discount=discount+refundFees;
      print(discount);
      //2: get currentUser
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.report.uid)
          .get();
      GroceryUser currentUser = GroceryUser.fromMap(documentSnapshot.data() as Map);

      //3: get consult
      DocumentSnapshot documentSnapshot2 = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.report.consultUid)
          .get();
      GroceryUser consult = GroceryUser.fromMap(documentSnapshot2.data() as Map);

      //4.    update conult balance
      if (consult.payedBalance != null)
        payedBalance = consult.payedBalance! - discount;
      else
        payedBalance = -discount;
      print("endmeeting3");
      print(consult.balance);
      print("endmeeting3222222");
      if (consult.balance != null)
        consultBalance = consult.balance! - discount;
      else
        consultBalance = -discount;

      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.report.consultUid)
          .set({
        'balance': consultBalance,
        'payedBalance': payedBalance,
      }, SetOptions(merge: true));

      //5: update user balance
      if (currentUser.balance != null)
        userbalance = currentUser.balance! + 30;
      else
        userbalance = 30;
      print("endmeeting4");
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.report.uid)
          .set({
        'balance': userbalance,
      }, SetOptions(merge: true));
    }
    if (block == true) {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.report.consultUid)
          .set({
             'isBlocked': true,
             'accountStatus': "Block"}, SetOptions(merge: true));
      await FirebaseFirestore.instance.collection(Paths.appAnalysisPath)
          .doc("TgWCp3B22sbkl0Nm3wLx").update({"blockedConsult": FieldValue.increment(1)});
    }
      await FirebaseFirestore.instance
          .collection(Paths.complaintsPath)
          .doc(widget.report.id)
          .set({
        'status': "closed",
      }, SetOptions(merge: true));
    setState(() {
      submit = false;
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  updateStatus() async {
    setState(() {
      adding = true;
    });
    await FirebaseFirestore.instance
        .collection(Paths.complaintsPath)
        .doc(widget.report.id)
        .set({
      'status': "closed",
    }, SetOptions(merge: true));
    setState(() {
      adding = false;
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: AppColors.lightGrey,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(0.0, 1.0), // shadow direction: bottom right
    );
  }

  StartChat(String uid) async {
    setState(() {
      loadingChat = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("SupportList")
        .where(
          'userUid',
          isEqualTo: uid,
        )
        .limit(1)
        .get();
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      var item = SupportList.fromMap(querySnapshot.docs[0].data() as Map);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SupportMessageScreen(item: item, user: widget.loogedUser, ),
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



  void _show(BuildContext ctx, size) {
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: Colors.transparent,
      context: ctx,
      builder: (ctx) => Container(
        height: size.height * .8,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
            )),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'take Action',
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          color: theme == "light"
                              ? AppColors.black
                              : AppColors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: order,
                          onChanged: (value) {
                            setState(() {
                              order = !order;
                            });
                          },
                        ),
                        Container(
                          width: size.width * .3,
                          child: Text(
                            getTranslated(context, "order1"),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * .3,
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            //initialValue: displayController.text.toString(),
                            controller: orderController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            enableInteractiveSelection: false,
                            style: GoogleFonts.cairo(
                              fontSize: 14.0,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 8.0),
                              border: InputBorder.none,
                              hintText: orderController.text.toString(),
                              hintStyle: GoogleFonts.cairo(
                                fontSize: 14.0,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                              counterStyle: GoogleFonts.cairo(
                                fontSize: 12.5,
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: block,
                          onChanged: (value) {
                            setState(() {
                              block = !block;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "block"),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: refund,
                          onChanged: (value) {
                            setState(() {
                              refund = !refund;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "refund"),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: solved,
                          onChanged: (value) {
                            setState(() {
                              solved = !solved;
                            });
                          },
                        ),
                        Text(
                          getTranslated(context, "solved"),
                          style: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: theme == "light"
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    submit
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Center(
                              child: SizedBox(
                                height: 35,
                                width: size.width,
                                child: MaterialButton(
                                  onPressed: () {
                                    submit=true;
                                    takeAction();
                                  },
                                  color: AppColors.white3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Text(
                                    getTranslated(context, "submit"),
                                    style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      color: AppColors.black2,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                  ],
                ),
              );
            })),
      ),
    );
  }

  showReview(Size size, String title, String bottom) async {
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
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: loading
                          ? CircularProgressIndicator()
                          : Container(
                              width: size.width * .2,
                              child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (bottom == "block") {
                                    await FirebaseFirestore.instance
                                        .collection(Paths.usersPath)
                                        .doc(widget.report.consultUid)
                                        .set({'isBlocked': true, 'balance': 0},
                                            SetOptions(merge: true));
                                  } else {
                                    //refund
                                    print("refunddddd");
                                    dynamic payedBalance = 0,
                                        userbalance = 0,
                                        consultBalance = 0;
                                    //1: get taxes
                                    DocumentReference docRef = FirebaseFirestore
                                        .instance
                                        .collection(Paths.settingPath)
                                        .doc("pzBqiphy5o2kkzJgWUT7");
                                    final DocumentSnapshot taxDocumentSnapshot =
                                        await docRef.get();
                                    var taxes = Setting.fromMap(
                                            taxDocumentSnapshot.data() as Map)
                                        .taxes;
                                    dynamic taxesvalue = (30 * taxes) / 100;
                                    dynamic discount = 30 - taxesvalue;
                                    print(discount);
                                    //2: get currentUser
                                    DocumentSnapshot documentSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection(Paths.usersPath)
                                            .doc(widget.report.uid)
                                            .get();
                                    GroceryUser currentUser =
                                        GroceryUser.fromMap(
                                            documentSnapshot.data() as Map);

                                    //3: get consult
                                    DocumentSnapshot documentSnapshot2 =
                                        await FirebaseFirestore.instance
                                            .collection(Paths.usersPath)
                                            .doc(widget.report.consultUid)
                                            .get();
                                    GroceryUser consult =
                                        GroceryUser.fromMap(
                                            documentSnapshot2.data() as Map);

                                    //4.    update conult balance
                                    if (consult.payedBalance != null)
                                      payedBalance =
                                          consult.payedBalance! - discount;
                                    else
                                      payedBalance = -discount;
                                    print("endmeeting3");
                                    if (consult.balance != null)
                                      consultBalance =
                                          consult.balance! - discount;
                                    else
                                      consultBalance = -discount;

                                    await FirebaseFirestore.instance
                                        .collection(Paths.usersPath)
                                        .doc(widget.report.consultUid)
                                        .set({
                                      'balance': consultBalance,
                                      'payedBalance': payedBalance,
                                    }, SetOptions(merge: true));

                                    //5: update user balance
                                    if (currentUser.balance != null)
                                      userbalance = currentUser.balance! + 30;
                                    else
                                      userbalance = 30;
                                    print("endmeeting4");
                                    await FirebaseFirestore.instance
                                        .collection(Paths.usersPath)
                                        .doc(widget.report.uid)
                                        .set({
                                      'balance': userbalance,
                                    }, SetOptions(merge: true));
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pop(context);
                                  updateStatus();
                                },
                                child: Text(
                                  getTranslated(context, 'Ok'),
                                  style: TextStyle(
                                    fontFamily: getTranslated(context, "fontFamily"),
                                    color: Colors.black87,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Center(
                      child: Container(
                        width: size.width * .2,
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(0.0),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            getTranslated(context, 'cancel'),
                            style: TextStyle(
                              fontFamily: getTranslated(context, "fontFamily"),
                              color: Colors.black87,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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

  packageDialog(Size size) async {
    await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.report.consultUid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      orderController.text = data["order"].toString();
    });
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
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Center(
                      child: Text(
                        getTranslated(context, "order"),
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * .3,
                      child: Text(
                        getTranslated(context, "order1"),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * .3,
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        //initialValue: displayController.text.toString(),
                        controller: orderController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        enableInteractiveSelection: false,
                        style: GoogleFonts.cairo(
                          fontSize: 14.0,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 8.0),
                          border: InputBorder.none,
                          hintText: orderController.text.toString(),
                          hintStyle: GoogleFonts.cairo(
                            fontSize: 14.0,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                          counterStyle: GoogleFonts.cairo(
                            fontSize: 12.5,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          setState(() {
                            load = false;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          getTranslated(context, 'cancel'),
                          style: GoogleFonts.cairo(
                            color: Colors.black87,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    saving
                        ? CircularProgressIndicator()
                        : Container(
                            width: 50.0,
                            child: MaterialButton(
                              padding: const EdgeInsets.all(0.0),
                              onPressed: () async {
                                setState(() {
                                  saving = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection(Paths.usersPath)
                                    .doc(widget.report.consultUid)
                                    .set({
                                  'order': int.parse(
                                    orderController.text.toString(),
                                  ),
                                }, SetOptions(merge: true));
                                setState(() {
                                  saving = false;
                                });
                                Navigator.pop(context);
                                updateStatus();
                              },
                              child: Text(
                                getTranslated(context, 'save'),
                                style: GoogleFonts.cairo(
                                  color: Colors.red.shade700,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            );
          })),
      barrierDismissible: false,
      context: context,
    );
  }
}
