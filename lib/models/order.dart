
import 'package:cloud_firestore/cloud_firestore.dart';
class Orders {
  String orderId;
  String orderStatus;
  Timestamp orderTimestamp;
  dynamic orderTimeValue;
  UserDetails consult;
  UserDetails user;
  String? packageId;
  String? promoCodeId;
  String payWith;
  String consultType;
  dynamic remainingCallNum;
  dynamic packageCallNum;
  dynamic answeredCallNum;
  dynamic callPrice;
  dynamic price;

  Orders({
    required this.orderId,
    required this.orderStatus,
    required this.orderTimestamp,
    this.orderTimeValue,
    required this.consult,
    required this.consultType,
    required this.user,
    required this.payWith,
    this.remainingCallNum,
    this.packageCallNum,
    this.answeredCallNum,
    this.packageId,
    this.promoCodeId,
    this.callPrice,
    this.price,


  });

  factory Orders.fromMap(Map data) {
    
    return Orders(
      orderId: data['orderId'],
      orderStatus: data['orderStatus'],
      payWith: data['payWith'],
      consultType:data['consultType']==null?"":data['consultType'],
      orderTimestamp: data['orderTimestamp'],
      orderTimeValue: data['orderTimeValue'],
      consult: UserDetails.fromHashmap(data['consult']),
      user: UserDetails.fromHashmap(data['user']),
      remainingCallNum: data['remainingCallNum'],
      packageCallNum: data['packageCallNum'],
      answeredCallNum: data['answeredCallNum'],
      packageId: data['packageId'],
      promoCodeId: data['promoCodeId'],
      callPrice: data['callPrice'],
      price: data['price'],

    );
  }
}
class UserDetails {
  String name;
  String? image;
  String uid;
  String phone;
  String? countryCode;
  String? countryISOCode;

  UserDetails({
    required this.name,
    this.image,
    required this.uid,
    required this.phone,
    this.countryCode,
    this.countryISOCode
  });

  factory UserDetails.fromHashmap(Map<String, dynamic> Details) {
    return UserDetails(
        name: Details['name'],
        uid: Details['uid'],
        image: Details['image'],
        phone:Details['phone'],
        // countryCode: Details['countryCode'],
        // countryISOCode:Details['countryISOCode']
    );
  }
}

