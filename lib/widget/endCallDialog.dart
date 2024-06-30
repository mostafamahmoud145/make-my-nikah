import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/models/setting.dart';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../models/user.dart';
import '../blocs/account_bloc/account_bloc.dart';
import '../config/app_constat.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../localization/localization_methods.dart';
import '../models/AppAppointments.dart';
import '../models/order.dart';

class EndCallDialog extends StatefulWidget {
  final AppAppointments appointment;
  final GroceryUser user;

  EndCallDialog({
    required this.appointment,
    required this.user,
  });

  @override
  _EndCallDialogState createState() => _EndCallDialogState();
}

class _EndCallDialogState extends State<EndCallDialog> {
  bool endingCall = false, done = true;
  late AccountBloc accountBloc;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    print("=======endCallDialog"+widget.appointment.appointmentId);
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
        content: StatefulBuilder(builder: (context, setState) {
          return Container(
            // height: size.height * 0.25,
            width: double.maxFinite,
            constraints: BoxConstraints.loose(size),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    getTranslated(context, "doesCallEndWithClient"),
                    style: TextStyle(
                      fontFamily: getTranslated(context, "Ithra"),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      color: AppColors.black1,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
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
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection(Paths.appAppointments)
                                .doc(widget.appointment.appointmentId)
                                .set({
                              'allowCall': false,
                            }, SetOptions(merge: true));

                            Navigator.pop(context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (route) => false);
                            //Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: Text(
                            getTranslated(context, 'no'),
                            style: TextStyle(
                              fontFamily: getTranslated(context, "Ithra"),
                              color: AppColors.black1,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      endingCall
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              width: 50.0,
                              child: MaterialButton(
                                padding: const EdgeInsets.all(0.0),
                                onPressed: () {
                                  setState(() {
                                    endingCall = true;
                                  });
                                  callDone();

                                  /* Navigator.pop(context);
                                  confirmEndCallDialog(size, context);*/
                                },
                                child: Text(
                                  getTranslated(context, 'yes'),
                                  style: TextStyle(
                                    fontFamily: getTranslated(context, "Ithra"),
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
              ),
            ),
          );
        }));
  }

  //-----------
  // confirmEndCallDialog(Size size, BuildContext context) {
  //   return showDialog(
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(15.0),
  //         ),
  //       ),
  //       elevation: 5.0,
  //       contentPadding: const EdgeInsets.only(
  //           left: AppPadding.p16, right: AppPadding.p16, top: 20.0, bottom: 10.0),
  //       content: StatefulBuilder(
  //         builder: (context, setState) {
  //           return Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               SizedBox(
  //                 height: 15.0,
  //               ),
  //               Text(
  //                 getTranslated(context, "areYouSureCloseAppointment"),
  //                 style: TextStyle(
  //                   fontFamily: getTranslated(context, "Ithra"),
  //                   fontSize: 14.0,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.pink,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10.0,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.max,
  //                 children: <Widget>[
  //                   InkWell(
  //                     onTap: () async {
  //                       await FirebaseFirestore.instance
  //                           .collection(Paths.appAppointments)
  //                           .doc(widget.appointment.appointmentId)
  //                           .set({
  //                         'allowCall': false,
  //                       }, SetOptions(merge: true));
  //                       Navigator.pop(context);
  //                       //Navigator.pop(context);
  //                       Navigator.pushNamedAndRemoveUntil(
  //                         context,
  //                         '/home',
  //                         (route) => false,
  //                       );
  //                     },
  //                     child: Container(
  //                       height: 35,
  //                       width: 50,
  //                       padding: const EdgeInsets.all(2),
  //                       decoration: BoxDecoration(
  //                         color: AppColors.lightPink,
  //                         borderRadius: BorderRadius.circular(10.0),
  //                       ),
  //                       child: Center(
  //                         child: Text(
  //                           getTranslated(context, "no"),
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               fontFamily:
  //                                   getTranslated(context, "Ithra"),
  //                               color: AppColors.pink,
  //                               fontSize: 11.0,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   endingCall
  //                       ? Center(child: CircularProgressIndicator())
  //                       : InkWell(
  //                           onTap: () async {
  //                             setState(() {
  //                               endingCall = true;
  //                             });
  //                             callDone(context);
  //                           },
  //                           child: Container(
  //                             height: 35,
  //                             width: 50,
  //                             padding: const EdgeInsets.all(2),
  //                             decoration: BoxDecoration(
  //                               color: AppColors.pink,
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ),
  //                             child: Center(
  //                               child: Text(
  //                                 getTranslated(context, "yes"),
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                   fontFamily:
  //                                       getTranslated(context, "Ithra"),
  //                                   color: AppColors.white,
  //                                   fontSize: 11.0,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                 ],
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //     barrierDismissible: false,
  //     context: context,
  //   );
  // }

