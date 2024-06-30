
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AppAppointments.dart';

class GroceryUser {
  String? accountStatus;
  bool? isBlocked;
  bool? isDeveloper;
  bool? isGlorified;
  String? uid;
  String? name;
  String? email;
  String? userType;
  String? phoneNumber;
  String? photoUrl;
  num? rating;
  num? polite;
  num? serious;
  num? exceptional;
  num? appropriate;
  int? reviewsCount;
  String? tokenId;
  String? countryCode;
  String? countryISOCode;
  String? nationalityCode;
  String? userLang;
  num? price;
  String? preferredPaymentMethod;
  bool? profileCompleted=false;
  Timestamp? createdDate;
  int? createdDateValue;
  AppointmentDate? date;
  String? fullName;
  String? userName;
  String? spouse;
  String?ImageUrl;
  String? bankName;
  String? bankAccountNumber;
  String? fullAddress;
  String? personalIdUrl;
  String? fromUtc;
  String? toUtc;
  int? age;
  String? education;
  String? location;
  String? type;
  bool? allowEditPayinfo;
  List<String>? searchIndex;
  String? bio;
  String? country;
  List<WorkTimes>?workTimes;
  List<String>? workDays;
  num? balance;
  num? payedBalance;
  int? answeredSupportNum;
  int? ordersNumbers;
  String? loggedInVia;
  String? supportListId;
  String? customerId;
  int? order;
  String? origin;
  String? doctrine;
  String? aboutMe;
  String? partnerSpecifications;
  String? nationality;
  String? color;
  num? length;
  num? weight;
  int? childrenNum;
  String?  maritalStatus;
  String? specialization;
  String? employment;
  String? living;
  String? smooking;
  String? hijab;
  String? marriage;
  List<String>? wishlist;
  List<String>? languages;
  List<String>? todayAppointmentList;
  List<String>? consultOpenAppointmentDates;
  String? userConsultIds;
  String? link;
  List<String>? promoList;
  num? rate;
  String? tribal;
  bool? isPhoneMain;
  bool?isApple;
  
  //not user and will remove them
/*  String? link;
  String? defaultAddress;
  List<Address> address;

  List<dynamic> languages;

  bool? voice;
  bool? chat;

  String? price;
  Map<String?, dynamic> cart;
  dynamic answeredSupportNum;
  bool? sendGrant;*/
  GroceryUser({
    this.todayAppointmentList,
    this.origin,
    this.aboutMe,
    this.price,
    this.rating,
    this.answeredSupportNum,
    this.partnerSpecifications,
    this.nationality,
    this.color,
    this.date,
    this.length,
    this.weight,
    this.nationalityCode,
    this.maritalStatus,
    this.childrenNum,
    this.employment,
    this.specialization,
    this.living,
    this.link,
    this.languages,
    this.doctrine,
    this.hijab,
    this.smooking,
    this.marriage,
    this.allowEditPayinfo,
    this.type,
    this.accountStatus,
    this.age,
    this.location,
    this.education,
    this.userLang,
    this.isDeveloper,
    this.fullName,
    this.userName,
    this.spouse,
    this.ImageUrl,
    this.fullAddress,
    this.bankName,
    this.bankAccountNumber,
    this.personalIdUrl,
    this.countryCode,
    this.countryISOCode,
    this.order,
    this.customerId,
    this.isBlocked,
    this.uid,
    this.searchIndex,
    this.email,
    this.userType,
    this.phoneNumber,
    this.serious,
    this.polite,
    this.exceptional,
    this.appropriate,
    this.reviewsCount,
    this.name,
    this.photoUrl,
    this.ordersNumbers,
    this.bio,
    this.workDays,
    this.workTimes,
    this.country,
    this.balance,
    this.payedBalance,
    this.tokenId,
    this.loggedInVia,
    this.supportListId,
    this.profileCompleted,
    this.createdDate,
    this.createdDateValue,
    this.preferredPaymentMethod,
    this.fromUtc,
    this.toUtc,
    this.wishlist,
    this.promoList,
    this.isGlorified,
    this.consultOpenAppointmentDates,
    this.userConsultIds,
    this.rate,
    this.tribal,this.isPhoneMain,
    this.isApple


  });

