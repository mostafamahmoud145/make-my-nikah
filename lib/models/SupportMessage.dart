
import 'package:cloud_firestore/cloud_firestore.dart';
class SupportMessage {
  String? supportId;
  Timestamp messageTime;
  String messageTimeUtc;
  String userUid;
  String message;
  dynamic type;
  dynamic owner;
  String ownerName;
  double prgress;

  SupportMessage({
    required this.prgress,
    required this.message,
     this.supportId,
    required this.messageTime,
    required this.messageTimeUtc,
    required this.userUid,
    this.type,
    this.owner,
    required this.ownerName,
  });

  factory SupportMessage.fromMap(Map data) {
    
    return SupportMessage(
      prgress: 100,
      supportId: data['supportId'],
      message: data['message'],
      messageTimeUtc: data['messageTimeUtc'],
      type: data['type'],
      owner: data['owner'],
      userUid: data['userUid'],
      messageTime: data['messageTime'],
      ownerName: data['ownerName'],
    );
  }

  factory SupportMessage.fromDatabase(Map<String, dynamic> json) {
    return SupportMessage(
      prgress: 100,
      supportId: json['supportId'],
      message: json['message'],
      messageTimeUtc: json['messageTimeUtc'],
      type: json['type'],
      owner: json['owner'],
      userUid: json['userUid'],
      messageTime: Timestamp.fromMillisecondsSinceEpoch(json['messageTime']),
      ownerName: json['ownerName'],
    );
  }
}
