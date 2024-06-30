
import 'package:cloud_firestore/cloud_firestore.dart';
class ErrorLogModel {
  Timestamp timestamp;
  bool seen;
  String id;
  String desc;
  String screen;
  String function;
  String phone;
  ErrorLogModel({
    required this.id,
    required  this.seen,
    required this.timestamp,
    required this.desc,
    required this.screen,
    required this.function,
    required this.phone,

  });

  factory ErrorLogModel.fromMap(Map data) {
    return ErrorLogModel(
      id: data['id'],
      seen: data['seen'],
      timestamp: data['timestamp'],
      desc: data['desc'],
      screen: data['screen'],
      function: data['function'],
      phone: data['phone'],
    );
  }
}


