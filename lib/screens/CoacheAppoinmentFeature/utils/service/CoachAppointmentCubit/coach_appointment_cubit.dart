import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/service/Funcation/errorLog.dart';
import 'package:grocery_store/screens/walletFeature/utils/stripe_payment_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
part 'coach_appointment_state.dart';

class CoachAppointmentCubit extends Cubit<CoachAppointmentState> {
  CoachAppointmentCubit() : super(CoachAppointmentInitial());

  late GroceryUser consultant;
  late GroceryUser user;
  DateTime? date;
  late int selectedCard;
  late String time;
  late List<String> todayAppointmentList;
  late String initialUrl;
  bool showPayView = false;
  dynamic discountt = 0;

  bool load = false;
  int currentNumber = 0;

  share() async {
    String uid = consultant.uid!;
    // Create DynamicLink
    print("share1");
    print("https://makemynikahapp\.page\.link/.*coach_id=" + uid);
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://makemynikahapp\.page\.link/coach_id=" + uid),
      uriPrefix: "https://makemynikahapp\.page\.link",
      androidParameters:
          const AndroidParameters(packageName: "com.app.MakeMyNikah"),
      iosParameters: const IOSParameters(
          bundleId: "com.app.MakeMyNikahApp", appStoreId: "1668556326"),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    File file;
    if (consultant.photoUrl!.isEmpty) {
      print("share5");
      final bytes =
          await rootBundle.load('assets/icons/icon/Mask Group 47.png');
      final list = bytes.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      file = await File('${tempDir.path}/image.jpg').create();
      file.writeAsBytesSync(list);
      print("share6");
    } else {
      final directory = await getTemporaryDirectory();
      final path = directory.path;
      final response = await http.get(Uri.parse(consultant.photoUrl!));
      file =
          await File('$path/image_${DateTime.now().millisecondsSinceEpoch}.png')
              .writeAsBytes(response.bodyBytes);
    }
    String text =
        "${consultant.name} \n I think that he is a good coach \n ${dynamicLink.shortUrl.toString()}";
    // ignore: deprecated_member_use
    Share.shareFiles(["${file.path}"], text: text);
    emit(CoachAppointmentUpdate());
  }

  Future<void> stripePayment(
      {required double price, required BuildContext context,String? promoCodeId}) async {
   // package.price = package.price - ((discountt * package.price) / 100);
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
              productName: "buy order",
              productDesc: ' ',
            ),
          );
        },
      );
  print("stripePayment1");
      print(price.toString());
      if (isPaymentSuccessful != null && isPaymentSuccessful) {
        // تم الدفع بنجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Payment is successful"),
          ),
        );
       
        await updateDatabaseAfterAddingOrder(context, "stripe", price,promoCodeId);
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
      print("stripeerror");
      print("error in stripe is ${errorr.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occured ${errorr.toString()}'),
        ),
      );

      load = false;
      emit(CoachAppointmentUpdate());
    }
  }

  userBalancePayment(
    context,
    double price,
    String? promoCodeId
  ) async {
    var newBalance = double.parse(user.balance.toString()) - price;
    await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(user.uid)
        .set({
      'balance': newBalance,
    }, SetOptions(merge: true));
    user.balance = newBalance;
    emit(CoachAppointmentUpdate());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment is successful"),
      ),
    );
    
    await updateDatabaseAfterAddingOrder(context, "userBalance", price,promoCodeId);
    print("done");
  }

  pay(consultPackage package) async {
    package.price = package.price - ((discountt * package.price) / 100);

//  showPayView = true;
//   emit(CoachAppointmentUpdate());
    try {
      String userName = "jeras";
      if (user != null && user!.name != null) userName = user!.name!;
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
        "amount": double.parse(package.price.toString()) +
            ((double.parse(package.price.toString()) * 5) / 100),
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
          "phone": {"country_code": "", "number": user!.phoneNumber}
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
      emit(CoachAppointmentUpdate());
    } catch (e) {
      errorLog("pay", e.toString(), user,"CoachDetailScreen");
      await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
        "success": "false",
        "reason": e.toString(),
        "userUid": user.uid
      });
      showPayView = false;
      load = false;
      emit(CoachAppointmentUpdate());
      // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
    }
  }

  updateDatabaseAfterAddingOrder(
    context,
    String? payWith,
    double price,
    String? promoCodeId
  ) async {

   print(price);
   print(promoCodeId);
    try {
      //createOrder

      DateTime dateValue = DateTime.now();
      String orderId=Uuid().v4();
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
        "consultType": "coach",
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
        'callPrice': price,
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
      currentNumber = 1;

      print("af_purchase event");
      await addAppointment(context, orderId,price);
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
      BlocProvider.of<AccountBloc>(context).add(GetLoggedUserEvent());
      print("callPrice0000111");
      print(price);
      // showAddAppointmentDialog(orderId);
    } catch (e) {
      errorLog("updateDatabaseAfterAddingOrder", e.toString(), user,"CoachDetailScreen");
    }
  }

  Future<void> addAppointment(context, String orderId,double price ) async {
    print("todayAppointmentList : ${todayAppointmentList.length}");

    try {
      date = date!.toUtc();
      String appointmentId = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.appAppointments)
          .doc(appointmentId)
          .set({
        'appointmentId': appointmentId,
        'appointmentStatus': 'open',
        "consultType": "coach",
        'allowCall': false,
        'roomList': [],
        'type': 'valid',
        "orderId":orderId,
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
        'callPrice': price,
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
            .doc(orderId)
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
      emit(CoachAppointmentUpdate());
      Navigator.pop(context);
      // appointmentDialog(MediaQuery.of(context).size, date);
    } catch (e) {
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
