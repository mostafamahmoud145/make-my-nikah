import 'package:cloud_firestore/cloud_firestore.dart';

class UserReviews{
  String? name;
  String? image;
  String? rate;
  String? description;


  UserReviews({
    this.name,
    this.rate,
    this.description,
    this.image,
  });


  factory UserReviews.fromMap(Map data) {
    return UserReviews(
        name: data['name'],
        image:data['image'],
        rate: data['rate'],
        description: data['description']
    );
  }

}