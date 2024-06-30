import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/blocs/sign_up_bloc/signup_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/screens/successScreen.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../config/app_values.dart';
import '../config/assets_manager.dart';
import '../config/colorsFile.dart';
import '../widget/IconButton.dart';
import '../widget/TextButton.dart';
import '../widget/keyboardButton.dart';
import 'consultRules.dart';
import 'google_apple_signup/services/enum/authentication_type.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String email;
  final bool isSigningIn;

  //final String userType;
  final String countryCode;
  final String countryISOCode;

  //final String type;
  const VerificationScreen({
    required this.phoneNumber,
    required this.email,
    required this.name,
    required this.isSigningIn,
    //required this.userType,
    // required this.type,
    required this.countryCode,
    required this.countryISOCode,
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool openKeyboard = false;

  MaskedTextController otpController = MaskedTextController(mask: '000000');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _timer;
  late Timer timer;
  String _code = "";
  late bool inProgress;
  bool isResendOTP = false;
  late String smsCode, theme = "light";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _verificationCode = '', keyboardText = "";
  String? lang;

  @override
  void initState() {
    super.initState();
    inProgress = false;
    listOPT();
    signInWithphoneNumber(widget.phoneNumber);
    startTimer();
  }

  checkUser(String phoneNumber, String uid) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
              phoneNumber: phoneNumber,
              uid: uid,
              signInType: SignInType.mobile,
              countryCode: widget.countryCode,
              countryISOCode: widget.countryISOCode,
              name: widget.name),
        ),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  listOPT() async {
    try {
      await SmsAutoFill().listenForCode;
    } catch (e) {
      print("ffffffss" + e.toString());
    }
  }

  void startTimer() {
    _timer = 60;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timer--;
      });
      if (_timer == 0) {
        timer.cancel();
      }
    });
  }

  void showFailedSnakbar(String s) {
    if (mounted)
      Fluttertoast.showToast(
          msg: s,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppPadding.p21_3.h, horizontal: AppPadding.p32.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /*IconButton(
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    getTranslated(context, 'back'),
                    width: 30,
                    height: 30,
                  ),
                ),*/
                IconButton1(
                  onPress: () {
                    Navigator.pop(context);
                  },
                  Width: AppSize.w53_3.w,
                  Height: AppSize.h53_3.h,
                  ButtonBackground: AppColors.white,
                  BoxShape1: BoxShape.circle,
                  Icon: lang == "ar"
                      ? AssetsManager.blackIosArrowRightIconPath.toString()
                      : AssetsManager.blackIosArrowLeftIconPath.toString(),
                  IconWidth: lang == "ar" ? AppSize.w24.w : AppSize.w28_4.w,
                  IconHeight: lang == "ar" ? AppSize.h24.h : AppSize.h28_4.h,
                  IconColor: AppColors.black,
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.white3,
            height: 0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: AppSize.h53_3.h,
              ),
              Image.asset(
                'assets/icons/icon/Group 3630.png',
                width: AppSize.w152_2.w,
                height: AppSize.h155_4.h,
              ),
              SizedBox(
                height: AppSize.h32_5.h,
              ),
              Text(
                getTranslated(context, 'enterCode'),
                style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    color: AppColors.balck2,
                    fontSize: AppFontsSizeManager.s26_6.sp,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: AppSize.h21_3.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p101_3.w),
                child: Text(
                  _timer > 50
                      ? getTranslated(context, "otpSending")
                      : getTranslated(context, "otpSend"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: getTranslated(context, "fontFamily"),
                    color: AppColors.grey2,
                    fontSize: AppFontsSizeManager.s24.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppSize.h64.h,
                ),
                _timer > 50
                    ? loadVerificationCode()
                    : Container(
                        height: AppSize.h72.h,
                        padding: const EdgeInsets.symmetric(
                            // horizontal: 70.0,
                            vertical: 0.0),
                        child: Pinput(
                          separatorBuilder: (index) => Padding(
                              padding: EdgeInsets.only(left: AppSize.h21_3.w)),
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                          toolbarEnabled: true,
                          controller: otpController,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              openKeyboard = true;
                            });
                          },
                          defaultPinTheme: PinTheme(
                            width: AppSize.w60.w,
                            height: AppSize.h72.h,
                            textStyle: TextStyle(
                                fontSize: AppFontsSizeManager.s29_3.sp,
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontWeight: FontWeight.w600),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.brown),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.r5_3.r),
                            ),
                          ),
                          length: 6,
                          onCompleted: (pin) {
                            smsCode = pin;
                            if (pin.trim().length == 6) {
                              signInWithSmsCode(pin);
                              if (mounted)
                                setState(() {
                                  inProgress = true;
                                });
                            }
                          },
                        )),
                SizedBox(
                  height: AppSize.h16.h,
                ),
                Center(
                    child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: convertPtToPx(39).w,
                    ),
                    Text(
                      getTranslated(context, 'resendcode'),
                      style: TextStyle(
                        fontFamily: getTranslated(context, "fontFamily"),
                        color: AppColors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '$_timer sec',
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: AppColors.reddark,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  height: AppSize.h70.h,
                )

                // PinFieldAutoFill(
                //   decoration: UnderlineDecoration(
                //     textStyle:
                //         TextStyle(fontSize: 20, color: Colors.transparent),
                //     colorBuilder: FixedColorBuilder(Colors.transparent),
                //   ),
                //   codeLength: 6,
                //   onCodeSubmitted: (code) {},
                //   onCodeChanged: (code) {
                //     if (code!.length == 6) {
                //       FocusScope.of(context).requestFocus(FocusNode());
                //       otpController.text = code;
                //       print(code);
                //       signInWithSmsCode(code);
                //       //signupBloc.add(VerifyphoneNumber(code));
                //       if(mounted)setState(() {
                //         inProgress = true;
                //         smsCode = code;
                //       });
                //     }
                //   },
                // ),
              ]),
          SizedBox(
            height: AppSize.h130.h,
          ),
          _timer > 50
              ? Center(child: CircularProgressIndicator())
              : buildVerificationBtn(context, inProgress, size),
          SizedBox(
            height: AppSize.h81.h,
          ),
        ],
      ),
    );
  }

  Widget buildVerificationBtn(
      BuildContext context, bool inProgress, Size size) {
    return inProgress
        ? Center(child: CircularProgressIndicator())
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                getTranslated(context, 'leftrose'),
                width: 25,
                height: 25,
              ),
              TextButton1(
                  onPress: () {
                    VerifyphoneNumber(smsCode);
                    print("phone number = ${widget.phoneNumber}");
                    print("sms code = $smsCode");
                  },
                  Width: 362.6.w,
                  Height: 69.3.h,
                  Title: getTranslated(context, "sendCode"),
                  ButtonRadius: 34.6.r,
                  TextSize: 22.6.sp,
                  GradientColor: Color.fromRGBO(207, 0, 54, 1),
                  GradientColor2: Color.fromRGBO(255, 47, 101, 1),
                  TextFont: getTranslated(context, "fontFamily"),
                  TextColor: AppColors.white),
              /*InkWell(
                onTap: () {
                  VerifyphoneNumber(smsCode);
                  print("phone number = ${widget.phoneNumber}");
                  print("sms code = $smsCode");
                },
                child: Container(
                  width: size.width * .6,
                  height: 45.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerLeft,
                        colors: [
                          Color.fromRGBO(207, 0, 54, 1),
                          Color.fromRGBO(255, 47, 101, 1)
                        ],
                      )),
                  child: Center(
                    child: Text(
                      getTranslated(context, "sendCode"),
                      style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          color: AppColors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),*/
              Image.asset(
                getTranslated(context, 'rightrose'),
                width: 25,
                height: 25,
              ),
            ],
          );
  }

  Widget loadVerificationCode() {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 800),
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.black.withOpacity(0.6),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * .8,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ));
  }

  //================
  //send code
  Future<bool> signInWithphoneNumber(String phoneNumber) async {
    try {
      print("signInWithphoneNumber222");
      isResendOTP = false;

      int? forceResendToken;
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (authCredential) =>
            phoneVerificationCompleted(authCredential),
        verificationFailed: (authException) =>
            phoneVerificationFailed(authException, phoneNumber),
        codeSent: (String verificationId, int? resendToken) async {
          print("otp sent000");
          print(verificationId);
          this._verificationCode = verificationId;
        },
        codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
        forceResendingToken: forceResendToken,
      );
      print("dreamphonesendotpSuccess");
      return true;
    } catch (e) {
      print("dreamphonesendotpfailed");
      print(e);
      String id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.errorLogPath)
          .doc(id)
          .set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'phone': widget.phoneNumber,
        'screen': "otp",
        'function': "signInWithphoneNumber",
      });

      if (mounted)
        setState(() {
          inProgress = false;
        });
      showFailedSnakbar(e.toString());
      return false;
    }
  }

  //resend OTP
  Future<bool> resendOTP(String phoneNumber) async {
    try {
      isResendOTP = true;

      http.post(
        Uri.parse(
            'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/twilioSendVerificationCode'),
        body: {'phoneNumber': widget.phoneNumber},
      );

      return true;
    } catch (e) {
      print(e);
      String id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.errorLogPath)
          .doc(id)
          .set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'phone': widget.phoneNumber,
        'screen': "otp",
        'function': "signInWithphoneNumber",
      });

      if (mounted)
        setState(() {
          inProgress = false;
        });
      showFailedSnakbar(e.toString());
      return false;
    }
  }

  phoneVerificationCompleted(PhoneAuthCredential authCredential) {
    print("verification completed ${authCredential.smsCode}");
    // otpController.text=authCredential.smsCode;
    //showFailedSnakbar("verification completed ${authCredential.smsCode}");
    signInWithSmsCodeStep2(authCredential: authCredential);
    print('verified');
  }

  phoneVerificationCompleted2(AuthCredential authCredential) {
    print('verified');
  }

  phoneVerificationFailed(FirebaseException authException, String phone) async {
    print('failedssssssss111');
    String id = Uuid().v4();
    await FirebaseFirestore.instance
        .collection(Paths.errorLogPath)
        .doc(id)
        .set({
      'timestamp': Timestamp.now(),
      'id': id,
      'seen': false,
      'desc': authException.message.toString(),
      'phone': phone,
      'screen': "otp",
      'function': authException.code.toString(),
    });
    print('Message: ${authException.message}');
    print('Code: ${authException.code}');
    if (mounted)
      setState(() {
        inProgress = false;
      });
    showFailedSnakbar(authException.message.toString());
  }

  phoneCodeAutoRetrievalTimeout(String verificationCode) {
    print("verificationCode");
    print(verificationCode);
    this._verificationCode = verificationCode;
  }

  phoneCodeSent(String verificationCode, List<int> code) {
    print("otp sent");
    print(verificationCode);
    print(code.toString());
    this._verificationCode = verificationCode;
  }

  Future<void> signInWithSmsCode(String smsCode) async {
    try {
      setState(() {
        inProgress = true;
      });
      if (isResendOTP) {
        signInWithSmsCodeStep2();
      } else {
        print("pppppppp");
        print(_verificationCode);
        print(smsCode);
        AuthCredential authCredential = PhoneAuthProvider.credential(
            verificationId: _verificationCode, smsCode: smsCode);
        signInWithSmsCodeStep2(authCredential: authCredential);
      }
    } catch (e) {
      String id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.errorLogPath)
          .doc(id)
          .set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'phone': widget.phoneNumber,
        'screen': "otp",
        'function': "signInWithSmsCode",
      });

      print('Code: ${e.toString()}');
      if (mounted)
        setState(() {
          inProgress = false;
        });
      showFailedSnakbar(e.toString());
      print("phonenumber11error " + e.toString());
      return null;
    }
  }

  Future<void> signInWithSmsCodeStep2({AuthCredential? authCredential}) async {
    try {
      setState(() {
        inProgress = true;
      });
      print("pppppppp222");
      UserCredential authResult;

      if (isResendOTP) {
        var authUserRes = await http.post(
          Uri.parse(
              'https://us-central1-make-my-nikah-d49f5.cloudfunctions.net/twilioVerifyPhoneNum'),
          body: {'userCode': smsCode, 'phoneNumber': widget.phoneNumber},
        );

        print('TOKENNN :: ');

        final token = authUserRes.body;

        print(token);

        authResult = await firebaseAuth.signInWithCustomToken(token);
      } else {
        authResult = await firebaseAuth.signInWithCredential(authCredential!);
      }

      if (authResult != null &&
          authResult.user != null &&
          authResult.user!.uid != null) {
        checkUser(widget.phoneNumber, authResult.user!.uid);
      } else {
        print("pppppppp2220000");
        String id = Uuid().v4();
        await FirebaseFirestore.instance
            .collection(Paths.errorLogPath)
            .doc(id)
            .set({
          'timestamp': Timestamp.now(),
          'id': id,
          'seen': false,
          'desc': "invalid sms code",
          'phone': widget.phoneNumber,
          'screen': "otp",
          'function': "signInWithSmsCodeStep2",
        });

        showFailedSnakbar("invalid sms code");
        setState(() {
          inProgress = false;
        });
      }
    } catch (e) {
      print("phonenumber11error " + e.toString());
      String id = Uuid().v4();
      await FirebaseFirestore.instance
          .collection(Paths.errorLogPath)
          .doc(id)
          .set({
        'timestamp': Timestamp.now(),
        'id': id,
        'seen': false,
        'desc': e.toString(),
        'phone': widget.phoneNumber,
        'screen': "otp",
        'function': "signInWithSmsCodeStep2",
      });

      if (mounted) showFailedSnakbar(e.toString());
      if (mounted)
        setState(() {
          inProgress = false;
        });
      return null;
    }
  }
}
