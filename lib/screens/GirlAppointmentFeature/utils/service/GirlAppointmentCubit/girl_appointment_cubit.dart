import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../../../CoacheAppoinmentFeature/utils/service/Funcation/errorLog.dart';
import '../../../../walletFeature/utils/stripe_payment_bottom_sheet.dart';
part 'girl_appointment_state.dart';

class GirlAppointmentCubit extends Cubit<GirlAppointmentState> {
  GirlAppointmentCubit() : super(GirlAppointmentInitial());
  late GroceryUser consultant;
  late GroceryUser user;
  DateTime? date;
  late int selectedCard;
  late String time;
  late List<String> todayAppointmentList;
  late String initialUrl;
  // Orders? order;
  bool showPayView = false;
  dynamic discountt = 0;
  ///////////////////////////////////////
  late AccountBloc accountBloc;
  bool sharing = false;
  String? userImage, userName = "nikahUser", type;
  bool validPartner = false;
  dynamic price = 30.0;
  late Size size;
  // bool loadData = false;
  // String lang = "";

  ///

  Future<void> stripePayment(
      {required dynamic pricee, required context,
      required String consultType,String? promoCodeId
      }) async {
    final double price = pricee;
    print(price);
    try {
      print("stripePayment1");
      print(price.toString());

      final isPaymentSuccessful = await showModalBottomSheet<bool>(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            child: StripePaymentBottomSheet(
              loggedUser: user,
              price: price,
              productName: "AppointmentTo${consultant.uid}_${Uuid().v4()}",
              productDesc: 'AppointmentTo${consultant.uid}--from${user.uid}',
            ),
          );
        },
      );

