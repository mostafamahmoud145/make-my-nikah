import 'package:animate_icons/animate_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/blocs/notification_bloc/notification_bloc.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/order.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/presention/booking_details.dart';
import 'package:grocery_store/screens/GirlAppointmentFeature/utils/service/GirlAppointmentCubit/girl_appointment_cubit.dart';
import 'package:grocery_store/widget/app_bar_widget.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../config/app_values.dart';
import '../../../models/userDetails.dart';
import '../../CoacheAppoinmentFeature/utils/service/Funcation/errorLog.dart';
import '../utils/service/funcation/check_valid_partner.dart';
import '../utils/service/funcation/pay_status.dart';
import 'widget/girl_bio_widget.dart';
import 'widget/girl_looking_for_widget.dart';
import 'widget/girl_reviews_container_widget.dart';

class GirlDetailsView extends StatefulWidget {
  final GroceryUser consultant;
  final GroceryUser? loggedUser;
  final bool? appleReview;

  const GirlDetailsView(
      {Key? key, required this.consultant, this.appleReview, this.loggedUser})
      : super(key: key);

  @override
  _GirlDetailsViewState createState() => _GirlDetailsViewState();
}

class _GirlDetailsViewState extends State<GirlDetailsView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GroceryUser? user;
  late AccountBloc accountBloc;
  Orders? order;
  int currentNumber = 0;
  bool booking = false;
  late int localFrom, localTo;
  bool first = true, load = false, fromBalance = false, sharing = false;
  String? userImage, userName = "nikahUser";
  bool validPartner = false;
  AnimateIconController? animatecontroller;
  dynamic price = 30.0;
  late Size size;
  late NotificationBloc notificationBloc;
  UserDetail userDetails = UserDetail();
  bool loadData = false;
  String lang = "";
bool payView = false;
  @override
  void initState() {
    super.initState();
    animatecontroller = AnimateIconController();
    cleanConsultDays();
    setState(() {
      loadData = true;
      validPartner = false;
    });
    payView = false;
        BlocProvider.of<GirlAppointmentCubit>(context).showPayView=false;
    getuserDetails(loggedUser: widget.loggedUser, userID: widget.consultant.uid)
        .then((value) {
      if (value["userDetails"] != null) {
        this.userDetails = value["userDetails"];
        loadData = value["loadData"];
        validPartner = value["validPartner"];
      } else {
        validPartner = value["validPartner"];
        loadData = value["loadData"];
      }
      setState(() {});
    });

    accountBloc = BlocProvider.of<AccountBloc>(context);
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    if (widget.loggedUser != null) {
      user = widget.loggedUser!;
      getNumber();
      accountBloc.add(GetLoggedUserEvent());
      notificationBloc.add(GetAllNotificationsEvent(user!.uid!));
    }
    localFrom = DateTime.parse(widget.consultant.fromUtc!).toLocal().hour;
    localTo = DateTime.parse(widget.consultant.toUtc!).toLocal().hour;
    if (localTo == 0) localTo = 24;
    accountBloc.stream.listen((state) {
      if (state is GetLoggedUserCompletedState) {
        user = state.user;
      }
    });

    print("content_view event started ");
  }

  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    size = MediaQuery.of(context).size;
    return BlocBuilder<GirlAppointmentCubit, GirlAppointmentState>(
      builder: (context, state) {
        final girlAppointmentCubit = BlocProvider.of<GirlAppointmentCubit>(context);
        payView = girlAppointmentCubit.showPayView;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body:payView
              ? WebView(
                  initialUrl:
                      BlocProvider.of<GirlAppointmentCubit>(context).initialUrl,
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url
                        .startsWith("https://www.jeras.io/app/redirect_url")) {
                        payView = true;
                        var str = request.url;
                        const start = "tap_id=";
                        final startIndex = str.indexOf(start);
                        String charge = str.substring(
                            startIndex + start.length, str.length);
                        payStatus(charge,widget.loggedUser);
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
              : SafeArea(
            child: Column(
              children: <Widget>[
                AppBarWidget2(text: widget.consultant.name!),
                SizedBox(height: AppSize.h21_3.h,),
                Container(
                  width: size.width,
                  color: AppColors.lightGray,
                  height: AppSize.h1.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        //top: AppPadding.p32.h,
                        left: AppPadding.p32.w,
                        right: AppPadding.p32.w),
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        // Bio
                        GirlBioWidget(
                            consultant: widget.consultant,
                            loggedUser: widget.loggedUser,
                            loadData: loadData,
                            userDetails: userDetails),
                        SizedBox(
                          height: AppSize.h32.h,
                        ),
                        // LookingFor
                        GirlLookingForWidget(
                            loadData: loadData,
                            consultant: widget.consultant,
                            loggedUser: widget.loggedUser,
                            userDetails: userDetails),
                        SizedBox(
                          height: AppSize.h32.h,
                        ),
                        //reviews
                        GirlReviewsContainerWidget(
                            consultant: widget.consultant),
                        SizedBox(
                          height: AppSize.h53_3.h,
                        ),
                        GirlBookingDetails(
                            load: load,
                            loggedUser: widget.loggedUser,
                            consultant: widget.consultant,
                            validPartner: validPartner)
                      ],
                    ),
                  ),
                )
              ],
            ),
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
          var order2 = Orders.fromMap(value.docs[0].data() as Map);
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
            errorLog("getNumber1", err.toString(), user, "girlAppointmentView");
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
        errorLog("getNumber", err.toString(), user, "girlAppointmentView");
        setState(() {
          load = false;
        });
      });
    } catch (e) {
      errorLog("getNumber1", e.toString(), user, "girlAppointmentView");
      setState(() {
        load = false;
        currentNumber = 0;
        order = null;
      });
    }
  }

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

}
