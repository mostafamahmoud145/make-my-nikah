/*

import 'package:cloud_firestore/cloud_firestore.dart';

import 'order.dart';

class InfCourseVideo {
  String influencerId;
  String courseId;
  String videoId;
  String name;
  String desc;
  String link;
  bool active;
  dynamic order;
  dynamic views;



  InfCourseVideo({
    required this.influencerId,
    required this.courseId,
    required this.name,
    required this.desc,
    required this.active,
    required this.link,
    this.order,
    required this.videoId,
    this.views,

  });

  factory InfCourseVideo.fromMap(Map data) {
    
    return InfCourseVideo(
      courseId: data['courseId'],
      influencerId: data['influencerId'],
      videoId: data['videoId'],
      name:data['name'],
      active:data['active'],
      link: data['link'],
      desc: data['desc'],
      order: data['order'],
      views: data['views']==null?0:data['views'],
    );
  }
}


*/
