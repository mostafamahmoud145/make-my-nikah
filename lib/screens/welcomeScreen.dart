
import 'package:flutter/services.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../config/colorsFile.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>with SingleTickerProviderStateMixin {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode( SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  MediaQuery.removePadding( context: context,removeTop: true,
        child: Stack (children: <Widget>[
            Column(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container( width: size.width,
                height: size.height*0.20,
                child: Image.asset('assets/icons/icon/wel.png',
                    width: size.width,
                    height: size.height*0.20,
                    fit:BoxFit.cover
                ),
              ),
               Container(width: size.width,
                 height: size.height*0.45,
                 child: Center(child: Image.asset('assets/plan/Group2879.png',
                   width: size.width*0.55,
                   height: size.height*0.15,
                 ),),
               ),
               Container(width: size.width,
                height: size.height*0.35,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Center(
                        child: Text("A smart way to recognize those wishing to marry",
                          textAlign: TextAlign.center,
                          maxLines: 3,softWrap: true,
                          overflow:TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: "Restie", color: AppColors.black,
                              fontSize: 25.0,fontWeight: FontWeight.w500 ),
                      ),),
                    ),
                    Container(
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.greendark2,
                              AppColors.red1
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,

                          )
                      ),
                      height: 50,
                      child: MaterialButton(
                        onPressed: () async {
                          Navigator.popAndPushNamed(context, '/lang');
                        },
                        // color: AppColors.red1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(fontFamily: "montserrat",
                            color: AppColors.black,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),

            ],
          ),

        ]),
      ),
    );
  }
}
