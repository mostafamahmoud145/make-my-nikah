import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_store/config/app_fonts.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/screens/PayCoursesFeature/presention/course_videos_view.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/config/colorsFile.dart';
import 'package:grocery_store/localization/localization_methods.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../screens/PayCoursesFeature/utils/service/PayCourseCubit/pay_course_cubit.dart';
import '../screens/YoutubePlayerDemoScreen.dart';
import '../screens/courseVideosScreen.dart';

//-------
class courseListWidget extends StatefulWidget {
  final Courses course;
  final GroceryUser? loggedUser;

  const courseListWidget({Key? key, required this.course, this.loggedUser})
      : super(key: key);

  @override
  State<courseListWidget> createState() => _courseListWidgetState();
}

class _courseListWidgetState extends State<courseListWidget> {
  bool sharing = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            // CourseVideosScreen
            builder: (context) => BlocProvider<PayCourseCubit>(
              create: (context) => PayCourseCubit(),
              child: CourseVideosView(
                loggedUser:
                    widget.loggedUser != null ? widget.loggedUser! : null,
                course: widget.course,
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.tabBar,
          borderRadius: BorderRadius.circular(AppRadius.r32.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.h21_3.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.brown, width: 2.6.w),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    memCacheHeight: 500,
                    memCacheWidth: 500,
                    imageUrl: widget.course.image,
                    fit: BoxFit.cover,
                    height: AppSize.h160.r,
                    width: AppSize.h160.r,
                    placeholder: (context, url) => Center(
                      child: Container(
                        height: 100,
                        child: Center(
                          child: Image.asset('assets/icons/icon/load2.gif',
                              width: 40, height: 40, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Image.asset(
                        'assets/icons/icon/Mask Group 47.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppSize.h10_6.h,
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppSize.w199_7.r,
                      child: Center(
                        child: Text(
                          StringUtils.capitalize(widget.course.name),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "academyFontFamily"),
                              color: AppColors.balck2,
                              fontSize: AppFontsSizeManager.s21_3.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h6.h,
                    ),
                    SizedBox(
                      width: AppSize.w199_7.r,
                      child: Center(
                        child: Text(
                          StringUtils.capitalize(widget.course.title),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily:
                                  getTranslated(context, "academyFontFamily"),
                              color: AppColors.darkGrey,
                              fontSize: AppFontsSizeManager.s18_6.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.h4.h,
                    ),
                    RatingBar(
                      initialRating:
                          double.parse(widget.course.rate.toString()),
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 14,
                      itemPadding: EdgeInsets.only(right: AppPadding.p10_6.w),
                      ratingWidget: RatingWidget(
                        full: Image.asset(
                          "assets/icons/icon/s1.png",
                          width: AppSize.h12.r,
                          height: AppSize.h12.r,
                        ),
                        half: Image.asset(
                          "assets/icons/icon/s2.png",
                          width: AppSize.h12.r,
                          height: AppSize.h12.r,
                        ),
                        empty: Image.asset(
                          "assets/icons/icon/s2.png",
                          width: AppSize.h12.r,
                          height: AppSize.h12.r,
                        ),
                      ),
                      onRatingUpdate: (double value) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  share(BuildContext context) async {
    setState(() {
      sharing = true;
    });
    String uid = widget.course.courseId;
    // Create DynamicLink
    print("share1");
    print("https://beautapplication\.page\.link/.*course_id=" + uid);
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://beautapplication\.page\.link/course_id=" + uid),
      uriPrefix: "https://beautapplication\.page\.link",
      androidParameters:
          const AndroidParameters(packageName: "com.app.MakeMyNikah"),
      iosParameters: const IOSParameters(
          bundleId: "com.app.MakeMyNikah", appStoreId: "1665532757"),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    File file;
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final response = await http.get(Uri.parse(widget.course.image));
    file =
        await File('$path/image_${DateTime.now().millisecondsSinceEpoch}.png')
            .writeAsBytes(response.bodyBytes);
    String text =
        "${widget.course.name} \n I think that it will be a good course for you \n ${dynamicLink.shortUrl.toString()}";
    Share.shareFiles(["${file.path}"], text: text);
    setState(() {
      sharing = false;
    });
  }
}
