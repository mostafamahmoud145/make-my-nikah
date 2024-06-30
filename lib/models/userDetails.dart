

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  String? healthCondition;
  String? userId;
  String? hobbies;
  String? habbits;
  String? characterNature;
  String? values;
  String? priorties;
  String? nearMosque;
  String? positivePoints;
  String? negativePoints;
  String? lovableThings;
  String? hatefulThings;
  String? marriageYears;
  String? quranLevel;
  String? religionLevel;
  String? partnerOrigin;
  String? partnerDoctrine;
  String? partnerMaritalState;
  String? partnerLivingStander;
  String? partnerEmploymentStatus;
  String? partnerEducationalLevel;
  String? partnerSpecialization;
  String? partnerSmoking;
  int? partnerMinAge;
  int? partnerMaxAge;
  int? partnerMinHeight;
  int? partnerMaxHeight;
  int? partnerMinWeight;
  int? partnerMaxWeight;
  String? partnerTribal;


  UserDetail({
    this.healthCondition,
    this.userId,
    this.hobbies,
    this.habbits,
    this.characterNature,
    this.values,
    this.priorties,
    this.positivePoints,
    this.negativePoints,
    this.lovableThings,
    this.hatefulThings,
    this.marriageYears,
    this.quranLevel,
    this.religionLevel,
    this.partnerEducationalLevel,
    this.partnerEmploymentStatus,
    this.partnerLivingStander,
    this.partnerMaritalState,
    this.partnerOrigin,
    this.partnerDoctrine,
    this.partnerSmoking,
    this.partnerSpecialization,
    this.partnerMinAge,
    this.partnerMaxAge,
    this.partnerMinHeight,
    this.partnerMaxHeight,
    this.partnerMinWeight,
    this.partnerMaxWeight,
    this.partnerTribal
  });

  factory UserDetail.fromMap(Map data) {

    
    return UserDetail(

      healthCondition:data['healthCondition']==null?"":data['healthCondition'],
      userId: data['userId'],
      hobbies:data['hobbies'],
      habbits:data['habits'],
      characterNature:data['characterNature'],
      values:data['values'],
      priorties:data['priorties'],
      positivePoints:data['positivePoints'],
      negativePoints:data['negativePoints'],
      lovableThings:data['lovableThings'],
      hatefulThings:data['hatefulThings'],
      marriageYears:data['marriageYears'],
      quranLevel:data['quranLevel'],
      religionLevel:data['religionLevel'],
      partnerEducationalLevel: data['partnerEducationalLevel'],
      partnerSpecialization: data['partnerSpecialization'],
      partnerMaritalState: data['partnerMaritalState'],
      partnerLivingStander: data['partnerLivingStander'],
      partnerEmploymentStatus: data['partnerEmploymentStatus'],
      partnerOrigin: data['partnerOrigin'],
      partnerDoctrine: data['partnerDoctrine'],
      partnerSmoking: data['partnerSmoking'],
      partnerMinAge: data['partnerMinAge'],
      partnerMaxAge: data['partnerMaxAge'],
      partnerMinHeight: data['partnerMinHeight'],
      partnerMaxHeight: data['partnerMaxHeight'],
      partnerMinWeight: data['partnerMinWeight'],
      partnerMaxWeight: data['partnerMaxWeight'],
      partnerTribal: data['partnerTribal']

    );
  }
}
