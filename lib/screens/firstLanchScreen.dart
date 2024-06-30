import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/app/onboarding/view/pages/onboarding_page.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:flutter/material.dart';
import 'introductionScreen.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool onBoarding = false;
  @override
  void initState() {
    super.initState();
    checkOnBoardingPermission()..whenComplete(() => navigate());
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => navigate(),
    // );
  }

  Future<void> checkOnBoardingPermission() async {
    DocumentReference docRef2 = await FirebaseFirestore.instance
        .collection("Setting")
        .doc("pzBqiphy5o2kkzJgWUT7");
    final DocumentSnapshot documentSnapshot = await docRef2.get();
    var data = documentSnapshot.data() as Map<String, dynamic>;
    onBoarding = data['onBoarding'] ?? false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
              const Color.fromRGBO(255, 47, 101, 1),
              const Color.fromRGBO(210, 3, 57, 1),
              const Color.fromRGBO(207, 0, 54, 1),
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

  Future<void> navigate() async {
    Timer(Duration(seconds: 1), () {
      if (onBoarding) {
        print('ooooooooooooooooooooooooooooo $onBoarding');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnBoardingPage(OnBoardingPageArgs()),
          ),
        );
      } else {
        print('!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        Navigator.popAndPushNamed(
          context,
          '/home',
          arguments: {
            'userType': "CLIENT",
          },
        );
      }
    });
  }
}
