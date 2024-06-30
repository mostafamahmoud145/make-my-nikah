
import 'package:cloud_firestore/cloud_firestore.dart';

import 'order.dart';

class CourseVideo {
  String courseId;
  String videoId;
  String name;
  String link;
  String? image;
  bool active;
  dynamic views;




  CourseVideo({
    required this.courseId,
    required this.videoId,
    required this.link,
    this.views,
    required this.name,
    required this.active,
     this.image,


  });

  factory CourseVideo.fromMap(Map data) {
    return CourseVideo(
      courseId: data['courseId'],
      name:data['name'],
      active:data['active']==null?false:data['active'],
      views:data['views']==null?0:data['views'],
      image: data['image'],
      videoId: data['videoId'],
      link: data['link'],
    );
  }
}