      if (isPaymentSuccessful != null && isPaymentSuccessful) {
        // تم الدفع بنجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Payment is successful"),
          ),
        );
        // await addAppointment(context, package);
        await updateDatabaseAfterAddingOrder(
            "stripe", consultType, context, price,promoCodeId);
        await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
          "success": true.toString(),
          "reason": "success",
          "userUid": user.uid
        });
        await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
          "success": true.toString(),
          "reason": "success",
          "userUid": user.uid
        });
      } else {
        // لم يتم الدفع أو حدث خطأ
        print("stripeerror");
      }
    } catch (errorr) {
      print("stribe${errorr.toString()}");
      await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
        "success": "false",
        "reason": errorr.toString(),
        "userUid": user.uid
      });
      print("stripeerror");
      print("error in stripe is ${errorr.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occured ${errorr.toString()}'),
        ),
      );
      emit(GirlAppointmentUpdate());
    }
  }

  userBalancePayment({required dynamic pricee, required context,
      required String consultType,String? promoCodeId
      }) async {
        print("userBalancePaymentppppp");
    price = pricee ;
    var newBalance = double.parse(user.balance.toString()) - price;
    await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(user.uid)
        .set({
      'balance': newBalance,
    }, SetOptions(merge: true));
    user.balance = newBalance;
    emit(GirlAppointmentUpdate());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment is successful"),
      ),
    );
    await updateDatabaseAfterAddingOrder("userBalance", consultType, context, price, promoCodeId);
    print("done");
  }

  pay(pricee) async {
    final price = pricee - ((discountt * pricee) / 100);
    try {
      String userName = "jeras";
      if (user.name != null) userName = user.name!;
      String description = "رسوم الخدمة (5%)";
      final uri = Uri.parse('https://api.tap.company/v2/charges');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization':"Bearer sk_test_vUR9IN1ryt0JDHjQzBXYgiCq",
        'Authorization': "Bearer sk_live_C7V9cpBMFWbt2ukjd3fRxIeD",
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
      };
      Map<String, dynamic> body = {
        "amount": double.parse(price.toString()) +
            ((double.parse(price.toString()) * 5) / 100),
        "currency": "USD",
        "threeDSecure": true,
        "save_card": true,
        "description": description,
        "statement_descriptor": "مؤسسة  محور النقطة",
        "metadata": {
          "udf1": "مؤسسة  محور النقطة",
          "udf2": "مؤسسة  محور النقطة"
        },
        "reference": {"transaction": "txn_0001", "order": "ord_0001"},
        "receipt": {"email": false, "sms": true},
        "customer": {
          "id": '',
          "first_name": userName,
          "middle_name": ".",
          "last_name": ".",
          "email": userName + "@jeras.com",
          "phone": {"country_code": "", "number": user.phoneNumber}
        },
        "merchant": {"id": ""},
        "source": {"id": "src_all"},
        "post": {"url": "http://your_website.com/post_url"},
        "redirect": {"url": "https://www.jeras.io/app/redirect_url"}
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      var response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      String responseBody = response.body;
      var res = json.decode(responseBody);
      print("Erorr: $res ");
      String url = res['transaction']['url'];
      // Navigator.pop(context);
      initialUrl = url;
      // webViewController.loadRequest(Uri.parse(initialUrl));
      showPayView = true;
      emit(GirlAppointmentUpdate());
    } catch (e) {
      showPayView = false;
      emit(GirlAppointmentUpdate());
      errorLog("pay", e.toString(), user, "girlAppointmentView");
      await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
        "success": "false",
        "reason": e.toString(),
        "userUid": user.uid
      });
      showPayView = false;
      // load = false;
      emit(GirlAppointmentUpdate());
      // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
    }
  }

  updateDatabaseAfterAddingOrder(String? payWith, type, context, price,String? promoCodeId) async {
    try {
      //createOrder
      String orderId = Uuid().v4();
      DateTime dateValue = DateTime.now();
      await FirebaseFirestore.instance
          .collection(Paths.ordersPath)
          .doc(orderId)
          .set({
        'orderStatus': 'open',
        'orderId': orderId,
        'date': {
          'day': dateValue.day,
          'month': dateValue.month,
          'year': dateValue.year,
        },
        "consultType": type,
        'orderTimestamp': Timestamp.now(),
        'utcTime': DateTime.now().toUtc().toString(),
        'orderTimeValue':
            DateTime(dateValue.year, dateValue.month, dateValue.day)
                .millisecondsSinceEpoch,
        'packageId': "",
        'promoCodeId': promoCodeId,
        'remainingCallNum': 1,
        'packageCallNum': 1,
        'answeredCallNum': 0,
        'callPrice': double.parse(price.toString()),
        "payWith": payWith,
        "platform": Platform.isIOS ? "iOS" : "Android",
        'price': price.toString(),
        'consult': {
          'uid': consultant.uid,
          'name': consultant.name,
          'image': consultant.photoUrl,
          'phone': consultant.phoneNumber,
          'countryCode': consultant.countryCode,
          'countryISOCode': consultant.countryISOCode,
        },
        'user': {
          'uid': user.uid,
          'name': user.name,
          'image': user.photoUrl,
          'phone': user.phoneNumber,
          'countryCode': user.countryCode,
          'countryISOCode': user.countryISOCode,
        },
      });
      // currentNumber = 1;

      print("af_purchase event");
      await addAppointment(context,new consultPackage(Id:orderId,discount: 0,price: price,callNum: 1, consultUid: '', active: false ),type);
      await FirebaseAnalytics.instance.logPurchase(
          currency: "USD",
          value: price,
          affiliation: consultant.uid,
          transactionId: orderId);
      //update user order numbers
      int userOrdersNumbers = 1;
      dynamic payedBalance = double.parse(price.toString());
      if (user.ordersNumbers != null)
        userOrdersNumbers = user.ordersNumbers! + 1;
      if (user.payedBalance != null)
        payedBalance = user.payedBalance! + payedBalance;

      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(user.uid)
          .set({
        'ordersNumbers': userOrdersNumbers,
        'payedBalance': payedBalance,
        'customerId': " ",
        "userConsultIds": user.userConsultIds! + "," + consultant.uid!,
        'preferredPaymentMethod': "stripe"
      }, SetOptions(merge: true));
      final accountBloc = BlocProvider.of<AccountBloc>(context);

      accountBloc.add(GetLoggedUserEvent());

      // showAddAppointmentDialog(orderId, price);
    } catch (e) {
      // errorLog("updateDatabaseAfterAddingOrder", e.toString());
    }
  }
 Future<void> addAppointment(context, consultPackage package,type) async {
    print("==========todayAppointmentList : ${todayAppointmentList.length}");

    try {
      date = date!.toUtc();
      String appointmentId = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .doc(appointmentId)
          .set({
        'appointmentId': appointmentId,
        'appointmentStatus': 'open',
        "consultType": type,
        'allowCall': false,
        'roomList': [],
        'type': 'valid',
        "orderId": package.Id,
        'timestamp': DateTime.now().toUtc(),
        'timeValue':
            DateTime(date!.year, date!.month, date!.day).millisecondsSinceEpoch,
        'secondValue': DateTime(date!.year, date!.month, date!.day, date!.hour,
                date!.minute, date!.second, date!.millisecond)
            .millisecondsSinceEpoch,
        'appointmentTimestamp': DateTime(date!.year, date!.month, date!.day,
            date!.hour, date!.minute, date!.second, date!.millisecond),
        'utcTime': date.toString(),
        'consultChat': 0,
        'userChat': 0,
        'callPrice': package.price,
        'callCost': 0.0,
        'consult': {
          'uid': consultant.uid,
          'name': consultant.name,
          'image': consultant.photoUrl,
          'phone': consultant.phoneNumber,
          'countryCode': consultant.countryCode,
          'countryISOCode': consultant.countryISOCode,
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
          'day': date!.day,
          'month': date!.month,
          'year': date!.year,
        },
        'time': {
          'hour': date!.hour,
          'minute': date!.minute,
        },
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(Paths.ordersPath)
            .doc(package.Id)
            .set({
              'orderStatus': "completed",
              'remainingCallNum': 0,
            }, SetOptions(merge: true))
            .then((value) async {})
            .catchError((err) {});
      }).catchError((err) {});

      //========================
      todayAppointmentList.removeAt(selectedCard);
      await FirebaseFirestore.instance
          .collection(Paths.consultDaysPath)
          .doc(time + "-" + consultant.uid!)
          .set({
        'todayAppointmentList': todayAppointmentList,
      }, SetOptions(merge: true));

      // setState(() {
      // selectedCard=-1;
      // });
      //emit(CoachAppointmentUpdate());
      Navigator.pop(context);
      // appointmentDialog(MediaQuery.of(context).size, date);
    } catch (e) {
      print("rrrrrrrr"+e.toString());
      String id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.errorLogPath)
          .doc(id)
          .set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'payUrl': '',
        'phone': user == null ? " " : user.phoneNumber,
        'screen': "ConsultantDetailsScreen",
        'function': "addAppointment",
      });
    }
  }
}