 Future<void> callDone() async {
    try {
      setState(() {
        endingCall = true;
      });
      //closeAppointment
      await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .doc(widget.appointment.appointmentId)
          .update({
        'appointmentStatus': "closed",
        'allowCall': false,
        'closedUtcTime': DateTime.now().toUtc().toString(),
        'closedDate': {
          'day': DateTime.now().day,
          'month': DateTime.now().month,
          'year': DateTime.now().year,
        },
      });

      //close order
      await FirebaseFirestore.instance
          .collection(Paths.ordersPath)
          .doc(widget.appointment.orderId)
          .set({
        'answeredCallNum': 1,
        'orderStatus': "closed",
        'remainingCallNum': 0
      }, SetOptions(merge: true));

      //update consultbalance
      print("endmeeting1");
      DocumentReference docRef = FirebaseFirestore.instance
          .collection(Paths.settingPath)
          .doc("pzBqiphy5o2kkzJgWUT7");
      final DocumentSnapshot taxDocumentSnapshot = await docRef.get();
      var taxes = Setting.fromMap(taxDocumentSnapshot.data() as Map).coachTaxes;
      print("endmeeting2");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.user.uid)
          .get();
      GroceryUser currentUser = GroceryUser.fromMap(documentSnapshot.data() as Map);
      dynamic taxesvalue = (widget.appointment.callPrice * taxes) / 100;
      dynamic consultBalance = widget.appointment.callPrice - taxesvalue;
      dynamic payedBalance = consultBalance;
      if (currentUser.payedBalance != null)
        payedBalance = payedBalance + currentUser.payedBalance;
      print("endmeeting3");
      if (currentUser.balance != null)
        consultBalance = consultBalance + currentUser.balance;
      print("endmeeting4");
      int? consultOrdersNumbers = 1;
      if (currentUser.ordersNumbers != null)
        consultOrdersNumbers = 1 + currentUser.ordersNumbers!;
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(widget.user.uid)
          .set({
        'balance': consultBalance,
        'payedBalance': payedBalance,
        'ordersNumbers': consultOrdersNumbers
      }, SetOptions(merge: true));
      setState(() {
        endingCall = false;
      });

      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
            (route) => false,
      );


    } catch (e) {
      print("eeeeee" + e.toString());
      errorLog("callDone", e.toString());
    }
  }

  double calculatePriceAfterTax(double price, double taxPercentage) {
    double taxAmount = (price * taxPercentage) / 100;
    double priceAfterTax = price - taxAmount;
    return priceAfterTax;
  }

 
  errorLog(String function, String error) async {
    String id = Uuid().v4();
    await FirebaseFirestore.instance
        .collection(Paths.errorLogPath)
        .doc(id)
        .set({
      'timestamp': Timestamp.now(),
      'id': id,
      'seen': false,
      'desc': error,
      'phone': widget.user == null ? " " : widget.user.phoneNumber,
      'screen': "videoScreen",
      'function': function,
    });
  }
}
