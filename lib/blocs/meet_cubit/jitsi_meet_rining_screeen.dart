import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:grocery_store/Utils/extensions/bloc_extension.dart';
import 'package:grocery_store/Utils/extensions/printing_extension.dart';
import 'package:grocery_store/Utils/extensions/size_extension.dart';

import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/widget/resopnsive.dart';

import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../Utils/app_shadow.dart';
import '../../config/app_constat.dart';
import '../../config/app_values.dart';
import '../../config/assets_manager.dart';
import '../../config/paths.dart';
import '../../localization/localization_methods.dart';
import '../../methodes/pt_to_px.dart';
import '../../models/user.dart';
import 'jitsi_service/meet_service.dart';
import 'meet_cubit.dart';

class JitsiMeetRiningScreen extends StatefulWidget {
  JitsiMeetRiningScreen();

  @override
  JitsiMeetRiningScreenState createState() => JitsiMeetRiningScreenState();
}

class JitsiMeetRiningScreenState extends State<JitsiMeetRiningScreen> {
  @override
  initState() {
    super.initState();
    context.meetCubit.goToCall();
  }

  @override
  deactivate() {
    super.deactivate();
    context.meetCubit.deActivateAudio();
  }

  void onJitsiMeetingBackgrounded() {
    'Jitsi Meeting is in the background'.logPrint();
  }

  void onJitsiMeetingForegrounded() {
    'Jitsi Meeting is in the foreground'.logPrint();
  }

