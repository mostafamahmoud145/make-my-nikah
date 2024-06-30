
import 'package:cloud_firestore/cloud_firestore.dart';


class banner {
  bool status;
  String id;
  String?  phone;
  String? name;
  String? uid;
  String? image;
  String? link;
  banner({
    required this.id,
    required this.status,
    this.phone,
    this.name,
    this.image,
    this.uid,
    this.link,

  });

  factory banner.fromMap(Map data) {
    return banner(
      id: data['id'],
      status: data['status'],
      phone: data['phone'],
      name: data['name'],
      image: data['image'],
      uid: data['uid'],
      link: data['link'],
    );
  }
}
