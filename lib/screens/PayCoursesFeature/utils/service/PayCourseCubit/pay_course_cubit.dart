import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/coursePackage.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/service/Funcation/errorLog.dart';
import 'package:grocery_store/screens/walletFeature/utils/stripe_payment_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
part 'pay_course_state.dart';

class PayCourseCubit extends Cubit<PayCourseCubitState> {
  PayCourseCubit() : super(PayCourseCubitInitial());
  late Courses course;
  late GroceryUser user;
  bool paytap = false;
  DateTime? date;
  late int selectedCard;
  late String initialUrl;
  bool showPayView = false, sharing = false;
  dynamic discountt = 0;
  String  promoCodeId="";
  int paidSince = -1;
  bool load = false;

  share(BuildContext context) async {
    sharing = true;
    emit(PayCourseCubitUpdate());
    String uid = course.courseId;
    // Create DynamicLink
    print("share1");
    print("https://makemynikahapp\.page\.link/.*course_id=" + uid);
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://makemynikahapp\.page\.link/course_id=" + uid),
      uriPrefix: "https://makemynikahapp\.page\.link",
      androidParameters:
          const AndroidParameters(packageName: "com.app.MakeMyNikah"),
      iosParameters: const IOSParameters(
          bundleId: "com.app.MakeMyNikahApp", appStoreId: "1668556326"),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    File file;
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final response = await http.get(Uri.parse(course.image));
    file =
        await File('$path/image_${DateTime.now().millisecondsSinceEpoch}.png')
            .writeAsBytes(response.bodyBytes);
    String text =
        "${course.name} \n I think that it will be a good course for you \n ${dynamicLink.shortUrl.toString()}";
    Share.shareFiles(["${file.path}"], text: text);
    sharing = false;
    emit(PayCourseCubitUpdate());
  }

  Future<void> stripePayment(
      {required double price,String? promoCodeId, required BuildContext context}) async {
       print("stripePayment122222");
    
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
              productName: "buy course",
              productDesc: '',
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
        await updateDatabaseAfterBuying(user, "stripe", course,price);
        await calcCourseDeadline();
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

      // load = false;
      emit(PayCourseCubitUpdate());
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
    emit(PayCourseCubitUpdate());
    await updateDatabaseAfterBuying(user, "userBalance", course,price);
    await calcCourseDeadline();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment is successful"),
      ),
    );
  }

  pay(CoursePackage package) async {
    package.price = package.price - ((discountt * package.price) / 100);
    // paytap = true;
    // emit(PayCourseCubitUpdate());
    try {
      String userName = "jeras";
      if (user != null && user.name != null) userName = user.name!;
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
      paytap = true;
      emit(PayCourseCubitUpdate());
    } catch (e) {
      errorLog("pay", e.toString(), user, "CourseVideosView");
      await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
        "success": "false",
        "reason": e.toString(),
        "userUid": user.uid
      });
      showPayView = false;
      paytap = false;
      // load = false;
      emit(PayCourseCubitUpdate());
      // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
    }
  }

  updateDatabaseAfterBuying(
      GroceryUser user, String payWith, Courses course,double price) async {
    //createOrder
    String orderId = Uuid().v4();
    DateTime dateValue = DateTime.now();
    await FirebaseFirestore.instance
        .collection(Paths.ordersPath)
        .doc(orderId)
        .set({
      'orderStatus': 'closed',
      'orderId': orderId,
      'date': {
        'day': dateValue.day,
        'month': dateValue.month,
        'year': dateValue.year,
      },
      "consultType": "course",
      'orderTimestamp': Timestamp.now(),
      'utcTime': DateTime.now().toUtc().toString(),
      'orderTimeValue': DateTime(dateValue.year, dateValue.month, dateValue.day)
          .millisecondsSinceEpoch,
      'packageId': "",
      'promoCodeId': promoCodeId,
      'remainingCallNum': 0,
      'packageCallNum': 0,
      'answeredCallNum': 0,
      'callPrice': price,
      "payWith": payWith,
      "platform": Platform.isIOS ? "iOS" : "Android",
      'price': price.toString(),
      'consult': {
        'uid': course.courseId,
        'name': course.name,
        'image': course.image,
        'phone': " ",
        'countryCode': " ",
        'countryISOCode': " ",
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
    await FirebaseAnalytics.instance.logPurchase(
        currency: "USD",
        value: price,
        affiliation: course.courseId,
        transactionId: orderId);
    if (course.paidUsers == null)
      course.paidUsers = [user.uid];
    else
      course.paidUsers!.add(user.uid!);
    await FirebaseFirestore.instance
        .collection("Courses")
        .doc(course.courseId)
        .set({
      'paidUsers': course.paidUsers,
    }, SetOptions(merge: true));

    showPayView = false;
    emit(PayCourseCubitUpdate());
  }

  toggilepay() {
    showPayView = !showPayView;
    emit(PayCourseCubitUpdate());
  }

  calcCourseDeadline() async {
    load = true;
    paidSince = -1;
    emit(PayCourseCubitUpdate());
    final QuerySnapshot isPaid = await FirebaseFirestore.instance
        .collection(Paths.ordersPath)
        .where("consult.uid", isEqualTo: course.courseId)
        .where("user.uid", isEqualTo: user.uid)
        .get();
    final List<Map<String, dynamic>> ordersList =
        isPaid.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    DateTime? latestDateTime;
    if (ordersList.isNotEmpty) {
      latestDateTime =
          ordersList.map((order) => order["orderTimestamp"].toDate()).reduce(
                (value, element) => value.isAfter(element) ? value : element,
              );
    }
    if (latestDateTime != null) {
      Duration difference = latestDateTime.difference(DateTime.now());
      int courseDeadline = (difference.inDays).abs();
      print(courseDeadline);
      if (courseDeadline <= 30) {
        paidSince = courseDeadline;
      }
    }
    load = false;
    emit(PayCourseCubitUpdate());
  }
}
