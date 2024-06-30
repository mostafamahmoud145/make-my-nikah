import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_store/blocs/account_bloc/account_bloc.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/language_constants.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/screens/clientScreen.dart';
import 'package:grocery_store/screens/coachScreen.dart';
import 'package:grocery_store/screens/questions/ask_question_screen.dart';
import 'package:grocery_store/screens/setting/setting.dart';
import 'package:grocery_store/screens/userPaymentHistoryScreen.dart';
import 'package:grocery_store/screens/walletFeature/presention/wallet_view.dart';
import 'package:grocery_store/widget/IconButton.dart';
import 'package:grocery_store/widget/drawer_item.dart';
import 'package:grocery_store/widget/nikah_dialog.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import '../main.dart';
import '../models/user.dart';
import '../screens/AllReportsScreen.dart';
import '../screens/DevelopTechSupport/allDevelopSupport.dart';
import '../screens/aboutUsScreen.dart';
import '../screens/account_screen.dart';
import '../screens/addFakeReview.dart';
import '../screens/consultPaymentHistoryScreen.dart';
import '../screens/favoriteScreen.dart';
import '../screens/interviewListScreen.dart';
import '../screens/invoice/allInvoicesScreen.dart';
import '../screens/push_notifications_screens/AllSendedNotification.dart';
import '../screens/reviews_screen.dart';
import '../screens/suggestionScreen.dart';
import '../screens/techUserDetails/userDetailsScreen.dart';
import '../screens/technicalAppointment/allAppointmentScreen.dart';
import '../screens/userAccountScreen.dart';
// import '../screens/walletScreen.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget();

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AccountBloc accountBloc;
  GroceryUser? user;
  bool load = false, loadUser = true, wrongNumber = false;
  TextEditingController searchController = new TextEditingController();
  String? userImage, userName, lang, theme = "light", selectedLang;
  late Size size;

  @override
  void initState() {
    super.initState();
    accountBloc = BlocProvider.of<AccountBloc>(context);
    accountBloc.add(GetLoggedUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    lang = getTranslated(context, "lang");
    return Drawer(
        width: convertPtToPx(AppSize.w360).w,
        backgroundColor: Colors.white,
        elevation: 0.0,
        child: BlocBuilder(
          bloc: accountBloc,
          builder: (context, state) {
            print("Account state");
            print(state);
            if (state is GetLoggedUserInProgressState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetLoggedUserCompletedState) {
              user = state.user;
              return loggedUserDrawer(size);
            } else {
              return notLoggedUserDrawer(size);
            }
          },
        ));
  }

  Widget loggedUserDrawer(Size size) {
    return Container(
      color: AppColors.white,
      //width: convertPtToPx(360).w,
      child: ListView(
        shrinkWrap: true,
        //padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Center(
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.6),
              onTap: () {
                print("hhhhhhhh");
                print(user!.userType);
                if (user == null)
                  Navigator.pushNamed(context, '/Register_Type');
                else if (user != null && user!.isDeveloper!)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AllDevelopTechScreen(loggedUser: user!),
                    ),
                  );
                else if (user != null && user!.userType == "USER")
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserAccountScreen(user: user!, firstLogged: false),
                    ),
                  );
                else if (user != null && user!.userType == "CONSULTANT")
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountScreen(user: user!, firstLogged: false),
                    ),
                  );
                else if (user != null && user!.userType == "COACH")
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CoachScreen(user: user!, firstLogged: false),
                    ),
                  );
                else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ClientScreen(user: user!, firstLogged: false),
                    ),
                  );
                }
              },
              child: Image.asset('assets/icons/icon/Mask Group 47.png',
                  height: convertPtToPx(AppSize.h57.h),
                  width: convertPtToPx(AppSize.w60.w)),
            ),
          ),
          SizedBox(
            height: AppSize.h10.h,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                user!.name!,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontFamily: getTranslated(context, "Montserratsemibold"),
                  fontSize: AppFontsSizeManager.s26_6.sp,
                  color: AppColors.pink2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          /*  Center(
            child: Text(
              getTranslated(context, "welcomeBack"),
              style: TextStyle(
                fontFamily: getTranslated(context, "fontFamily"),
                fontSize: 11.0,
                color: AppColors.grey,
              ),
            ),
          ),*/
          SizedBox(
            height: convertPtToPx(AppSize.h21).h,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: convertPtToPx(AppPadding.p63.r),
              left: convertPtToPx(AppPadding.p63.r),
            ),
            child: user!.userType == "SUPPORT"
                ? Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        getTranslated(context, "searchByMobile"),
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 18.0,
                          color: AppColors.reddark2,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: searchController,
                        enableInteractiveSelection: true,
                        onChanged: (text) {
                          setState(() {
                            wrongNumber = false;
                          });
                        },
                        style: TextStyle(
                          fontFamily: getTranslated(context, "fontFamily"),
                          fontSize: 14.0,
                          color: AppColors.black,
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          fillColor: theme == "light"
                              ? Colors.white
                              : Color(0xff3f3f3f),
                          filled: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          helperStyle: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          hintStyle: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.reddark2,
                          ),
                          prefixStyle: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          suffixIcon: InkWell(
                              child: Icon(Icons.send_rounded,
                                  color: AppColors.reddark2, size: 18),
                              onTap: () {
                                initiateSearch(searchController.text);
                              }),
                          // labelText: getTranslated(context, "phoneNumber"),
                          labelStyle: TextStyle(
                            fontFamily: getTranslated(context, "fontFamily"),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: AppColors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: AppColors.grey)),
                          //border: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      load ? CircularProgressIndicator() : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      wrongNumber
                          ? Text(
                              getTranslated(context, "noUser"),
                              style: GoogleFonts.elMessiri(
                                color: Colors.red,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : SizedBox(),
                    ],
                  )
                : Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            getTranslated(context, "balance"),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            double.parse(user!.balance.toString())
                                    .toStringAsFixed(2) +
                                "\$",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              color: AppColors.pink2,
                            ),
                          ),
                        ],
                      ),
                      //SizedBox(width: AppSize.w85_3.w,),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            getTranslated(context, "orderNum"),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratmedium"),
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            user!.ordersNumbers.toString(),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              color: AppColors.pink2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: AppPadding.p24.r, bottom: AppPadding.p24.r),
            child: Container(
              width: size.width,
              height: convertPtToPx(AppSize.h0_5).h,
              color: AppColors.lightGrey6,
            ),
          ),
          (user!.userType == "USER" ||
                  user!.userType == "CLIENT" ||
                  user!.userType == "COACH")
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //profile
                    InkWell(
                      onTap: () {
                        if (user == null)
                          Navigator.pushNamed(context, '/Register_Type');
                        else if (user != null && user!.userType == "USER")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserAccountScreen(
                                  user: user!, firstLogged: false),
                            ),
                          );
                        else if (user != null && user!.userType == "COACH")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CoachScreen(user: user!, firstLogged: false),
                            ),
                          );
                        else
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ClientScreen(user: user!, firstLogged: false),
                            ),
                          );
                      },
                      child: MenuItemWidget(
                        iconHeight: AppSize.h26_6.h,
                        iconWidth: AppSize.w18_6.w,
                        imagePath: AssetsManager.personIconPath,
                        title: getTranslated(context, "account"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //favorites
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesScreen(
                              loggedUser: user!,
                            ),
                          ),
                        );
                      },
                      child: MenuItemWidget(
                        iconHeight: AppSize.h20_4.h,
                        iconWidth: AppSize.w21_3.w,
                        imagePath: AssetsManager.favorites,
                        title: getTranslated(context, "favorite"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //wallet
                    (user != null && user!.userType == "COACH")
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ConsultPaymentHistoryScreen(
                                    user: user!,
                                  ),
                                ),
                              );
                            },
                            child: MenuItemWidget(
                              iconHeight: AppSize.h21_3.h,
                              iconWidth: AppSize.w26_6.w,
                              imagePath: AssetsManager.walletIconPath,
                              title: getTranslated(context, "paymentHistory"),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletView(
                                    loggedUser: user!,
                                  ),
                                ),
                              );
                            },
                            child: MenuItemWidget(
                              iconHeight: AppSize.h21_3.h,
                              iconWidth: AppSize.w26_6.w,
                              imagePath: AssetsManager.walletIconPath,
                              title: getTranslated(context, "wallet"),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : SizedBox(),
          (user!.userType == "CONSULTANT")
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // profile
                    InkWell(
                      onTap: () {
                        if (user == null)
                          Navigator.pushNamed(context, '/Register_Type');
                        else if (user != null && user!.userType == "USER")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserAccountScreen(
                                  user: user!, firstLogged: false),
                            ),
                          );
                        else if (user != null && user!.userType == "COACH")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CoachScreen(user: user!, firstLogged: false),
                            ),
                          );
                        else if (user != null && user!.userType == "CONSULTANT")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountScreen(
                                  user: user!, firstLogged: false),
                            ),
                          );
                        else
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ClientScreen(user: user!, firstLogged: false),
                            ),
                          );
                      },
                      child: MenuItemWidget(
                        iconHeight: AppSize.h26_6.h,
                        iconWidth: AppSize.w18_6.w,
                        imagePath: AssetsManager.personIconPath,
                        title: getTranslated(context, "account"),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h32.h,
                    ),
                    //  paymentHistory
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultPaymentHistoryScreen(
                              user: user!,
                            ),
                          ),
                        );
                      },
                      child: MenuItemWidget(
                        iconHeight: AppSize.h21_3.h,
                        iconWidth: AppSize.w26_6.w,
                        imagePath: AssetsManager.walletIconPath,
                        title: getTranslated(context, "paymentHistory"),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h32.h,
                    ),
                    //reviews
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewScreens(
                              consult: user!,
                              reviewLength: 1,
                            ),
                          ),
                        );
                      },
                      child: MenuItemWidget(
                        iconHeight: AppSize.h21_3.h,
                        iconWidth: AppSize.w26_6.w,
                        imagePath: AssetsManager.star3IconPath,
                        title: getTranslated(context, "Reviews"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : SizedBox(),
          user!.userType == "SUPPORT"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //profile
                    InkWell(
                      onTap: () {
                        if (user == null)
                          Navigator.pushNamed(context, '/Register_Type');
                        else if (user != null && user!.userType == "USER")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserAccountScreen(
                                  user: user!, firstLogged: false),
                            ),
                          );
                        else if (user != null && user!.userType == "COACH")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CoachScreen(user: user!, firstLogged: false),
                            ),
                          );
                        else if (user != null && user!.userType == "CONSULTANT")
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountScreen(
                                  user: user!, firstLogged: false),
                            ),
                          );
                        else
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ClientScreen(user: user!, firstLogged: false),
                            ),
                          );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/Group 3548.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "account"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/icons/icon/Icon ionic-ios-arrow-back.png',
                              width: 7,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //interviews
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InterviewListScreen(
                              loggedUser: user!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/Group 3547.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "interviews"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.balck2, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //invoices
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllInvoicesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/Group 3549.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "invoices"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.balck2, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //reviews
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddFakeReviewScreen(user: user!),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/Group 3550.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "addReview"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.balck2, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //developNotes
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AllDevelopTechScreen(loggedUser: user!),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/Group 3551.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "developNotes"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.balck2, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //reports
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllReporsScreen(
                              loggedUser: user!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/Group 3552.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "reports"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.balck2, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //appointment
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllAppointmentsScreen(
                              loggedUser: user!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/phone call outline_.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "appointments"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.balck2, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //notification
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllSendedNotificationSreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: size.width * .85,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        decoration: decoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/menu/Group 3553.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getTranslated(context, "notification"),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily:
                                          getTranslated(context, "fontFamily"),
                                      fontSize: AppFontsSizeManager.s21_3.sp,
                                      color: AppColors.balck2,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.balck2, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : SizedBox(),
          commonItems(),
        ],
      ),
    );
  }

  Widget notLoggedUserDrawer(Size size) {
    return Container(
      color: AppColors.white,
      child: Column(
        //padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        children: <Widget>[
          SizedBox(height: 50),
          Center(
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.6),
              onTap: () {
                Navigator.pushNamed(context, '/Register_Type');
              },
              child: Container(
                  height: size.height * 0.05,
                  width: size.width * 0.11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/icons/icon/Mask Group 47.png',
                      height: 25, width: 40)),
            ),
          ),
          SizedBox(
            height: AppSize.h21_3.h,
          ),
          Center(
            child: Text(
              getTranslated(context, "welcomeBack"),
              style: TextStyle(
                fontFamily: getTranslated(context, "Montserratsemibold"),
                fontSize: AppFontsSizeManager.s21_3.sp,
                fontWeight: FontWeight.normal,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(height: size.height * .1),
          commonItems(),
        ],
      ),
    );
  }

  Widget commonItems() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //suggestions
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuggestionScreen(loggedUser: user),
            ),
          );
        },
        child: MenuItemWidget(
          iconHeight: AppSize.h21_3.h,
          iconWidth: AppSize.w26_6.w,
          imagePath: AssetsManager.lumpIconPath,
          title: getTranslated(context, "suggestions"),
        ),
      ),
      SizedBox(
        height: AppSize.h32.h,
      ),
      //FAQ
      user != null
          ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(user: user!),
                  ),
                );
              },
              child: MenuItemWidget(
                iconHeight: AppSize.h21_3.h,
                iconWidth: AppSize.w26_6.w,
                imagePath: AssetsManager.questionIcon,
                title: getTranslated(context, "FAQ"),
              ),
            )
          : SizedBox(),
      user != null
          ? SizedBox(
              height: AppSize.h32.h,
            )
          : SizedBox(),

      //aboutUs
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutUsScreen(),
            ),
          );
        },
        child: MenuItemWidget(
          iconHeight: AppSize.h21_3.h,
          iconWidth: AppSize.w26_6.w,
          imagePath: AssetsManager.peopleIconPath,
          title: getTranslated(context, "aboutUs"),
        ),
      ),
      SizedBox(
        height: AppSize.h32.h,
      ),

      //language
      InkWell(
        onTap: () {
          selectedLang = lang;
          languagesDialog(size);
        },
        child: DrawerItemWidget(
          iconHeight: AppSize.h21_3.h,
          iconWidth: AppSize.w26_6.w,
          imagePath: AssetsManager.langIconPath,
          title: getTranslated(context, "languages"),
        ),
      ),
      SizedBox(
        height: AppSize.h32.h,
      ),

      //share
      InkWell(
        onTap: () {
          inviteAFriend();
        },
        child: DrawerItemWidget(
          iconHeight: AppSize.h26_6.h,
          iconWidth: AppSize.w26_6.w,
          imagePath: AssetsManager.redShareIconPath,
          title: getTranslated(context, "share"),
        ),
      ),
      SizedBox(
        height: AppSize.h32.h,
      ),
