
import 'package:cloud_firestore/cloud_firestore.dart';
class SupportList {
  String supportListId;
  bool supportListStatus;
  bool openingStatus;
  Timestamp messageTime;
  String userUid;
  String? userName;
  String owner;
  String lastMessage;
  dynamic image;
  dynamic userMessageNum;
  dynamic supportMessageNum;

  SupportList({
    required this.supportListId,
    required this.owner,
    required this.supportListStatus,
    required this.openingStatus,
    required this.messageTime,
    required this.userUid,
     this.userName,
    required this.lastMessage,
    this.image,
    this.userMessageNum,
    this.supportMessageNum,


  });

  factory SupportList.fromMap(Map data) {
    
    return SupportList(
      supportListId: data['supportListId'],
      owner:data['owner'],
      supportListStatus: data['supportListStatus']==null?false:data['supportListStatus'],
      openingStatus:data['openingStatus']==null?false:data['openingStatus'],
      messageTime: data['messageTime'],
      userUid: data['userUid'],
      userName: data['userName'],
      lastMessage: data['lastMessage'],
      image: data['image'],
      userMessageNum: data['userMessageNum'],
      supportMessageNum: data['supportMessageNum'],


    );
  }
}

