import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_store/config/app_constat.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/config/assets_manager.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/methodes/show_failed_snackbar.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/google_apple_signup/services/methods/navigation_method.dart';
import 'package:grocery_store/screens/home_screen.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';




class CompleteAppointmentScreen extends StatefulWidget {
  const CompleteAppointmentScreen(
      {Key? key, required this.isUser, this.getEmail})
      : super(key: key);
  final bool isUser;
  final Function({
    required String email,
  })? getEmail;

  @override
  State<CompleteAppointmentScreen> createState() =>
      _CompleteAppointmentScreenState();
}

class _CompleteAppointmentScreenState extends State<CompleteAppointmentScreen> {
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetsManager.securityIcon,
                height: convertPtToPx(AppSize.h165).h,
              ),
              SizedBox(
                height: convertPtToPx(AppSize.h32).h,
              ),
              Text(
                widget.isUser
                    ? getTranslated(context, 'toCompleteBooking')
                    : getTranslated(context, "forSecurity"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, 'Ithra'),
                  color: AppColors.black,
                  fontSize: convertPtToPx(AppFontsSizeManager.s24).sp,
                  //fontWeight: FontWeight.normal
                ),
              ),
              SizedBox(
                height: convertPtToPx(AppSize.h16).h,
              ),
              Text(
                getTranslated(context, "linkAccount"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: getTranslated(context, 'Ithralight'),
                  color: AppColors.black,
                  fontSize: convertPtToPx(AppFontsSizeManager.s16).sp,
                  //fontWeight: FontWeight.normal
                ),
              ),
              SizedBox(
                height: convertPtToPx(AppSize.h41).h,
              ),
              load
                  ? CircularProgressIndicator()
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppPadding.p32.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                linkEmailWithPhone(context);
                              },
                              child: Container(
                                height: AppSize.h64.h,
                                width: AppSize.w244.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        convertPtToPx(AppRadius.r8).r),
                                    border: Border.all(
                                      color: AppColors.red3,
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                        scale: 1.4,
                                        child: SvgPicture.asset(
                                          AssetsManager.googleIconsPath,
                                          height: AppSize.h32.h,
                                          width: AppSize.w32.w,
                                        )),
                                    SizedBox(
                                      width: AppSize.w10_6.w,
                                    ),
                                    Text(
                                      getTranslated(
                                          context, "linkGoogleAccount"),
                                      maxLines: AppConstants.maxLines,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily:
                                            getTranslated(context, 'Ithra'),
                                        color: AppColors.red3,
                                        fontSize: AppFontsSizeManager.s16.sp,
                                        //fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          InkWell(
                              onTap: () {
                                //linkEmailWithPhone(context);
                                linkAppleWithPhone(context);
                              },
                              child: Container(
                                height: AppSize.h64.h,
                                width: AppSize.w244.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        convertPtToPx(AppRadius.r8).r),
                                    border: Border.all(
                                      color: AppColors.red3,
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                        scale: 1.2,
                                        child: SvgPicture.asset(
                                          AssetsManager.apple_Icon_Path,
                                          height: AppSize.h32.h,
                                          width: AppSize.w32.w,
                                        )),
                                    SizedBox(width: AppSize.w10_6.w),
                                    Text(
                                      getTranslated(
                                          context, "linkAppleAccount"),
                                      maxLines: AppConstants.maxLines,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily:
                                            getTranslated(context, 'Ithra'),
                                        color: AppColors.red3,
                                        fontSize: AppFontsSizeManager.s16.sp,
                                        //fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> linkAppleWithPhone(BuildContext context) async {
    try {
      setState(() {
        load = true;
      });

      final appleResult = await TheAppleSignIn.performRequests(
          [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);

        switch (appleResult.status) {
          case AuthorizationStatus.authorized:
            final appleIdCredential = appleResult.credential!;
            final oauthCredential = OAuthProvider("apple.com").credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken!),
              accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
            );

            // Link Apple account to existing user
            User? existingUser = FirebaseAuth.instance.currentUser;
            await existingUser?.linkWithCredential(oauthCredential);

            updateUserAppleId(context,appleIdCredential.identityToken.toString());
            setState(() {
              load = false;
            });
            navigateWithoutBack(context,()=> HomeScreen());
            // Update UI or navigate after successful linking
            // ...
            break;
          case AuthorizationStatus.error:
          // Handle error
            break;
          case AuthorizationStatus.cancelled:
          // Handle cancellation
            break;
        }
    } catch (e) {
      setState(() {
        load = false;
      });
      // Handle exception
    }
  }

  Future<void> updateUserAppleId(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isApple': true});
    } catch (e) {
      showFailedSnackBar(getTranslated(context, 'failed'));
    }
  }

  Future<void> linkEmailWithPhone(BuildContext context) async {
    try {
      setState(() {
        load = true;
      });
      //get currently logged in user
      User? existingUser = await FirebaseAuth.instance.currentUser;

      //get the credentials of the new linking account
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //now link these credentials with the existing user
      UserCredential linkAuthResult =
          await existingUser!.linkWithCredential(googleCredential);

      // update user data and set user email.
      if (linkAuthResult.user != null) {
        await updateUserEmail(context, linkAuthResult.user!.email!);

        if (widget.isUser) {
          widget.getEmail!(email: linkAuthResult.user!.email!);
          setState(() {
            load = false;
          });
          Navigator.pop(context);
        } else {
          setState(() {
            load = false;
          });

          await FirebaseFirestore.instance
              .collection(Paths.usersPath)
              .doc(linkAuthResult.user!.uid)
              .get()
              .then((value) {
            GroceryUser? user= GroceryUser.fromMap(value.data() as Map<dynamic, dynamic>);

            navigateWithoutBack(context,()=> HomeScreen());
          }).catchError((error){
            setState(() {
              load = false;
            });
            print(error);
            showFailedSnackBar(getTranslated(context, 'failed'));
          });

        }
      }
    } catch (e) {
      setState(() {
        load = false;
      });
      print('rrrr$e');
      showFailedSnackBar(getTranslated(context, 'failed'));
    }
  }

  Future<void> updateUserEmail(BuildContext context, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection(Paths.usersPath)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'email': email});
    } catch (e) {
      showFailedSnackBar(getTranslated(context, 'failed'));
    }
  }

  // Unlink Google Account
  Future<void> unlinkGoogleAccount(BuildContext context) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Check if the user has Google linked
        final List<UserInfo> providers = await currentUser.providerData;

        if (providers.any((provider) => provider.providerId == "google.com")) {
          // Unlink Google account
          await currentUser.unlink("google.com");

          // remove user email from user account.
          await updateUserEmail(context, '');
          await GoogleSignIn().signOut();

        } else {
          print("No Google account linked to unlink");
        }
      }
    } catch (e) {
      print("Error unlinking Google account: $e");
    }
  }

  String getPlatformIcon() => Platform.isAndroid
      ? AssetsManager.googleIcon
      : AssetsManager.appleIconPath;
}