//Setting
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingPage(),
            ),
          );
        },
        child: DrawerItemWidget(
          iconHeight: AppSize.h26_6.h,
          iconWidth: AppSize.w26_6.w,
          imagePath: AssetsManager.settingIcon,
          title: getTranslated(context, "settings"),
        ),
      ),
      SizedBox(
        height: AppSize.h32.h,
      ),
      //logout
      InkWell(
        onTap: () {
          if (user == null)
            Navigator.pushNamed(context, '/Register_Type');
          else
            showSignoutConfimationDialog(size);
        },
        child: DrawerItemWidget(
          iconHeight: AppSize.h26_6.h,
          iconWidth: AppSize.w26_6.w,
          imagePath: AssetsManager.logoutIconPath,
          title: user == null
              ? getTranslated(context, "login")
              : getTranslated(context, "logout"),
        ),
      ),

      SizedBox(
        height: 20,
      ),
    ]);
  }

  Decoration decoration() {
    return BoxDecoration(
      color: Color.fromRGBO(249, 250, 251, 1),
      borderRadius: BorderRadius.circular(13.0),
      /* boxShadow: [
        BoxShadow(
          color: Color.fromRGBO( 63, 63 ,63, 0.08),
          blurRadius: 16,
          spreadRadius: 0.0,
          offset: Offset(-10, -8), // shadow direction: bottom right
        )
      ],*/
    );
  }

  changelanguage(String lang, String code) async {
    await setLocal(lang);
    if (lang == "En") lang = "en";
    Locale _temp = Locale(lang, code);
    if (user != null) {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(user!.uid)
          .set({
        'userLang': lang,
      }, SetOptions(merge: true));
      accountBloc.add(GetLoggedUserEvent());
    }
    MyApp.setLocale(context, _temp);
    Navigator.pop(context);
  }

  initiateSearch(String text) async {
    setState(() {
      load = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Paths.usersPath)
        .where(
          'phoneNumber',
          isEqualTo: text,
        )
        .limit(1)
        .get();
    if (querySnapshot != null && querySnapshot.docs.length != 0) {
      var userSearch = GroceryUser.fromMap(querySnapshot.docs[0].data() as Map);
      setState(() {
        load = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsScreen(
            user: userSearch,
            loggedUser: user!,
          ),
        ),
      );
    } else {
      setState(() {
        load = false;
        wrongNumber = true;
      });
    }
  }

  languagesDialog(Size size) {
    String langVal = getTranslated(context, "lang");
    print("hhhhhh");
    print(selectedLang);
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p59_3.h,
        padLeft: AppPadding.p33_3.w,
        padReight: AppPadding.p33_3.w,
        padTop: AppPadding.p20.h,
        radius: AppRadius.r21_3.r,
        dialogContent: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              color: Colors.white,
              width: AppSize.w386_6.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Container(
                            child: Icon(Icons.close, color: AppColors.pink2))),
                  ),
                  SizedBox(
                    height: convertPtToPx(15).h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, "selectLanguage"),
                        style: TextStyle(
                            fontFamily:
                                getTranslated(context, "Montserratsemibold"),
                            fontSize: AppFontsSizeManager.s26_6.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: AppSize.w16.w,
                      ),
                      SvgPicture.asset(
                        AssetsManager.lang2IconPath,
                        height: AppSize.h32.h,
                        width: AppSize.w32.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.h58_6.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedLang = "en";
                              changelanguage("en", "US");
                              langVal = "en";
                            });
                            print("kkkkkkk");
                            print(selectedLang);
                          },
                          child: Container(
                            height: AppSize.h56.h,
                            width: AppSize.w166_1.w,
                            padding: EdgeInsets.only(
                                top: AppPadding.p6.w,
                                bottom: AppPadding.p6.w,
                                left: AppPadding.p32.w,
                                right: AppPadding.p32.w),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r5_3.r),
                                border: Border.all(
                                    color: selectedLang != "ar"
                                        ? AppColors.reddark2
                                        : AppColors.grey3)),
                            child: Center(
                              child: Text(
                                getTranslated(context, 'english'),
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratsemibold"),
                                  fontSize: AppFontsSizeManager.s24.sp,
                                  color: selectedLang != "ar"
                                      ? AppColors.reddark2
                                      : AppColors.darkGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppSize.w53_3.w,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedLang = "ar";
                              changelanguage("ar", "AR");
                              langVal = "en";
                            });
                            print("kkkkkkk");
                            print(selectedLang);
                          },
                          child: Container(
                            height: AppSize.h56.h,
                            width: AppSize.w166_1.w,
                            padding: EdgeInsets.only(
                                top: AppPadding.p6.w,
                                bottom: AppPadding.p6.w,
                                left: AppPadding.p32.w,
                                right: AppPadding.p32.w),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r5_3.r),
                                border: Border.all(
                                    color: selectedLang == "ar"
                                        ? AppColors.reddark2
                                        : AppColors.grey3)),
                            child: Center(
                              child: Text(
                                getTranslated(context, 'arabic'),
                                style: TextStyle(
                                  fontFamily: getTranslated(
                                      context, "Montserratsemibold"),
                                  fontSize: AppFontsSizeManager.s24.sp,
                                  color: selectedLang == "ar"
                                      ? AppColors.reddark2
                                      : AppColors.darkGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Center(
                  //   child: Container(
                  //     width: 50.0,
                  //     child: MaterialButton(
                  //       padding: const EdgeInsets.all(0.0),
                  //       onPressed: () async {
                  //         if (selectedLang == "ar")
                  //           changelanguage("ar", "AR");
                  //         else
                  //           changelanguage("en", "US");
                  //       },
                  //       child: Text(
                  //         getTranslated(context, 'save'),
                  //         style: TextStyle(
                  //           fontFamily: getTranslated(context, "fontFamily"),
                  //           fontSize: 15.0,
                  //           color: Colors.red.shade700,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  showSignoutConfimationDialog(Size size) {
    return showDialog(
      builder: (context) => NikahDialogWidget(
        padButtom: AppPadding.p42_6.h,
        padLeft: AppPadding.p21_3.w,
        padReight: AppPadding.p21_3.w,
        padTop: AppPadding.p21_3.h,
        radius: AppRadius.r21_3.r,
        dialogContent: Container(
          width: AppSize.w410_6.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(AssetsManager.redCancelIconPath),
                  ),
                ],
              ),
              RotationTransition(
                  turns: AlwaysStoppedAnimation(180 / 360),
                  child: SvgPicture.asset(
                    AssetsManager.logoutIconPath,
                    height: AppSize.h48.r,
                    width: AppSize.w48.r,
                  )),
              SizedBox(
                height: AppSize.h21_3.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: AppPadding.p40.w, left: AppPadding.p40.w),
                child: Text(
                  getTranslated(context, "doYouNeedToLogout"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: getTranslated(context, "Montserratmedium"),
                      fontSize: AppFontsSizeManager.s24.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: AppSize.h32.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: AppPadding.p18_6.w, left: AppPadding.p18_6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: AppSize.w160.w,
                      height: AppSize.h52.h,
                      decoration: BoxDecoration(
                        color: AppColors.reddark2,
                        borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection(Paths.usersPath)
                              .doc(user!.uid)
                              .set({
                            'tokenId': "",
                          }, SetOptions(merge: true));
                          FirebaseAuth.instance.signOut();
                          accountBloc.add(GetLoggedUserEvent());
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/Register_Type',
                            (route) => false,
                          );
                        },
                        child: Center(
                          child: Text(
                            getTranslated(context, "logout"),
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSize.w53.w,
                    ),
                    Container(
                      width: AppSize.w160.w,
                      height: AppSize.h52.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.r5_3.r),
                        border: Border.all(color: AppColors.reddark2),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            getTranslated(context, 'cancel'),
                            style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "Montserratsemibold"),
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              color: AppColors.reddark2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  Future inviteAFriend() async {
    String url = Platform.isIOS
        ? "https://apps.apple.com/us/app/1636182527"
        : "https://play.google.com/store/apps/details?id=com.app.MakeMyNikah";

    await FlutterShare.share(
        title: 'Nikah',
        text: 'I loved the idea of this app and I want to share it with you',
        linkUrl: "https://makemynikah.com/",
        chooserTitle: 'Nikah');
  }
}
