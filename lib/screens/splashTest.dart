import 'package:flutter/material.dart';
import 'package:grocery_store/config/colorsFile.dart';

class SplashTest extends StatelessWidget {
  const SplashTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(0.5, 0),
                end: Alignment(0.5, 1),
                colors: [
              const Color(0xffff2f65),
              const Color(0xffd20339),
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
}
