
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order.dart';

class Chat {
  String chatId;
  bool chatStatus;
  Timestamp messageTime;
  UserDetails consult;
  UserDetails user;
  String lastMessage;
  dynamic userMessageNum;
  dynamic consultMessageNum;

  Chat({
    required this.chatId,
    required this.chatStatus,
    required this.messageTime,
    required this.user,
    required this.consult,
    required this.lastMessage,
    this.userMessageNum,
    this.consultMessageNum,


  });

  factory Chat.fromMap(Map data) {
    return Chat(
      chatId: data['chatId'],
      chatStatus: data['chatStatus']==null?false:data['chatStatus'],
      messageTime: data['messageTime'],
      lastMessage: data['lastMessage'],
      userMessageNum: data['userMessageNum'],
      consultMessageNum: data['consultMessageNum'],
      consult: UserDetails.fromHashmap(data['consult']),
      user: UserDetails.fromHashmap(data['user']),


    );
  }
}

