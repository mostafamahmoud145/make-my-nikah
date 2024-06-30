import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/models/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/CoacheAppoinmentFeature/presention/coache_profile_view.dart';
import 'package:grocery_store/screens/PayCoursesFeature/presention/course_videos_view.dart';
import 'package:grocery_store/screens/clientScreen.dart';
import 'package:grocery_store/screens/coachScreen.dart';
import 'package:grocery_store/screens/userAccountScreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import '../blocs/account_bloc/account_bloc.dart';
import '../models/courses.dart';
import 'GirlAppointmentFeature/presention/girl_details_view.dart';
import 'consultRules.dart';


class SplashScreen extends StatefulWidget {
  PendingDynamicLinkData? initialLink;

  SplashScreen(this.initialLink);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userType;
  late AccountBloc accountBloc;
  dynamic androidBuildNum, iosBuildNum;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    Timer(Duration(milliseconds: 4000), () {
      checkUserAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromRGBO(255, 47 ,101,1),
                  const Color.fromRGBO(210 ,3, 57,1),
                  const Color.fromRGBO(207 ,0 ,54,1),
                ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/icon/splash1.png',
                width: size.width * 0.25,
                height: size.height * 0.12,
              ),
              SizedBox(height: size.height * 0.01),
              Image.asset(
                'assets/icons/icon/splash2.png',
                width: size.width * 0.56,
                height: size.height * 0.09,
              ),
            ],
          ),
        ),
      ),
    );
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
          } else if (FirebaseAuth.instance.currentUser != null) {
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
