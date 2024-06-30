import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/screens/splash_screens/second_splash.dart';
import 'dart:async';

import 'package:grocery_store/widget/resopnsive.dart';

import '../../config/colorsFile.dart';

class FirstSplashScreen extends StatefulWidget {
  PendingDynamicLinkData? initialLink;
   String? payload;
  FirstSplashScreen(this.initialLink, this.payload);
  @override
  _FirstSplashScreenState createState() => _FirstSplashScreenState();
}

class _FirstSplashScreenState extends State<FirstSplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    ))
      ..addListener(() {
        setState(() {});
      });

    _controller?.forward();

    Timer(Duration(milliseconds:2000 ), () {
      _navigateToNextScreen(context);
    });
  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SecondSplashScreen(widget.initialLink,widget.payload),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Transform.translate(
          offset: Offset(0.0, _animation!.value * screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                AssetsManager.appLogoPath,
                width: AppSize.w145.w,
                height: AppSize.h145.h,
                color: AppColors.pink2,
              ), // Your logo here
              // You can add more widgets here
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

