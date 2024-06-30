
import 'package:cloud_firestore/cloud_firestore.dart';

class PromoCode {
  String promoCodeId;
  bool promoCodeStatus;
  Timestamp promoCodeTimestamp;
  String ownerName;
  String code;
  dynamic usedNumber;
  dynamic discount;
  String type;

  PromoCode({
    required this.promoCodeId,
    required this.promoCodeStatus,
    required this.promoCodeTimestamp,
    required this.type,
   
    required this.ownerName,
    required this.code,
    required this.usedNumber,
    required this.discount,



  });

  factory PromoCode.fromMap(Map  data){
    //Map data = doc.data();
    return PromoCode(
      promoCodeId: data['promoCodeId'],
      promoCodeStatus: data['promoCodeStatus'],
      promoCodeTimestamp: data['promoCodeTimestamp'],
      type: data['type']==null?"default":data['type'],
      ownerName: data['ownerName'],
      code: data['code'],
      usedNumber: data['usedNumber'],
      discount: data['discount'],

    );
  }

  tomap(){
    //Map data = doc.data();
    return <String,dynamic>
    {
      'promoCodeId': promoCodeId??'',
      'promoCodeStatus':promoCodeStatus??'',
      'promoCodeTimestamp': promoCodeTimestamp.seconds,
      'type': type,
      'ownerName': ownerName??'',
      'code': code??'',
      'usedNumber': usedNumber??0,
      'discount': discount??0,
  }

    ;
  }

}


