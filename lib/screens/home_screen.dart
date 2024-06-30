import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_store/blocs/notification_bloc/notification_bloc.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/parse_duration.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/methodes/show_failed_snackbar.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/pages/AppointmentsPage.dart';
import 'package:grocery_store/pages/CoachesPage.dart';
import 'package:grocery_store/pages/home_page.dart';
import 'package:grocery_store/pages/TechnicalSupportPage.dart';
import 'package:grocery_store/pages/CallHistoryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/coache_profile_view.dart';
import 'package:grocery_store/screens/PayCoursesFeature/presention/course_videos_view.dart';
import 'package:grocery_store/screens/account_screen.dart';
import 'package:grocery_store/screens/clientScreen.dart';
import 'package:grocery_store/screens/coachDetailScreen.dart';
import 'package:grocery_store/screens/coachScreen.dart';
import 'package:grocery_store/screens/google_apple_signup/services/methods/navigation_method.dart';
import 'package:grocery_store/screens/google_apple_signup/views/screens/complete_appointment_screen.dart';
import 'package:grocery_store/screens/google_apple_signup/views/widgets/jerasDialogWidget.dart';
import 'package:grocery_store/screens/rate_partner_screen.dart';
import 'package:grocery_store/screens/register_bottom_sheet.dart';
import 'package:grocery_store/screens/userAccountScreen.dart';
import 'package:grocery_store/services/shared%20preferences/shared_preferences.dart';
import 'package:grocery_store/tool_tip/custom_tooltip.dart';
import 'package:grocery_store/tool_tip/tooltib_model.dart';
import 'package:grocery_store/tool_tip/tooltip_manager.dart';
import 'package:grocery_store/tool_tip/tooltip_progress.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../blocs/account_bloc/account_bloc.dart';
import '../config/app_values.dart';
import '../config/colorsFile.dart';
import '../models/courses.dart';
import '../models/user_notification.dart';
import '../pages/AcademyPage.dart';
import '../pages/CoachesCallsPage.dart';
import '../services/firebase_service.dart';
import '../widget/drawerWidget.dart';
import 'DevelopTechSupport/allDevelopSupport.dart';
import 'GirlAppointmentFeature/presention/girl_details_view.dart';
import 'consultantDetailsScreen.dart';
import 'courseVideosScreen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? notificationPage;

  const HomeScreen({Key? key, this.notificationPage}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late int _selectedPage;
  late PageController _pageController;
  late NotificationBloc notificationBloc;
  late UserNotification userNotification;
  late AccountBloc accountBloc;
  GroceryUser user = new GroceryUser();

  late String userType = "", theme = "light", userImage, lang, userName;
  late Size size;
  bool load = true, first = true;
  User? currentUser = FirebaseAuth.instance.currentUser;
  DateTime? currentBackPressTime;
  final InAppReview inAppReview = InAppReview.instance;
  late Timer _timer;
  late Timer _timer2;
  dynamic rating = 0.0;
  //  final InAppReview inAppReview = InAppReview.instance;
  //  late int _selectedPage;
  // late PageController _pageController;

  @override
  void initState() {
    super.initState();
    if (widget.notificationPage != null)
      _selectedPage = widget.notificationPage!;
    else
      _selectedPage = 0;
    _pageController = PageController(initialPage: _selectedPage);
    //----------
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
    notificationBloc = BlocProvider.of<NotificationBloc>(context);

    accountBloc.stream.listen((state) {
      print(state);
      if (state is GetLoggedUserCompletedState) {
        user = state.user;
      }
    });
    notificationBloc.stream.listen((state) {
      print('NOTIFICATION STATE :::: $state');
    });

    // if the current logged user is not connected the email auth yet.
    WidgetsBinding.instance.addPostFrameCallback((_) => linkConsultantGmail());
    _timer = Timer.periodic(Duration(hours: 2), (Timer t) {
      if ((CashHelper.getData(key: 'rate') == null && currentUser != null)) {
        print("00000000");
        showDialog(
            context: context,
            builder: (context) {
              return rateReactionsDialog(size);
            });
        CashHelper.saveData(
            key: 'time', value: Duration(microseconds: 0).toString());
      }
    });
  }

  Future<void> linkConsultantGmail() async {
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentReference docRef2 = FirebaseFirestore.instance
          .collection("Setting")
          .doc("pzBqiphy5o2kkzJgWUT7");
      final DocumentSnapshot documentSnapshot2 = await docRef2.get();
      Setting? setting =
          Setting.fromMap(documentSnapshot2.data() as Map<String, dynamic>);
      DocumentReference docRef = FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(FirebaseAuth.instance.currentUser!.uid);
      final DocumentSnapshot documentSnapshot = await docRef.get();
      var loggedUser = GroceryUser.fromMap(documentSnapshot.data() as Map);
  final List<UserInfo> providers =
          await FirebaseAuth.instance.currentUser!.providerData;
      bool googleProvider =
          providers.any((provider) => provider.providerId == "google.com");
      bool appleProvider =
          providers.any((provider) => provider.providerId == "apple.com");
   
      if (loggedUser.profileCompleted == true &&
          setting.userSignupPop == true &&googleProvider==false&&appleProvider==false &&
          _selectedPage == 0) {
        navigateWithoutBack(context, showSecurityDialog(size));
      }
    }
  }

  void dispose() {
    _timer.cancel();

    // Always cancel a timer when the widget is disposed
    super.dispose();
  }

  showSecurityDialog(Size size) {
    return showDialog(
      builder: (context) => DialogWidget(
        padButtom: 0,
        padLeft: 0,
        padReight: 0,
        padTop: 0,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          width: AppSize.w441_3.w,
          // height: AppSize.h326_6.h,
          padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p32.w, vertical: AppPadding.p32.h),
          child: Column(
            /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,*/
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AssetsManager.iconoirCancelIconPath,
                      width: AppSize.w32.r,
                      height: AppSize.h32.r,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Center(
                child: SvgPicture.asset(AssetsManager.securityIcon,
                    height: AppSize.h62.h, width: AppSize.w49_3.w),
              ),
              SizedBox(height: AppSize.h13_3.h),
              Column(
                children: [
                  Text(
                    getTranslated(context, "oneStep"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: AppSize.h1_8.h,
                      //backgroundColor: Colors.red,
                      fontFamily: getTranslated(context, "fontFamily"),
                      fontSize: AppFontsSizeManager.s32.sp,
                      color: AppColors.black,
                      wordSpacing: 0,
                      letterSpacing: 0,

                      // fontStyle: FontStyle.normal,
                      //fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSize.h13_3.h),
                  Text(
                    getTranslated(context, "toSafeAccount"),
                    style: TextStyle(
                      fontFamily: getTranslated(context, 'fontFamily'),
                      height: AppSize.h2.h,
                      fontSize: AppFontsSizeManager.s21_3.sp,
                      color: AppColors.blackColor,
                      //fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(
                    height: AppSize.h21_3.h,
                  ),
                  InkWell(
                      onTap: () {
                        linkEmailWithPhone(context);
                      },
                      child: Container(
                        height: AppSize.h64.h,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                convertPtToPx(AppRadius.r8).r),
                            border: Border.all(
                              color: AppColors.red3,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                                scale: 1.2,
                                child: SvgPicture.asset(
                                  AssetsManager.googleIconsPath,
                                  height: AppSize.h32.r,
                                  width: AppSize.w32.r,
                                )),
                            SizedBox(
                              width: AppSize.w10_6.w,
                            ),
                            Text(
                              getTranslated(context, "linkGoogleAccount"),
                              maxLines: AppConstants.maxLines,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: getTranslated(
                                    context, "Montserratbold"),
                                color: AppColors.CWG,
                                fontSize: AppFontsSizeManager.s16.sp,
                                //fontWeight: FontWeight.normal
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: AppSize.h21_3.h,
                  ),
                  //SizedBox(width: AppSize.w57_3.w),
                  InkWell(
                      onTap: () {
                        linkAppleWithPhone(context);
                      },
                      child: Container(
                        height: AppSize.h64.h,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                convertPtToPx(AppRadius.r8).r),
                            border: Border.all(
                              color: AppColors.red3,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                                scale: 1.1,
                                child: SvgPicture.asset(
                                  AssetsManager.apple_Icon_Path,
                                  height: AppSize.h32.r,
                                  width: AppSize.w32.r,
                                )),
                            SizedBox(width: AppSize.w10_6.w),
                            Text(
                              getTranslated(context, "linkAppleAccount"),
                              maxLines: AppConstants.maxLines,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: getTranslated(
                                    context, "Montserratbold"),
                                color: AppColors.CWG,
                                fontSize: AppFontsSizeManager.s16.sp,
                                //fontWeight: FontWeight.normal
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  Future<void> linkEmailWithPhone(BuildContext context) async {
    try {
      setState(() {
        load = true;
      });
      //get currently logged in user
      User? existingUser = await FirebaseAuth.instance.currentUser;

      //get the credentials of the new linking account
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //now link these credentials with the existing user
      UserCredential linkAuthResult =
          await existingUser!.linkWithCredential(googleCredential);

      // update user data and set user email.
      if (linkAuthResult.user != null) {
        await updateUserEmail(context, linkAuthResult.user!.email!);
        setState(() {
          load = false;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        load = false;
      });
      print('rrrr$e');
      showFailedSnackBar(getTranslated(context, 'failed'));
    }
  }

  Future<void> updateUserEmail(BuildContext context, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'email': email});
    } catch (e) {
      showFailedSnackBar(getTranslated(context, 'failed'));
    }
  }

  Future<void> linkAppleWithPhone(BuildContext context) async {
    try {
      setState(() {
        load = true;
      });

      final appleResult = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (appleResult.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = appleResult.credential!;
          final oauthCredential = OAuthProvider("apple.com").credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          // Link Apple account to existing user
          User? existingUser = FirebaseAuth.instance.currentUser;
          await existingUser?.linkWithCredential(oauthCredential);

          updateUserAppleId(
              context, appleIdCredential.identityToken.toString());
          setState(() {
            load = false;
          });
          navigateWithoutBack(context, () => HomeScreen());
          // Update UI or navigate after successful linking
          // ...
          break;
        case AuthorizationStatus.error:
          // Handle error
          break;
        case AuthorizationStatus.cancelled:
          // Handle cancellation
          break;
      }
    } catch (e) {
      setState(() {
        load = false;
      });
      // Handle exception
    }
  }

  Future<void> updateUserAppleId(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isApple': true});
    } catch (e) {
      showFailedSnackBar(getTranslated(context, 'failed'));
    }
  }

  @override
  void didChangeDependencies() {
    GroceryUser? loggedUser;
    super.didChangeDependencies();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      if (dynamicLinkData != null) {
        if (dynamicLinkData.link.toString().contains("consultant_id")) {
          if (FirebaseAuth.instance.currentUser != null) {
            var __user = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            loggedUser = GroceryUser.fromMap(__user.data() as Map);
          }
          final Uri link = dynamicLinkData.link;
          print(dynamicLinkData.link.toString());
          String result = dynamicLinkData.link.toString().replaceAll(
              'https://makemynikahapp.page.link/consultant_id=', ' ');
          String consultantId = result.trim();
          print("hhhhh = $link");
          print(consultantId);
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(consultantId)
              .get()
              .then((value) async {
            GroceryUser currentUser = GroceryUser.fromMap(value.data() as Map);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    //  ConsultantDetailsScreen
                    GirlDetailsView(
                  consultant: currentUser,
                  appleReview: false,
                  loggedUser: loggedUser,
                ),
              ),
            );
          });
          return;
        }
        if (dynamicLinkData.link.toString().contains("coach_id")) {
          if (FirebaseAuth.instance.currentUser != null) {
            var __user = await FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            loggedUser = GroceryUser.fromMap(__user.data() as Map);
          }
          final Uri link = dynamicLinkData.link;
          print(dynamicLinkData.link.toString());
          String result = dynamicLinkData.link
              .toString()
              .replaceAll('https://makemynikahapp.page.link/coach_id=', ' ');
          String consultantId = result.trim();
          print("hhhhh = $link");
          print(consultantId);
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(consultantId)
              .get()
              .then((value) async {
            GroceryUser currentUser = GroceryUser.fromMap(value.data() as Map);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoachProfileView(
                  consultant: currentUser,
                  loggedUser: loggedUser,
                ),
              ),
            );
          });
          return;
        } else {
          final Uri link = dynamicLinkData.link;
          print(dynamicLinkData.link.toString());
          String result = dynamicLinkData.link
              .toString()
              .replaceAll('https://makemynikahapp.page.link/course_id=', ' ');
          String courseId = result.trim();
          print("hhhhh = $link");
          print(courseId);
          await FirebaseFirestore.instance
              .collection('Courses')
              .doc(courseId)
              .get()
              .then((value) async {
            Courses course = Courses.fromMap(value.data() as Map);
            Navigator.push(
              context,
              MaterialPageRoute(
                // CourseVideosScreen
                builder: (context) => CourseVideosView(
                  loggedUser: loggedUser == null ? null : loggedUser,
                  course: course,
                ),
              ),
            );
          });
          return;
        }
      }
    }).onError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: BlocBuilder(
            bloc: accountBloc,
            builder: (context, state) {
              if (state is GetLoggedUserCompletedState) {
                return Scaffold(
                  drawer: DrawerWidget(),
                  backgroundColor: Colors.white,
                  key: _scaffoldKey,
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                    ),
                    height: 60.h,
                    width: size.width,
                    child: BlocBuilder(
                      bloc: accountBloc,
                      builder: (context, state) {
                        print("Account state");
                        print(state);
                        if (state is GetLoggedUserInProgressState) {
                          return Center(child: userBottomNavigation());
                        } else if (state is GetLoggedUserCompletedState) {
                          user = state.user;
                          if (mounted & first) {
                            if (FirebaseService.checkInit == false) {
                              print("coooooooooooooooo $context");
                              FirebaseService.init(context);
                            }
                            notificationBloc
                                .add(GetAllNotificationsEvent(user!.uid!));
                            first = false;
                          }
                          return (user!.userType == "CONSULTANT")
                              ? consultBottomNavigation()
                              : (user!.userType == "COACH")
                                  ? coachBottomNavigation()
                                  : userBottomNavigation();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                  body: userHomeBody(),
                );
              } else {
                return Scaffold(
                    drawer: DrawerWidget(),
                    backgroundColor: Colors.white,
                    key: _scaffoldKey,
                    bottomNavigationBar: Container(
                      child: userBottomNavigation(),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                      ),
                      height: 60.h,
                      width: size.width,
                    ),
                    body: userHomeBody());
              }
            }));
  }

  Widget userBottomNavigation() {
    return Container(
      //padding: EdgeInsets.only(left: 3, right: 3),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ///**------------------>>>>>SHOW TOOL TIPS FOR MAN<<<<<------------------**///
          CustomTooltipManager(
            tooltips: [
              TooltipData(
                getTranslated(context, "notificationTipTxt"),
                ToolTipKeysManager.notificationTipKey,
                Offset(lang == "ar" ? AppSize.w3.w : AppSize.w302.w, -20.h),
                "save1",
              ),
              TooltipData(
                getTranslated(context, "searchTipTxt"),
                ToolTipKeysManager.searchTipKey,
                Offset(lang == "ar" ? AppSize.w10.w : AppSize.w260.w, AppSize.h100.h),
                "save7",
              ),
              TooltipData(
                getTranslated(context, "favTipTxt"),
                ToolTipKeysManager.callsNavTipKey,
                Offset(
                    lang == "ar" ? AppSize.w245.w : AppSize.w90_5.w, lang == "ar" ? AppSize.h303.h : AppSize.h240.h),
                "save2",
              ),
              TooltipData(
                getTranslated(context, "manCoachTipTxt"),
                ToolTipKeysManager.coachesNavTipKey,
                Offset(
                    lang == "ar" ? AppSize.w265.w : AppSize.w38.w, lang == "ar" ? AppSize.h755.h : AppSize.h763.h),
                "save3",
              ),
              TooltipData(
                getTranslated(context, "manCallsTipTxt"),
                ToolTipKeysManager.callsTipKey,
                Offset(
                    lang == "ar" ? AppSize.w207.w : AppSize.w150.w, lang == "ar" ? AppSize.h765.h : AppSize.h770.h),
                "save4",
              ),
              TooltipData(
                getTranslated(context, "manCoursesTipTxt"),
                ToolTipKeysManager.academyNavTipKey,
                Offset(
                    lang == "ar" ? AppSize.w102.w : AppSize.w205.w, lang == "ar" ? AppSize.h760.h : AppSize.h760.h),
                "save5",
              ),
              TooltipData(
                getTranslated(context, "supportTipTxt"),
                ToolTipKeysManager.supportNAvTipKey,
                Offset(
                    lang == "ar" ? AppSize.w2.w : AppSize.w300.w, lang == "ar" ? AppSize.h730.h : AppSize.h745.h),
                "save6",
              ),
            ],
            tooltipBuilder: (context, message, showNext, currentIndex, total, closeToolTip) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SingleChildScrollView( // Add this
                    child: Column(
                      children: [
                        if (currentIndex == 0 || currentIndex == 1)
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: currentIndex == 0
                                      ? lang == "ar"
                                      ? AppSize.w170.w
                                      : AppSize.w0.w
                                      : currentIndex == 1
                                      ? lang == "ar"
                                      ? AppSize.w170.w
                                      : AppSize.w0.w
                                      : 0.w,
                                  left: currentIndex == 0
                                      ? lang == "ar"
                                      ? AppSize.w0.w
                                      : AppSize.w170.w
                                      : currentIndex == 1
                                      ? lang == "ar"
                                      ? AppSize.w0.w
                                      : AppSize.w170.w
                                      : AppSize.w0.w,
                                ),
                                child: Lottie.asset(
                                    'assets/lotifile/tool_tip_animation.json',
                                    width: currentIndex == 1
                                        ? AppSize.w133_3.w
                                        : AppSize.w100.w,
                                    height: currentIndex == 1
                                        ? AppSize.w133_3.w
                                        : AppSize.h100.h),
                              ),
                              Padding(
                                key: ToolTipKeysManager.searchTipKey,
                                padding: EdgeInsets.only(
                                  right: currentIndex == 0
                                      ? lang == "ar"
                                      ? AppSize.w170.w
                                      : AppSize.w0.w
                                      : currentIndex == 1
                                      ? lang == "ar"
                                      ? AppSize.w170.w
                                      : AppSize.w0.w
                                      : AppSize.w0.w,
                                  left: currentIndex == 0
                                      ? lang == "ar"
                                      ? AppSize.w0.w
                                      : AppSize.w170.w
                                      : currentIndex == 1
                                      ? lang == "ar"
                                      ? AppSize.w0.w
                                      : AppSize.w170.w
                                      : AppSize.w0.w,
                                ),
                                child: ClipPath(
                                  clipper: TriangleClipper(),
                                  child: Container(
                                    width: AppSize.w21_3.w,
                                    height: AppSize.w10_6.h,
                                    color: AppColors.pink2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        GestureDetector(
                          onTap: showNext,
                          child: Container(
                            width: AppSize.w269_3.w,
                             height: currentIndex == 2 ? AppSize.h173_3.h : // Adjust height for favorite tooltip
                            currentIndex == 6
                                ? lang == "ar"
                                ? AppSize.h200.h
                                : AppSize.h190.h
                                : currentIndex == 4
                                ? AppSize.h173_3.h
                                : currentIndex == 2
                                ? AppSize.h170.h
                                : AppSize.h173.h,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(primary: AppColors.white),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.r16.r),
                                  side: BorderSide(
                                      color: AppColors.pink2,
                                      width: AppSize.w1.w),
                                ),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: closeToolTip,
                                            icon: Icon(
                                              Icons.close,
                                              color: AppColors.red3,
                                              size: AppSize.w21.r,
                                            ))
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: AppPadding.p16.w,
                                          left: AppPadding.p22_6.w,
                                          bottom: AppPadding.p10.h),
                                      child: Text(
                                        message,
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontFamily: getTranslated(
                                              context, "Montserratsemibold"),
                                          fontSize: AppFontsSizeManager.s16.sp,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: AppPadding.p20.w,
                                          left: lang == "ar"
                                              ? 0
                                              : AppPadding.p20.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: AppSize.w65.w,
                                            height: AppSize.h7.h,
                                            child: ToolTipProgressListView(
                                              select: currentIndex,
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppSize.w30.w,
                                          ),
                                          Container(
                                            width: AppSize.w80.w,
                                            height: AppSize.h29_3.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.red3,
                                              borderRadius: BorderRadius.circular(
                                                  AppRadius.r10.r),
                                              gradient: LinearGradient(
                                                begin: Alignment(0.5, 0),
                                                end: Alignment(0.5, 1),
                                                colors: [
                                                  AppColors.primary2,
                                                  AppColors.pink2,
                                                ],
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: showNext,
                                              child: Center(
                                                child: Text(
                                                  getTranslated(
                                                      context, "goNext"),
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontFamily: getTranslated(
                                                        context,
                                                        "Montserratsemibold"),
                                                    fontSize: AppFontsSizeManager
                                                        .s13_5.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(207, 0, 54, 0.1),
                                  blurRadius: 16.r,
                                  spreadRadius: 0.0,
                                  offset: Offset(0.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (currentIndex == 6 ||
                            currentIndex == 2 ||
                            currentIndex == 3 ||
                            currentIndex == 4 ||
                            currentIndex == 5)
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: currentIndex == 2
                                        ? 0.w
                                        : currentIndex == 1
                                        ? lang == "ar"
                                        ? 80.w
                                        : 0.w
                                        : currentIndex == 5
                                        ? lang == "ar"
                                        ? 0.w
                                        : 120.w
                                        : currentIndex == 6
                                        ? lang == "ar"
                                        ? 0.w
                                        : 160.w
                                        : 0.w,
                                    right: currentIndex == 4
                                        ? lang == "ar"
                                        ? 110.w
                                        : 0.w
                                        : currentIndex == 1
                                        ? lang == "ar"
                                        ? 0.h
                                        : 115.h
                                        : currentIndex == 5
                                        ? lang == "ar"
                                        ? 90.w
                                        : 0.w
                                        : currentIndex == 6
                                        ? lang == "ar"
                                        ? 115.w
                                        : 0.w
                                        : 0.w),
                                child: Lottie.asset(
                                    'assets/lotifile/tool_tip_animation.json',
                                    width: currentIndex == 1
                                        ? AppSize.w133_3.w
                                        : AppSize.w100.w,
                                    height: currentIndex == 1
                                        ? AppSize.w133_3.w
                                        : AppSize.h100.h),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: currentIndex == 2
                                        ? 0.w
                                        : currentIndex == 1
                                        ? lang == "ar"
                                        ? 80.w
                                        : 0.w
                                        : currentIndex == 5
                                        ? lang == "ar"
                                        ? 0.w
                                        : 120.w
                                        : currentIndex == 6
                                        ? lang == "ar"
                                        ? 0.w
                                        : 160.w
                                        : 0.w,
                                    right: currentIndex == 4
                                        ? lang == "ar"
                                        ? 110.w
                                        : 0.w
                                        : currentIndex == 1
                                        ? lang == "ar"
                                        ? 0.w
                                        : 115.h
                                        : currentIndex == 5
                                        ? lang == "ar"
                                        ? 90.w
                                        : 0.w
                                        : currentIndex == 6
                                        ? lang == "ar"
                                        ? 115.w
                                        : 0.w
                                        : 0.w),
                                child: RotationTransition(
                                  turns: AlwaysStoppedAnimation(180 / 360),
                                  child: ClipPath(
                                    clipper: TriangleClipper(),
                                    child: Container(
                                      width: 16.w,
                                      height: 8.h,
                                      color: AppColors.pink2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
            ),
          matching(false),
          coaches(),
          calls(),
          academy(),
          support(),
        ],
      ),
    );
  }

  int currentIndex = 0;
  Widget consultBottomNavigation() {
    lang = getTranslated(context, "lang");
    return Container(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ///**------------------>>>>>SHOW TOOL TIPS FOR WOMAN<<<<<------------------**///
          lang == "ar"
              ? CustomTooltipManager(
                  tooltips: [
                    TooltipData(
                      getTranslated(context, "notificationTipTxt"),
                      ToolTipKeysManager.notificationTipKey,
                      Offset(lang == "ar" ? 1.w : 305.w, -20.h),
                      "save8",
                    ),
                    TooltipData(
                      getTranslated(context, "callsTipTxt"),
                      ToolTipKeysManager.callsNavTipKey,
                      Offset(lang == "ar" ? 299.w : 18.w,
                          lang == "ar" ? 748.h : 735.h),
                      "save9",
                    ),
                    TooltipData(
                      getTranslated(context, "coachesTipTxt"),
                      ToolTipKeysManager.coachesNavTipKey,
                      Offset(lang == "ar" ? 262.w : 48.w,
                          lang == "ar" ? 763.h : 765.h),
                      "save10",
                    ),
                    TooltipData(
                      getTranslated(context, "callHistoryTipTxt"),
                      ToolTipKeysManager.callHistoryNavTipKey,
                      Offset(150.w, lang == "ar" ? 765.h : 760.h),
                      "save11",
                    ),
                    TooltipData(
                      getTranslated(context, "academyTipTxt"),
                      ToolTipKeysManager.academyNavTipKey,
                      Offset(lang == "ar" ? 97.w : 262.w,
                          lang == "ar" ? 765.h : 762.h),
                      "save12",
                    ),
                    TooltipData(
                      getTranslated(context, "supportTipTxt"),
                      ToolTipKeysManager.supportNAvTipKey,
                      Offset(lang == "ar" ? 7.w : 300.w,
                          lang == "ar" ? 765.h : 746.h),
                      "save13",
                    ),
                  ],
                  tooltipBuilder: (context, message, showNext, currentIndex,
                      total, closeToolTip) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            if (currentIndex == 0)
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: currentIndex == 0
                                          ? lang == "ar"
                                              ? 170.w
                                              : 0.w
                                          : currentIndex == 1
                                              ? 185.w
                                              : 0.w,
                                      left: currentIndex == 0
                                          ? lang == "ar"
                                              ? 0.w
                                              : 170.w
                                          : 0.w,
                                    ),
                                    child: Lottie.asset(
                                        'assets/lotifile/tool_tip_animation.json',
                                        width: AppSize.w100.w,
                                        height: AppSize.h100.h),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: currentIndex == 0
                                            ? lang == "ar"
                                                ? 170.w
                                                : 0.w
                                            : 0.w,
                                        left: currentIndex == 0
                                            ? lang == "ar"
                                                ? 0.w
                                                : 170.w
                                            : 0.w),
                                    child: ClipPath(
                                      clipper: TriangleClipper(),
                                      child: Container(
                                        width: 21.3.w,
                                        // Adjust the width as needed
                                        height: 10.6.h,
                                        // Adjust the height as needed
                                        color: AppColors.pink2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            GestureDetector(
                              onTap: showNext,
                              child: Container(
                                width: 272.w,
                                height: currentIndex == 0
                                    ? 165.h
                                    : currentIndex == 1
                                        ? 190.h
                                        : currentIndex == 2
                                            ? 170.h
                                            : currentIndex == 4
                                                ? 170.h
                                                : currentIndex == 5
                                                    ? 170.h
                                                    : 165.h,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: AppColors.white),
                                  ),
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.r16.r),
                                      side: BorderSide(
                                          color: AppColors.pink2,
                                          width: AppSize.w1.w),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: closeToolTip,
                                                icon: Icon(
                                                  Icons.close,
                                                  color: AppColors.red3,
                                                  size: AppSize.w21.r,
                                                ))
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: AppPadding.p16.w,
                                              left: AppPadding.p22_6.w,
                                              bottom: AppPadding.p10.h),
                                          child: Text(
                                            message,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontFamily: getTranslated(context,
                                                  "Montserratsemibold"),
                                              fontSize:
                                                  AppFontsSizeManager.s16.sp,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: AppPadding.p20.w,
                                              left: lang == "ar"
                                                  ? 0.w
                                                  : AppPadding.p20.w),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 65,
                                                height: 7,
                                                child: ToolTipProgressListView(
                                                  select: currentIndex,
                                                ),
                                              ),
                                              SizedBox(
                                                width: AppSize.w30.w,
                                              ),
                                              Container(
                                                width: AppSize.w80.w,
                                                height: AppSize.h29_3.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.red3,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppRadius.r10.r),
                                                  gradient: LinearGradient(
                                                    begin: Alignment(0.5, 0),
                                                    end: Alignment(0.5, 1),
                                                    colors: [
                                                      AppColors.primary2,
                                                      AppColors.pink2,
                                                    ],
                                                  ),
                                                ),
                                                child: GestureDetector(
                                                  onTap: showNext,
                                                  child: Center(
                                                    child: Text(
                                                      getTranslated(
                                                          context, "goNext"),
                                                      style: TextStyle(
                                                        color: AppColors.white,
                                                        fontFamily: getTranslated(
                                                            context,
                                                            "Montserratsemibold"),
                                                        fontSize:
                                                            AppFontsSizeManager
                                                                .s13_5.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color.fromRGBO(207, 0, 54, 0.1),
                                      blurRadius: 16.r,
                                      spreadRadius: 0.0,
                                      offset: Offset(0.0, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (currentIndex == 1 ||
                                currentIndex == 2 ||
                                currentIndex == 3 ||
                                currentIndex == 4 ||
                                currentIndex == 5)
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: currentIndex == 2
                                            ? 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 105.w
                                                    : 0.w
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 0.w
                                                        : 145.w
                                                    : 0,
                                        right: currentIndex == 4
                                            ? lang == "ar"
                                                ? 110.w
                                                : 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 0.w
                                                    : 150.h
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 110.w
                                                        : 0.w
                                                    : currentIndex == 2
                                                        ? lang == "ar"
                                                            ? 0.w
                                                            : 15.w
                                                        : 0.w),
                                    child: Lottie.asset(
                                        'assets/lotifile/tool_tip_animation.json',
                                        width: AppSize.w100.w,
                                        height: AppSize.h100.h),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: currentIndex == 2
                                            ? 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 105.w
                                                    : 0.w
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 0.w
                                                        : 145.w
                                                    : 0.w,
                                        right: currentIndex == 4
                                            ? lang == "ar"
                                                ? 110.w
                                                : 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 0.w
                                                    : 150.h
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 110.w
                                                        : 0.w
                                                    : currentIndex == 2
                                                        ? lang == "ar"
                                                            ? 0.w
                                                            : 15.w
                                                        : 0.w),
                                    child: RotationTransition(
                                      turns:
                                          new AlwaysStoppedAnimation(180 / 360),
                                      child: ClipPath(
                                        clipper: TriangleClipper(),
                                        child: Container(
                                          width: 16.w,
                                          // Adjust the width as needed
                                          height: 8.h,
                                          // Adjust the height as needed
                                          color: AppColors.pink2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              : CustomTooltipManager(
                  tooltips: [
                    TooltipData(
                      getTranslated(context, "notificationTipTxt"),
                      ToolTipKeysManager.notificationTipKey,
                      Offset(lang == "ar" ? 5.w : 305.w, -20.h),
                      "save8",
                    ),
                    TooltipData(
                      getTranslated(context, "callsTipTxt"),
                      ToolTipKeysManager.callsNavTipKey,
                      Offset(lang == "ar" ? 307.w : 18.w,
                          lang == "ar" ? 720.h : 735.h),
                      "save9",
                    ),
                    TooltipData(
                      getTranslated(context, "coachesTipTxt"),
                      ToolTipKeysManager.coachesNavTipKey,
                      Offset(lang == "ar" ? 260.w : 48.w,
                          lang == "ar" ? 720.h : 765.h),
                      "save10",
                    ),
                    TooltipData(
                      getTranslated(context, "callHistoryTipTxt"),
                      ToolTipKeysManager.callHistoryNavTipKey,
                      Offset(152.w, lang == "ar" ? 720.h : 760.h),
                      "save11",
                    ),
                    TooltipData(
                      getTranslated(context, "academyTipTxt"),
                      ToolTipKeysManager.academyNavTipKey,
                      Offset(lang == "ar" ? 97.w : 262.w,
                          lang == "ar" ? 720.h : 762.h),
                      "save12",
                    ),
                    TooltipData(
                      getTranslated(context, "supportTipTxt"),
                      ToolTipKeysManager.supportNAvTipKey,
                      Offset(lang == "ar" ? 2.w : 300.w,
                          lang == "ar" ? 720.h : 746.h),
                      "save13",
                    ),
                  ],
                  tooltipBuilder: (context, message, showNext, currentIndex,
                      total, closeToolTip) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            if (currentIndex == 0)
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: currentIndex == 0
                                            ? lang == "ar"
                                                ? 170.w
                                                : 0.w
                                            : 0.w,
                                        left: currentIndex == 0
                                            ? lang == "ar"
                                                ? 0.w
                                                : 170.w
                                            : 0.w),
                                    child: Lottie.asset(
                                        'assets/lotifile/tool_tip_animation.json',
                                        width: AppSize.w100.w,
                                        height: AppSize.h100.h),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: currentIndex == 0
                                            ? lang == "ar"
                                                ? 170.w
                                                : 0.w
                                            : 0.w,
                                        left: currentIndex == 0
                                            ? lang == "ar"
                                                ? 0.w
                                                : 170.w
                                            : 0.w),
                                    child: ClipPath(
                                      clipper: TriangleClipper(),
                                      child: Container(
                                        width: 21.3.w,
                                        // Adjust the width as needed
                                        height: 10.6.h,
                                        // Adjust the height as needed
                                        color: AppColors.pink2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            GestureDetector(
                              onTap: showNext,
                              child: Container(
                                width: 272.w,
                                height: currentIndex == 1
                                    ? 210.h
                                    : currentIndex == 1
                                        ? 200.h
                                        : currentIndex == 2
                                            ? 170.h
                                            : currentIndex == 4
                                                ? 170.h
                                                : currentIndex == 5
                                                    ? 190.h
                                                    : 173.h,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: AppColors.white),
                                  ),
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.r16.r),
                                      side: BorderSide(
                                          color: AppColors.pink2,
                                          width: AppSize.w1.w),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: closeToolTip,
                                                icon: Icon(
                                                  Icons.close,
                                                  color: AppColors.red3,
                                                  size: AppSize.w21.r,
                                                ))
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: AppPadding.p16.w,
                                              left: AppPadding.p22_6.w,
                                              bottom: AppPadding.p10.h),
                                          child: Text(
                                            message,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontFamily: getTranslated(context,
                                                  "Montserratsemibold"),
                                              fontSize:
                                                  AppFontsSizeManager.s16.sp,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: AppPadding.p20.w,
                                              left: lang == "ar"
                                                  ? 0
                                                  : AppPadding.p20.w),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 65.w,
                                                height: 7.h,
                                                child: ToolTipProgressListView(
                                                  select: currentIndex,
                                                ),
                                              ),
                                              SizedBox(
                                                width: AppSize.w30.w,
                                              ),
                                              Container(
                                                width: AppSize.w80.w,
                                                height: AppSize.h29_3.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.red3,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppRadius.r10.r),
                                                  gradient: LinearGradient(
                                                    begin: Alignment(0.5, 0),
                                                    end: Alignment(0.5, 1),
                                                    colors: [
                                                      AppColors.primary2,
                                                      AppColors.pink2,
                                                    ],
                                                  ),
                                                ),
                                                child: GestureDetector(
                                                  onTap: showNext,
                                                  child: Center(
                                                    child: Text(
                                                      getTranslated(
                                                          context, "goNext"),
                                                      style: TextStyle(
                                                        color: AppColors.white,
                                                        fontFamily: lang == "ar"
                                                            ? getTranslated(
                                                                context,
                                                                "fontFamily")
                                                            : getTranslated(
                                                                context,
                                                                "Montserratsemibold"),
                                                        fontSize:
                                                            AppFontsSizeManager
                                                                .s13_5.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color.fromRGBO(207, 0, 54, 0.1),
                                      blurRadius: 16.r,
                                      spreadRadius: 0.0,
                                      offset: Offset(0.0, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (currentIndex == 1 ||
                                currentIndex == 2 ||
                                currentIndex == 3 ||
                                currentIndex == 4 ||
                                currentIndex == 5)
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: currentIndex == 2
                                            ? 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 80.w
                                                    : 0.w
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 0.w
                                                        : 145.w
                                                    : 0,
                                        right: currentIndex == 4
                                            ? lang == "ar"
                                                ? 110.w
                                                : 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 0.w
                                                    : 150.h
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 90.w
                                                        : 0.w
                                                    : currentIndex == 2
                                                        ? lang == "ar"
                                                            ? 0.w
                                                            : 15.w
                                                        : 0),
                                    child: Lottie.asset(
                                        'assets/lotifile/tool_tip_animation.json',
                                        width: AppSize.w100.w,
                                        height: AppSize.h100.h),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: currentIndex == 2
                                            ? 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 80.w
                                                    : 0.w
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 0.w
                                                        : 145.w
                                                    : 0.w,
                                        right: currentIndex == 4
                                            ? lang == "ar"
                                                ? 110.w
                                                : 0.w
                                            : currentIndex == 1
                                                ? lang == "ar"
                                                    ? 0.w
                                                    : 150.h
                                                : currentIndex == 5
                                                    ? lang == "ar"
                                                        ? 90.w
                                                        : 0.w
                                                    : currentIndex == 2
                                                        ? lang == "ar"
                                                            ? 0.w
                                                            : 15.w
                                                        : 0.w),
                                    child: RotationTransition(
                                      turns:
                                          new AlwaysStoppedAnimation(180 / 360),
                                      child: ClipPath(
                                        clipper: TriangleClipper(),
                                        child: Container(
                                          width: 16,
                                          // Adjust the width as needed
                                          height: 8,
                                          // Adjust the height as needed
                                          color: AppColors.pink2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
          matching(true),
          coaches(),
          callHistory(),
          academy(),
          support(),
        ],
      ),
    );
  }

  Widget coachBottomNavigation() {
    return Container(
      padding: EdgeInsets.only(left: 3.w, right: 3.w),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ///**------------------>>>>>SHOW TOOL TIPS FOR COACH<<<<<------------------**///
          CustomTooltipManager(
            tooltips: [
              TooltipData(
                getTranslated(context, "notificationTipTxt"),
                ToolTipKeysManager.notificationTipKey,
                Offset(lang == "ar" ? 12.w : 290.w, -15.h),
                "save14",
              ),
              TooltipData(
                getTranslated(context, "coachSearchTipTxt"),
                ToolTipKeysManager.searchTipKey,
                Offset(lang == "ar" ? 23.w : 275.w, 120.h),
                "save15",
              ),
              TooltipData(
                getTranslated(context, "coachFavTipTxt"),
                ToolTipKeysManager.callsNavTipKey,
                Offset(
                    lang == "ar" ? 247.w : 98.w, lang == "ar" ? 300.h : 292.h),
                "save16",
              ),
              TooltipData(
                getTranslated(context, "coachCallsTipTxt"),
                ToolTipKeysManager.coachesNavTipKey,
                Offset(
                    lang == "ar" ? 265.w : 38.w, lang == "ar" ? 635.h : 635.h),
                "save17",
              ),
              TooltipData(
                getTranslated(context, "coachCallHistoryTipTxt"),
                ToolTipKeysManager.callsTipKey,
                Offset(
                    lang == "ar" ? 205.w : 150.w, lang == "ar" ? 625.h : 625.h),
                "save18",
              ),
              TooltipData(
                getTranslated(context, "supportTipTxt"),
                ToolTipKeysManager.supportNAvTipKey,
                Offset(
                    lang == "ar" ? -1.w : 300.w, lang == "ar" ? 730.h : 742.h),
                "save19",
              ),
            ],
            tooltipBuilder: (context, message, showNext, currentIndex, total,
                closeToolTip) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      if (currentIndex == 0 || currentIndex == 1)
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: currentIndex == 0
                                    ? lang == "ar"
                                        ? 170.w
                                        : 0.w
                                    : currentIndex == 1
                                        ? lang == "ar"
                                            ? 170.w
                                            : 0.w
                                        : 0.w,
                                left: currentIndex == 0
                                    ? lang == "ar"
                                        ? 0.w
                                        : 170.w
                                    : currentIndex == 1
                                        ? lang == "ar"
                                            ? 0.w
                                            : 170.w
                                        : 0.w,
                              ),
                              child: Lottie.asset(
                                  'assets/lotifile/tool_tip_animation.json',
                                  width: AppSize.w100.w,
                                  height: AppSize.h100.h),
                            ),
                            Padding(
                              key: ToolTipKeysManager.searchTipKey,
                              padding: EdgeInsets.only(
                                right: currentIndex == 0
                                    ? lang == "ar"
                                        ? 170.w
                                        : 0.w
                                    : currentIndex == 1
                                        ? lang == "ar"
                                            ? 170.w
                                            : 0.w
                                        : 0.w,
                                left: currentIndex == 0
                                    ? lang == "ar"
                                        ? 0.w
                                        : 170.w
                                    : currentIndex == 1
                                        ? lang == "ar"
                                            ? 0.w
                                            : 170.w
                                        : 0.w,
                              ),
                              child: ClipPath(
                                clipper: TriangleClipper(),
                                child: Container(
                                  width: 21.3.w,
                                  // Adjust the width as needed
                                  height: 10.6.h,
                                  // Adjust the height as needed
                                  color: AppColors.pink2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      GestureDetector(
                        key: ToolTipKeysManager.coachesNavTipKey,
                        onTap: showNext,
                        child: Container(
                          width: 272.w,
                          height: currentIndex == 5
                              ? lang == "ar"
                                  ? 200.h
                                  : 190.h
                              : currentIndex == 2
                                  ? 175.h
                                  : currentIndex == 4
                                      ? 180.h
                                      : currentIndex == 3
                                          ? 175.h
                                          : 173.h,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme:
                                  ColorScheme.light(primary: AppColors.white),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r16.r),
                                side: BorderSide(
                                    color: AppColors.pink2,
                                    width: AppSize.w1.w),
                              ),
                              key: ToolTipKeysManager.callsTipKey,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: closeToolTip,
                                          icon: Icon(
                                            Icons.close,
                                            color: AppColors.red3,
                                            size: AppSize.w21.r,
                                          ))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: AppPadding.p16.w,
                                        left: AppPadding.p22_6.w,
                                        bottom: AppPadding.p10.h),
                                    child: Text(
                                      message,
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontFamily: getTranslated(
                                            context, "Montserratsemibold"),
                                        fontSize: AppFontsSizeManager.s16.sp,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: AppPadding.p20.w,
                                        left: lang == "ar"
                                            ? 0
                                            : AppPadding.p20.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 65,
                                          height: 7,
                                          child: ToolTipProgressListView(
                                            select: currentIndex,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AppSize.w30.w,
                                        ),
                                        Container(
                                          width: AppSize.w80.w,
                                          height: AppSize.h29_3.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.red3,
                                            borderRadius: BorderRadius.circular(
                                                AppRadius.r10.r),
                                            gradient: LinearGradient(
                                              begin: Alignment(0.5, 0),
                                              end: Alignment(0.5, 1),
                                              colors: [
                                                AppColors.primary2,
                                                AppColors.pink2,
                                              ],
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: showNext,
                                            child: Center(
                                              child: Text(
                                                getTranslated(
                                                    context, "goNext"),
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontFamily: getTranslated(
                                                      context,
                                                      "Montserratsemibold"),
                                                  fontSize: AppFontsSizeManager
                                                      .s13_5.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                color: Color.fromRGBO(207, 0, 54, 0.1),
                                blurRadius: 16.r,
                                spreadRadius: 0.0,
                                offset: Offset(0.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (currentIndex == 6 ||
                          currentIndex == 2 ||
                          currentIndex == 3 ||
                          currentIndex == 4 ||
                          currentIndex == 5)
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            if (currentIndex == 6 ||
                                currentIndex == 2 ||
                                currentIndex == 3 ||
                                currentIndex == 4 ||
                                currentIndex == 5)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: currentIndex == 2
                                        ? 0.w
                                        : currentIndex == 1
                                            ? lang == "ar"
                                                ? 80.w
                                                : 0.w
                                            : currentIndex == 5
                                                ? lang == "ar"
                                                    ? 0.w
                                                    : 150.w
                                                : currentIndex == 6
                                                    ? lang == "ar"
                                                        ? 0.w
                                                        : 115.w
                                                    : 0,
                                    right: currentIndex == 4
                                        ? lang == "ar"
                                            ? 110.w
                                            : 0.w
                                        : currentIndex == 1
                                            ? lang == "ar"
                                                ? 0.w
                                                : 115.h
                                            : currentIndex == 5
                                                ? lang == "ar"
                                                    ? 108.w
                                                    : 0.w
                                                : currentIndex == 6
                                                    ? lang == "ar"
                                                        ? 115.w
                                                        : 0.w
                                                    : 0.w),
                                child: Lottie.asset(
                                    'assets/lotifile/tool_tip_animation.json',
                                    width: AppSize.w100.w,
                                    height: AppSize.h100.h),
                              ),
                            if (currentIndex == 6 ||
                                currentIndex == 2 ||
                                currentIndex == 3 ||
                                currentIndex == 4 ||
                                currentIndex == 5)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: currentIndex == 2
                                        ? 0.w
                                        : currentIndex == 1
                                            ? lang == "ar"
                                                ? 80.w
                                                : 0.w
                                            : currentIndex == 5
                                                ? lang == "ar"
                                                    ? 0.w
                                                    : 150.w
                                                : currentIndex == 6
                                                    ? lang == "ar"
                                                        ? 0.w
                                                        : 115.w
                                                    : 0.w,
                                    right: currentIndex == 4
                                        ? lang == "ar"
                                            ? 110.w
                                            : 0.w
                                        : currentIndex == 1
                                            ? lang == "ar"
                                                ? 0.w
                                                : 115.h
                                            : currentIndex == 5
                                                ? lang == "ar"
                                                    ? 108.w
                                                    : 0.w
                                                : currentIndex == 6
                                                    ? lang == "ar"
                                                        ? 115.w
                                                        : 0.w
                                                    : 0.w),
                                child: RotationTransition(
                                  turns: new AlwaysStoppedAnimation(180 / 360),
                                  child: ClipPath(
                                    clipper: TriangleClipper(),
                                    child: Container(
                                      width: 16.w,
                                      // Adjust the width as needed
                                      height: 8.h,
                                      // Adjust the height as needed
                                      color: AppColors.pink2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
          matching(false),
          coachesCall(),
          callHistory(),
          academy(),
          support()
        ],
      ),
    );
  }

  Widget matching(bool consult) {
    return Expanded(
      key: ToolTipKeysManager.callsNavTipKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          /*  if (FirebaseAuth.instance.currentUser ==
              null) {
            Navigator.pushNamed(
                context, '/Register_Type');
          } else*/
          {
            _pageController.jumpToPage(
              0,
            );
          }

          setState(() {
            _selectedPage = 0;
          });
        },
        child: Container(
          // width: size.width * .20,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _selectedPage == 0
                      ? 'assets/icons/icon/Group2804.png'
                      : 'assets/icons/icon/Group2808.png',
                  width: 32.6.w,
                  height: 32.h,
                ),
                Text(
                  consult
                      ? getTranslated(context, "appointments")
                      : getTranslated(context, "schedule"),
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    fontSize: AppFontsSizeManager.s13_3.sp,
                    color: _selectedPage == 0
                        ? AppColors.black
                        : AppColors.lightGrey6,
                    letterSpacing: 0.52,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget coaches() {
    return Expanded(
      key: ToolTipKeysManager.coachesNavTipKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _pageController.jumpToPage(
            5,
          );
          setState(() {
            _selectedPage = 5;
          });
        },
        child: Container(
          // width: 32.w,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _selectedPage == 5
                      ? 'assets/icons/icon/Group3420.png'
                      : 'assets/icons/icon/Group3421.png',
                  width: 40.w,
                  height: 40.h,
                ),
                Text(
                  getTranslated(context, "coaches"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    fontSize: AppFontsSizeManager.s13_3.sp,
                    color: _selectedPage == 5
                        ? AppColors.black
                        : AppColors.lightGrey6,
                    letterSpacing: 0.52,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget coachesCall() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print('appointments');
          if (FirebaseAuth.instance.currentUser == null) {
            Navigator.pushNamed(context, '/Register_Type');
          } else {
            _pageController.jumpToPage(
              6,
            );
          }

          setState(() {
            _selectedPage = 6;
          });
        },
        child: Container(
          // width: size.width * .20,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _selectedPage == 6
                      ? 'assets/icons/icon/Group2805.png'
                      : 'assets/icons/icon/Group2806.png',
                  width: 32.6.w,
                  height: 32.w,
                ),
                Text(
                  getTranslated(context, "appointments"),
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    fontSize: AppFontsSizeManager.s13_3.sp,
                    color: _selectedPage == 6
                        ? AppColors.black
                        : AppColors.lightGrey6,
                    letterSpacing: 0.52,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget callHistory() {
    return Expanded(
      key: ToolTipKeysManager.callHistoryNavTipKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (FirebaseAuth.instance.currentUser == null) {
            Navigator.pushNamed(context, '/Register_Type');
          } else {
            _pageController.jumpToPage(
              3,
            );
          }

          setState(() {
            _selectedPage = 3;
          });
        },
        child: Container(
          // width: size.width * .20,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _selectedPage == 3
                      ? 'assets/icons/icon/Group2805.png'
                      : 'assets/icons/icon/Group2806.png',
                  width: 32.6.w,
                  height: 32.w,
                ),
                Text(
                  getTranslated(context, "callHistory"),
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    fontSize: AppFontsSizeManager.s13_3.sp,
                    color: _selectedPage == 3
                        ? AppColors.black
                        : AppColors.lightGrey6,
                    letterSpacing: 0.52,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget academy() {
    return Expanded(
      key: ToolTipKeysManager.academyNavTipKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _pageController.jumpToPage(
            4,
          );
          setState(() {
            _selectedPage = 4;
          });
        },
        child: Container(
          // width: size.width * .20,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _selectedPage == 4
                      ? 'assets/icons/icon/Group37.png'
                      : 'assets/icons/icon/Group38.png',
                  width: 32.6.w,
                  height: 32.w,
                ),
                Text(
                  getTranslated(context, "academy"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    fontSize: AppFontsSizeManager.s13_3.sp,
                    color: _selectedPage == 4
                        ? AppColors.black
                        : AppColors.lightGrey6,
                    letterSpacing: 0.52,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget support() {
    return Expanded(
      key: ToolTipKeysManager.supportNAvTipKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print('support');
          if (FirebaseAuth.instance.currentUser == null) {
            Navigator.pushNamed(context, '/Register_Type');
          } else {
            _pageController.jumpToPage(
              2,
            );
          }
          setState(() {
            _selectedPage = 2;
          });
        },
        child: Container(
          // width: size.width * .20,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _selectedPage == 2
                      ? 'assets/icons/icon/Group2809.png'
                      : 'assets/icons/icon/Group2810.png',
                  width: 32.6.w,
                  height: 32.w,
                ),
                Text(
                  getTranslated(context, "support"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    fontSize: AppFontsSizeManager.s13_3.sp,
                    color: _selectedPage == 2
                        ? AppColors.black
                        : AppColors.lightGrey6,
                    letterSpacing: 0.52,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Column(
      children: [
        Container(
          width: size.width,
          padding: EdgeInsets.only(
              left: AppPadding.p32.w,
              right: AppPadding.p32.w,
              top: AppPadding.p44_6.h,
              bottom: AppPadding.p21_3.h
            ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              /* IconButton(
                onPressed: () {
                  if (_scaffoldKey.currentState!.isDrawerOpen) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    _scaffoldKey.currentState!.openDrawer();
                  }
                },
                icon: Image.asset(
                  'assets/icons/icon/Group 3633.png',
                  width: 45,
                  height: 45,
                ),
              ),*/
              IconButton1(
                BorderColor: Color.fromRGBO(32, 32, 32, 0.09),
                borderWidth: AppSize.h1_3.h,
                key: ToolTipKeysManager.notificationTipKey,
                onPress: () {
                  if (_scaffoldKey.currentState!.isDrawerOpen) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    _scaffoldKey.currentState!.openDrawer();
                  }
                },
                Width: AppSize.w60.w,
                Height: AppSize.h60.h,
                ButtonBackground: AppColors.white,
                ButtonRadius: AppRadius.r10_6.r,
                Icon: AssetsManager.drawerIconPath.toString(),
                IconWidth: AppSize.w20.r,
                IconHeight: AppSize.h25.r,
                IconColor: Color.fromRGBO(48, 48, 48, 1),
              ),
              InkWell(
                splashColor: Colors.white.withOpacity(0.6),
                onTap: () {
                  if (user == null)
                    Navigator.pushNamed(context, '/Register_Type');
                  else if (user != null && user!.isDeveloper!)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllDevelopTechScreen(loggedUser: user!),
                      ),
                    );
                  else if (user!.userType == "USER")
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserAccountScreen(
                            user: user!, firstLogged: false),
                      ),
                    );
                  else if (user!.userType == "CONSULTANT")
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountScreen(user: user!, firstLogged: false),
                      ),
                    );
                  else if (user!.userType == "COACH")
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CoachScreen(user: user!, firstLogged: false),
                      ),
                    );
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClientScreen(user: user!, firstLogged: false),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 41.2.w,
                  height: 39.6.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/icons/icon/Mask Group 47.png',
                    width: 54.6.w,
                    height: 52.h,
                  ),
                ),
              ),
              currentUser == null
                  ? noNotificationWidget()
                  : BlocBuilder(
                      bloc: notificationBloc,
                      buildWhen: (previous, current) {
                        if (current is GetAllNotificationsInProgressState ||
                            current is GetAllNotificationsFailedState ||
                            current is GetAllNotificationsCompletedState ||
                            current is GetNotificationsUpdateState) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        if (state is GetAllNotificationsInProgressState) {
                          return noNotificationWidget();
                        }
                        if (state is GetAllNotificationsFailedState) {
                          return IconButton1(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                            },
                            Width: AppSize.w58.w,
                            Height: AppSize.h58.h,
                            ButtonBackground: AppColors.white,
                            ButtonRadius: AppRadius.r10_6.r,
                            Icon:
                                AssetsManager.notificationIconPath.toString(),
                            IconWidth: AppSize.w26_6.r,
                            IconHeight: AppSize.h26_6.r,
                            IconColor: Color.fromRGBO(48, 48, 48, 1),
                          );
                        }
                        if (state is GetNotificationsUpdateState) {
                          if (state.userNotification != null) {
                            if (state
                                    .userNotification.notifications!.length ==
                                0) {
                              return noNotificationWidget();
                            }
                            userNotification = state.userNotification;
                            return Stack(children: [
                              IconButton1(
                                onPress: () {
                                  if (userNotification.unread!) {
                                    notificationBloc.add(
                                      NotificationMarkReadEvent(FirebaseAuth
                                          .instance.currentUser!.uid),
                                    );
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationScreen(
                                        userNotification: userNotification,
                                      ),
                                    ),
                                  );
                                },
                                Width: AppSize.w58_6.r,
                                Height: AppSize.h58_6.r,
                                BorderColor: Color.fromRGBO(32, 32, 32, 0.09),
                                borderWidth: AppSize.w1_5.h,
                                ButtonBackground: AppColors.white,
                                ButtonRadius: 10.6.r,
                                Icon: AssetsManager.notificationIconPath
                                    .toString(),
                                IconWidth: AppSize.w26_6.r,
                                IconHeight: AppSize.h26_6.r,
                                IconColor: Color.fromRGBO(48, 48, 48, 1),
                              ),

                              //c
                              userNotification.unread
                                  ? Positioned(
                                      child: Container(
                                        width: 7.8.w,
                                        height: 7.8.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                      right: 17.2.w,
                                      bottom: 18.5.h,
                                      top: 0,
                                    )
                                  : SizedBox(),
                            ]);
                            //(p)
                            /*return IconButton(
                        onPressed: () {
                          if (userNotification.unread!) {
                            notificationBloc.add(
                              NotificationMarkReadEvent(
                                  FirebaseAuth.instance.currentUser!.uid),
                            );
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NotificationScreen(
                                    userNotification: userNotification,
                                  ),
                            ),
                          );
                        },
                        icon: Image.asset(
                          'assets/icons/icon/Group 3634.png',
                          width: 44,
                          height: 44,
                        ),
                      );*/
                          }
                          return noNotificationWidget();
                        }
                        return noNotificationWidget();
                      },
                    ),
            ],
          ),
        ),
        Container(color: AppColors.white3, height: 1.h, width: size.width),
      ],
    );
  }

  Widget calls() {
    return Expanded(
      key: ToolTipKeysManager.callsTipKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print('appointments');
          if (FirebaseAuth.instance.currentUser == null) {
            Navigator.pushNamed(context, '/Register_Type');
          } else {
            _pageController.jumpToPage(
              1,
            );
          }

          setState(() {
            _selectedPage = 1;
          });
        },
        child: Container(
          // width: size.width * .20,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _selectedPage == 1
                      ? 'assets/icons/icon/Group2805.png'
                      : 'assets/icons/icon/Group2806.png',
                  width: 40.w,
                  height: 40.h,
                ),
                Text(
                  getTranslated(context, "appointments"),
                  style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    color: _selectedPage == 1
                        ? AppColors.black
                        : AppColors.lightGrey6,
                    fontSize: 8.0,
                    letterSpacing: 0.52,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerAcademyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size.width,
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 35, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (_scaffoldKey.currentState!.isDrawerOpen) {
                      _scaffoldKey.currentState!.openEndDrawer();
                    } else {
                      _scaffoldKey.currentState!.openDrawer();
                    }
                  },
                  icon: Image.asset(
                    'assets/icons/icon/Group 3422.png',
                    width: 40.w,
                    height: 40.w,
                  ),
                ),
                InkWell(
                  splashColor: Colors.white.withOpacity(0.6),
                  onTap: () {
                    if (user == null)
                      Navigator.pushNamed(context, '/Register_Type');
                    else if (user != null && user!.isDeveloper!)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AllDevelopTechScreen(loggedUser: user!),
                        ),
                      );
                    else if (user!.userType == "USER")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAccountScreen(
                              user: user!, firstLogged: false),
                        ),
                      );
                    else if (user!.userType == "CONSULTANT")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AccountScreen(user: user!, firstLogged: false),
                        ),
                      );
                    else if (user!.userType == "COACH")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CoachScreen(user: user!, firstLogged: false),
                        ),
                      );
                    else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ClientScreen(user: user!, firstLogged: false),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 40.2,
                    height: 38.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/mm/Mask Group 35.png',
                      width: 40.2,
                      height: 38.6,
                    ),
                  ),
                ),
                currentUser == null
                    ? noNotificationWidget()
                    : BlocBuilder(
                        bloc: notificationBloc,
                        buildWhen: (previous, current) {
                          if (current is GetAllNotificationsInProgressState ||
                              current is GetAllNotificationsFailedState ||
                              current is GetAllNotificationsCompletedState ||
                              current is GetNotificationsUpdateState) {
                            return true;
                          }
                          return false;
                        },
                        builder: (context, state) {
                          if (state is GetAllNotificationsInProgressState) {
                            return noNotificationWidget();
                          }
                          if (state is GetNotificationsUpdateState) {
                            if (state.userNotification != null) {
                              if (state
                                      .userNotification.notifications!.length ==
                                  0) {
                                return noNotificationWidget();
                              }
                              userNotification = state.userNotification;
                              return InkWell(
                                onTap: () {
                                  if (userNotification.unread!) {
                                    notificationBloc.add(
                                      NotificationMarkReadEvent(FirebaseAuth
                                          .instance.currentUser!.uid),
                                    );
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotificationScreen(
                                        userNotification: userNotification,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/icons/icon/not1.png',
                                  width: 35.0,
                                  height: 35.0,
                                ),
                              );
                            }
                            return noNotificationWidget();
                          }
                          return noNotificationWidget();
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: AppColors.grey,
          blurRadius: 2.0,
          spreadRadius: 0.0,
          offset: Offset(0.0, 1.0),
        )
      ],
    );
  }

  Widget noNotificationWidget() {
    return IconButton1(
      onPress: () {
        Fluttertoast.showToast(
            msg: getTranslated(context, "noNotification"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      Width: AppSize.w58_6.r,
      Height: AppSize.h58_6.r,
      BorderColor: Color.fromRGBO(32, 32, 32, 0.09),
      borderWidth: AppSize.w1_5.h,
      ButtonBackground: AppColors.white,
      ButtonRadius: 10.6.r,
      Icon: AssetsManager.notificationIconPath.toString(),
      IconWidth: AppSize.w26_6.r,
      IconHeight: AppSize.h26_6.r,
      IconColor: Color.fromRGBO(48, 48, 48, 1),
    );
  }

  Widget rateReactionsDialog(size) {
    return BlocProvider(
        create: (context) => RateCubit(RateInitialState()),
        child: BlocConsumer<RateCubit, RateStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return NikahDialogWidget(
                padButtom: AppPadding.p32.h,
                padLeft: 0.w,
                padReight: 0.w,
                padTop: AppPadding.p10_6.h,
                radius: AppRadius.r21_3.r,
                dialogContent: Container(
                  width: AppSize.w433_3.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                        child: Align(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              //color:AppColors.lightGrey2,
                              AssetsManager.closeIcon,

                              height: AppSize.h24.r,
                              width: AppSize.w24.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: lang == "ar"
                              ? AlignmentDirectional.topEnd
                              : AlignmentDirectional.topEnd,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h15_3.h,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppPadding.p68.w),
                        child: Text(
                          getTranslated(context, 'rate_qs3'),
                          style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratsemibold"),
                            color: AppColors.black,
                            fontSize: AppFontsSizeManager.s24.sp,
                            //fontWeight: AppFontsWeightManager.bold,
                          ),
                          //minFontSize: 13,
                          // The smallest possible font size to display.
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h34_8.h,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: AppSize.h67_8.r,
                        width: size.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.p26_6.w),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              RateCubit.get(context).changeSelected(
                                  RateCubit.get(context).reactions[index]);
                              print(
                                  RateCubit.get(context).selected!.keys.first);
                            },
                            child: Container(
                              height: AppSize.h67_8.r,
                              width: AppSize.w67_8.r,
                              child: CircleAvatar(
                                radius: AppRadius.r50.r,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(
                                  RateCubit.get(context)
                                      .reactions[index]
                                      .keys
                                      .first,
                                  height: AppSize.h46_6.r,
                                  width: AppSize.w46_6.r,
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    end: Alignment.topCenter,
                                    begin: Alignment.bottomCenter,
                                    colors: (RateCubit.get(context).selected ==
                                            RateCubit.get(context)
                                                .reactions[index])
                                        ? [
                                            AppColors.darkOrange,
                                            AppColors.pink2,
                                          ]
                                        : [
                                            AppColors.lightGrey10,
                                            AppColors.lightGrey10
                                          ]),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            width: AppSize.w10_5.w,
                          ),
                          itemCount: RateCubit.get(context).reactions.length,
                        ),
                      ),
                      SizedBox(
                        height: AppSize.h48.h,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                        child: InkWell(
                          onTap: () async {
                            if (RateCubit.get(context).selected != null) {
                              Navigator.pop(context);
                              CashHelper.saveData(key: 'rate', value: 'true');
                              print(RateCubit.get(context)
                                  .selected!
                                  .values
                                  .single);
                              user.rate = RateCubit.get(context)
                                  .selected!
                                  .values
                                  .single;
                              accountBloc
                                  .add(UpdateAccountDetailsEvent(user: user));
                              if (await inAppReview.isAvailable()) {
                                inAppReview.requestReview();
                              }
                            } else {
                              showSnakbar(
                                  getTranslated(context, 'snakbar_msg'), true);
                            }
                          },
                          child: Container(
                            height: AppSize.h56.h,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: AppColors.pink2,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r16.r)),
                            child: Center(
                              child: Text(
                                getTranslated(context, 'senD'),
                                style: TextStyle(
                                  fontSize: AppFontsSizeManager.s18_6.sp,
                                  color: AppColors.white1,
                                  fontFamily: getTranslated(
                                      context, "Montserratsemibold"),
                                  //fontWeight: AppFontsWeightManager.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  color: AppColors.white,
                ),
              );
            }));
  }

  void showSnakbar(String s, bool status) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: AppColors.white,
        fontSize: 16.0.sp);
  }

  showStartSurveyDialog({
    required String lang,
    required dynamic rating,
  }) {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p32.h,
        padLeft: AppPadding.p32.w,
        padReight: AppPadding.p32.w,
        padTop: AppPadding.p10_6.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          width: AppSize.w369_3.w,
          color: AppColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AssetsManager.closeIcon,
                      color: AppColors.lightGrey2,
                      width: AppSize.w24.w,
                      height: AppSize.h25_3.h,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSize.h26_6.h,
              ),
              Text(
                getTranslated(context, "doYouLikeOurApp"),
                style: TextStyle(
                    color: AppColors.black,
                    fontFamily: getTranslated(context, "Montserratsemibold"),
                    fontSize: AppFontsSizeManager.s24.sp),
              ),
              SizedBox(
                height: AppSize.h17_3.h,
              ),
              Text(
                getTranslated(context, "rateAppText"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: getTranslated(context, "Montserratmedium"),
                  fontSize: AppFontsSizeManager.s18_6.sp,
                  fontWeight:
                      lang == "ar" ? AppFontsWeightManager.semiBold : null,
                ),
              ),
              SizedBox(
                height: AppSize.h21_3.h,
              ),
              StatefulBuilder(
                builder: (context, setState) => Container(
                  height: AppSize.h42_6.h,
                  child: Align(
                      alignment: Alignment.center,
                      child: SmoothStarRating2(
                        wrapAlignment: lang == "ar"
                            ? WrapAlignment.start
                            : WrapAlignment.end,

                        color: AppColors.yellow,
                        allowHalfRating: false,
                        onRatingChanged: (v) {
                          setState(() {
                            rating = v;
                          });
                          print("******************************$v");
                        },
                        starCount: 5,
                        rating: rating,
                        size: AppSize.h42_6.r,
                        // height: AppSize.h42_6.r,
                        //
                        filledIconData: SvgPicture.asset(
                          AssetsManager.starRateYellow,
                          height: AppSize.h42_6.r,
                          width: AppSize.w42_6.r,
                        ),
                        defaultIconData: SvgPicture.asset(
                          AssetsManager.starRateGrey,
                          height: AppSize.h42_6.r,
                          width: AppSize.w42_6.r,
                        ),

                        spacing: AppSize.w13_3.w,
                      )),
                ),
              ),
              SizedBox(
                height: AppSize.h20.h,
              ),
              Center(
                child: Container(
                  width: AppSize.w400.w,
                  height: AppSize.h52.h,
                  decoration: BoxDecoration(
                    color: AppColors.lightPink3,
                    borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      rateSentDialog();
                    },
                    child: Center(
                      child: Text(
                        getTranslated(context, "sendRate"),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily:
                              getTranslated(context, "Montserratsemibold"),
                          color: AppColors.pink2,
                          fontSize: AppFontsSizeManager.s21_3.sp,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  ///------------------------------ Rate Sent App Dialog --------------------------///

  rateSentDialog() {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p32.h,
        padLeft: AppPadding.p32.w,
        padReight: AppPadding.p32.w,
        padTop: AppPadding.p10_6.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          width: AppSize.w369_3.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AssetsManager.closeIcon,
                      color: AppColors.lightGrey2,
                      width: AppSize.w24.r,
                      height: AppSize.h24.r,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSize.h8.h,
              ),
              SvgPicture.asset(
                AssetsManager.rateImagePath,
                width: AppSize.w153_7.w,
                height: AppSize.h93_8.h,
              ),
              SizedBox(
                height: AppSize.h21_3.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p26_6.w),
                child: Text(
                  getTranslated(context, "rateSentText"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.black,
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      fontSize: AppFontsSizeManager.s24.sp),
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Center(
                child: Container(
                  width: AppSize.w400.w,
                  height: AppSize.h52.h,
                  decoration: BoxDecoration(
                    color: AppColors.reddark2,
                    borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
                  ),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      getTranslated(context, "continue"),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily:
                            getTranslated(context, "Montserratsemibold"),
                        color: Colors.white,
                        fontSize: AppFontsSizeManager.s21_3.sp,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  Widget userHomeBody() {
    return Column(
      children: <Widget>[
        headerWidget(),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomePage(
                userType: userType,
              ), //0
              //   boy
              AppointmentsPage(), //1
              //  boy, girl , support
              TechnicalSupportPage(), //2
              // girl
              CallHistoryPage(), //3
              // boy, girl , support
              AcademyPage(), //4
              CoachesPage(), //5
              CoachesCallPage(), //6
            ],
          ),
        ),
      ],
    );
  }
}

typedef void RatingChangeCallback(double rating);

class SmoothStarRating2 extends StatefulWidget {
  final dynamic starCount;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final Color? borderColor;
  final double size;
  final bool allowHalfRating;
  final Widget? filledIconData;
  final WrapAlignment wrapAlignment;
  final IconData? halfFilledIconData;
  final Widget?
      defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;
  SmoothStarRating2({
    required this.wrapAlignment,
    this.starCount = 5,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData,
    this.onRatingChanged,
    this.color,
    this.borderColor,
    this.size = 25,
    this.filledIconData,
    this.halfFilledIconData,
    this.allowHalfRating = true,
  });

  @override
  State<SmoothStarRating2> createState() => _SmoothStarRating2State();
}

class _SmoothStarRating2State extends State<SmoothStarRating2> {
  Widget buildStar(BuildContext context, dynamic index) {
    Widget icon;
    if (index >= widget.rating) {
      icon = widget.defaultIconData ??
          Icon(
            Icons.star_border,
            color: widget.borderColor ?? Theme.of(context).primaryColor,
            size: widget.size,
          );
    } else if (index > widget.rating - (widget.allowHalfRating ? 0.5 : 1.0) &&
        index < widget.rating) {
      icon = new Icon(
        widget.halfFilledIconData != null
            ? widget.halfFilledIconData
            : Icons.star_half,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size,
      );
    } else {
      icon = widget.filledIconData ??
          Icon(
            Icons.star,
            color: widget.color ?? Theme.of(context).primaryColor,
            size: widget.size,
          );
    }

    return new GestureDetector(
      onTap: () {
        if (this.widget.onRatingChanged != null)
          setState(() {
            widget.onRatingChanged!(index + 1.0);
          });
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject() as RenderBox;
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / widget.size;
        var newRating = widget.allowHalfRating ? i : i.round().toDouble();
        if (newRating > widget.starCount) {
          setState(() {
            newRating = widget.starCount.toDouble();
          });
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        if (this.widget.onRatingChanged != null)
          setState(() {
            widget.onRatingChanged!(newRating);
          });
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: Wrap(
          alignment: widget.wrapAlignment,
          spacing: widget.spacing,
          children: List.generate(
              widget.starCount, (index) => buildStar(context, index))),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class RateCubit extends Cubit<RateStates> {
  RateCubit(super.RateInitialState);

  static RateCubit get(context) => BlocProvider.of(context);

  List<Map<String, dynamic>> reactions = [
    {AssetsManager.angry: 5},
    {AssetsManager.sad: 4},
    {AssetsManager.regular: 3},
    {AssetsManager.smile: 2},
    {AssetsManager.happy: 1}
  ];

  Map<String, dynamic>? selected;

  void changeSelected(Map<String, dynamic> _selected) {
    selected = _selected;
    emit(ChangedReactionState());
  }
}

abstract class RateStates {}

class RateInitialState extends RateStates {}

class ChangedReactionState extends RateStates {}
