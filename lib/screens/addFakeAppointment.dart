
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/user.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddAppointmentScreen extends StatefulWidget {
  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool saving = false;
  String? userPhone, consultPhone, theme = "light", callNum, price,dropdownOrderTypeValue;
  List<KeyValueModel> _orderTypeArray = [
    KeyValueModel(key: "audio", value: "audio"),
    KeyValueModel(key: "video", value: "video"),
    KeyValueModel(key: "coach", value: "coach"),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(
                left: 27.0, right: 30.0, top: 27.0, bottom: 15.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                SizedBox(width: 10),
                Text(
                  getTranslated(context, "addOrder"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: getTranslated(context, "fontFamily"),
                      color: AppColors.pink3,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                ),
              ],
            ),
          )),
          Center(
              child: Container(
                  color: AppColors.white3, height: 1, width: size.width)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 97),
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.06,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            validator: (String? val) {
                              if (val!.trim().isEmpty) {
                                return getTranslated(context, 'required');
                              }
                              return null;
                            },
                            onSaved: (val) {
                              userPhone = val;
                            },
                            enableInteractiveSelection: true,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15.0),
                              helperStyle: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.65),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              errorStyle: TextStyle(
                                fontFamily: getTranslated(context, "fontFamily"),
                                color: AppColors.pink3,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.5,
                                fontSize: 14.0,
                              ),
                              hintStyle: GoogleFonts.poppins(
                                // color: Colors.black54,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              //prefixIcon: Icon(Icons.title),
                              labelText: getTranslated(context, "userPhone"),
                              labelStyle: TextStyle(
                                color: AppColors.lightGrey1,
                                fontWeight: FontWeight.w400,
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                                letterSpacing: 0.5,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.grey1, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.grey1, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 17.0,
                        ),
                        Container(
                          height: size.height * 0.06,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            validator: (String? val) {
                              if (val!.trim().isEmpty) {
                                return getTranslated(context, 'required');
                              }
                              return null;
                            },
                            onSaved: (val) {
                              consultPhone = val;
                            },
                            enableInteractiveSelection: true,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15.0),
                              helperStyle: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.65),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              errorStyle: TextStyle(
                                fontFamily: getTranslated(context, "fontFamily"),
                                color: AppColors.pink3,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.5,
                                fontSize: 14.0,
                              ),
                              hintStyle: GoogleFonts.poppins(
                                // color: Colors.black54,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              //prefixIcon: Icon(Icons.title),
                              labelText: getTranslated(context, "consultPhone"),
                              labelStyle: TextStyle(
                                color: AppColors.lightGrey1,
                                fontWeight: FontWeight.w400,
                                fontFamily:
                                    getTranslated(context, "fontFamily"),
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                                letterSpacing: 0.5,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: AppColors.grey1, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: AppColors.grey1, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 17.0,
                        ),
                        Container(
                          height: size.height * 0.06,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            validator: (String? val) {
                              if (val!.trim().isEmpty) {
                                return getTranslated(context, 'required');
                              }
                              return null;
                            },
                            onSaved: (val) {
                              price = val;
                            },
                            enableInteractiveSelection: true,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                              helperStyle: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.65),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              errorStyle: TextStyle(
                                fontFamily: getTranslated(context, "fontFamily"),
                                color: AppColors.pink3,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.5,
                                fontSize: 14.0,
                              ),
                              hintStyle: GoogleFonts.poppins(
                                // color: Colors.black54,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              //prefixIcon: Icon(Icons.title),
                              labelText: getTranslated(context, "price"),
                              labelStyle: TextStyle(
                                color: AppColors.lightGrey1,
                                fontWeight: FontWeight.w400,
                                fontFamily:
                                getTranslated(context, "fontFamily"),
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                                letterSpacing: 0.5,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: AppColors.grey1, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                    color: AppColors.grey1, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 17.0,
                        ),
                        Container(
                            height: 50.0,
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
                                  "type",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                    //color: Colors.black,
                                    fontSize: 15.0,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                underline: Container(),
                                isExpanded: true,
                                value: dropdownOrderTypeValue,
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: Colors.black),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(fontFamily: getTranslated(context, "fontFamily"),
                                  color: Color(0xFF3b98e1),
                                  fontSize: 13.0,
                                  letterSpacing: 0.5,
                                ),
                                items: _orderTypeArray
                                    .map((data) => DropdownMenuItem<String>(
                                    child: Text(
                                      data.value!,
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

                                  setState(() {
                                    dropdownOrderTypeValue = value;

                                  });
                                },
                              ),
                            )),
                        SizedBox(
                          height: 17.0,
                        ),

                        saving
                            ? Center(child: CircularProgressIndicator())
                            : MaterialButton(
                                minWidth: size.width * 0.52,
                                height: size.height * 0.072,
                                onPressed: () {
                                  save();
                                },
                                color: AppColors.pink3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                child: Text(
                                  getTranslated(context, "save"),
                                  style: TextStyle(
                                    color: theme == "light"
                                        ? AppColors.white
                                        : AppColors.black,
                                    fontSize: 16.0,
                                    fontFamily:
                                        getTranslated(context, "fontFamily"),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  save() async {
    late GroceryUser user, consult;
    List<GroceryUser> users = [], consults = [];
    if (_formKey.currentState!.validate()&&dropdownOrderTypeValue!=null) {
      _formKey.currentState!.save();
      try {
        setState(() {
          saving = true;
        });

        //get userdata
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(Paths.usersPath)
            .where(
              'phoneNumber',
              isEqualTo: userPhone,
            )
            .get();

        for (var doc in querySnapshot.docs) {
          users.add(GroceryUser.fromMap(doc.data() as Map));
        }
        if (users.length > 0) user = users[0];
        //get consultdata
        QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
            .collection(Paths.usersPath)
            .where(
              'phoneNumber',
              isEqualTo: consultPhone,
            )
            .get();

        for (var doc in querySnapshot2.docs) {
          consults.add(GroceryUser.fromMap(doc.data() as Map));
        }
        if (consults.length > 0) consult = consults[0];
        //add order
        DateTime date = DateTime.now();
        if (user != null && consult != null) {
          String orderId=Uuid().v4();
          DateTime dateValue=DateTime.now().toUtc();
          //add order
          await FirebaseFirestore.instance.collection(Paths.ordersPath).doc(orderId).set({
            'orderStatus': 'completed',
            'orderId': orderId,
            'consultType':dropdownOrderTypeValue,
            'orderTimestamp': Timestamp.now(),
            'utcTime':DateTime.now().toUtc().toString(),
            'orderTimeValue': DateTime(dateValue.year, dateValue.month, dateValue.day ).millisecondsSinceEpoch,
            'packageId': "",
            'promoCodeId':"",
            'date':{
              'day': dateValue.day,
              'month': dateValue.month,
              'year': dateValue.year,
            },
            'remainingCallNum': 0,
            'packageCallNum':1,
            'answeredCallNum':0,
            'callPrice':int.parse(price!),
            "payWith":"support",
            "platform": Platform.isIOS ? "iOS" : "Android",
            'price':price!,
            'consult': {
              'uid': consult.uid,
              'name': consult.name,
              'image': consult.photoUrl,
              'phone': consult.phoneNumber,
            },
            'user': {
              'uid': user.uid,
              'name': user.name,
              'image': user.photoUrl,
              'phone': user.phoneNumber,

            },
          });

        

          await FirebaseAnalytics.instance.logPurchase(
              currency: "USD",
              value: double.parse(price!),
              affiliation: consult.uid,
              transactionId:orderId
          );
          await FirebaseAnalytics.instance.logEvent(name: "payInfo",parameters:{
            "success": true,
            "reason": "success",
            "userUid":consult.uid
          } );
          //add appointment
          date = date.toUtc();
          String appointmentId = Uuid().v4();
          await FirebaseFirestore.instance.collection(Paths.appAppointments).doc(
              appointmentId).set({
            'appointmentId': appointmentId,
            'appointmentStatus': 'open',
            'consultType':dropdownOrderTypeValue,
            'allowCall':false,
            'roomList':[],
            "orderId":orderId,
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
            'type':'support',
            'consultChat': 0,
            'userChat': 0,
            'isUtc': true,
            'callPrice': int.parse(price!),
            'callCost': 0,
            'consult': {
              'uid': consult.uid,
              'name': consult.name,
              'image': consult.photoUrl,
              'phone': consult.phoneNumber,
              'countryCode': consult.countryCode,
              'countryISOCode': consult.countryISOCode,
            },
            'user': {
              'uid': user.uid,
              'name': user.name,
              'image': user.photoUrl,
              'phone': user.phoneNumber,
              'countryCode': user.countryCode,
              'countryISOCode': user.countryISOCode,

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
          });

          //update user order numbers
          int userOrdersNumbers=1;
          dynamic payedBalance=double.parse(price.toString());
          if(user.ordersNumbers!=null)
            userOrdersNumbers=(user.ordersNumbers!+1);
          if(user.payedBalance!=null)
            payedBalance=user.payedBalance!+payedBalance;

          await FirebaseFirestore.instance.collection(Paths.usersPath).doc(user.uid).set({
            'ordersNumbers': userOrdersNumbers,
            'payedBalance':payedBalance,
          }, SetOptions(merge: true));
          //-----------
          appointmentDialog(MediaQuery.of(context).size, date.toString(), true);
        } else {
          print(consults.length);
          print(users.length);
          appointmentDialog(MediaQuery.of(context).size,
              getTranslated(context, 'invalidNumbers'), false);
        }
        setState(() {
          saving = false;
        });
      } catch (e) {
        print("rrrrrrrrrr" + e.toString());
      }
    }
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
  appointmentDialog(Size size, String data, bool status) {
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
            Text(
              getTranslated(context, "appointments"),
              style: TextStyle(
                fontFamily: getTranslated(context, "fontFamily"),
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              status
                  ? getTranslated(context, "appointmentRegister")
                  : getTranslated(context, "error"),
              style: TextStyle(
                fontFamily: getTranslated(context, "fontFamily"),
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: status ? Colors.black87 : Colors.red,
              ),
            ),
            Text(
              data,
              style: TextStyle(
                fontFamily: getTranslated(context, "fontFamily"),
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Center(
              child: Container(
                width: size.width * .5,
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.pop(context);
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
          ],
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }
}
