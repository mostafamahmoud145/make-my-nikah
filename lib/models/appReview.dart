import 'package:cloud_firestore/cloud_firestore.dart';

class AppReviews{
  String? name;
  String? image;
  String? title;
  String? description;


  AppReviews({
    this.name,
    this.title,
    this.description,
    this.image,
  });


  factory AppReviews.fromMap(Map data) {
    return AppReviews(
        name: data['name'],
        image:data['image'],
        title: data['title'],
        description: data['description']
    );
    }

}