  Widget callScreenBody(MeetStates state) {
    if (state is MeetInitialState ||
        state is MeetLoadingState ||
        state is MeetRequestedPermissionState) {
      return shimmerLoad();
    } else if (state is MeetUserInAnotherState) {
      return endWidget("anotherCall");
    } else if (state is MeetErrorState || state is MeetErrorFindingToken) {
      // Future(() => Fluttertoast.showToast(
      //     msg: getTranslated(context, "removeNotification"),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.TOP,
      //     backgroundColor: Colors.red,
      //     textColor: AppColors.white,
      //     fontSize: 16.sp));
      return SizedBox.shrink();
    } else if (state is MeetUserRefusedState) {
      return endWidget("userRefuse");
    } else if (state is MeetUserClosedState || state is MeetEndingCallState) {
      return endWidget("userClose",
          withButton: state is! MeetEndingCallState ||
              context.meetCubit.meetService.meetDetails.loggedUser!.userType ==
                  AppConstants.user ||
              context.meetCubit.meetService.meetDetails.loggedUser?.userType == AppConstants.clientAnonymous||
              (context.meetCubit.meetService.meetDetails.loggedUser!.userType ==
                      AppConstants.consultant &&
                  context.meetCubit.receiver?.userType == AppConstants.coach)
      );
    } else if (state is MeetUserInCallState) {
      return endWidget("userInCallNow", withButton: false);
    } else if (state is MeetUserTimeOutState) {
      return endWidget("notAvailable", withButton: true);
    } else if (state is MeetUserIncomingCallState ||
        state is MeetUserCallingState) {
      return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(Paths.usersPath)
            .doc(context.meetCubit.meetService.meetDetails.receiverId)
            .withConverter(
              fromFirestore: GroceryUser.fromFirestore,
              toFirestore: (GroceryUser user, _) => user.toFirestore(),
            )
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<GroceryUser>> snapshot) {
          if (snapshot.hasError) {
            return endWidget('failed');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return shimmerLoad();
          } else {
            return Stack(
              children: [
                Align(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Lottie.asset(
                                      'assets/lotifile/callinganim.json'),
                                ),
                                Container(
                                  width: convertPtToPx(130.w),
                                  height: convertPtToPx(130.w),
                                  padding: EdgeInsets.all(15.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.pinkShadowColor,
                                          blurRadius: 22.r,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.0,
                                              2.0), // shadow direction: bottom right
                                        )
                                      ]),
                                  //borderRadius: BorderRadius.circular(80.0),
                                  child: SvgPicture.asset(
                                    AssetsManager.mask_groupImagePath,
                                    color: AppColors.pink2,
                                    width: 65,
                                    height: 65,
                                  ),
                                )
                              ],
                            ),
                            text(snapshot.data!.data()!.name!, 28,
                                Color.fromRGBO(32, 32, 32, 1), FontWeight.w600),
                            text(
                                getTranslated(context, "callingNow"),
                                15,
                                Color.fromRGBO(147, 147, 147, 1),
                                FontWeight.normal),
                          ],
                        ),
                        SizedBox(),
                        !context.meetCubit.meetService.meetDetails.iscaller!
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  refuseWidget(state),
                                  SizedBox(
                                    width: context.width * .20,
                                  ),
                                  //acceptWidget(),
                                ],
                              )
                            : refuseWidget(state),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      );
    } else {
      "error ${state.toString()}".logPrint();
      return endWidget("error", withButton: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<MeetCubit, MeetStates>(listener: (context, state) {
        if (state is MeetErrorFindingToken || state is MeetErrorState) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          showNotAvailableDialog(context.meetCubit.receiver?.name ?? '',
              context.meetCubit.meetService);
        }
      }, builder: (context, state) {
        return Scaffold(
            backgroundColor: Color.fromRGBO(247, 247, 247, 1),
            extendBodyBehindAppBar: true,
            body: callScreenBody(state));
      }),
    );
  }

  void showNotAvailableDialog(String name, MeetService service) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16.sp), // Set border radius here
            ),
            surfaceTintColor: AppColors.white,
            actionsPadding:
                EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
            actions: [
              InkWell(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Future(() => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (con) => BlocProvider<MeetCubit>(
                              create: (context) => MeetCubit(service),
                              child: JitsiMeetRiningScreen())),
                      (predict) => predict.isCurrent ? false : true));
                },
                borderRadius: BorderRadius.circular(10.sp),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.cherry,
                        AppColors.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTranslated(context, "retryCalling"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: getTranslated(
                                context, "Ithra"), // 'Montserrat',
                            fontSize: 14,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Icon(
                          Icons.phone_forwarded_outlined,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            contentPadding: EdgeInsets.all(24.w),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        // Check before pop
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.close,
                        color: AppColors.black,
                        size: 20,
                      )),
                ),
                Text(
                  getTranslated(context, "retry"),
                  style: TextStyle(
                    fontFamily:
                        getTranslated(context, "Ithra"), // 'Montserrat',
                    fontSize: 20,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: " $name ",
                      style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Ithra"), // 'Montserrat',
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getTranslated(context, 'notAvailable'),
                      style: TextStyle(
                        fontFamily:
                            getTranslated(context, "Ithra"), // 'Montserrat',
                        fontSize: 14,
                        color: AppColors.pureBlack, fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  getTranslated(context, 'userClosed'),
                  style: TextStyle(
                    fontFamily:
                        getTranslated(context, "Ithra"), // 'Montserrat',
                    fontSize: 14,
                    color: AppColors.black1, fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget shimmerLoad() {
    return Stack(
      children: [
        Align(
          child: Container(
            padding: EdgeInsets.only(top: 100, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Shimmer.fromColors(
                            period: Duration(milliseconds: 800),
                            baseColor: Colors.grey.withOpacity(0.6),
                            highlightColor:
                                AppColors.pureBlack.withOpacity(0.6),
                            child: Container(
                              height: 170.h,
                              width: 170.h,
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.pureBlack.withOpacity(0.2),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: context.width * .20,
                      height: 50,
                    ),
                    Shimmer.fromColors(
                        period: Duration(milliseconds: 800),
                        baseColor: Colors.grey.withOpacity(0.6),
                        highlightColor: AppColors.pureBlack.withOpacity(0.6),
                        child: Container(
                          height: 50,
                          width: kIsWeb && context.width > 400
                              ? context.width * .3
                              : context.width * .8,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pureBlack.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.0.r),
                          ),
                        )),
                    SizedBox(
                      width: context.width * .20,
                      height: 7,
                    ),
                    Shimmer.fromColors(
                        period: Duration(milliseconds: 800),
                        baseColor: Colors.grey.withOpacity(0.6),
                        highlightColor: AppColors.pureBlack.withOpacity(0.6),
                        child: Container(
                          height: 50,
                          width: kIsWeb && context.width > 400
                              ? context.width * .3
                              : context.width * .8,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pureBlack.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.0.r),
                          ),
                        ))
                  ],
                ),
                SizedBox(),
                !context.meetCubit.meetService.meetDetails.iscaller!
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Shimmer.fromColors(
                              period: Duration(milliseconds: 800),
                              baseColor: Colors.grey.withOpacity(0.6),
                              highlightColor:
                                  AppColors.pureBlack.withOpacity(0.6),
                              child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              )),
                          SizedBox(
                            width: context.width * .20,
                            height: 10,
                          ),
                          Shimmer.fromColors(
                              period: Duration(milliseconds: 800),
                              baseColor: Colors.grey.withOpacity(0.6),
                              highlightColor:
                                  AppColors.pureBlack.withOpacity(0.6),
                              child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              )),
                          SizedBox(
                            width: context.width * .20,
                            height: 10,
                          ),
                        ],
                      )
                    : context.meetCubit.meetService.meetDetails.iscaller!
                        ? Shimmer.fromColors(
                            period: Duration(milliseconds: 800),
                            baseColor: Colors.grey.withOpacity(0.6),
                            highlightColor:
                                AppColors.pureBlack.withOpacity(0.6),
                            child: Container(
                              height: 60,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ))
                        : Container(),
              ],
            ),
          ),
        )
      ],
    );
  }

  /// Cancel Calling and update the firebase to cancel on the remote user
  Widget refuseWidget(MeetStates state) {
    return IgnorePointer(
      ignoring:
          state is! MeetUserIncomingCallState || state is MeetUserInCallState,
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
          await context.meetCubit.refuse();

          /// then end the call in the user screen.
        },
        child: Container(
          height: 60,
          width: 100,
          decoration: BoxDecoration(
            color: AppColors.red3,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Image.asset(
              'assets/call/md-call@3x.png',
              width: 40,
              height: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget closeWidget() {
    return InkWell(
      onTap: () {
        context.meetCubit.deActivateAudio();
        Navigator.pop(context);
      },
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: text(getTranslated(context, "Ok"), 15, AppColors.white,
              FontWeight.w300),
        ),
      ),
    );
  }

  endWidget(String _text, {bool withButton = true}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                boxShadow: [AppShadow.primaryShadow],
                color: AppColors.white,
                border: Border.all(
                  width: 6,
                  color: AppColors.white,
                ),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AssetsManager.mask_groupImagePath,
                color: AppColors.pink2,
                width: 65,
                height: 65,
              )),
          SizedBox(
            height: context.height * .15,
          ),
          Center(
              child: text(getTranslated(context, _text), 13,
                  Color.fromRGBO(32, 32, 32, 1), FontWeight.w500)),
          SizedBox(
            height: context.height * .15,
          ),
          // if (inCallNow == false)
          //   widget.loggedUser!.userType== AppConstants.user ? Center(child: closeWidget()) : SizedBox(),
          withButton ? Center(child: closeWidget()) : SizedBox()
        ],
      ),
    );
  }

  Widget text(String text, double size, Color color, FontWeight weight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "Ithra", // 'Montserrat',
          fontSize: size,
          color: color,
          fontWeight: weight),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        shape: BoxShape.circle,
        //color: Color.fromRGBO(255, 255, 255,.42),
        border: Border.all(color: Color.fromRGBO(211, 211, 211, 1), width: .5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(255, 255, 255, 0),
            AppColors.pureBlack,
          ],
        ));
  }
}

// Widget acceptWidget() {
//   return InkWell(
//     onTap: () {
//       // _accept();
//       navigate = true;
//       FirebaseDatabase.instance
//           .ref('userCallState')
//           .child(FirebaseAuth.instance.currentUser!.uid)
//           .child('callState')
//           .set('oncall')
//           .then((value) => Future(
//               () => Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (con) => CallSample(
//                         host: widget.host,
//                         iscaller: false,
//                         isVideo: true,
//                         normalCall: true,
//                         CallerId: widget.CallerId,
//                         ReciverId: widget.ReciverId,
//                       )))));
//
//       setState(() {
//         _inCalling = true;
//       });
//     },
//     child: Container(
//       height: 60,
//       width: 100,
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(1, 199, 21, 1),
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       child: Center(
//         child: Image.asset(
//           'assets/call/md-call1@3x.png',
//           width: 25,
//           height: 25,
//         ),
//       ),
//     ),
//   );
// }