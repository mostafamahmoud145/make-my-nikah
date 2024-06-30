
import 'package:cloud_firestore/cloud_firestore.dart';
class DevelopMessage {
  String developMessageId;
  Timestamp messageTime;
  String messageTimeUtc;
  String userUid;
  String message;
  dynamic type;
  dynamic owner;
  String ownerName;

  DevelopMessage({
    required this.message,
    required this.developMessageId,
    required this.messageTime,
    required this.messageTimeUtc,
    required this.userUid,
    this.type,
    this.owner,
    required this.ownerName,


  });

  factory DevelopMessage.fromMap(Map data) {

    return DevelopMessage(
      developMessageId: data['developMessageId'],
      message: data['message'],
      messageTimeUtc:data['messageTimeUtc'],
      type: data['type'],
      owner: data['owner'],
      userUid: data['userUid'],
      messageTime: data['messageTime'],
      ownerName: data['ownerName'],

    );
  }
}

