import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/screens/userAccountScreen.dart';
import 'package:grocery_store/services/firebase_service.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../blocs/account_bloc/account_bloc.dart';
import '../../config/colorsFile.dart';
import '../../config/paths.dart';
import '../../models/courses.dart';
import '../../models/setting.dart';
import '../../models/user.dart';

import '../CoacheAppoinmentFeature/presention/coache_profile_view.dart';
import '../GirlAppointmentFeature/presention/girl_details_view.dart';
import '../PayCoursesFeature/presention/course_videos_view.dart';
import '../clientScreen.dart';
import '../coachScreen.dart';
import '../consultRules.dart';

class SecondSplashScreen extends StatefulWidget {
  PendingDynamicLinkData? initialLink;
  String? payload;
  SecondSplashScreen(this.initialLink,this.payload);

  @override
  _SecondSplashScreenState createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<double> _logoMoveUpAnimation;
  late Animation<double> _appNameOpacityAnimation;
  String? userType;
  late AccountBloc accountBloc;
  dynamic androidBuildNum, iosBuildNum;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoSizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 2.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.5, curve: Curves.easeInOut)),
    );

    _logoMoveUpAnimation = Tween<double>(
      begin: 0.0,
      end: -20.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.5, 0.65, curve: Curves.easeInOut)),
    );

    _appNameOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.55, 0.75, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    accountBloc = BlocProvider.of<AccountBloc>(context);
    Timer(Duration(milliseconds: 1), () {
      checkUserAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _controller.value <= 0.2 ? [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ] : [
                      Color.fromRGBO(255, 47, 101, 1),
                      Color.fromRGBO(210, 3, 57, 1),
                      Color.fromRGBO(207, 0, 54, 1),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: AppSize.w508.w,
                  height: AppSize.h306_6.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(0, _logoMoveUpAnimation.value),
                        child: ScaleTransition(
                          scale: _logoSizeAnimation,
                          child: Image.asset(AssetsManager.appLogoPath,
                            color: AppColors.white,
                            width: AppSize.w145.w,
                            height: AppSize.h145.h,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 210.0.r, // Dynamically adjusted position
                        child: FadeTransition(
                          opacity: _appNameOpacityAnimation,
                          child: Image.asset(AssetsManager.appNamePath,
                            width: AppSize.w321_8.w,
                            height: AppSize.h104.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future<void> checkUserAccount() async {
    Timer(Duration(milliseconds: 5000), () {
      GroceryUser? loggedUser;
      FirebaseFirestore.instance
          .collection(Paths.settingPath)
          .doc("pzBqiphy5o2kkzJgWUT7")
          .get()
          .then((value) async {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        setState(() {
          androidBuildNum =
              Setting.fromMap(value.data() as Map).androidBuildNumber;
          iosBuildNum = Setting.fromMap(value.data() as Map).iosBuildNumber;
        });

        if ((Platform.isAndroid &&
            int.parse(packageInfo.buildNumber) >= androidBuildNum) ||
            (Platform.isIOS &&
                int.parse(packageInfo.buildNumber) >= iosBuildNum)) {
          if (widget.initialLink != null) {
            if (widget.initialLink!.link.toString().contains("consultant_id")) {
              if (FirebaseAuth.instance.currentUser != null) {
                var __user = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get();
                loggedUser = GroceryUser.fromMap(__user.data() as Map);
              }
              final Uri link = widget.initialLink!.link;
              print(link.toString());
              String result = link.toString().replaceAll(
                  'https://makemynikahapp.page.link/consultant_id=', ' ');
              String consultantId = result.trim();

              await FirebaseFirestore.instance
                  .collection(Paths.usersPath)
                  .doc(consultantId)
                  .get()
                  .then((value) async {
                GroceryUser currentUser =
                GroceryUser.fromMap(value.data() as Map);
                Navigator.pushNamed(context, '/home');
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
            } else if (widget.initialLink!.link.toString().contains("coach_id")) {
              if (FirebaseAuth.instance.currentUser != null) {
                var __user = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get();
                loggedUser = GroceryUser.fromMap(__user.data() as Map);
              }
              final Uri link = widget.initialLink!.link;
              print(link.toString());
              String result = link
                  .toString()
                  .replaceAll('https://makemynikahapp.page.link/coach_id=', ' ');
              String consultantId = result.trim();

              await FirebaseFirestore.instance
                  .collection(Paths.usersPath)
                  .doc(consultantId)
                  .get()
                  .then((value) async {
                GroceryUser currentUser =
                GroceryUser.fromMap(value.data() as Map);
                Navigator.pushNamed(context, '/home');
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
              final Uri link = widget.initialLink!.link;
              print(link.toString());
              String result = link
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
                Navigator.pushNamed(context, '/home');
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
            }
          } else if (widget.payload != null) {
            Map<String, dynamic> data = json.decode(widget.payload!);
             Navigator.pushNamed(
                context,
                '/home',
                arguments: {
                  'userType': "CLIENT",
                },
              );
            FirebaseService.navigation(
                context,
                data['title'],
                data['body'],
                data['titleKey'],
                data['bodyKey'],
                data['specific_consult_id'],
                data['specific_screen'],
                data['link'],
                data['notificationId'],
                data['notificationType'],
                data['type'],
                "notification");
          }else if (FirebaseAuth.instance.currentUser != null) {
            DocumentReference docRef = FirebaseFirestore.instance
                .collection(Paths.usersPath)
                .doc(FirebaseAuth.instance.currentUser!.uid);
            final DocumentSnapshot documentSnapshot = await docRef.get();
            if (documentSnapshot.exists) {
              GroceryUser currentUser =
              GroceryUser.fromMap(documentSnapshot.data() as Map);
              if (currentUser.isBlocked == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(
                  context,
                  '/home',
                  arguments: {
                    'userType': userType,
                  },
                );
              } else if (currentUser.userType == "COACH" &&
                  currentUser.profileCompleted == false)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoachScreen(
                      user: currentUser,
                      firstLogged: true,
                    ),
                  ),
                );
              else if (currentUser.userType == "CONSULTANT" &&
                  currentUser.profileCompleted == false)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => consultRuleScreen(user: currentUser),
                  ),
                );
              else if (currentUser.userType == "USER" &&
                  currentUser.profileCompleted == false)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserAccountScreen(user: currentUser, firstLogged: true),
                  ),
                );
              else if (currentUser.userType == "CLIENT" &&
                  currentUser.profileCompleted == false)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ClientScreen(user: currentUser,
                            firstLogged: true),
                  ),
                );
              else
                Navigator.popAndPushNamed(
                  context,
                  '/home',
                  arguments: {
                    'userType': userType,
                  },
                );
            } else {
              FirebaseAuth.instance.signOut();
              accountBloc.add(GetLoggedUserEvent());
              Navigator.popAndPushNamed(
                context,
                '/home',
                arguments: {
                  'userType': "CLIENT",
                },
              );
            }
          } else {
            print("spppppp05555");
            Navigator.popAndPushNamed(
              context,
              '/home',
              arguments: {
                'userType': "CLIENT",
              },
            );
          }
        } else
          Navigator.popAndPushNamed(context, '/ForceUpdateScreen');
      }).catchError((err) {});
    });

  }

}
