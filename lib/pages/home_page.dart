import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/svg.dart';

import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/AppAppointments.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/YoutubePlayerDemoScreen.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/appointmentWidget.dart';
import 'package:grocery_store/widget/consultantListItem.dart';

import 'package:grocery_store/widget/resopnsive.dart';
import 'package:http/http.dart' as http;

import '../FireStorePagnation/paginate_firestore.dart';

import 'package:shimmer/shimmer.dart';
import 'package:twilio_voice/twilio_voice.dart';

import '../config/app_fonts.dart';
import '../config/app_values.dart';
import '../models/banner.dart';
import '../screens/filterScreen.dart';
import '../screens/rate_partner_screen.dart';
import '../screens/twCallScreen.dart';
import '../widget/image_slider_widget.dart';
import '../widget/tab_bar_widget.dart';
import '../widget/tab_button.dart';
import '../widget/userAppointmentWiget.dart';

class HomePage extends StatefulWidget {
  final userType;

  const HomePage({Key? key, this.userType}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late AccountBloc accountBloc;
  GroceryUser? user;
  bool first = true, loadBanner = true;
  List<banner> bannerList = [];
  bool home = true, favorite = false;
  bool load = true,
      loadPageWidget = true,
      inAppleReview = false,
      loadSetting = true;
  Query query = FirebaseFirestore.instance
      .collection('Users')
      .where('userType', isEqualTo: 'CONSULTANT')
      .where('accountStatus', isEqualTo: "Active")
      .orderBy('order', descending: true);
  Setting? setting;
  bool avaliable = false, marriage = true, coaches = false;
  Size? size;
  late String userId;
  var registered = false;
  var hasPushedToCall = false;
  late AppLifecycleState state;
  String lang = "";

  @override
  void initState() {
    super.initState();

    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
    getImageSlider();
  }

  checkAvaliable(GroceryUser _user) {
    DateTime _now = DateTime.now();
    String dayNow = _now.weekday.toString(), languages = "";
    int timeNow = _now.hour;
    if (_user.workDays!.contains(dayNow)) {
      int localFrom = DateTime.parse(_user.fromUtc.toString()).toLocal().hour;
      int localTo = DateTime.parse(_user.toUtc.toString()).toLocal().hour;
      if (localTo == 0) localTo = 24;
      if (localFrom <= timeNow && localTo > timeNow) {
        avaliable = true;
      }
    }
  }

  getImageSlider() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Banners')
          .where('type', isEqualTo: "Home")
          .where('status', isEqualTo: true)
          .get();
      var _bannerList = List<banner>.from(
        querySnapshot.docs.map(
              (snapshot) => banner.fromMap(snapshot.data() as Map),
        ),
      );
      setState(() {
        bannerList = _bannerList;
        print("kkkksssasas");
        print(bannerList.length);
        loadBanner = false;
      });
    } catch (e) {
      setState(() {
        loadBanner = false;

        print("kkkksssasaswwwww");
        print(e.toString());
      });
    }
  }

  @override
  void dispose() {
    //first = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lang = getTranslated(context, "lang");
    super.build(context);
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: BlocBuilder(
          bloc: accountBloc,
          builder: (context, state) {
            print("Account state");
            print(state);
            if (state is GetLoggedUserInProgressState) {
              return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.pink,
                  ));
            } else if (state is GetLoggedUserCompletedState) {
              user = state.user;
              //twilio setting

              waitForLogin();
              waitForCall();
              WidgetsBinding.instance.addObserver(this);
              TwilioVoice.instance.registerClient(user!.uid!, user!.uid!);
              if (user!.userType == "CONSULTANT") {
                checkAvaliable(user!);
                return consultHome(size!);
              } else {
                return userHome(size!);
              }
            } else {
              return userHome(size!);
            }
          },
        ),
      ),
    );
  }

  Widget userHome(Size size) {
    String lang = getTranslated(context, "lang");
    String? name = " ";
    if (user != null) name = user!.name!.trimLeft().trimRight().split(' ')[0];
    return
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.only(
                  top: AppPadding.p21_3.h,
                  // bottom: AppPadding.p21_3.h,
                  left: AppPadding.p32.w,
                  right: AppPadding.p32.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lang == "ar"
                          ? getTranslated(context, "hi") + " " + name
                          : getTranslated(context, "hi") + name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily:
                          getTranslated(context, "Montserratsemibold"),
                          fontSize: AppFontsSizeManager.s26_6.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    IconButton1(
                      onPress: () {
                        if (user == null) {
                          Navigator.pushNamed(context, '/Register_Type');
                        } else
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterScreen(
                                    userId: user!.uid!, loggedUser: user!)),
                          );
                      },
                      Width: AppSize.w54_6.r,
                      Height: AppSize.h54_6.r,
                      GradientColor: AppColors.GradientColor3,
                      GradientColor2: AppColors.GradientColor4,
                      Begin: Alignment.topCenter,
                      End: Alignment.bottomCenter,
                      ButtonRadius: AppRadius.r10_6.r,
                      Icon: AssetsManager.whiteSearchIconPath.toString(),
                      IconWidth: AppSize.w29_1.r,
                      IconHeight: AppSize.h29_1.r,
                      IconColor: AppColors.white,
                    ),
                  ],
                ),
              ),
                 ImageSliderWidget(AcademyBannerList:bannerList,),
          SizedBox(
            height: AppSize.h21_3.h,
          ),

          SizedBox(
            height: AppSize.h650.h,
            child: Padding(
              padding: EdgeInsets.only(
                left: lang == "ar" ? 0.w : AppPadding.p32.w,
                right: lang == "ar" ? AppPadding.p32.w : 0.w,
                // bottom: AppPadding.p10_6.h,
              ),

              child: PaginateFirestore(
                key: ValueKey(query),
                separator: Container(
                  width: AppSize.w21_3.w,
                ),
                itemBuilderType: PaginateBuilderType.listView,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, documentSnapshot, index) {
                  return Wrap(
                    direction: Axis.vertical,
                    children: [
                      ConsultantListItem(
                        consult:
                        GroceryUser.fromMap(documentSnapshot[index].data() as Map),
                        loggedUser: user,
                        size: size,
                        inAppleReview: inAppleReview,
                      ),
                    ],
                  );
                },
                query: query,
                isLive: true,
              ),
            ),
          ),

                ],
              ),
        );
  }

  ///------------------------------ Rate App Dialog --------------------------///
  dynamic rating = 0.0;

  BoxDecoration decoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: AppColors.grey,
          blurRadius: 2.0,
          spreadRadius: 0.0,
          offset: Offset(0.0, 1.0), // shadow direction: bottom right
        )
      ],
    );
  }

  Widget consultHome(Size size) {
    String lang = "";
    lang = getTranslated(context, "lang");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: convertPtToPx(AppPadding.p20.h),
              right: convertPtToPx(AppPadding.p20.w),
              left: convertPtToPx(AppPadding.p20.w),
              bottom: convertPtToPx(AppPadding.p10.h)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              avaliable
                  ? Image.asset(
                AssetsManager.online,
                width: convertPtToPx(AppSize.w10.w),
                height: convertPtToPx(AppSize.h10.h),
              )
                  : Image.asset(
                AssetsManager.offline,
                width: convertPtToPx(AppSize.w10.w),
                height: convertPtToPx(AppSize.h10.h),
              ),
              SizedBox(
                width: convertPtToPx(AppSize.w8.w),
              ),
              Center(
                child: Text(
                  avaliable
                      ? getTranslated(context, "active")
                      : getTranslated(context, "notActive"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratmedium"),
                    color: AppColors.black3,
                    fontSize: convertPtToPx(AppFontsSizeManager.s14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: convertPtToPx(AppSize.h20.h),
        ),

        /// -TAP BAR WIDGET- ///
        Center(
          child: Container(
            width: AppSize.w506_6.w,
            height: AppSize.h72.h,
            child: TabBarWidget(
                width: size.width * AppSize.w0_6,
                height: AppSize.w58,
                radius: AppRadius.r15,
                buttons: [
                  //button x
                  TabButton(
                    onPress: () {
                      setState(() {
                        marriage = true;
                        coaches = false;
                      });
                    },
                    Height: AppSize.h53.h,
                    Width: AppSize.w176.w,
                    ButtonRadius: AppRadius.r10_6.r,
                    ButtonColor:
                    marriage ? AppColors.pink2 : Colors.transparent,
                    Title: getTranslated(context, "marriageCalls"),
                    TextFont: getTranslated(context, "academyFontFamily"),
                    TextSize: AppFontsSizeManager.s21_3.sp,
                    TextColor: marriage ? AppColors.white : AppColors.darkGrey,
                  ),
                  //button y
                  TabButton(
                    onPress: () {
                      setState(() {
                        marriage = false;
                        coaches = true;
                      });
                    },
                    Height: AppSize.h53.h,
                    Width: lang == "ar" ? AppSize.w200.w : AppSize.w176.w,
                    ButtonRadius: convertPtToPx(AppRadius.r8.r),
                    ButtonColor: coaches ? AppColors.pink2 : Colors.transparent,
                    Title: getTranslated(context, "coachesCall"),
                    TextFont: getTranslated(context, "academyFontFamily"),
                    TextSize: AppFontsSizeManager.s21_3.sp,
                    TextColor: coaches ? AppColors.white : AppColors.darkGrey,
                  ),
                ],
                padding: EdgeInsets.all(AppPadding.p7)),
          ),
        ),
        //old tap_bar
        // Center(
        //   child: Container(
        //       width: size.width * .85,
        //       height: 50,
        //       decoration: BoxDecoration(
        //         color: Color.fromRGBO(248, 248, 248,1),
        //         borderRadius: BorderRadius.circular(15.0),
        //       ),
        //       padding: EdgeInsets.only(left: 10,right: 10),
        //       child: Center(
        //         child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               InkWell(
        //                 onTap: () {
        //                   setState(() {
        //                     marriage = true;
        //                     coaches=false;
        //
        //
        //                   });
        //                 },
        //                 child: Container(
        //                   height: 30,
        //                   width: size.width * .30,
        //                   decoration: BoxDecoration(
        //                     color: marriage ? Color.fromRGBO(207, 0 ,54,1): Colors.transparent,
        //                     borderRadius: BorderRadius.circular(8.0),
        //                   ),
        //                   child: Center(
        //                     child: Text(
        //                       getTranslated(context, "marriageCalls"),
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontFamily: getTranslated(context, "fontFamily"),
        //                           color: marriage ? Colors.white : Color.fromRGBO(115, 115 ,115,1),
        //                           fontSize: 12.0,
        //                           fontWeight: FontWeight.w300
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //
        //               InkWell(
        //                 onTap: () {
        //                   setState(() {
        //                     marriage = false;
        //                     coaches=true;
        //
        //                   });
        //                 },
        //                 child: Container(
        //                   height: 30,
        //                   width: size.width * .30,
        //                   decoration: BoxDecoration(
        //                     color: coaches ? Color.fromRGBO(207, 0 ,54,1): Colors.transparent,
        //                     borderRadius: BorderRadius.circular(8.0),
        //                   ),
        //                   child: Center(
        //                     child: Text(
        //                       getTranslated(context, "coachesCall"),
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontFamily: getTranslated(context, "fontFamily"),
        //                           color: coaches ?Colors.white : Color.fromRGBO(115, 115 ,115,1),
        //                           fontSize: 12.0,
        //                           fontWeight: FontWeight.w300
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //
        //             ]),
        //       )), ),
        SizedBox(
          height: 20,
        ),
        marriage == true
            ? Expanded(
          child: PaginateFirestore(
            separator: SizedBox(
              height: 20,
            ),
            itemBuilderType: PaginateBuilderType.listView,
            padding: EdgeInsets.only(
                left: AppPadding.p53.w,
                right: AppPadding.p53.h,
                bottom: 16.0,
                top: 16.0),
            itemBuilder: (context, documentSnapshot, index) {
              return AppointmentWiget(
                  appointment: AppAppointments.fromMap(
                      documentSnapshot[index].data() as Map),
                  loggedUser: user!,
                  theme: "light");
            },
            query: FirebaseFirestore.instance
                .collection(Paths.appAppointments)
                .where('consult.uid', isEqualTo: user!.uid)
                .where('appointmentStatus', isEqualTo: "open")
                .orderBy('timestamp', descending: true),
            // to fetch real-time data
            isLive: true,
          ),
        )
            : SizedBox(),
        coaches == true
            ? Expanded(
          child: PaginateFirestore(
            separator: SizedBox(
              height: 20,
            ),
            itemBuilderType: PaginateBuilderType.listView,
            padding: EdgeInsets.only(
                left: AppPadding.p53.r,
                right: AppPadding.p53.r,
                bottom: 16.0,
                top: 16.0),
            itemBuilder: (context, documentSnapshot, index) {
              return AppointmentWiget(
                woman: coaches,
                appointment: AppAppointments.fromMap(
                    documentSnapshot[index].data() as Map),
                loggedUser: user!,
              );
            },
            query: FirebaseFirestore.instance
                .collection(Paths.appAppointments)
                .where('user.uid', isEqualTo: user!.uid)
                .where('appointmentStatus', isEqualTo: "open")
                .orderBy('secondValue', descending: true),
            // to fetch real-time data
            isLive: true,
          ),
        )
            : SizedBox(),
      ],
    );
  }

  Widget loadVerificationCode() {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 800),
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.black.withOpacity(0.6),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * .9,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  registerUser() {
    print("voip- service init");
    register();
    TwilioVoice.instance.setOnDeviceTokenChanged((token) {
      print("voip-device token changed");
      register();
    });
  }

  register() async {
    print("voip-registtering with token ");
    print("voip-calling voice-accessToken");
    Map<dynamic, dynamic> callMap = {
      "platform": Platform.isIOS ? "iOS" : "Android",
      "userId": this.userId,
    };
    try {
      String url =
          "https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/accessToken";
      if (Platform.isIOS == true) {
        url =
        "https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/accessToken3";
      }
      var callIntentRes = await http.post(
        Uri.parse(url),
        body: callMap,
      );
      var callIntent = jsonDecode(callIntentRes.body);
      print("kkkkkkkkkkkkkk");
      print(callIntent);

      if (callIntent['message'] != 'Success') {
        print("callError1" + callIntent['data']);
      } else {
        String token = callIntent['data'];
        String? androidToken;
        if (Platform.isAndroid) {
          androidToken = await FirebaseMessaging.instance.getToken();
        } else {
          androidToken = "CachedDeviceToken";
        }
        TwilioVoice.instance
            .setTokens(accessToken: token, deviceToken: androidToken);
      }
    } catch (e) {
      print("callError" + e.toString());
    }
  }

  waitForLogin() {
    final auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) async {
      // print("authStateChanges $user");
      if (user == null) {
        print("user is anonomous");
        //await auth.signInAnonymously();
      } else if (!registered) {
        print("user is anonomous111111");
        registered = true;
        this.userId = user.uid;
        registerUser();
        FirebaseMessaging.instance.requestPermission();
      }
    });
  }

  checkActiveCall() async {
    final isOnCall = await TwilioVoice.instance.call.isOnCall();
    print("checkActiveCall $isOnCall");
    if (isOnCall &&
        !hasPushedToCall &&
        TwilioVoice.instance.call.activeCall?.callDirection ==
            CallDirection.incoming) {
      print("user is on call");
      pushToCallScreen();
      hasPushedToCall = true;
    }
  }

  void waitForCall() {
    checkActiveCall();
    TwilioVoice.instance.callEventsListener
      ..listen((event) {
        print("voip-onCallStateChanged $event");

        switch (event) {
          case CallEvent.answer:
            print("twillioAnsweredhome");

            //at this point android is still paused
            if (Platform.isIOS && state == null ||
                state == AppLifecycleState.resumed) {
              pushToCallScreen();
              hasPushedToCall = true;
            }
            break;
          case CallEvent.ringing:
            final activeCall = TwilioVoice.instance.call.activeCall;
            if (activeCall != null) {
              final customData = activeCall.customParams;
              if (customData != null) {
                print("voip-customData $customData");
              }
            }
            break;
          case CallEvent.connected:
            if (Platform.isAndroid &&
                TwilioVoice.instance.call.activeCall?.callDirection ==
                    CallDirection.incoming) {
              if (state != AppLifecycleState.resumed) {
                TwilioVoice.instance.showBackgroundCallUI();
              } else if (state == null || state == AppLifecycleState.resumed) {
                pushToCallScreen();
                hasPushedToCall = true;
              }
            }
            break;
          case CallEvent.callEnded:
            hasPushedToCall = false;
            break;
          case CallEvent.returningCall:
            pushToCallScreen();
            hasPushedToCall = true;
            break;
          default:
            break;
        }
      });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.state = state;
    print("didChangeAppLifecycleState");
    if (state == AppLifecycleState.resumed) {
      checkActiveCall();
    }
  }

  void pushToCallScreen() {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (context) => VoiceCallScreen()));
  }
/* update() async {
   var querySnapshot = await FirebaseFirestore.instance.collection(Paths.usersPath)
                                .where('accountStatus', isEqualTo:"Active")
                                .where('userType', isEqualTo:"COACH")
                                .get();
                            for (var doc in querySnapshot.docs) {
                              await FirebaseFirestore.instance.collection(Paths.usersPath).doc(doc.id).set({
                                'price':20,
                              }, SetOptions(merge: true));
                            }
} */
}
