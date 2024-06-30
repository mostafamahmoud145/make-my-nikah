import 'dart:convert';
import 'package:animate_icons/animate_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_store/config/paths.dart';
import 'package:grocery_store/methodes/pt_to_px.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/screens/PayCoursesFeature/presention/widget/payCourseWidget/buy_course_widget.dart';
import 'package:grocery_store/screens/PayCoursesFeature/utils/service/PayCourseCubit/pay_course_cubit.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../config/app_values.dart';
import '../../CoacheAppoinmentFeature/utils/service/Funcation/errorLog.dart';
import 'widget/payCourseWidget/course_details_widget.dart';
import 'widget/payCourseWidget/course_image_widget.dart';
import 'widget/payCourseWidget/course_videos_builder_widget.dart';
import 'widget/payCourseWidget/pay_course_bottom_widget.dart';

class CourseVideosView extends StatefulWidget {
  final Courses course;
  final GroceryUser? loggedUser;

  const CourseVideosView({Key? key, required this.course, this.loggedUser})
      : super(key: key);

  @override
  _CourseVideosViewState createState() => _CourseVideosViewState();
}

class _CourseVideosViewState extends State<CourseVideosView> {
  AnimateIconController? animatecontroller;
  late Size size;
  bool buy = false;
  bool payView = false;

  @override
  void initState() {
    super.initState();
    if (widget.loggedUser != null) {
      BlocProvider.of<PayCourseCubit>(context).user = widget.loggedUser!;
      BlocProvider.of<PayCourseCubit>(context).course = widget.course;
      BlocProvider.of<PayCourseCubit>(context).calcCourseDeadline();
    }

    animatecontroller = AnimateIconController();
    print("content_view event started ");
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return BlocBuilder<PayCourseCubit, PayCourseCubitState>(
      builder: (context, state) {
        final payCourseCubit = BlocProvider.of<PayCourseCubit>(context);
        payView = payCourseCubit.paytap;
        buy = payCourseCubit.showPayView;
        return Scaffold(
          backgroundColor: Colors.white,
          body: payView
              ? WebView(
                  initialUrl:
                      BlocProvider.of<PayCourseCubit>(context).initialUrl,
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url
                        .startsWith("https://www.jeras.io/app/redirect_url")) {
                      setState(() {
                        payView = true;
                        buy = false;
                        var str = request.url;
                        const start = "tap_id=";
                        final startIndex = str.indexOf(start);

                        String charge = str.substring(
                            startIndex + start.length, str.length);
                        payStatus(charge);
                      });
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  initialMediaPlaybackPolicy:
                      AutoMediaPlaybackPolicy.always_allow,
                  onPageFinished: (url) {
                    //showSnakbar(url, true);
                    setState(() => payView = false);
                  },
                )
              : SafeArea(
                  child: Stack(children: [
                    Column(
                      children: <Widget>[
                        CourseImageWidget(course: widget.course),
                        buy
                            ? Expanded(
                                child: BuyCourseWidget(
                                    user: widget.loggedUser!,
                                    course: widget.course),
                              )
                            : Expanded(
                                child: Column(
                                  children: [
                                    PayCourseBottom(
                                      paidSince: payCourseCubit.paidSince,
                                      load: payCourseCubit.load,
                                      course: widget.course,
                                      onPress: () async {
                                        if (widget.loggedUser == null)
                                          Navigator.pushNamed(
                                              context, '/Register_Type');
                                        else {
                                          payCourseCubit.toggilepay();
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: CourseVideosBuilder(
                                          course: widget.course,
                                          loggedUserId:
                                              widget.loggedUser != null
                                                  ? widget.loggedUser!.uid
                                                  : null),
                                    ),
                                    // SizedBox(
                                    //   height: AppSize.h21_3.h,
                                    // ),
                                  ],
                                ),
                              )
                      ],
                    ),
                    Positioned(
                      top: AppSize.h315.h,
                      left: AppSize.w32.w,
                      right: AppSize.w32.w,
                      child: CourseDetailsWidget(
                        title: widget.course.title,
                        description: widget.course.desc,
                        rate: widget.course.rate.toString(),
                      ),
                    ),
                  ]),
                ),
        );
      },
    );
  }

  payStatus(String chargeId) async {
    try {
      final uri = Uri.parse('https://api.tap.company/v2/charges/' + chargeId);
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer sk_live_C7V9cpBMFWbt2ukjd3fRxIeD",
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br'
      };
      var response = await get(
        uri,
        headers: headers,
      );
      String responseBody = response.body;
      var res = json.decode(responseBody);

      if (res['status'] == "CAPTURED") {
        String? customerId = res['customer']['id'];
        customerId = customerId != null ? customerId : "";
      } else {
        await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
          "success": "false",
          "reason": res['status'],
          "userUid": widget.loggedUser!.uid
        });
        String id = Uuid().v4();
        await FirebaseFirestore.instance
            .collection(Paths.errorLogPath)
            .doc(id)
            .set({
          'timestamp': Timestamp.now(),
          'id': id,
          'seen': false,
          'desc': res['status'],
          'phone':
              widget.loggedUser == null ? " " : widget.loggedUser!.phoneNumber,
          'screen': "ConsultantDetailsScreen",
          'function': "payStatus",
        });
        setState(() {});
        // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
      }
    } catch (e) {
      errorLog(
          "payStatus", e.toString(), widget.loggedUser, "CourseVideosView");
      await FirebaseAnalytics.instance.logEvent(name: "payInfo", parameters: {
        "success": "false",
        "reason": e.toString(),
        "userUid": widget.loggedUser!.uid
      });
      // Helper.ShowToastMessage(getTranslated(context, "failed"), true);
    }
  }
}
