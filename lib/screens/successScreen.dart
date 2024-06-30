
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/screens/coachScreen.dart';
import 'package:grocery_store/screens/google_apple_signup/services/enum/authentication_type.dart';
import 'package:grocery_store/screens/userAccountScreen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../blocs/account_bloc/account_bloc.dart';
import '../config/app_fonts.dart';
import '../config/colorsFile.dart';
import '../config/paths.dart';
import '../models/user.dart';
import 'clientScreen.dart';
import 'consultRules.dart';

class SuccessScreen extends StatefulWidget {
final String? phoneNumber;
final String uid;
final String? countryCode;
final String? countryISOCode;
final String? name;
final SignInType signInType;
final String? email;
const SuccessScreen({Key? key,  this.phoneNumber, required this.uid,
   this.countryCode,  this.countryISOCode,  this.name,required this.signInType, this.email,}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>with SingleTickerProviderStateMixin {
  late AccountBloc accountBloc;
  Size? size;
  bool isSelectedHusband = false;
  bool isSelectedWife = false;
  bool isSelectedUser = false;
  String? type;
  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
  }



  @override
  Widget build(BuildContext context) {
     size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(  width: size!.width,
            height: size!.height*0.30,
          ),
          Container(width: size!.width,
            height: size!.height*0.50,
            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/icon/Group 3632.png',
                 width: 93,
                 height: 93,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    getTranslated(context, 'verified'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: AppColors.balck2,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40),
                  child: Text(
                    getTranslated(context, 'verifiedSuccess'),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                      color: AppColors.grey2,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),),
          ),
          Container(width: size!.width,
            height: size!.height*0.10,
            child: Center(child:  Container(
              width: size!.width * 0.8,
              decoration:
              BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO( 207, 0, 54,1),
                      Color.fromRGBO( 255, 47, 101,1)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,

                  )
              ),
              height: 45,
              child: MaterialButton(
                onPressed: () async {
                  accountBloc.add(GetLoggedUserEvent());
                  checkUser( widget.uid);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(getTranslated(context, "start"),
                  style: TextStyle(fontFamily: getTranslated(context,"fontFamily"),
                    color: AppColors.white,
                    fontSize: 15.0,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),)
          ),

        ],
      ),
    );
  }
  checkUser(String uid) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection(Paths.usersPath).doc(uid);
      final DocumentSnapshot documentSnapshot = await docRef.get();
      if(documentSnapshot.exists){
        print("login event");
        accountBloc.add(GetLoggedUserEvent());
        String eventName = "af_login";
        Map eventValues = {};
        addEvent(eventName, eventValues);
        var user = GroceryUser.fromMap(documentSnapshot.data() as Map);
        if(user.isBlocked==true){
          await FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
                (route) => false,
          );
        }
        else if(user.profileCompleted==true){
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
                (route) => false,
          );
        }
        else if(user.profileCompleted==false&&user.userType=="CONSULTANT"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => consultRuleScreen(user: user),
            ),
          );
        }
        else if(user.profileCompleted==false&&user.userType=="COACH"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CoachScreen(user: user, firstLogged: true),
            ),
          );
        }
        else if(user.profileCompleted==false&&user.userType=="USER"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserAccountScreen(user: user, firstLogged: true),
            ),
          );
        }
        else Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ClientScreen(user: user, firstLogged: true),
            ),
          );

      }
      else{
        _show(context);
      }
    }catch(e){
      print("checkuser error");
      print(e.toString());
    }
  }
  register(  String type) async {
    try {
    //user not found-create user and save it
    print("register event");
    String eventName = "af_complete_registration";
    Map eventValues = {
    "af_registration_method": "phone number",
    };
    addEvent(eventName, eventValues);
    print("registerSt1");
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .doc(widget.uid);
     var data = {
    'accountStatus': 'NotActive',
    'userLang': 'en',
    'profileCompleted': false,
    'isBlocked': false,
    'uid': widget.uid,
    'name': " ",
    'email':widget.email,
    'phoneNumber': widget.phoneNumber,
    'photoUrl': '',
    'tokenId': "",
    'loggedInVia': widget.signInType.name,
    "isPhoneMain":widget.signInType==SignInType.mobile?true:false,
    "userType": type,
    "languages": [],
    "countryCode": widget.countryCode,
    "countryISOCode": widget.countryISOCode,
    "country":widget.name,
    'date': {
    'day': DateTime.now().day,
    'month': DateTime.now().month,
    'year': DateTime.now().year,
    },
    'utcTime':DateTime.now().toUtc().toString(),
    "createdDate": Timestamp.now(),
    "createdDateValue": DateTime(DateTime.now().year,
    DateTime.now().month, DateTime.now().day)
        .millisecondsSinceEpoch,
    };
    ref.set(data, SetOptions(merge: true));
    final DocumentSnapshot currentDoc = await ref.get();
    var user = GroceryUser.fromMap(currentDoc.data() as Map);
    if (user.userType == "CONSULTANT") {
       Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => consultRuleScreen(user: user),
    ),
    );
    }
    else if(user.userType=="USER") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAccountScreen(user: user),
        ),
      );

    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientScreen(user: user),
        ),
      );
    }
    } catch (e) {
      print(e);
      return null;
    }
  }
  void _show(BuildContext ctx) {
    showModalBottomSheet(
      elevation: 10,
      backgroundColor: Colors.transparent,
      context: ctx,
      builder: (ctx) => Container(
        height:AppSize.h600.h,
        width: AppSize.w570.w,
        padding:  EdgeInsets.symmetric(horizontal: AppPadding.p56.w, vertical: 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
            )),
        child: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /* Center(
                    child:  Image.asset("assets/icons/icon/Group2885.png",width: 100,height: 70,)
                ),*/
                SizedBox(height: AppSize.h26_6.h,),
                Container(
                  height: AppSize.h5_3.h,
                  width: AppSize.w117_3.w,
                  color: AppColors.darkGrey1,

                ),
                SizedBox(height: AppSize.h26_6.h,),

                Text(
                  getTranslated(context, "wantRegister"),
                  style: TextStyle(
                    fontSize: AppFontsSizeManager.s30.sp,
                    color: AppColors.black,
                    fontFamily: getTranslated(
                      context,
                      "Montserratsemibold",
                    ),
                  ),

                ),
                SizedBox(height: AppSize.h53_3.h,),

                Container(
                  width: AppSize.w460.w,
                  height: AppSize.h64.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      color: AppColors.white,
                      border: Border.all(color: isSelectedHusband?AppColors.pink2: AppColors.darkGrey,width: 1)
                  ),
                  child: MaterialButton(
                    onPressed: ()  {
                      type = "CONSULTANT";
                      //register("CONSULTANT");
                      isSelectedHusband =! isSelectedHusband;
                      isSelectedWife = false;
                      isSelectedUser = false;
                      setState(() {
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                    ),
                    child: Text(
                      getTranslated(context, "seekingAhusband"),
                      style: TextStyle(fontFamily: getTranslated(context,"Montserratsemibold"),
                        color:isSelectedHusband?AppColors.pink2: AppColors.darkGrey,
                        fontWeight: FontWeight.normal,
                        fontSize: AppFontsSizeManager.s24.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSize.h32.h,),
                Container(
                  width: AppSize.w460.w,
                  height: AppSize.h64.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      color: AppColors.white,
                      border: Border.all(color: isSelectedWife?AppColors.pink2: AppColors.darkGrey,width: 1)
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      type = "USER";

                      //register("USER");
                      isSelectedWife =! isSelectedWife;
                      isSelectedHusband = false;
                      isSelectedUser =false;
                      setState(() {
                      });

                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                    ),
                    child: Text(
                      getTranslated(context, "seekingAwife"),
                      style: TextStyle(fontFamily: getTranslated(context,"Montserratsemibold"),
                        color:isSelectedWife?AppColors.pink2: AppColors.darkGrey,
                        fontWeight: FontWeight.normal,
                        fontSize: AppFontsSizeManager.s24.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSize.h32.h,),
                Container(
                  width: AppSize.w460.w,
                  height: AppSize.h64.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                      color: AppColors.white,
                      border: Border.all(color: isSelectedUser?AppColors.pink2: AppColors.darkGrey,width: 1)
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      type = "CLIENT";

                      //register("CLIENT");
                      isSelectedUser =! isSelectedUser;
                      isSelectedHusband = false;
                      isSelectedWife = false;
                      setState(() {
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r10_6.r),
                    ),
                    child: Text(
                      getTranslated(context, "normalUser"),
                      style: TextStyle(fontFamily: getTranslated(context,"Montserratsemibold"),
                        color:isSelectedUser?AppColors.pink2: AppColors.darkGrey,
                        fontWeight: FontWeight.normal,
                        fontSize: AppFontsSizeManager.s24.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSize.h64.h,),

                InkWell(
                  onTap: () {
                    register(type!);
                    },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.pink2,
                        borderRadius:
                        BorderRadius.circular(AppRadius.r16.r)
                    ),
                    width: AppSize.w416.w,
                    height: AppSize.h66_6.h,
                    child: Center(
                      child: Text(
                        getTranslated(context, "continue"),
                        style: TextStyle(
                          fontFamily: getTranslated(
                            context,
                            "Montserratsemibold",
                          ),
                          fontSize: AppFontsSizeManager.s26_6.sp,
                          color: AppColors.white,

                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          );
        }),
      ),
    );
  }
  addEvent(String eventName,Map eventValues) async {

    if(eventName=="af_login")
      await FirebaseAnalytics.instance.logLogin(
      loginMethod: "phone",);
    else
    await FirebaseAnalytics.instance.logSignUp(
    signUpMethod: "phone",);
  }

}
