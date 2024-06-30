import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/screens/google_apple_signup/services/enum/authentication_type.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/apple_sign_up_cubit/apple_sign_up_cubit.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/gmail_sign_up_cubit/gmail_sign_up_cubit.dart';
import 'package:grocery_store/screens/google_apple_signup/view_model/setting_cubit/setting_cubit.dart';
import 'package:grocery_store/screens/google_apple_signup/views/widgets/gmail_apple_widget.dart';
import 'package:grocery_store/screens/google_apple_signup/views/widgets/new_phone_number_widgets.dart';
import 'package:grocery_store/screens/google_apple_signup/views/widgets/phone_number_widget.dart';
import 'package:grocery_store/screens/privecy_screen.dart';
import 'package:grocery_store/screens/register_bottom_sheet.dart';
import 'package:grocery_store/screens/successScreen.dart';
import 'package:grocery_store/screens/test.dart';
import 'package:grocery_store/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:intl_phone_field/countries.dart' as country;
import '../config/app_values.dart';
import '../config/colorsFile.dart';
import '../widget/IconButton.dart';
import '../widget/TextButton.dart';
import '../widget/keyboardButton.dart';
import 'package:country_calling_code_picker/picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String mobileNo = "",
      countryCode = "+1",
      countryISOCode = "US",
      countryname = "United States",
      keyboardText = "";
  String phonenum = "0";

  bool openKeyboard = false;

  TextEditingController phoneController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String phoneNumber = "", email = "example@example.com", name = "name";
  bool inProgress = false, inProgressApple = false;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'GB', theme = "";
  Country _selectedCountry =
      new Country("United States of America", "flags/usa.png", "US", "+1");
  DateTime? currentBackPressTime;
  String lang = "";
  late SettingCubit settingCubit;
  late GmailSignUpCubit gmailSignUpCubit;
  late AppleSignUpCubit appleSignUpCubit;
  @override
  void initState() {
    super.initState();
    inProgress = false;
    inProgressApple = false;
    settingCubit = BlocProvider.of<SettingCubit>(context);
    gmailSignUpCubit = GmailSignUpCubit();
    appleSignUpCubit = AppleSignUpCubit();
    settingCubit.getSetting();
    initCountry();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initCountry() async {
    final country = await getCountryByCountryCode(context, "US");
    setState(() {
      _selectedCountry = country!;
    });
    print("kkkkk");
    print(_selectedCountry.name);
    print(_selectedCountry.flag);
    print(_selectedCountry.countryCode);
    print(_selectedCountry.callingCode);
  }

  signUpWithphoneNumber() async {
    if (mobileNo == null || mobileNo == "")
      showFailedSnakbar(getTranslated(context, "enterAll"));
    // else if (!getCountryByCode(countryCode, mobileNo)) {
    //   showFailedSnakbar(getTranslated(context, "EnterValidPhoneNumber"));
    // }
    else {
      phoneNumber = mobileNo;
      print('prooooooobb ====::: $phoneNumber');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            email: email,
            phoneNumber: phoneNumber,
            name: countryname,
            // userType:widget.userType,
            //type:widget.type,
            countryCode: countryCode,
            countryISOCode: countryISOCode,
            isSigningIn: false,
          ),
        ),
      );
    }
  }

  getCountryByCode(String countryCode, phoneNumber) {
    List<country.Country> _countryList = country.countries;
    // Assuming _countryList is the list of available countries
    for (country.Country newcountry in _countryList) {
      if (newcountry.dialCode == countryCode.split('+')[1]) {
        return phoneNumber.length == newcountry.minLength;
      }
    }
  }

  void showFailedSnakbar(String s) {
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
    lang = getTranslated(context, "lang");
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: gmailSignUpCubit,
          listener: (context, state) {
            print("-----------gmailSignUpCubit $state");
            if (state is GmailSignUpSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessScreen(
                    uid: state.uid!,
                    email: state.email,
                    signInType: SignInType.google,
                  ),
                ),
              );
            }
          },
        ),
        BlocListener(
          bloc: appleSignUpCubit,
          listener: (context, state) {
            print("-----------appleSignUpCubit $state");
            if (state is AppleSignUpSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessScreen(
                    uid: state.uid!,
                    email: state.email,
                    signInType: SignInType.apple,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: AppPadding.p21_3.h,
                        left: AppPadding.p32.w,
                        right: AppPadding.p32.w,
                        top: AppPadding.p70.w),
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
                            setState(() {
                              DateTime now = DateTime.now();
                              if (currentBackPressTime == null ||
                                  now.difference(currentBackPressTime!) >
                                      Duration(seconds: 2)) {
                                currentBackPressTime = now;
                                Fluttertoast.showToast(
                                    msg: getTranslated(context, 'exitApp'));
                              } else {
                                SystemNavigator.pop();
                              }
                            });
                          },
                          Width: AppSize.w53_3.w,
                          Height: AppSize.h53_3.h,
                          ButtonBackground: AppColors.white,
                          BoxShape1: BoxShape.circle,
                          Icon: lang == "ar"
                              ? AssetsManager.blackIosArrowRightIconPath
                                  .toString()
                              : AssetsManager.blackIosArrowLeftIconPath
                                  .toString(),
                          IconWidth:
                              lang == "ar" ? AppSize.w21_3.w : AppSize.w28_4.w,
                          IconHeight:
                              lang == "ar" ? AppSize.h21_3.h : AppSize.h28_4.h,
                          IconColor: AppColors.black,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.white3,
                    height: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: AppSize.h86_6.h, bottom: AppSize.h21_3.h),
                    child: Center(
                      child: Text(
                        getTranslated(context, "addMobileNum"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.balck2,
                            fontFamily:
                                getTranslated(context, "Montserratsemibold"),
                            fontWeight: FontWeight.w600,
                            fontSize: AppFontsSizeManager.s26_6.sp),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppPadding.p81_3.w, right: AppPadding.p81_3.w),
                    child: Text(
                      getTranslated(context, "loginText"),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: getTranslated(context, "Montserrat"),
                        color: AppColors.grey2,
                        fontSize: AppFontsSizeManager.s24.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSize.h118_6.h,
                  ),
                  NewPhoneNumberWidget(
                    onChanged: (newNum) {
                      mobileNo = newNum.phoneNumber!;
                      print(
                          'ooooooooooooooooo====================== $mobileNo');
                    },
                  ),
                  SizedBox(
                    height: AppSize.h40.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        lang == "ar"
                            ? SvgPicture.asset(
                                AssetsManager.goldFlower4IconPath,
                                width: AppSize.w32_5.w,
                                height: AppSize.h32_5.h,
                              )
                            : SvgPicture.asset(
                                AssetsManager.goldFlower3IconPath,
                                width: AppSize.w32_5.w,
                                height: AppSize.h32_5.h,
                              ),
                        SizedBox(
                          width: AppSize.w4_3.w,
                        ),
                        Center(
                          child: TextButton1(
                              onPress: () {
                                // setState(() {
                                //   mobileNo = phoneController.text;
                                // });
                                signUpWithphoneNumber();
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
                        ),
                        SizedBox(
                          width: AppSize.w4_3.w,
                        ),
                        lang == "ar"
                            ? SvgPicture.asset(
                                AssetsManager.goldFlower3IconPath,
                                width: AppSize.w32_5.w,
                                height: AppSize.h32_5.h,
                              )
                            : SvgPicture.asset(
                                AssetsManager.goldFlower4IconPath,
                                width: AppSize.w32_5.w,
                                height: AppSize.h32_5.h,
                              ),
                      ],
                    ),
                  ),
                  BlocBuilder(
                    bloc: settingCubit,
                    builder: (context, state) {
                      print("settingCubitStates $state");
                      if (state is SettingSuccessState) {
                        if (state.setting.authType == "both")
                          return Column(
                            children: [
                              SizedBox(height: AppSize.h53_3.h),
                              lineWidget(),
                              SizedBox(height: AppSize.h21_3.h),
                              googleAppleWidget(),
                            ],
                          );
                        else
                          return SizedBox(
                            child: Container(color: AppColors.green),
                          );
                      } else
                        return SizedBox(
                          child: Container(color: AppColors.balck2),
                        );
                    },
                  ),
                  SizedBox(
                    height: AppSize.h206_1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      //top: openKeyboard ? AppSize.h42_6.h : AppSize.h68.h,
                      //bottom: AppSize.h21_3.h,
                      left: AppSize.w68.w,
                      right: AppSize.w68.w,
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PrivecyScreen(), //TermScreen(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: getTranslated(context, "registerNote1"),
                          style: TextStyle(
                              fontFamily: getTranslated(context, "Montserrat"),
                              color: AppColors.grey2,
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                              text: " ",
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "Montserrat"),
                                decorationThickness: 1,
                                color: Color.fromRGBO(158, 158, 158, 1),
                                fontSize: 11.0,
                              ),
                            ),
                            TextSpan(
                              text: getTranslated(context, "registerNote2"),
                              style: TextStyle(
                                decorationThickness: 1,
                                fontFamily:
                                    getTranslated(context, "Montserrat"),
                                color: AppColors.pink2,
                                fontSize: AppFontsSizeManager.s18_6.sp,
                              ),
                            ),
                            TextSpan(
                              text: " ",
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "Montserrat"),
                                decorationThickness: 1,
                                color: Color.fromRGBO(158, 158, 158, 1),
                                fontSize: 11.0,
                              ),
                            ),
                            TextSpan(
                              text: getTranslated(context, "registerNote3"),
                              style: TextStyle(
                                  fontFamily:
                                      getTranslated(context, "Montserrat"),
                                  color: AppColors.grey2,
                                  fontSize: AppFontsSizeManager.s18_6.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: " ",
                              style: TextStyle(
                                fontFamily:
                                    getTranslated(context, "Montserrat"),
                                decorationThickness: 1,
                                color: Color.fromRGBO(205, 61, 99, 1),
                                fontSize: 11.0,
                              ),
                            ),
                            TextSpan(
                              text: getTranslated(context, "policy"),
                              style: TextStyle(
                                decorationThickness: 1,
                                fontFamily:
                                    getTranslated(context, "Montserrat"),
                                color: AppColors.pink2,
                                fontSize: AppFontsSizeManager.s18_6.sp,
                              ),
                            ),
                          ],
                        ),
                        softWrap: true,
                        maxLines: 10,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectCountry() async {
    final country =
        await Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return PickerPage();
    }));
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        countryname = _selectedCountry.name;
        countryCode = _selectedCountry.callingCode;
        countryISOCode = _selectedCountry.countryCode;
        print(countryISOCode);
      });
    }
  }

  lineWidget() => Padding(
        padding: EdgeInsets.only(
          // top: convertPtToPx(AppPadding.p40).h,
          // bottom: convertPtToPx(AppPadding.p32).h,
          left: convertPtToPx(AppPadding.p25).w,
          right: convertPtToPx(AppPadding.p25).w,
        ),
        child: Row(
          children: [
            Expanded(
                child: Divider(
              color: AppColors.lightGrey,
              height: convertPtToPx(AppSize.h1).h,
            )),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: convertPtToPx(AppPadding.p16).w),
              child: Text(
                getTranslated(context, "or"),
                maxLines: AppConstants.maxLines,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: getTranslated(context, 'Ithra'),
                  color: AppColors.grey,
                  fontSize: convertPtToPx(AppFontsSizeManager.s14).sp,
                  //fontWeight: FontWeight.normal
                ),
              ),
            ),
            Expanded(
                child: Divider(
              color: AppColors.lightGrey,
              height: convertPtToPx(AppSize.h1).h,
            )),
          ],
        ),
      );
  googleAppleWidget() => Padding(
        padding:
            EdgeInsets.symmetric(horizontal: convertPtToPx(AppPadding.p25).w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder(
              bloc: gmailSignUpCubit,
              builder: (context, state) {
                print("##########GmailSignUpCubit$state");
                if (state is GmailSignUpLoadingState ||
                    state is GmailSignUpSuccessState)
                  return CircularProgressIndicator();
                else
                  return InkWell(
                      onTap: () async {
                        gmailSignUpCubit.signInWithGoogle();
                      },
                      child: GmailAppleWidget(
                          getTranslated(context, "Montserrat"),
                          AssetsManager.googleIconsPath,
                          getTranslated(context, "registerWithGoogle")));
              },
            ),
            SizedBox(
              height: AppSize.h21_3.h,
            ),
            BlocBuilder(
              bloc: appleSignUpCubit,
              builder: (context, state) {
                if (state is AppleSignUpLoadingState ||
                    state is AppleSignUpSuccessState)
                  return CircularProgressIndicator();
                else
                  return InkWell(
                    onTap: () async {
                      appleSignUpCubit.signInWithApple();
                    },
                    child: GmailAppleWidget(
                        getTranslated(context, "Montserrat"),
                        AssetsManager.apple_Icon_Path,
                        getTranslated(context, "linkAppleAccount")),
                  );
              },
            ),
          ],
        ),
      );
}
