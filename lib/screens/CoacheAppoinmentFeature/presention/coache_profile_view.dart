import 'dart:convert';

import 'package:animate_icons/animate_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/consultPackage.dart';
import 'package:grocery_store/models/order.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/widget/CoachProfileWidget/coach_info_widget.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/utils/service/CoachAppointmentCubit/coach_appointment_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../config/app_values.dart';
import '../../../models/user.dart';
import '../../../widget/app_bar_widget.dart';
import '../utils/service/Funcation/errorLog.dart';
import 'widget/CoachProfileWidget/coach_details_widget.dart';

//  CoachAppointmentCubit created before navigate 
class CoachProfileView extends StatefulWidget {
  final GroceryUser consultant;
  final GroceryUser? loggedUser;

  const CoachProfileView({Key? key, required this.consultant, this.loggedUser})
      : super(key: key);

  @override
  _CoachProfileViewState createState() => _CoachProfileViewState();
}

class _CoachProfileViewState extends State<CoachProfileView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> dayList = [], dayListValue = [];
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = new TextEditingController();
  GroceryUser? user;
  late AccountBloc accountBloc;
  Orders? order;
  int currentNumber = 0;
  bool first = true, showPayView = false, load = false, fromBalance = false;
  String? userImage, userName = "beautUser", type = "coach";
  bool validPartner = false;
  AnimateIconController? animatecontroller;

  double price = 0.0;
  late Size size;

  bool loadData = false;
  bool payView = false;

  String lang = "";

  @override
  void initState() {
    super.initState();
    price = double.parse(widget.consultant.price.toString());
    animatecontroller = AnimateIconController();
    cleanConsultDays();
     payView = false;
        BlocProvider.of<CoachAppointmentCubit>(context).showPayView=false;

    accountBloc = BlocProvider.of<AccountBloc>(context);
    if (widget.loggedUser != null) {
      user = widget.loggedUser!;
      getNumber();
      accountBloc.add(GetLoggedUserEvent());
    }

    accountBloc.stream.listen((state) {
      if (state is GetLoggedUserCompletedState) {
        user = state.user;
      }
    });

    print("content_view event started ");
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    BlocProvider.of<CoachAppointmentCubit>(context).consultant =
        widget.consultant;
    return BlocBuilder<CoachAppointmentCubit, CoachAppointmentState>(
      builder: (context, state) {
        payView = BlocProvider.of<CoachAppointmentCubit>(context).showPayView;
        print("BlocProvider.of<CoachAppointmentCubit>(context).showPayView$payView");

        try {
          BlocProvider.of<CoachAppointmentCubit>(context).user =
              widget.loggedUser!;
        } catch (e) {}
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: payView
              ? WebView(
                  initialUrl: BlocProvider.of<CoachAppointmentCubit>(context)
                      .initialUrl,
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url
                        .startsWith("https://www.jeras.io/app/redirect_url")) {
                      setState(() {
                        payView = true;
                        showPayView = false;
                        var str = request.url;
                        const start = "tap_id=";
                        final startIndex = str.indexOf(start);

                        String charge = str.substring(
                            startIndex + start.length, str.length);
                        payStatus(charge);
                      });
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  initialMediaPlaybackPolicy:
                      AutoMediaPlaybackPolicy.always_allow,
                  onPageFinished: (url) {
                    //showSnakbar(url, true);
                    setState(() => payView = false);
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                      child: AppBarWidget4(onPress: () {
                        BlocProvider.of<CoachAppointmentCubit>(context).share();
                      }),
                    ),
                    SizedBox(
                      height: AppSize.h8.h,
                    ),
                    Container(
                        color: AppColors.lightGrey,
                        height: AppSize.h1,
                        width: double.infinity),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CoacheInfoWidget(consultant: widget.consultant),
                            CoachDetailsWidget(
                                consultant: widget.consultant,
                                load: load,
                                user: user),
                            SizedBox(
                              height: AppSize.h49_3.h,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }

  Future<void> getNumber() async {
    try {
      setState(() {
        load = true;
      });
      await FirebaseFirestore.instance
          .collection(Paths.ordersPath)
          .where(
            'user.uid',
            isEqualTo: user!.uid,
          )
          .where(
            'consult.uid',
            isEqualTo: widget.consultant.uid,
          )
          .where('orderStatus', isEqualTo: 'open')
          .get()
          .then((value) async {
        if (value.docs.length > 0) {
          var order2 = Orders.fromMap(value.docs[0].data());
          setState(() {
            order = order2;
          });
          await FirebaseFirestore.instance
              .collection(Paths.appAppointments)
              .where(
                'orderId',
                isEqualTo: order!.orderId,
              )
              .get()
              .then((value) async {
            if (value.docs.length > 0) {
              setState(() {
                currentNumber = order!.packageCallNum - value.docs.length;
              });
            } else {
              setState(() {
                currentNumber = order!.packageCallNum;
              });
            }
          }).catchError((err) {
            errorLog("getNumber1", err.toString(), widget.loggedUser,"CoachDetailScreen");
            setState(() {
              load = false;
            });
          });
        } else {
          setState(() {
            currentNumber = 0;
            order = null;
          });
        }
        setState(() {
          load = false;
        });
      }).catchError((err) {
        errorLog("getNumber", err.toString(), widget.loggedUser,"CoachDetailScreen");
        setState(() {
          load = false;
        });
      });
    } catch (e) {
      errorLog("getNumber", e.toString(), widget.loggedUser,"CoachDetailScreen");
      setState(() {
        load = false;
        currentNumber = 0;
        order = null;
      });
    }
  }

  // showAddAppointmentDialog(
  //     {required orderId, required localFrom, required localTo}) async {
  //   bool isProceeded = await showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return AddAppointmentDialog(
  //           loggedUser: user!,
  //           consultant: widget.consultant,
  //           localFrom: localFrom,
  //           localTo: localTo,
  //           type: type!,
  //           orderId: orderId,
  //           callPrice: price);
  //     },
  //   );

  //   if (isProceeded) {
  //     print("allah");
  //     setState(() {
  //       load = false;
  //     });
  //   }
  // }

  cleanConsultDays() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Paths.consultDaysPath)
          .where('date',
              isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .millisecondsSinceEpoch)
          .where('consultUid', isEqualTo: widget.consultant.uid)
          .get();
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection(Paths.consultDaysPath)
            .doc(doc.id)
            .delete();
      }
    } catch (e) {
      print("hhhhhh" + e.toString());
    }
  }

  payStatus(String chargeId) async {
    try {
      final uri = Uri.parse('https://api.tap.company/v2/charges/' + chargeId);
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization':"Bearer sk_test_vUR9IN1ryt0JDHjQzBXYgiCq",
        'Authorization': "Bearer sk_live_C7V9cpBMFWbt2ukjd3fRxIeD",
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br'
      };
      var response = await get(
        uri,
        headers: headers,
      );
      String responseBody = response.body;
      var res = json.decode(responseBody);

      if (res['status'] == "CAPTURED") {
        String? customerId = res['customer']['id'];
        customerId = customerId != null ? customerId : "";
        BlocProvider.of<CoachAppointmentCubit>(context)
            .updateDatabaseAfterAddingOrder(
                context,
                "tapCompany", price,"");
        // updateDatabaseAfterAddingOrder(customerId, "tapCompany", ".",
        //     totalPrice: price);
      } else {
        //callHuperPayWidget
        //--------add details event
        String eventName = "af_add_payment_info";
        Map eventValues = {
          "af_success": false,
          "af_achievement_id": res['status'],
        };
        // addEvent(eventName, eventValues);
        await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
          "success": "false",
          "reason": res['status'],
          "userUid": user!.uid
        });
        String id = Uuid().v4();
        await FirebaseFirestore.instance
            .collection(Paths.errorLogPath)
            .doc(id)
            .set({
          'timestamp': Timestamp.now(),
          'id': id,
          'seen': false,
          'desc': res['status'],
          'phone': user == null ? " " : user!.phoneNumber,
          'screen': "ConsultantDetailsScreen",
          'function': "payStatus",
        });
        setState(() {
          showPayView = false;
          load = false;
        });
        // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
      }
    } catch (e) {
      errorLog("payStatus", e.toString(), user,"CoachDetailScreen");
      await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
        "success": "false",
        "reason": e.toString(),
        "userUid": user!.uid
      });
      setState(() {
        showPayView = false;
        load = false;
      });
      // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
    }
  }

}
