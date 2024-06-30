import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../config/colorsFile.dart';
import '../widget/playVideoWidget.dart';
import 'YoutubePlayerDemoScreen.dart';

class IntroductionScreening extends StatefulWidget {
  const IntroductionScreening({Key? key}) : super(key: key);

  @override
  State<IntroductionScreening> createState() => _IntroductionScreeningState();
}

class _IntroductionScreeningState extends State<IntroductionScreening> {
  
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    var listPagesViewModel = [
      PageViewModel(
        title: getTranslated(context, "title1"),
        body: getTranslated(context, "body1"),
        image: Image.asset("assets/icons/icon/No Favorite illustration.png",width: size.width * 0.49,height: size.height * 0.24,),
        decoration: const PageDecoration(
          pageColor: Colors.white,
          titleTextStyle: TextStyle(color: Color(0xff202020),fontFamily: "montserrat",
            fontSize: 19,fontWeight: FontWeight.w600,
          ),
          bodyTextStyle: TextStyle(color: Color(0xff9e9e9e),fontFamily: "montserrat",
            fontSize: 17,fontWeight: FontWeight.w300,
          ),
        ),
      ),
      /*  PageViewModel(
        title: "Title of custom body page",
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayVideoWidget( url: "https://firebasestorage.googleapis.com/v0/b/beaut-e383d.appspot.com/o/videos%2FMMN%20intro-3.mov?alt=media&token=33cb873e-b696-474b-bd4a-2230e7c12432"),

            Text(" to edit a post"),
          ],
        ),
       image: PlayVideoWidget( url: "https://firebasestorage.googleapis.com/v0/b/beaut-e383d.appspot.com/o/videos%2FMMN%20intro-3.mov?alt=media&token=33cb873e-b696-474b-bd4a-2230e7c12432"),

      ),*/
      PageViewModel(
    title: getTranslated(context, "title2"),
    body: getTranslated(context, "body2"),
    image: Image.asset("assets/icons/icon/No Connection illustartion.png",width: size.width * 0.49,height: size.height * 0.24,),
    decoration: const PageDecoration(
      titleTextStyle: TextStyle(color: Color(0xff202020),fontFamily: "montserrat",
        fontSize: 19,fontWeight: FontWeight.w600,
      ),
      bodyTextStyle: TextStyle(color: Color(0xff9e9e9e),fontFamily: "montserrat",
        fontSize: 17,fontWeight: FontWeight.w300,
      ),
    ),
    ),
      PageViewModel(
        title: getTranslated(context, "title3"),
        body: getTranslated(context, "body3"),
        image: Image.asset("assets/icons/icon/Not Found illustration.png",width: size.width * 0.49,height: size.height * 0.24,),
        decoration: const PageDecoration(
          titlePadding: EdgeInsets.only(top: 16.0, bottom: 24.0,left: 25,right: 25),
          bodyPadding: EdgeInsets.only(left: 25,right: 25),
          titleTextStyle: TextStyle(color: Color(0xff202020),fontFamily: "montserrat",
            fontSize: 19,fontWeight: FontWeight.w600,
          ),
          bodyTextStyle: TextStyle(color: Color(0xff9e9e9e),fontFamily: "montserrat",
            fontSize: 17,fontWeight: FontWeight.w300,
          ),
        ),
      ),

    ];

    return  IntroductionScreen(globalBackgroundColor: Colors.white,
      pages: listPagesViewModel,
      onDone: () {
        //Navigator.popAndPushNamed(context, '/home');
        //-----
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Navigator.popAndPushNamed(
          context,
          '/home',
          arguments: {
            'userType': "CLIENT",
          },
        );
      },
      onSkip: () {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Navigator.popAndPushNamed(
          context,
          '/home',
          arguments: {
            'userType': "CLIENT",
          },
        );
      },
     // showBackButton: true,
      showNextButton: true,
      showSkipButton: true,
     // dotsFlex:3,
     // skipOrBackFlex:2,
      rtl:false,
      controlsPosition:Position(left: 0, right: 0, bottom: 20),
      done: Text("Start",style: TextStyle(
          color: AppColors.reddark2,
          fontSize: 19,
          fontFamily: getTranslated(context, "fontFamily")
      ),),
      skip: Text("Skip",style: TextStyle(
        color: AppColors.reddark2,
        fontSize: 19,
        fontFamily: getTranslated(context, "fontFamily")
      ),),
     next: const Icon(Icons.navigate_next,size: 35,color: AppColors.reddark2,),
      dotsDecorator: DotsDecorator(
        //  size: const Size.square(10.0),
          activeSize: const Size(10.0, 10.0),
          activeColor: AppColors.reddark2,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          )
      ),
    );
  }
}
