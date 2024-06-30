

import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearch {
  String? userId;
  int? minAge;
  int? maxAge;
  String? country;
  String? nationality;
  String? countryCode;
  String? nationalityCode;
  List<dynamic>? skinColor;
  int? minHeight;
  int? maxHeight;
  int? minWeight;
  int? maxWeight;
  String? maritalState;
  String? hijab;
  String? religion;
  String? marriageType;
  String? education;
  String? employment;
  String? smoke;
  String? drinkers;
  String? tribal;


  UserSearch({
    this.userId,
    this.minAge,
    this.maxAge,
    this.country,
    this.nationality,
    this.countryCode,
    this.nationalityCode,
    this.skinColor,
    this.minHeight,
    this.maxHeight,
    this.minWeight,
    this.maxWeight,
    this.maritalState,
    this.hijab,
    this.religion,
    this.marriageType,
    this.education,
    this.employment,
    this.smoke,
    this.drinkers,
    this.tribal
  });

  factory UserSearch.fromMap(Map data) {

    
    return UserSearch(

      userId:data['userId'],
      minAge:data['minAge'],
      maxAge:data['maxAge'],
      country: data['country'],
      nationality:data['nationality'],
      countryCode: data['countryCode'],
      nationalityCode:data['nationalityCode'],
      skinColor:data['skinColor'],
      minHeight:data['minHeight'],
      maxHeight:data['maxHeight'],
      minWeight:data['minWeight'],
      maxWeight:data['maxWeight'],
      maritalState:data['maritalState'],
      hijab:data['hijab'],
      religion:data['religion'],
      marriageType:data['marriageType'],
      education:data['education'],
      employment:data['employment'],
      smoke:data['smoke'],
      drinkers:data['drinkers'],
      tribal:data['tribal'],

    );
  }
}