  factory GroceryUser.fromMap(Map data) {

    
    return GroceryUser(
      nationalityCode:data['nationalityCode'],
      date: AppointmentDate.fromHashmap(data['date']),
      rating:data['rating']==null?0.0:data['rating'],
      todayAppointmentList:data['todayAppointmentList']==null?[]:data['todayAppointmentList'],
      allowEditPayinfo:data['allowEditPayinfo']==null?false:data['allowEditPayinfo'],
      type:data["type"]==null?"":data["type"],
      price: data["price"]==null?0.0:data['price'],
      accountStatus: data['accountStatus']==null?"NotActive":data['accountStatus'],
      preferredPaymentMethod:data['preferredPaymentMethod']==null?"tapCompany":data['preferredPaymentMethod'],
      profileCompleted: data['profileCompleted']==null?false:data['profileCompleted'],
      userLang:data['userLang']==null?"ar":data['userLang'],
      countryCode:data['countryCode'],
      answeredSupportNum:data['answeredSupportNum']==null?0:data['answeredSupportNum'],
      location:data['location'],
      link:data['link'],
      countryISOCode:data['countryISOCode'],
      order:data['order']==null?0:data['order'],
      isBlocked: data['isBlocked'],
      uid: data['uid'],
      email: data['email'],
      age: data['age'],
      education: data['education'],
      customerId:data['customerId'],
      supportListId:data['supportListId'],
      userType: data['userType'],
      phoneNumber: data['phoneNumber'],
      name: data['name']==null?" ":data['name'],
      fullName: data['fullName'],
      userName: data['userName']==null?"" :data['userName'],
      spouse: data['spouse']==null?"" :data['spouse'],
      ImageUrl: data['ImageUrl']==null?"" :data['ImageUrl'],
      isPhoneMain:data['isPhoneMain']==null?false:data['isPhoneMain'],


      bio: data['bio'],
      country: data['country'],
      workTimes: data['workTimes']==null?[]:List<WorkTimes>.from(
        data['workTimes'].map(
              (workTimes) {
            return WorkTimes.fromHashmap(workTimes);
          },
        ),
      ),
      workDays: data['workDays']==null?[]: List.from(data['workDays']),
      //data['workDays'] as List<String>?,
      reviewsCount:data['reviewsCount']==null?0:data['reviewsCount'],
      serious: data['serious']==null?0.0:data['serious'],
      polite: data['polite']==null?0.0:data['polite'],
      exceptional: data['exceptional']==null?0.0:data['exceptional'],
      appropriate: data['appropriate']==null?0.0:data['appropriate'],
      ordersNumbers: data['ordersNumbers']==null?0:data['ordersNumbers'],
      balance: data['balance']==null?0.0:data['balance'],
      payedBalance: data['payedBalance']==null?0.0:data['payedBalance'],

      isDeveloper: data['isDeveloper']==null?false:data['isDeveloper'],
      photoUrl: data['photoUrl'],
      tokenId: data['tokenId'],
      searchIndex: data['searchIndex']==null?[]: List.from(data['searchIndex']),
      loggedInVia: data['loggedInVia'],
      createdDate: data['createdDate'],
      createdDateValue: data['createdDateValue'],
      fullAddress: data['fullAddress'],
      bankName: data['bankName'],
      bankAccountNumber: data['bankAccountNumber'],
      personalIdUrl: data['personalIdUrl'],
      fromUtc: data['fromUtc'],
      toUtc: data['toUtc'],
      childrenNum:data['childrenNum']==null?0:data['childrenNum'],
      origin: data['origin'],
      aboutMe: data['aboutMe'],
      partnerSpecifications: data['partnerSpecifications'],
      nationality: data['nationality'],
      color: data['color'],
      length:data['length'],
      weight:data['weight'],
      maritalStatus: data['maritalStatus'],
      employment: data['employment'],
      specialization: data['specialization'],
      living: data['living'],
      doctrine: data['doctrine'],
      hijab:data['hijab'],
      smooking:data['smooking'],
      tribal:data['tribal'],
      marriage: data['marriage'],
      wishlist: data['wishlist']==null?[]: List.from(data['wishlist']),
      promoList: data['promoList'] == null ? [] : List.from(data['promoList']),

      languages: data['languages']==null?[]:List.from(data['languages']),
      //will remove these
      userConsultIds:data['userConsultIds']==null?"":data['userConsultIds'],

      consultOpenAppointmentDates:data['consultOpenAppointmentDates']==null?[]
      : List.from(data['consultOpenAppointmentDates']),
      isGlorified:data['isGlorified']==null?false:data['isGlorified'],
      isApple:data['isApple']==null?false:data['isApple'],
    );
  }
  factory GroceryUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,SnapshotOptions? options,) {
    final data = snapshot.data();
    return GroceryUser(
      nationalityCode:data?['nationalityCode'],
      date: AppointmentDate.fromHashmap(data?['date']),
      todayAppointmentList:data?['todayAppointmentList']==null?[]:List.from(data?['todayAppointmentList']),
      allowEditPayinfo:data?['allowEditPayinfo']==null?false:data?['allowEditPayinfo'],
      type:data?["type"]==null?"":data?["type"],
      rating:data?['rating']==null?0.0:data?['rating'],
      accountStatus: data?['accountStatus']==null?"NotActive":data?['accountStatus'],
      preferredPaymentMethod:data?['preferredPaymentMethod']==null?"tapCompany":data?['preferredPaymentMethod'],
      profileCompleted: data?['profileCompleted']==null?false:data?['profileCompleted'],
      userLang:data?['userLang']==null?"ar":data?['userLang'],
      languages: data?['languages']==null?[]:List.from(data?['languages']),
      countryCode:data?['countryCode'],
      location:data?['location'],
      link:data?['link'],
      price:data?['price']==null?0:data?['price'],
      countryISOCode:data?['countryISOCode'],
      answeredSupportNum:data?['answeredSupportNum']==null?0:data?['answeredSupportNum'],
      order:data?['order']==null?0:data?['order'],
      isBlocked: data?['isBlocked'],
      uid: data?['uid'],
      email: data?['email'],
      age: data?['age'],
      education: data?['education'],
      customerId:data?['customerId'],
      supportListId:data?['supportListId'],
      userType: data?['userType'],
      phoneNumber: data?['phoneNumber'],
      name: data?['name']==null?" ":data?['name'],
      fullName: data?['fullName'],
      userName: data?['userName']==null?"" :data?['userName'],
      spouse: data?['spouse']==null?"" :data?['spouse'],
      ImageUrl: data?['ImageUrl']==null?"" :data?['ImageUrl'],
      promoList: data?['promoList'] == null ? [] : List.from(data?['promoList']),
isPhoneMain:data?['isPhoneMain']==null?false :data?['isPhoneMain'],
      bio: data?['bio'],
      country: data?['country'],
      workTimes: data?['workTimes']==null?[]:List<WorkTimes>.from(
        data?['workTimes'].map(
              (workTimes) {
            return WorkTimes.fromHashmap(workTimes);
          },
        ),
      ),
      workDays: data?['workDays']==null?[]:List.from(data?['workDays']),
      reviewsCount:data?['reviewsCount']==null?0:data?['reviewsCount'],
      serious: data?['serious']==null?0.0:data?['serious'],
      polite: data?['polite']==null?0.0:data?['polite'],
      exceptional: data?['exceptional']==null?0.0:data?['exceptional'],
      appropriate: data?['appropriate']==null?0.0:data?['appropriate'],
      ordersNumbers: data?['ordersNumbers']==null?0:data?['ordersNumbers'],
      balance: data?['balance']==null?0.0:data?['balance'],
      payedBalance: data?['payedBalance']==null?0.0:data?['payedBalance'],

      isDeveloper: data?['isDeveloper']==null?false:data?['isDeveloper'],
      photoUrl: data?['photoUrl'],
      tokenId: data?['tokenId'],
      searchIndex: data?['searchIndex']==null?[]:List.from(data?['searchIndex']),
      loggedInVia: data?['loggedInVia'],
      createdDate: data?['createdDate'],
      createdDateValue: data?['createdDateValue'],
      fullAddress: data?['fullAddress'],
      bankName: data?['bankName'],
      bankAccountNumber: data?['bankAccountNumber'],
      personalIdUrl: data?['personalIdUrl'],
      fromUtc: data?['fromUtc'],
      toUtc: data?['toUtc'],
      childrenNum:data?['childrenNum']==null?0:data?['childrenNum'],
      origin: data?['origin'],
      aboutMe: data?['aboutMe'],
      partnerSpecifications: data?['partnerSpecifications'],
      nationality: data?['nationality'],
      color: data?['color'],
      length:data?['length'],
      weight:data?['weight'],
      maritalStatus: data?['maritalStatus'],
      employment: data?['employment'],
      specialization: data?['specialization'],
      living: data?['living'],
      doctrine: data?['doctrine'],
      hijab:data?['hijab'],
      smooking:data?['smooking'],
      tribal:data?['tribal'],
      marriage: data?['marriage'],
      wishlist: data?['wishlist']==null?[]:List.from(data?['wishlist']),
      //will remove these
      userConsultIds:data?['userConsultIds']==null?"":data?['userConsultIds'],

      consultOpenAppointmentDates:data?['consultOpenAppointmentDates']==null?[]:
      List.from(data?['consultOpenAppointmentDates']),
      isGlorified:data?['isGlorified']==null?false:data?['isGlorified'],
       isApple:data?['isApple']==null?false:data?['isApple'],
    );

  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "..": name,
    };
  }
}

class Address {
  String? city;
  String? state;
  String? pincode;
  String? landmark;
  String? addressLine1;
  String? addressLine2;
  String? country;
  String? houseNo;

  Address({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.houseNo,
    this.landmark,
    this.pincode,
    this.state,
  });

  factory Address.fromHashmap(Map<String?, dynamic> address) {
    return Address(
      addressLine1: address['addressLine1'],
      addressLine2: address['addressLine2'],
      city: address['city'],
      country: address['country'],
      houseNo: address['houseNo'],
      landmark: address['landmark'],
      pincode: address['pincode'],
      state: address['state'],
    );
  }
}
class KeyValueModel {
  dynamic key;
  String? value;

  KeyValueModel({this.key, this.value});
}
class WorkTimes {
  String? from;
  String? to;
  WorkTimes({
    this.from,
    this.to,
  });

  factory WorkTimes.fromHashmap(Map<String?, dynamic> ranges) {
    return WorkTimes(
      from: ranges['from'],
      to: ranges['to'],

    );
  }
}