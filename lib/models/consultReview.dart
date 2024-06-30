
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultReview {
  String review;
  dynamic serious;
  dynamic polite;
  dynamic exceptional;
  dynamic appropriate;
  dynamic rating;
  Timestamp reviewTime;
  String uid;
  String description;
  String appointmentId;
  String name;
  String image;
  String consultUid;
  String consultName;
  String consultImage;
  ConsultReview({
    this.serious,
    this.polite,
    this.rating,
    this.exceptional,
    this.appropriate,
    required this.review,
    required this.reviewTime,
    required  this.consultUid,
    required this.appointmentId,
    required this.consultImage,
    required this.consultName,
    required this.uid,
    required this.name,
    required this.image,
    required this.description,
  });
  factory ConsultReview.fromMap(Map data) {
    
    return ConsultReview(

      serious: data['serious']==null?0.0:data['serious'],
      polite: data['polite']==null?0.0:data['polite'],
      rating: data['rating']==null?0.0:data['rating'],
      exceptional: data['exceptional']==null?0.0:data['exceptional'],
      appropriate: data['appropriate']==null?0.0:data['appropriate'],
      review: data['review']==null?" ":data['review'],
      appointmentId: data['appointmentId'],
      uid: data['uid'],
      name: data['name']==null?" ":data['name'],
      image: data['image']==null?" ":data['image'],
      description:data['description']==null?" ":data['description'],
      consultUid: data['consultUid'],
      reviewTime:data['reviewTime'],
      consultName: data['consultName']==null?" ":data['consultName'],
      consultImage: data['consultImage']==null?" ":data['consultImage'],

    );
  }
  factory ConsultReview.fromHashMap(Map<String, dynamic> review) {
    return ConsultReview(
      serious: review['serious'],
      polite: review['polite'],
      rating:review['rating'],
      exceptional: review['exceptional'],
      appropriate: review['appropriate'],
      review: review['review'],
      reviewTime: review['reviewTime'],
      uid: review['uid'],
      name: review['name'],
      image: review['image'],
      consultUid: review['review'],
      consultName: review['consultName'],
      consultImage: review['consultImage'],
      appointmentId:  review['appointmentId'],
      description: review['description'],
    );
  }
}