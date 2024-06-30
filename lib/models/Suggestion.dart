
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart';

class Suggestions {
  String suggestionId;
  String userUid;
  String title;
  String desc;
  bool status;
  Timestamp sendTime;
  UserDetails userData;

  Suggestions({
    required this.suggestionId,
    required this.userUid,
    required this.title,
    required this.desc,
    required this.sendTime,
    required this.status,
    required this.userData,
  });

  factory Suggestions.fromMap(Map data) {
    
    return Suggestions(
        suggestionId:data['suggestionId'],
        userUid: data['userUid'],
        title: data['title'],
        desc: data['desc'],
        status: data['status'],
        sendTime: data['sendTime'],
        userData: UserDetails.fromHashmap(data['userData'])
    );
  }
}


