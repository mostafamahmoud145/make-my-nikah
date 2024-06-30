import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/FireStorePagnation/paginate_firestore.dart';
import 'package:grocery_store/config/app_values.dart';
import 'package:grocery_store/models/courseVideo.dart';
import 'package:grocery_store/models/courses.dart';
import 'package:grocery_store/widget/resopnsive.dart';
import 'package:grocery_store/widget/videoItem.dart';

class CourseVideosBuilder extends StatelessWidget {
  const CourseVideosBuilder({
    super.key,
    required this.course,
    required this.loggedUserId,
  });
  final Courses course;
  final String? loggedUserId;

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      itemBuilderType: PaginateBuilderType.gridView,
      padding: EdgeInsets.only(
          left: AppPadding.p32.w,
          right: AppPadding.p32.w,
          top: AppPadding.p32.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 150,
          childAspectRatio: 1.8 //(AppSize.w242_6.w/AppSize.h245_3.h)
          ),
      itemBuilder: (context, documentSnapshot, index) {
        return VideoItem(
            video: CourseVideo.fromMap(documentSnapshot[index].data() as Map),
            course: course,
            loggedUserId: loggedUserId == null ? null : loggedUserId);
      },
      query: FirebaseFirestore.instance
          .collection("CourseVideo")
          .where('courseId', isEqualTo: course.courseId)
          .where('active', isEqualTo: true)
          .orderBy('order', descending: false),
      isLive: true,
    );
  }
}
