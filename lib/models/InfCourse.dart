/*

import 'package:cloud_firestore/cloud_firestore.dart';

import 'order.dart';

class InfCourses {
  String influencerId;
  String courseId;
  String name;
  String desc;
  String image;
  bool active;
  dynamic order;
  dynamic views;
  dynamic videoCount;
  String price;
  List<dynamic>paidUsers;



  InfCourses({
    required this.influencerId,
    required this.courseId,
    required this.name,
    required this.desc,
    required this.active,
    required this.image,
    this.order,
    this.videoCount,
    this.views,
    required this.price,
    required this.paidUsers,

  });

  factory InfCourses.fromMap(Map data) {
    
    return InfCourses(
      courseId: data['courseId'],
      influencerId: data['influencerId'],
      name:data['name'],
      active:data['active'],
      image: data['image'],
      desc: data['desc'],
      order: data['order'],
      views: data['views']==null?0:data['views'],
      videoCount: data['videoCount']==null?0:data['videoCount'],
      price: data['price']==null?"0.0":data['price'],
      paidUsers: data['paidUsers']==null?[]:data['paidUsers'],
    );
  }
}


*/
