
import 'package:cloud_firestore/cloud_firestore.dart';

import 'order.dart';

class Courses {
  String courseId;
  String name;
  String title;
  String desc;
  dynamic videoNum;
  String image;
  bool active;
  String type;
  dynamic price;
  double rate;
  List<dynamic>?paidUsers;



  Courses({
    required this.courseId,
    required this.name,
    required this.title,
    required this.desc,
    this.videoNum,
    required this.active,
    required this.image,
    this.price,
    required this.rate,
    required this.type,
    this.paidUsers,

  });

  factory Courses.fromMap(Map data) {
    return Courses(
      courseId: data['courseId'],
      name:data['name'],
      active:data['active']==null?false:data['active'],
      desc:data['desc']==null?"are they are be speacial man to are wall us do has arte habben":data['desc'],
      videoNum:data['videoNum']==null?0:data['videoCount'],
      paidUsers:data['paidUsers']==null?[]:data['paidUsers'],
      image: data['image'],
      price: data['price'],
      type: data['type'],
      title:data['title']==null?"no title":data['title'],
      rate: data['rate']==null?0.0:data['rate']
    );
  }
}


