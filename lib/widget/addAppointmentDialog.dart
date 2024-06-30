
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/consultDays.dart';
import '../models/consultPackage.dart';
import '../models/order.dart';
// import 'package:hijri/hijri_calendar.dart';
// import 'package:hijri_picker/hijri_picker.dart';
class AddAppointmentDialog extends StatefulWidget {
  final GroceryUser loggedUser;
  final GroceryUser consultant;
  final int localFrom;
  final int localTo;
  final String type;
  final String orderId;
  dynamic callPrice;
  AddAppointmentDialog({
     required this.loggedUser,required this.consultant, required this.localFrom,
    required this.localTo, required this.type, required this.orderId,required this.callPrice});

  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  int selectedCard = -1;
  bool hijri=false, gregorian=true,loadDates=true;
  String time=DateFormat('yyyy-MM-dd').format(DateTime.now()),dateText="", displayedTime=DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  late DateTime  selectedDate = DateTime.now(),date;
  List<dynamic> todayAppointmentList=[];
  @override
  void initState() {
    super.initState();
      getDate();

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 5.0,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        height: size.height * 0.5,
        width: double.maxFinite,
        constraints: BoxConstraints.loose(size),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, "selectAppointment"),
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.balck2,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.white.withOpacity(0.6),
                    onTap: () {
                      Navigator.pop(context);
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      width: 38.0,
                      height: 35.0,
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    splashColor: AppColors.green.withOpacity(0.6),
                    onTap: () {
                      setState(() {
                        displayedTime=DateFormat('yyyy-MM-dd').format(DateTime.now());
                        selectedDate=DateTime.now();
                        time=DateFormat('yyyy-MM-dd').format(DateTime.now());
                        gregorian = true;
                        hijri = false;
                      });
                    },
                    child: Container(
                      height: 25,
                      width: size.width * .3,
                      decoration: BoxDecoration(
                        color: gregorian? Theme.of(context).primaryColor
                            : AppColors.reddark2,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          getTranslated(context, "gregorian"),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                            color: gregorian? Colors.white
                                :Theme.of(context).primaryColor,
                            fontSize: 9.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox( width: 5.0,),
                  InkWell(
                    splashColor: AppColors.green.withOpacity(0.6),
                    onTap: () {
                      setState(() {
                        //displayedTime=HijriCalendar.now().toString();
                        selectedDate=DateTime.now();
                        time=DateFormat('yyyy-MM-dd').format(DateTime.now());
                        gregorian = false;
                        hijri = true;
                      });
                    },
                    child: Container(
                      height: 25,
                      width: size.width * .3,
                      decoration: BoxDecoration(
                        color: hijri? Theme.of(context).primaryColor
                            : AppColors.lightPink,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          getTranslated(context, "hijri"),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                            color: hijri? Colors.white
                                :Theme.of(context).primaryColor,
                            fontSize: 9.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(height: 25,//width: size.width*.60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0.0),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child:   InkWell(
                    splashColor:
                    Colors.white.withOpacity(0.6),
                    onTap: () async {
                      if(hijri)
                        _selectHijriDate(context);
                      else
                        _selectDate(context);
                    },
                    child: Row(
                      children: [
                        Expanded(flex:2,
                          child: Text(
                            displayedTime,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                              color:Theme.of(context).primaryColor,
                              fontSize: 11.0,
                            ),
                          ),
                        ),
                        Icon( Icons.date_range,size:20,
                          color: AppColors.reddark2,),
                      ],
                    ),
                  ),
                ),

              ),
              SizedBox( height: 20.0,),
              (loadDates==false&&todayAppointmentList.length>0)?
              GridView.count(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 3,
                children: new List<Widget>.generate(todayAppointmentList.length, (index) {
                  String  minues="00", d="Am",finalTime="";
                  if(DateTime.parse(todayAppointmentList[index]).toLocal().minute!=0)
                    minues=DateTime.parse(todayAppointmentList[index]).toLocal().minute.toString();
                  if(DateTime.parse(todayAppointmentList[index]).toLocal().hour>12)
                    finalTime=((DateTime.parse(todayAppointmentList[index]).toLocal().hour)-12).toString()+":"+minues+"Pm";
                  else if(DateTime.parse(todayAppointmentList[index]).toLocal().hour==12){
                    finalTime=DateTime.parse(todayAppointmentList[index]).toLocal().hour.toString()+":"+minues+"Pm";
                  }
                  else
                    finalTime=DateTime.parse(todayAppointmentList[index]).toLocal().hour.toString()+":"+minues+"Am";
                  return   InkWell(
                    splashColor:
                    Colors.purple.withOpacity(0.6),
                    onTap: () async {
                      print("selectedindex"+index.toString());
                      setState(() {
                        selectedCard=index;
                      });
                      addAppointment(DateTime.parse(todayAppointmentList[index]).toLocal());
                    },
                    child: selectedCard == index?Center(child: CircularProgressIndicator()):
                    Container(decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.grey2)
                    ),
                          child: new Center(
                            child: new Text('$finalTime', style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                              color:AppColors.balck2,
                              fontSize: 12.0,
                            ),),
                          ),
                        )
                  );
                }),
              
              )
                  :Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  loadDates?CircularProgressIndicator():SizedBox(),
                  Text(
                    dateText,
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  //-----------
  appointmentDialog(Size size,DateTime date) {
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
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
                child: Container(height: 70,width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.white,
                    ),
                    child: Image.asset('assets/icons/icon/Union.png', fit:BoxFit.contain,height: 70,width: 90)

                )
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              getTranslated(context, "appointmentRegister"),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: AppColors.balck2,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '${new DateFormat('dd MMM yyyy, hh:mm').format(DateTime.parse(date.toString()).toLocal())}',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                fontSize: 10.0,fontWeight: FontWeight.w300,
                color: AppColors.balck2,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                width: size.width*.4,height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.reddark2,
                        AppColors.brown
                      ],
                    )
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context,true);
                  },
                  child: Text(
                    getTranslated(context, 'Ok'),
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ), barrierDismissible: false,
      context: context,
    );
  }

 /* addEvent(String eventName,Map eventValues){
    AppsflyerSdk appsflyerSdk;
    if(Platform.isIOS) {
      Map<String, Object> appsFlyerOptions =  {
        "afDevKey": "S5MWquwKPo3DXx3PrxXECo",
        "afAppId": "id1665532757",
        "isDebug": true
      } ;
      appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
      appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true,
          registerOnDeepLinkingCallback: true
      );
    }
    else {
      Map<String, Object> appsFlyerOptions =  {
        "afDevKey": "S5MWquwKPo3DXx3PrxXECo",
        "isDebug": true
      } ;
      appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
      appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true,
          registerOnDeepLinkingCallback: true
      );
    }
    appsflyerSdk.logEvent(eventName, eventValues);

  }*/


  Future<void>addAppointment(DateTime date)async {
    print("callPrice0000");
    print(widget.callPrice);
    try {

      date = date.toUtc();
      String appointmentId = Uuid().v4();
      await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(
          appointmentId).set({
        'appointmentId': appointmentId,
        'appointmentStatus': 'open',
        'consultType':widget.type,
        'allowCall':false,
        'roomList':[],
        'type':'valid',
        "orderId":widget.orderId,
        'timestamp': DateTime.now().toUtc(),
        'timeValue': DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
        'secondValue': DateTime(
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second,
            date.millisecond).millisecondsSinceEpoch,
        'appointmentTimestamp': DateTime(
            date.year,
            date.month,
            date.day,
            date.hour,
            date.minute,
            date.second,
            date.millisecond),
        'utcTime': date.toString(),
        'consultChat': 0,
        'userChat': 0,
        'callPrice':widget.callPrice,
        'callCost': 0.0,
        'consult': {
          'uid': widget.consultant.uid,
          'name': widget.consultant.name,
          'image': widget.consultant.photoUrl,
          'phone': widget.consultant.phoneNumber,
          'countryCode': widget.consultant.countryCode,
          'countryISOCode': widget.consultant.countryISOCode,
        },
        'user': {
          'uid': widget.loggedUser.uid,
          'name': widget.loggedUser.name,
          'image': widget.loggedUser.photoUrl,
          'phone': widget.loggedUser.phoneNumber,
          'countryCode': widget.loggedUser.countryCode,
          'countryISOCode': widget.loggedUser.countryISOCode,

        },
        'date': {
          'day': date.day,
          'month': date.month,
          'year': date.year,
        },
        'time': {
          'hour': date.hour,
          'minute': date.minute,
        },
      }).then((value) async {
        await FirebaseFirestore.instance.collection(Paths.ordersPath).doc(
            widget.orderId).set({
          'orderStatus': "completed",
          'remainingCallNum': 0,
        }, SetOptions(merge: true)).then((value) async {

        }).catchError((err) {
        });
      }).catchError((err) {
      });



//========================
      todayAppointmentList.removeAt(selectedCard);
      await FirebaseFirestore.instance.collection(Paths.consultDaysPath).doc(time+"-"+widget.consultant.uid!).set({
        'todayAppointmentList': todayAppointmentList,
      }, SetOptions(merge: true));



      setState(() {
        selectedCard=-1;
      });
      Navigator.pop(context);
      appointmentDialog(MediaQuery
          .of(context)
          .size, date);
    }catch(e)  {
      String id = Uuid().v4();
      await FirebaseFirestore.instance.collection(Paths.errorLogPath).doc(id).set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'payUrl':'',
        'phone': widget.loggedUser == null ? " " : widget.loggedUser.phoneNumber,
        'screen': "ConsultantDetailsScreen",
        'function': "addAppointment",
      });
    }
  }

  getDate() async {
    print("kkkkk");
    try{
      if(DateTime(selectedDate.year, selectedDate.month, selectedDate.day).isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))||
          (!widget.consultant.workDays!.contains(selectedDate.weekday.toString())))
        setState(() {
          loadDates=false;
          todayAppointmentList=[];
          dateText=getTranslated(context,"selectData");
        });
      else
      {
        print("kkkkk11");
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(Paths.consultDaysPath).doc(time+"-"+widget.consultant.uid!).get();
       print(time+"-"+widget.consultant.uid!);
        if(documentSnapshot!=null&&documentSnapshot.exists){
          print("kkkkk13");
          ConsultDays consultDays = ConsultDays.fromMap(documentSnapshot.data() as Map);
          setState(() {
            loadDates=false;
            todayAppointmentList=consultDays.todayAppointmentList;
            if(todayAppointmentList.length==0)
              dateText=getTranslated(context,"noAppointment");
          });
        }
        else {
          print("kkkkk14");
          var from = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,widget.localFrom);
          var to = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,widget.localTo);
          var ttt=(to.difference(from).inHours).round();
          List<dynamic> appointmentList=[];
          var lessonTime=3;//widget.consultant.consultType=="glorified"?4:1;
          var lessonMintes=20;//widget.consultant.consultType=="glorified"?15:60;
          for(int start=0;start<ttt*lessonTime;start++)
          {
            if(from.add(Duration( minutes: start*lessonMintes)).isAfter(DateTime.now())) {
              var value=from.add(Duration( minutes: start*lessonMintes)).toUtc().toString();
              appointmentList.add(value);
            }
          }
          print("kkkkk15");
          await FirebaseFirestore.instance.collection(Paths.consultDaysPath).doc(time+"-"+widget.consultant.uid!).set({
            'id':time+"-"+widget.consultant.uid!,
            'day': time,
            'date': DateTime(selectedDate.year, selectedDate.month, selectedDate.day).millisecondsSinceEpoch,
            'consultUid':widget.consultant.uid,
            'todayAppointmentList': appointmentList,
          });
          setState(() {
            loadDates=false;
            todayAppointmentList=appointmentList;
          });
        }
      }
    }catch(e){
      print("startnew12ddd"+e.toString());
      String id = Uuid().v4();
      await FirebaseFirestore.instance.collection(Paths.errorLogPath) .doc(id).set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'phone': widget.loggedUser == null ? " " : widget.loggedUser.phoneNumber,
        'screen': "ConsultantDetailsScreen",
        'function': "getDate",
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    try{
      // Get the current date
      final DateTime now = DateTime.now();

      // Create a new DateTime object with only the year, month, and day (time is set to 00:00:00)
      final DateTime currentDate = DateTime(now.year, now.month, now.day);
      final DateTime? picked = await showDatePickerDialog(

        contentPadding: EdgeInsets.zero,
        context: context,
        initialDate: selectedDate,
        minDate: currentDate,
        maxDate: DateTime(2061, 10, 30),
        currentDate: currentDate,
        selectedDate: currentDate,
        currentDateDecoration: const BoxDecoration(),
        currentDateTextStyle: const TextStyle(),
        daysOfTheWeekTextStyle: TextStyle(
            fontFamily: getTranslated(context, "Montserratsemibold"),
            fontSize: 12,
            color: AppColors.grey3
        ),
        //disbaledCellsDecoration: const BoxDecoration(),
        disabledCellsTextStyle: const TextStyle(color: AppColors.grey),
        enabledCellsDecoration: const BoxDecoration(),
        enabledCellsTextStyle: const TextStyle(),
        initialPickerType: PickerType.days,
        selectedCellDecoration: const BoxDecoration(
          color: AppColors.pink2,
          shape: BoxShape.circle,
        ),
        selectedCellTextStyle: const TextStyle(
          color: AppColors.white,
        ),
        leadingDateTextStyle: const TextStyle(
            color: AppColors.pink2
        ),
        slidersColor: Colors.lightBlue,
        highlightColor: Colors.redAccent,
        slidersSize: 20,
        splashColor: Colors.lightBlueAccent,
        splashRadius: 40,
        centerLeadingDate: true,


      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          time = DateFormat('yyyy-MM-dd').format(picked);
          displayedTime=time;
          loadDates=true;
          todayAppointmentList=[];
          dateText=getTranslated(context,"load");
        });
          getDate();

      }
    }catch(e){
      print("startnew12ddd"+e.toString());
      String id = Uuid().v4();
      await FirebaseFirestore.instance.collection(Paths.errorLogPath) .doc(id).set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'phone': widget.loggedUser == null ? " " : widget.loggedUser.phoneNumber,
        'screen': "ConsultantDetailsScreen",
        'function': "_selectDate",
      });
    }
  }
  Future<Null> _selectHijriDate(BuildContext context) async {
    // try{
    //   final HijriCalendar? picked = await showHijriDatePicker(
    //     context: context,
    //     initialDate: new HijriCalendar.now(),
    //     lastDate: new HijriCalendar()
    //       ..hYear = 1445
    //       ..hMonth = 9
    //       ..hDay = 25,
    //     firstDate: new HijriCalendar()
    //       ..hYear = 1438
    //       ..hMonth = 12
    //       ..hDay = 25,
    //     initialDatePickerMode: DatePickerMode.day,
    //   );
    //   if (picked != null) {
    //     setState(() {
    //       //selectedDate = HijriCalendar().hijriToGregorian( picked.hYear, picked.hMonth, picked.hDay);
    //       time = DateFormat('yyyy-MM-dd').format(selectedDate);
    //       displayedTime = picked.toString();
    //       loadDates = true;
    //       todayAppointmentList = [];
    //       dateText = getTranslated(context, "load");
    //     });
    //       getDate();
    //
    //   }
    // }catch(e){
    //   print("startnew12ddd"+e.toString());
    //   String id = Uuid().v4();
    //   await FirebaseFirestore.instance.collection(Paths.errorLogPath) .doc(id).set({
    //     'timestamp': Timestamp.now(),
    //     'id': id,
    //     'seen': false,
    //     'desc': e.toString(),
    //     'phone': widget.loggedUser == null ? " " : widget.loggedUser.phoneNumber,
    //     'screen': "ConsultantDetailsScreen",
    //     'function': "_selectHijriDate",
    //   });
    // }
  }
}
